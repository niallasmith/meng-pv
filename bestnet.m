function [LCtesttable, EGtesttable] = bestnet(netnum)

%%%%%%%%%%%%%%%%%%%%%%%%%% NORMAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[LCnetMSE, LClowMSEtestdata, LCnetACC, LClowACCtestdata, EGnetMSE, EGlowMSEtestdata, EGnetACC, EGlowACCtestdata] = bulktrain(netnum,0);

save('NORMALLCnetMSE','LCnetMSE')
save('NORMALLCnetACC','LCnetACC')
save('NORMALEGnetMSE','EGnetMSE')
save('NORMALEGnetACC','EGnetACC')

LCtesttable1 = table2array([LClowMSEtestdata; LClowACCtestdata]);
EGtesttable1 = table2array([EGlowMSEtestdata; EGlowACCtestdata]);

%%%%%%%%%%%%%%%%%%%%%%%%%% ATC1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[LCnetMSE, LClowMSEtestdata, LCnetACC, LClowACCtestdata, EGnetMSE, EGlowMSEtestdata, EGnetACC, EGlowACCtestdata] = bulktrain(netnum,1);

save('ATC1LCnetMSE','LCnetMSE')
save('ATC1LCnetACC','LCnetACC')
save('ATC1EGnetMSE','EGnetMSE')
save('ATC1EGnetACC','EGnetACC')

LCtesttable2 = table2array([LClowMSEtestdata; LClowACCtestdata]);
EGtesttable2 = table2array([EGlowMSEtestdata; EGlowACCtestdata]);

%%%%%%%%%%%%%%%%%%%%%%%%%% ATC2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[LCnetMSE, LClowMSEtestdata, LCnetACC, LClowACCtestdata, EGnetMSE, EGlowMSEtestdata, EGnetACC, EGlowACCtestdata] = bulktrain(netnum,2);

save('ATC2LCnetMSE','LCnetMSE')
save('ATC2LCnetACC','LCnetACC')
save('ATC2EGnetMSE','EGnetMSE')
save('ATC2EGnetACC','EGnetACC')

LCtesttable3 = table2array([LClowMSEtestdata; LClowACCtestdata]);
EGtesttable3 = table2array([EGlowMSEtestdata; EGlowACCtestdata]);


LCtesttable = array2table([LCtesttable1; LCtesttable2; LCtesttable3]);
EGtesttable = array2table([EGtesttable1; EGtesttable2; EGtesttable3]);

EGtesttable.Properties.VariableNames = {'ACC' 'CORR' 'MSE'};
LCtesttable.Properties.VariableNames = {'ACC' 'CORR' 'MSE'};
LCtesttable.Properties.RowNames = {'NORMAL MSE' 'NORMAL ACC' 'ATC1 MSE' 'ATC1 ACC' 'ATC2 MSE' 'ATC2 ACC'};
EGtesttable.Properties.RowNames = {'NORMAL MSE' 'NORMAL ACC' 'ATC1 MSE' 'ATC1 ACC' 'ATC2 MSE' 'ATC2 ACC'};

save('LCtesttable','LCtesttable')
save('EGtesttable','EGtesttable')

end