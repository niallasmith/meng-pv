% This is a function to convert any subset of junction temperature data
% passed to it into lifetime consumption values. It is written to be called
% upon by simanalysis.m
%
% Function inputs:
% 1. junctionT
%       This is an array of junction temperatures.
% 1. time
%       This is an array of time values corresponding to the sampling times
%       of the junction temperature array.
%
% Function outputs:
% 1. LC
%       This is the value of lifetime consumption within the subset of
%       data, passed back to simanalysis.m
%
% Written by N. Smith
% Last updated 25/01/22 16:30

function LC = lifetime_consumption(junctionT, time)
[peaks, peak_locs, ~] = findpeaks(junctionT,time,'MinPeakDistance',0.01,'WidthReference','halfprom');
[valleys,val_locs] = findpeaks(-junctionT,time,'MinPeakDistance',0.01);

valleys = -valleys;

peak_locs = peak_locs';
val_locs = val_locs';

peak_valley = [valleys; peaks];
peak_valley_loc = [val_locs; peak_locs];
[peak_valley_loc_sort, I] = sort(peak_valley_loc);
peak_valley_sort = peak_valley(I);
if size(peak_valley_sort,1) > 3
    [c,~,~,~,~] = rainflow(peak_valley_sort,peak_valley_loc_sort);

cycle_table = array2table(c,'VariableNames',{'Count','Range','Mean','Start','End'});

A = 5e13;
B = [-4.416 1.285e3 -0.463 -0.716 -0.761 -0.5];
ton = [6e-3 0];
V = 600;
I = 20;
D = 50e-6;

Nf = zeros(size(c,1),1);
LCi = zeros(size(c,1),1);

for i = 1:size(c,1)
    Nf(i) = A * c(i,2)^B(1) * exp(B(2)/(c(i,3)+273)) * ton(1)^B(3) * V^B(4) * I^B(5) * D^B(6);
    LCi(i) = c(i,2) / Nf(i);
end
LC = sum(LCi,1);

else
    LC = 0;
end
end