function [LCnetMSE, LClowMSEtestdata, LCnetACC, LClowACCtestdata, EGnetMSE, EGlowMSEtestdata, EGnetACC, EGlowACCtestdata] = bulktrain(netnum,atcselect)

LClowMSE = 100;
LClowACC = 100;
EGlowMSE = 100;
EGlowACC = 100;

for i = 1:netnum
    [LCnet, EGnet, LCtestdata, EGtestdata] = training(atcselect);

    if LCtestdata.LCmse < LClowMSE
        LCnetMSE = LCnet;
        LClowMSE = LCtestdata.LCmse;
        LClowMSEtestdata = LCtestdata;
    end

    if LCtestdata.LCacc < LClowACC
        LCnetACC = LCnet;
        LClowACC = LCtestdata.LCacc;
        LClowACCtestdata = LCtestdata;
    end

    if EGtestdata.EGmse < EGlowMSE
        EGnetMSE = EGnet;
        EGlowMSE = EGtestdata.EGmse;
        EGlowMSEtestdata = EGtestdata;
    end

    if EGtestdata.EGacc < EGlowACC
        EGnetACC = EGnet;
        EGlowACC = EGtestdata.EGacc;
        EGlowACCtestdata = EGtestdata;
    end
end

end