% This is a function that translates long term NREL irradiance data into
% useable timeseries .mat files, in particular for use with the Simulink 
% 'From File' block.
%
% Function inputs:
% 1. Output irradiance filename, e.g. 'simin.mat'
% 2. Input filename, e.g. 'z7244086.txt'
% 3. Day of interest, integer (if input is 0, random day will be chosen)
% 4. Duration of interest, days
% 5. Simulation rate, integer e.g. 360x faster than real time (1day data = 24 sec simulation)
% 6. Remove night time? y/n
% 7. Subsection start, min (0 if no subsection)
% 8. Subsection duration, min (0 if no subsection)
%
% Function outputs:
% 1. mat timeseries file of irradiance data. Format:
%       [Irradiance] [Ambient T] [Cell T]
% To access, use:
%   load('filename.mat') OR
%   Open the file using the 'Open' buttonon the toolstrip and navigate to
%   the file.
% Timeseries will then be loaded into a variable called 'tsirr'.
% 2. Plots of saved data for both irradiance and temperatures
%
% Written by N. Smith
% Last updated 26/01/22 10:30

function nrel2mat(out_name, in_name1, in_name2, days, duration, rate, night, substart, subduration)

% set table import options
warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames') % turn off matlab warning for column headers, they will be changed anyway
opts = detectImportOptions(in_name1); % auto detect table options
opts.VariableNames = {'Date' 'Time' 'Irradiance' 'Temperature'}; % change NREL table headings to useable type
opts = setvartype(opts,{'Date','Time'},'datetime'); % set date and time columns as datetime type in table options
opts = setvaropts(opts,'Date', 'InputFormat', 'MM/dd/uuuu'); % set date datetime format as MM/dd/uuuu
opts = setvaropts(opts,'Time', 'InputFormat', 'HH:mm'); % set MST datetime format as HH:mm

A = readtable(in_name1, opts); % read table data from txt file

% table data formatting
A.Date = A.Date + timeofday(A.Time); % combine date and time columns 
A.Date.Format = 'MM/dd/uuuu HH:mm'; % set date & time column format to correctly display time
A.Time = []; % remove MST column, no longer needed

warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames') % turn off matlab warning for column headers, they will be changed anyway
opts = detectImportOptions(in_name2); % auto detect table options
opts.VariableNames = {'Date' 'Time' 'Temperature'}; % change NREL table headings to useable type
opts = setvartype(opts,{'Date','Time'},'datetime'); % set date and time columns as datetime type in table options
opts = setvaropts(opts,'Date', 'InputFormat', 'MM/dd/uuuu'); % set date datetime format as MM/dd/uuuu
opts = setvaropts(opts,'Time', 'InputFormat', 'HH:mm'); % set MST datetime format as HH:mm

B = readtable(in_name2, opts); % read table data from txt file

% table data formatting
B.Date = B.Date + timeofday(B.Time); % combine date and time columns 
B.Date.Format = 'MM/dd/uuuu HH:mm'; % set date & time column format to correctly display time
B.Time = []; % remove MST column, no longer needed

% date = zeros(size(A,1)/1440,1); % setup empty date array
irradiance = zeros(size(A,1)/1440,1440); % setup empty irradiance array
amb_temperature = zeros(size(A,1)/1440,1440);
cell_temperature = zeros(size(A,1)/1440,1440);
for i = 1:(size(A,1)/1440) % for each day of data
%     date(i,1) = (A.Date(1440*(i-1)+1));
    irradiance(i,1:1440) = A.Irradiance((1:1440)+1440*(i-1));
    amb_temperature(i,1:1440) = A.Temperature((1:1440)+1440*(i-1));
    cell_temperature(i,1:1440) = B.Temperature((1:1440)+1440*(i-1));
end

% random duration generation
if duration == 0 % iff duration is 0, specific user instruction to generate random number duration
    duration = rand(size(irradiance,1)); % generate uniform random number from 1 to total day count
end

irr_data_out = irradiance(days:(days+duration-1),:); % retrieve selected data from table A
amb_temp_data_out = amb_temperature(days:(days+duration-1),:);
cell_temp_data_out = cell_temperature(days:(days+duration-1),:);

% % handle multiple day duration request
% if duration > 1 % iff multiple days of data is required
%     data_temp(1,:) = irr_data_out(1,:); % create temp array with the same first row as specified data
%     for i=2:duration % for all days above 1
%         data_temp = horzcat(data_temp(1,:), irr_data_out(2,:)); % append data from each day onto the 1st row of temporary data array, combining into one long row 
%         irr_data_out(2,:) = []; % delete now useless array row
%     end
%     clear irr_data_out % reset data_out array dimensions ready for new data
%     irr_data_out = data_temp; % assign new single-row data
%     clear data_temp % reset temp data array
% end

% remove night time (low irradiance conditions)
threshold = 1; % threshold in W/m^2 for defining 'when is night time' 
if night == 'y' % iff the night needs to be removed
    for i=1:1:size(irr_data_out,2)
        if irr_data_out(i) < threshold % if irradiance value is less than threshold set
            irr_data_out(i) = 0; % set irradiance value to 0, making it easier to sort later
            amb_temp_data_out(i) = 0;
        end
    end
    [~, c, data_temp] = find(irr_data_out); % find values of all non-zero elements in irradiance matrix
    clear irr_data_out % clear irradiance data, resets matrix size ready for new (non-zero) entries
    irr_data_out = data_temp; % set new entries into output variable
    clear data_temp
    data_temp = amb_temp_data_out(c(1,:));
    clear amb_temp_data_out
    amb_temp_data_out = data_temp;
    clear data_temp
    data_temp = cell_temp_data_out(c(1,:));
    clear cell_temp_data_out
    cell_temp_data_out = data_temp;
    clear data_temp
end

% subsection data handling
if substart ~= 0 && subduration ~= 0
    data_temp = irr_data_out;
    clear irr_data_out
    irr_data_out = data_temp(substart:(substart+subduration));
    clear data_temp

    data_temp = amb_temp_data_out;
    clear amb_temp_data_out
    amb_temp_data_out = data_temp(substart:(substart+subduration));
    clear data_temp

    data_temp = cell_temp_data_out;
    clear cell_temp_data_out
    cell_temp_data_out = data_temp(substart:(substart+subduration));
    clear data_temp
end

% create timeseries object
irr_data_out = irr_data_out'; % transpose irradiance values to row vector
amb_temp_data_out = amb_temp_data_out';
cell_temp_data_out = cell_temp_data_out';
data_out = [irr_data_out amb_temp_data_out cell_temp_data_out];
savetime = 1:size(data_out,1); % create array of incremented values to be used for time
savetime = (savetime*60)./rate; % scale time array with specified rate
simin = timeseries(data_out,savetime); % create timeseries object

save(out_name,'simin','-mat','-v7.3'); % save timeseries object to file
figure(1)
plot(savetime,irr_data_out) % plot the data saved
xlim([0 simin.Time(size(simin.Time,1))]) % set correct x limits
title('Irradiance saved data preview') % define figure title
txt = {['Date: ' num2str(days)], ['Duration: ' num2str(duration)] };
text(50,500,txt); % put text on figure
fprintf('Simulation time: \n %f seconds \n',simin.Time(size(simin.Time,1))); % display in command window the final time of simulation for data

figure(2)
plot(savetime,amb_temp_data_out)
xlim([0 simin.Time(size(simin.Time,1))])
title('Temperature saved data preview')
hold on
plot(savetime,cell_temp_data_out)
hold off