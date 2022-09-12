function [LCsum, EGsum] = testing(netselect, atcselect, weatherselect)

switch netselect
    case 0
        switch atcselect
            case 0
                load NORMALLCnetACC.mat LCnetACC
                load NORMALEGnetACC.mat EGnetACC
                load normparamsNORMAL.mat normparams;
                LCnet = LCnetACC;
                EGnet = EGnetACC;
            case 1
                load ATC1LCnetACC.mat LCnetACC
                load ATC1EGnetACC.mat EGnetACC
                load normparamsATC1.mat normparams
                LCnet = LCnetACC;
                EGnet = EGnetACC;
            case 2
                load ATC2LCnetACC.mat LCnetACC
                load ATC2EGnetACC.mat EGnetACC
                load normparamsATC2.mat normparams
                LCnet = LCnetACC;
                EGnet = EGnetACC;
        end
    case 1
        switch atcselect
            case 0
                load NORMALLCnetMSE.mat LCnetMSE
                load NORMALEGnetMSE.mat EGnetMSE
                load normparamsNORMAL.mat normparams;
                LCnet = LCnetMSE;
                EGnet = EGnetMSE;
            case 1
                load ATC1LCnetMSE.mat LCnetMSE
                load ATC1EGnetMSE.mat EGnetMSE
                load normparamsATC1.mat normparams
                LCnet = LCnetMSE;
                EGnet = EGnetMSE;
            case 2
                load ATC2LCnetMSE.mat LCnetMSE
                load ATC2EGnetMSE.mat EGnetMSE
                load normparamsATC2.mat normparams
                LCnet = LCnetMSE;
                EGnet = EGnetMSE;
        end
end

switch weatherselect
    case 0
        load 'LCtestingTHRESHOLD.mat' LCdata; 
        load 'EGtestingTHRESHOLD.mat' EGdata;
    case 1
        load 'LCtestingCLEARTHRESHOLD.mat' LCdata;
        load 'EGtestingCLEARTHRESHOLD.mat' EGdata;
    case 2
        load 'LCtestingOVERCASTTHRESHOLD.mat' LCdata;
        load 'EGtestingOVERCASTTHRESHOLD.mat' EGdata;
    case 3
        load 'LCtestingVARIABLETHRESHOLD.mat' LCdata;
        load 'EGtestingVARIABLETHRESHOLD.mat' EGdata;
    case 4
        load 'LCtestingVERYVARIABLETHRESHOLD.mat' LCdata;
        load 'EGtestingVERYVARIABLETHRESHOLD.mat' EGdata;
end


% Apply networks to long term data

LCpred = predict(LCnet,LCdata);
EGpred = predict(EGnet,EGdata);

LC = normparams.Scale(1)*LCpred + normparams.Center(1);
EG = normparams.Scale(2)*EGpred + normparams.Center(2);

% Calculate sum
LCsum = sum(LC); 
EGsum = sum(EG); 

end