clear
clc

tic
load('simin1.mat')
sim('PV_model_final_02_2021a',simin.Time(size(simin.Time,1)))
load('simout.mat')
save('simout1.mat','simout','-mat','-v7.3')
delete 'simout.mat'
time = toc;
metatable = array2table([time efficiency]);
metatable.Properties.VariableNames = ["Duration" "Efficiency"];

clearvars -except metatable

tic
load('simin3.mat')
sim('PV_model_final_02_2021a',simin.Time(size(simin.Time,1)))
load('simout.mat')
save('simout3.mat','simout','-mat','-v7.3')
delete 'simout.mat'
time = toc;
temptable = array2table([time efficiency]);
metatable = [metatable; temptable];

clearvars -except metatable

tic
load('simin2.mat')
sim('PV_model_final_02_2021a',simin.Time(size(simin.Time,1)))
load('simout.mat')
save('simout2.mat','simout','-mat','-v7.3')
delete 'simout.mat'
time = toc;
temptable = array2table([time efficiency]);
metatable = [metatable; temptable];

clearvars -except metatable

tic
load('simin4.mat')
sim('PV_model_final_02_2021a',simin.Time(size(simin.Time,1)))
load('simout.mat')
save('simout4.mat','simout','-mat','-v7.3')
delete 'simout.mat'
time = toc;
temptable = array2table([time efficiency]);
metatable = [metatable; temptable];

clearvars -except metatable

tic
load('simin5.mat')
sim('PV_model_final_02_2021a',simin.Time(size(simin.Time,1)))
load('simout.mat')
save('simout5.mat','simout','-mat','-v7.3')
delete 'simout.mat'
time = toc;
temptable = array2table([time efficiency]);
metatable = [metatable; temptable];

clearvars -except metatable

tic
load('simin8.mat')
sim('PV_model_final_02_2021a',simin.Time(size(simin.Time,1)))
load('simout.mat')
save('simout8.mat','simout','-mat','-v7.3')
delete 'simout.mat'
time = toc;
temptable = array2table([time efficiency]);
metatable = [metatable; temptable];

clearvars -except metatable

tic
load('simin7.mat')
sim('PV_model_final_02_2021a',simin.Time(size(simin.Time,1)))
load('simout.mat')
save('simout7.mat','simout','-mat','-v7.3')
delete 'simout.mat'
time = toc;
temptable = array2table([time efficiency]);
metatable = [metatable; temptable];

clearvars -except metatable

tic
load('simin6.mat')
sim('PV_model_final_02_2021a',simin.Time(size(simin.Time,1)))
load('simout.mat')
save('simout6.mat','simout','-mat','-v7.3')
delete 'simout.mat'
time = toc;
temptable = array2table([time efficiency]);
metatable = [metatable; temptable];

metatable.Properties.RowNames = ["simout1" "simout3" "simout2" "simout4" "simout5" "simout8" "simout7" "simout6"];
save metatable

clear

fprintf('Finished.\n\n')