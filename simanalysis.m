% This is a function to convert simulation results from PV_model_final.slx
% into input and output data for training ANNs. It is written to be called
% upon by the user, specifiying datasets outlined in the function inputs
% section below.
%
% Function inputs:
% 1. simout
%       This is the filename of the simulation results file. E.g.
%       'simout.mat'. Input to the function must include quotation marks.
% 2. simin
%       This is the filename of the simulation mission profile file. E.g.
%       'simin.mat'. Input to the function must include quotation marks.
%
% Function outputs:
% 1. LC
%       This is a table for the training of an ANN. The table is 
%       structured as follows:
%       [Irradiance at t-1 min] [Irradiance at t min] [Irradiance at t+1 min] [Ambient temp at t min] [Lifetime consumption during t min]
%       For all minute sections of the simulation results.
% 2. EG
%       This is a table for the training of an ANN. The table is
%       structured as follows:
%       [Irradiance at t min] [Cell temperature at t min] [Energy generated during t min]
%       For all minute sections of the simulation results.
%
% Written by N. Smith
% Last updated 29/02/22

function [LCout, EGout] = simanalysis(simin, simout)

% load(simout,simout)
simoutS1T = simout.getElement('S1T').Values;
simoutEG = simout.getElement('EG').Values;

% load(simin,simin)

length_mins = floor(simoutS1T.Time(size(simoutS1T.Time,1))/60);
LCout = zeros(length_mins,5);
EGout = zeros(length_mins,3);

timestep = simoutS1T.Time(2) - simoutS1T.Time(1);

for i = 1:length_mins-1
    % 1. extract minute window junction temps
    junctionT = simoutS1T.Data(floor(i*(60/timestep)):floor((i+1)*(60/timestep)),1);
    time = simoutS1T.Time(floor(i*(60/timestep)):floor((i+1)*(60/timestep)))';

    % 1.1 extract minute window boundary ANN input irradiance
    if i == 1
        irr = [0 simin.Data(i,1) simin.Data(i+1,1)];
    else
        irr = [simin.Data(i-1,1) simin.Data(i,1) simin.Data(i+1,1)];
    end

    % 1.2 extract minute window boundary ANN input ambT
    ambT = simin.Data(i,2);
    cellT = simin.Data(i,3);

    % 2. find peaks
    % 3. find valleys
    % 4. rainflow counting
    % 5. lifetime consumption
    LC = lifetime_consumption(junctionT,time);

    % 6. calculate minute window EG
        EG = simoutEG.Data(i+1,1) - simoutEG.Data(i,1);

    % 7. store irr, ambT in input array
    % 8. store EG, LC in output array
    LCout(i,1) = irr(1);
    LCout(i,2) = irr(2);
    LCout(i,3) = irr(3);
    LCout(i,4) = ambT;
    LCout(i,5) = LC;

    EGout(i,1) = irr(2);
    EGout(i,2) = cellT;
    EGout(i,3) = EG;
end

LCout = array2table(LCout);
LCout.Properties.VariableNames = ["Irr-1" "Irr" "Irr+1" "AmbT" "LC"];
EGout = array2table(EGout);
EGout.Properties.VariableNames = ["Irr" "CellT" "EG"];
end