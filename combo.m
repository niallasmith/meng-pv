clear
clc

[LCtest, EGtest] = bestnet(5);
disp('LC')
disp(LCtest)
disp('EG')
disp(EGtest)

% netselect: 0=acc 1=mse
% weatherselect: 0=whole, 1=clear, 2=overcast, 3=variable, 4=veryvariable

results = bulktest(0,0);

disp('Whole Results')
disp(results)

if table2array(results(2,2)) > 0 || table2array(results(3,2)) > 0 || table2array(results(2,3)) > 0 || table2array(results(3,3)) > 0
    combo
end

results = bulktest(0,1);

disp('Clear Results')
disp(results)

results = bulktest(0,2);

disp('Overcast Results')
disp(results)

results = bulktest(0,3);

disp('Variable Results')
disp(results)

results = bulktest(0,4);

disp('Very Variable Results')
disp(results)