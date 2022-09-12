function results = bulktest(netselect,weatherselect)

[LCsumNORMAL, EGsumNORMAL] = testing(netselect, 0, weatherselect);
[LCsumATC1, EGsumATC1] = testing(netselect, 1, weatherselect);
[LCsumATC2, EGsumATC2] = testing(netselect, 2, weatherselect);

a = [LCsumNORMAL,0,EGsumNORMAL,0;
    LCsumATC1,100*(LCsumATC1-LCsumNORMAL)/LCsumNORMAL,EGsumATC1,100*(EGsumATC1-EGsumNORMAL)/EGsumNORMAL;
    LCsumATC2,100*(LCsumATC2-LCsumNORMAL)/LCsumNORMAL,EGsumATC2,100*(EGsumATC2-EGsumNORMAL)/EGsumNORMAL];

results = array2table(a);
results.Properties.VariableNames = [{'LC'} {'LC perc Change'} {'EG'} {'EG perc Change'}];
results.Properties.RowNames = [{'Normal'} {'ATC1'} {'ATC2'}];
end