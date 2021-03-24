function P = set_para()

%This function is used to collect all of the user-specified parameters and
%return them as a single struct, P.


%% Display parameters (plotting + animation)

    %Set the font and line sizes for the figures:
    P.TitleFontSize = 18;
    P.LabelFontSize = 16;
    P.LegendFontSize = 14;
    P.AxisFontSize = 14;
    P.CurveLineWidth = 2;
    P.PlotBallSize = 50;

end