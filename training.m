% This is a script to train a regression feedforward network for prediction 
% of lifetime consumption (LC) and energy generated (EG) values. 
% Raw simulation results of both simin and simout are first used to 
% generate the correctly formatted training data, then MATLAB's fitrnet 
% function is used to train the neural network.
% Simulation data has already been split into training and testing data,
% where testing data is entirely different mat files, and is not touched
% until after the network has been trained.
% Once the network has been trained, it is tested against the seperated
% testing data by considering: 1) integral of LC and EG values, 
% 2) Correlation of LC and EG values and 3) MSE of LC and EG values
%
% The hyperoptimise variable can be changed to 0 or 1 based on whether it 
% is required.
%
% The trained LC prediction network is saved in LCnet
% The trained EG prediction network is saved in EGnet
%
% Written by N. Smith
% Last updated 29/02/22
function [LCnet, EGnet, LCaccuracy, EGaccuracy] = training(select)
% clear
% clc

% % Set up simin and simout training data array
% select = 2; % Normal (No ATC) = 0, ATC1 = 1, ATC2 = 2 

% if select == 0
% a = {'simin1.mat' 'simout1NORMAL.mat';
%     'simin2.mat' 'simout2NORMAL.mat';
%     'simin3.mat' 'simout3NORMAL.mat';
%     'simin4.mat' 'simout4NORMAL.mat';
%     'simin5.mat' 'simout5NORMAL.mat';
%     'simin8.mat' 'simout8NORMAL.mat'};
% else 
%     if select == 1
%     a = {'simin1.mat' 'simout1ATC1.mat';
%     'simin2.mat' 'simout2ATC1.mat';
%     'simin3.mat' 'simout3ATC1.mat';
%     'simin4.mat' 'simout4ATC1.mat';
%     'simin5.mat' 'simout5ATC1.mat';
%     'simin8.mat' 'simout8ATC1.mat'};
%     else
%     a = {'simin1.mat' 'simout1ATC2.mat';
%     'simin2.mat' 'simout2ATC2.mat';
%     'simin3.mat' 'simout3ATC2.mat';
%     'simin4.mat' 'simout4ATC2.mat';
%     'simin5.mat' 'simout5ATC2.mat';
%     'simin8.mat' 'simout8ATC2.mat'};
%     end
% 
% end
% 
% % Analyse simin and simout training data
% load(char(a(1,1)))
% load(char(a(1,2)))
% [LCtable, EGtable] = simanalysis(simin,simout);
% clear simin simout
% for i = 2:5
%     load(char(a(i,1)))
%     load(char(a(i,2)))
%     [LCtemp, EGtemp] = simanalysis(simin,simout);
%     LCtable = [LCtable;LCtemp]; %#ok<AGROW> 
%     EGtable = [EGtable;EGtemp]; %#ok<AGROW> 
%     clear LCtemp EGtemp simin simout
% end
% 
% LCtrain = LCtable;
% EGtrain = EGtable;
% save("LCtrainATC2.mat","LCtrain")
% save("EGtrainATC2.mat","EGtrain")

LClayer = [10 30 1];
EGlayer = [5 20 4];

switch select
    case 0
        load LCtrainNORMAL.mat LCtrain
        load EGtrainNORMAL.mat EGtrain
    case 1
        load LCtrainATC1.mat LCtrain
        load EGtrainATC1.mat EGtrain
    case 2
        load LCtrainATC2.mat LCtrain
        load EGtrainATC2.mat EGtrain
end

% Normalise LC and EG values
[LCtrain.LC, LCcenter, LCscale] = normalize(LCtrain.LC,"range");
[EGtrain.EG, EGcenter, EGscale] = normalize(EGtrain.EG,"range");

normparams = array2table([LCcenter,LCscale;EGcenter,EGscale]);
normparams.Properties.VariableNames = ["Center" "Scale"];
normparams.Properties.RowNames = ["LC" "EG"];

% c = cvpartition(height(LCtable),"Holdout",0.10);
% trainingIdx = training(c); % Training set indices
% netTrain = LCtable(trainingIdx,:);
% testIdx = test(c); % Test set indices
% netTest = LCtable(testIdx,:);

% Set hyperoptimise parameter, 1 = yes, 0 = no
hyperoptimiseLC = 0;

if hyperoptimiseLC == 1
    params = hyperparameters("fitrnet",LCtrain,"LC");
    params(1).Range = [1 3];
    params(2).Optimize = false;
    params(3).Optimize = false;
%     params(4).Range = [1e-12 1e-7];
    params(4).Optimize = false;
    params(7).Range = [1 100];
    params(8).Range = [1 100];
    params(9).Range = [1 10];
    params(10).Optimize = false;
    params(11).Optimize = false;
    for ii = 1:length(params)
        disp(ii);disp(params(ii))
    end
    LCnet = fitrnet(LCtrain,"LC","Standardize",true, ...
        "Lambda",0, ...
        "Activations","tanh", ...
        "OptimizeHyperparameters",params, ...
        "HyperparameterOptimizationOptions", ...
        struct("AcquisitionFunctionName","expected-improvement-plus", ...
        "MaxObjectiveEvaluations",20));
else
    LCnet = fitrnet(LCtrain,"LC","Standardize",true,"LayerSizes",LClayer,"Activations","tanh","Lambda",0);
end

hyperoptimiseEG = 0;
if hyperoptimiseEG == 1
    params = hyperparameters("fitrnet",EGtrain,"EG");
    params(1).Range = [1 3];
    params(2).Optimize = false;
    params(3).Optimize = false;
%     params(4).Range = [0 1e-7];
    params(4).Optimize = false;
    params(7).Range = [1 100];
    params(8).Range = [1 100];
    params(9).Range = [1 10];
    params(10).Optimize = false;
    params(11).Optimize = false;
    for ii = 1:length(params)
        disp(ii);disp(params(ii))
    end
    EGnet = fitrnet(EGtrain,"EG","Standardize",true, ...
        "Activations","tanh", ...
        "Lambda",0, ...
        "OptimizeHyperparameters",params, ...
        "HyperparameterOptimizationOptions", ...
        struct("AcquisitionFunctionName","expected-improvement-plus", ...
        "MaxObjectiveEvaluations",20));
else
    EGnet = fitrnet(EGtrain,"EG","Standardize",true,"LayerSizes",EGlayer,"Activations","tanh","Lambda",0);
end

% testMSE = loss(net,netTest,"Lifetime Consumption") %#ok<NOPTS> 

% Set up simin and simout testing data array

% if select == 0
%     b = {'simin6.mat' 'simout6NORMAL.mat'; ...
%         'simin7.mat' 'simout7NORMAL.mat'};
% else 
%     if select == 1
%         b = {'simin6.mat' 'simout6ATC1.mat'; ...
%         'simin7.mat' 'simout7ATC1.mat'};
%     else
%         b = {'simin6.mat' 'simout6ATC2.mat'; ...
%         'simin7.mat' 'simout7ATC2.mat'};
%     end
% end
% 
% % Analyse simin and simout testing data
% load(char(b(1,1)))
% load(char(b(1,2)))
% [LCtest, EGtest] = simanalysis(simin,simout);
% load(char(b(2,1)))
% load(char(b(2,2)))
% [LCtemp, EGtemp] = simanalysis(simin,simout);
% LCtest = [LCtest;LCtemp];
% EGtest = [EGtest;EGtemp];
% clear LCtemp EGtemp simin simout


if select == 0
    load LCtestnormal.mat LCtest
    load EGtestnormal.mat EGtest
else
    if select == 1
        load LCtestATC1.mat LCtest
        load EGtestATC1.mat EGtest
    else
        load LCtestATC2.mat LCtest
        load EGtestATC2.mat EGtest 
    end
end

if select == 0
%     save("LCnetNORMAL.mat","LCnet")
%     save("EGnetNORMAL.mat","EGnet")
    save("normparamsNORMAL.mat","normparams")
%     save("LCtestNORMAL.mat","LCtest")
%     save("EGtestNORMAL.mat","EGtest")
else
    if select == 1
%         save("LCnetATC1.mat","LCnet")
%         save("EGnetATC1.mat","EGnet")
        save("normparamsATC1.mat","normparams")
%         save("LCtestATC1.mat","LCtest")
%         save("EGtestATC1.mat","EGtest")
    else
%         save("LCnetATC2.mat","LCnet")
%         save("EGnetATC2.mat","EGnet")
        save("normparamsATC2.mat","normparams")
%         save("LCtestATC2.mat","LCtest")
%         save("EGtestATC2.mat","EGtest")
    end
end

% Normalise testing data to same scale as input
LCtestnorm = normalize(LCtest.LC,'center',LCcenter,'scale',LCscale); % LC
EGtestnorm = normalize(EGtest.EG,'center',EGcenter,'scale',EGscale); % EG

LCpred = predict(LCnet,LCtest); % Apply trained network to input data
EGpred = predict(EGnet,EGtest);

% Calculate integral of entire day 
LCtotalpred = sum(LCpred); % LC predicted
EGtotalpred = sum(EGpred); % EG predicted
LCtotalreal = trapz(LCtestnorm); % LC simulated
EGtotalreal = trapz(EGtestnorm); % EG simulated

% Integral performance test
LCeff = (LCtotalpred / LCtotalreal)*100;
LCeff = abs(100-LCeff);
EGeff = (EGtotalpred / EGtotalreal)*100; 
EGeff = abs(100-EGeff);

% Correlation performance test
LCcorr = corr(LCtestnorm,LCpred);
EGcorr = corr(EGtestnorm,EGpred);

% MSE performance test
LCsquarederrors = ((LCtestnorm - LCpred).^2);
LCmse = mean(LCsquarederrors);
EGsquarederrors = ((EGtestnorm - EGpred).^2);
EGmse = mean(EGsquarederrors);

LCaccuracy = array2table([LCeff,LCcorr,LCmse]);
LCaccuracy.Properties.VariableNames = [{'LCacc'} {'LCcorr'} {'LCmse'}];
EGaccuracy = array2table([EGeff,EGcorr,EGmse]);
EGaccuracy.Properties.VariableNames = [{'EGacc'} {'EGcorr'} {'EGmse'}];

% Plot LC predictions vs simulation
% figure(1) 
% plot(LCtestnorm)
% hold on
% plot(LCpred)
% hold off
% title('Lifetime consumption simulation and predictions')
% ylabel('Normalised lifetime consumption')
% legend('Simulated','Predicted')
% 
% % Scatter plot of LC predictions vs simulation showing correlation and outliers
% figure(2) 
% scatter(LCtestnorm,LCpred)
% xlim([0 max(LCtestnorm)+0.1])
% ylim([0 max(LCtestnorm)+0.1])
% hold on
% plot(0:0.01:1,0:0.01:1)
% hold off
% title('Lifetime consumption simulation and predictions scatter plot')
% xlabel('Simulated')
% ylabel('Predicted')
% legend('','Simulation = Prediction')
% 
% % Plot EG predictions vs simulation
% figure(3) 
% plot(EGtestnorm)
% hold on
% plot(EGpred)
% hold off
% title('Energy generated simulation and predictions')
% ylabel('Normalised Energy generation')
% legend('Simulated','Predicted')
% 
% % Scatter plot of EG predictions vs simulation showing correlation and outliers
% figure(4) 
% scatter(EGtestnorm,EGpred)
% xlim([0 max(EGtestnorm)+0.1])
% ylim([0 max(EGtestnorm)+0.1])
% hold on
% plot(0:0.01:1,0:0.01:1)
% hold off
% title('Energy generated simulation and predictions scatter plot')
% xlabel('Simulated')
% ylabel('Predicted')
% legend('','Simulation = Prediction')
end