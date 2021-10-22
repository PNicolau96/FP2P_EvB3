% Our code can start here, once the hemodynamics are solved
function [cfig,S] = contrastAgend(S,n)

for i = 1:length(S.IE)
    S.IE(i).Q = abs(S.IE(i).Q);
end

% Define AIF for first two segments
A = 1/4.459; B = 3; C = 1.5;
AIF = zeros([1 n]);
for t = 1:n
    AIF(t) = A* t^B *exp(-t/C);
end
S.IE(1).concentration = AIF;
S.IE(2).concentration = AIF;

% Calculate concentration over time at the vessel entrance as flow
% weighted average of mother vessels (1 - 2 or 3 if collateral incl.)
for i = 3:length(S.IE)
    concentrationIn = zeros([1 n]);
    start_node = S.IE(i).nodes(1);
    inflow = 0;
    for j=1:length(S.IE)
        if S.IE(j).nodes(2) == start_node
            concentrationIn = concentrationIn + S.IE(j).concentration ...
                            * S.IE(j).Q;
            inflow = inflow + S.IE(j).Q;
        end
    end
    concentrationIn = concentrationIn / inflow;
    
    %Calculate the time it takes the agent to travel through vessel
    %Rounding to full seconds because discrete time steps are needed,
    %but maybe seconds it a bit to coarse
    velocity = abs(S.IE(i).Q / (pi * S.IE(i).r^2));
    time_delay = round(S.IE(i).l / velocity) + 1;
 
    %Implement Convolution inside a single vessel
    totalIn = sum(concentrationIn);
    h = zeros([1 n]);
    for t = 1:n
        if t >= time_delay
            h(t) = 2*(time_delay)^2/((t)^3);
        end
    end
    concentrationOut = zeros([1 n]);
    for t = 1:n
        ctout = 0;
        for tau = 1:t-1
            ctout = ctout + h(tau) * concentrationIn(t-tau);
        end
        concentrationOut(t) = ctout;
    end
    totalOut = sum(concentrationOut);
    concentrationOut = concentrationOut * totalIn / totalOut;
    
    S.IE(i).concentration = concentrationOut;
    S.IE(i).concentrationIn = concentrationIn;
    diff = (concentrationIn - concentrationOut);
    S.IE(i).diff = diff;
    residence = zeros([1 n]);
    dt = 1;
    for t = 2:n
        %residence(t) = integral(diff, t-1, t);
        residence(t) = residence(t-1) + diff(t) * dt;
    end
    S.IE(i).residence = residence;
    
    %Mean Transit time
    t_vector = linspace(1, n, n);
    c = sum(concentrationOut .* t_vector);
    S.IE(i).mtt = c / sum(concentrationOut);
end

for i = 3:length(S.IE)
    % Get average contrast flow in vessel (= flow in the middel):
    cAv = (S.IE(i).concentrationIn + S.IE(i).concentration) / 2;
        % Concentration x Flow
    S.IE(i).averageContrastFlow = cAv * S.IE(i).Q;
    
    % Get difference of In- and Outflow:
    S.IE(i).contrastFlowDifference = S.IE(i).diff * S.IE(i).Q;
    
    % Get total residence of contrast in vessel:
    S.IE(i).contrastResidence = S.IE(i).residence * S.IE(i).Q;
    
end

% %Find fastest path
for i = 1:length(S.IE)
    startnode = S.IE(i).nodes(1);
    mttMin = 10^5;
    fastParent = 0;
    for j = 1:length(S.IE)
        if S.IE(j).nodes(2) == startnode
            if S.IE(j).mtt < mttMin
                fastParent = j;
                mttMin = S.IE(j).mtt;
            end
        end
    end
    S.IE(i).fastParent = fastParent;
end

%Create list of MTT along fastest path
segment1 = S.IE(end);
segment2 = S.IE(end-1);
if segment1.mtt < segment2.mtt
    segment = segment1;
else
    segment = segment2;
end
mtts2 = [];
while true
    mtts2(end + 1) = segment.mtt;
    if segment.fastParent == 0
        break
    end
    segment = S.IE(segment.fastParent);
end
mtts2 = flip(mtts2);

figure
hold on
plot(mtts2,'--rs','LineWidth',2,...
                        'MarkerEdgeColor','k',...
                        'MarkerFaceColor','k',...
                        'MarkerSize',8);
title('Mean Transit Time (with collaterals, no thrombus)')
xlabel('Segments in the network')
ylabel('Mean transit time [s]');
hold off

cfig=figure;clf ;
title('Concentrations of agent over time (every segment)');
hold on
for i = 1:length(S.IE)
    plot(S.IE(i).concentration);
end
xlabel('t [s]')
ylabel('Concentration [-]')
hold off

figure
title({'Residence', '& Concentration Difference'})
%titleExtent = get(ht,'Extent')
plot(S.IE(55).residence)
hold on
plot(S.IE(55).diff)
hold off

%% Boxes

%Box 1
%Calculate Total Concentration for Box (Box selection with IE index i)
TotConc = [];
for t=1:n
    ConcT = 0;
    for i=26:34
        %ConcT = ConcT + S.IE(i).concentration(t);
        ConcT = ConcT + S.IE(i).averageContrastFlow(t);
    end
    TotConc = [TotConc, ConcT];
end
%%Calculate Total Residence for Box (Box selection with IE index i)
TotRes = [];
for t=1:n
    ResT = 0;
    for i=26:34
        %ResT = ResT + S.IE(i).residence(t);
        ResT = ResT + S.IE(i).contrastResidence(t);
    end
    TotRes = [TotRes, ResT];
end
%%Calculate Total Flow Difference for Box (Box selection with IE index i)
TotDiff = [];
for t=1:n
    DiffT = 0;
    for i=26:34
        %DiffT = DiffT+ S.IE(i).diff(t);
        DiffT = DiffT+ S.IE(i).contrastFlowDifference(t);
    end
    TotDiff = [TotDiff, DiffT];
end

%Box 2
%Calculate Total Concentration for Box (Box selection with IE index i)
TotConc2 = [];
for t=1:n
    ConcT2 = 0;
    for i=17:24
        %ConcT2 = ConcT2 + S.IE(i).concentration(t);
        ConcT2 = ConcT2 + S.IE(i).averageContrastFlow(t);
    end
    TotConc2 = [TotConc2, ConcT2];
end
%%Calculate Total Residence for Box (Box selection with IE index i)
TotRes2 = [];
for t=1:n
    ResT2 = 0;
    for i=17:24
        %ResT2 = ResT2 + S.IE(i).residence(t);
        ResT2 = ResT2 + S.IE(i).contrastResidence(t);
    end
    TotRes2 = [TotRes2, ResT2];
end
%%Calculate Total Flow Difference for Box (Box selection with IE index i)
TotDiff2 = [];
for t=1:n
    DiffT2 = 0;
    for i=17:24
        %DiffT2 = DiffT2 + S.IE(i).diff(t);
        DiffT2 = DiffT2 + S.IE(i).contrastFlowDifference(t);
    end
    TotDiff2 = [TotDiff2, DiffT2];
end

%Box 3
%Calculate Total Concentration for Box (Box selection with IE index i)
TotConc3 = [];
for t=1:n
    ConcT3 = 0;
    for i=43:50
         %ConcT3 = ConcT3 + S.IE(i).concentration(t);
        ConcT3 = ConcT3 + S.IE(i).averageContrastFlow(t);
    end
    TotConc3 = [TotConc3, ConcT3];
end
%%Calculate Total Residence for Box (Box selection with IE index i)
TotRes3 = [];
for t=1:n
    ResT3 = 0;
    for i=43:50
        %ResT3 = ResT3 + S.IE(i).residence(t);
        ResT3 = ResT3 + S.IE(i).contrastResidence(t);
    end
    TotRes3 = [TotRes3, ResT3];
end
%%Calculate Total Flow Difference for Box (Box selection with IE index i)
TotDiff3 = [];
for t=1:n
    DiffT3 = 0;
    for i=43:50
        %DiffT3 = DiffT3 + S.IE(i).diff(t);
        DiffT3 = DiffT3 + S.IE(i).contrastFlowDifference(t);
    end
    TotDiff3 = [TotDiff3, DiffT3];
end

%Box 4
%Calculate Total Concentration for Box (Box selection with IE index i)
TotConc4 = [];
for t=1:n
    ConcT4 = 0;
    for i=35:42
        %ConcT4 = ConcT4 + S.IE(i).concentration(t);
        ConcT4 = ConcT4 + S.IE(i).averageContrastFlow(t);
    end
    TotConc4 = [TotConc4, ConcT4];
end
%%Calculate Total Residence for Box (Box selection with IE index i)
TotRes4 = [];
for t=1:n
    ResT4 = 0;
    for i=35:42
        %ResT4 = ResT4 + S.IE(i).residence(t);
        ResT4 = ResT4 + S.IE(i).contrastResidence(t);
    end
    TotRes4 = [TotRes4, ResT4];
end
%%Calculate Total Flow Difference for Box (Box selection with IE index i)
TotDiff4 = [];
for t=1:n
    DiffT4 = 0;
    for i=35:42
        %DiffT4 = DiffT4 + S.IE(i).diff(t);
        DiffT4 = DiffT4 + S.IE(i).contrastFlowDifference(t);
    end
    TotDiff4 = [TotDiff4, DiffT4];
end

% %Box 5
% %Calculate Total Concentration for Box (Box selection with IE index i)
% TotConc5 = [];
% for t=1:n
%     ConcT5 = 0;
%     for i=[1,3,4,8:11]
%         ConcT5 = ConcT5 + S.IE(i).concentration(t);
%     end
%     TotConc5 = [TotConc5, ConcT5];
% end
% %%Calculate Total Residence for Box (Box selection with IE index i)
% TotRes5 = [];
% for t=1:n
%     ResT5 = 0;
%     for i=[1,3,4,8:11]
%         S.IE(1).residence(t)
%         ResT5 = ResT5 + S.IE(i).residence(t);
%     end
%     TotRes5 = [TotRes5, ResT5];
% end
% %%Calculate Total Flow Difference for Box (Box selection with IE index i)
% TotDiff5 = [];
% for t=1:n
%     DiffT5 = 0;
%     for i=[1,3,4,8:11]
%         DiffT5 = DiffT5 + S.IE(i).diff(t);
%     end
%     TotDiff5 = [TotDiff5, DiffT5];
% end
% 
% %Box 6
% %Calculate Total Concentration for Box (Box selection with IE index i)
% TotConc6 = [];
% for t=1:n
%     ConcT6 = 0;
%     for i=[2,6,7,12:15]
%         ConcT6 = ConcT6 + S.IE(i).concentration(t);
%     end
%     TotConc6 = [TotConc6, ConcT6];
% end
% %%Calculate Total Residence for Box (Box selection with IE index i)
% TotRes6 = [];
% for t=1:n
%     ResT6 = 0;
%     for i=[2,6,7,12:15]
%         ResT6 = ResT6 + S.IE(i).residence(t);
%     end
%     TotRes6 = [TotRes6, ResT6];
% end
% %%Calculate Total Flow Difference for Box (Box selection with IE index i)
% TotDiff6 = [];
% for t=1:n
%     DiffT6 = 0;
%     for i=[2,6,7,12:15]
%         DiffT6 = DiffT6 + S.IE(i).diff(t);
%     end
%     TotDiff6 = [TotDiff6, DiffT6];
% end

%Box 7
%Calculate Total Concentration for Box (Box selection with IE index i)
TotConc7 = [];
for t=1:n
    ConcT7 = 0;
    for i=[48:51,56,57,60]
        ConcT7 = ConcT7 + S.IE(i).concentration(t);
    end
    TotConc7 = [TotConc7, ConcT7];
end
%%Calculate Total Residence for Box (Box selection with IE index i)
TotRes7 = [];
for t=1:n
    ResT7 = 0;
    for i=[48:51,56,57,60]
        ResT7 = ResT7 + S.IE(i).residence(t);
    end
    TotRes7 = [TotRes7, ResT7];
end
%%Calculate Total Flow Difference for Box (Box selection with IE index i)
TotDiff7 = [];
for t=1:n
    DiffT7 = 0;
    for i=[48:51,56,57,60]
        DiffT7 = DiffT7 + S.IE(i).diff(t);
    end
    TotDiff7 = [TotDiff7, DiffT7];
end

%Box 8
%Calculate Total Concentration for Box (Box selection with IE index i)
TotConc8 = [];
for t=1:n
    ConcT8 = 0;
    for i=[52:55,58,59,61]
        ConcT8 = ConcT8 + S.IE(i).concentration(t);
    end
    TotConc8 = [TotConc8, ConcT8];
end
%%Calculate Total Residence for Box (Box selection with IE index i)
TotRes8 = [];
for t=1:n
    ResT8 = 0;
    for i=[52:55,58,59,61]
        ResT8 = ResT8 + S.IE(i).residence(t);
    end
    TotRes8 = [TotRes8, ResT8];
end
%%Calculate Total Flow Difference for Box (Box selection with IE index i)
TotDiff8 = [];
for t=1:n
    DiffT8 = 0;
    for i=[52:55,58,59,61]
        DiffT8 = DiffT8 + S.IE(i).diff(t);
    end
    TotDiff8 = [TotDiff8, DiffT8];
end
%% Figures
% %Total concentration, residence, and flow rate
% figure %Box 1
% hold on
% plot(TotConc)
% plot(TotRes)
% plot(TotDiff)
% title({'Total concentration, volume,', 'and (Inflow - Outflow) in selection',' (segments 16-23)'})
% xlabel('t (unit?)')
% legend({'Concentration in the Box (unit)','Total Volume (unit)','Total Flow Rate'},'Location','northeast')
% hold off
% figure %Box 2
% hold on
% plot(TotConc2)
% plot(TotRes2)
% plot(TotDiff2)
% title({'Total concentration, volume,', 'and (Inflow - Outflow) in selection',' (segments 24-31)'})
% xlabel('t (unit?)')
% legend({'Concentration in the Box (unit)','Total Volume (unit)','Total Flow Rate'},'Location','northeast')
% hold off
% figure %Box 3
% hold on
% plot(TotConc3)
% plot(TotRes3)
% plot(TotDiff3)
% title({'Total concentration, volume,', 'and (Inflow - Outflow) in selection',' (segments 32-39)'})
% xlabel('t (unit?)')
% legend({'Concentration in the Box (unit)','Total Volume (unit)','Total Flow Rate'},'Location','northeast')
% hold off
% figure %Box 4
% hold on
% plot(TotConc4)
% plot(TotRes4)
% plot(TotDiff4)
% title({'Total concentration, volume,', 'and (Inflow - Outflow) in selection',' (segments 40-47)'})
% xlabel('t (unit?)')
% legend({'Concentration in the Box (unit)','Total Volume (unit)','Total Flow Rate'},'Location','northeast')
% hold off
% % figure %Box 5
% % hold on
% % plot(TotConc5)
% % plot(TotRes5)
% % plot(TotDiff5)
% % title({'Total concentration, volume,', 'and (Inflow - Outflow) in selection',' (segments 1,3,4,8-11)'})
% % xlabel('t (unit?)')
% % legend({'Concentration in the Box (unit)','Total Volume (unit)','Total Flow Rate'},'Location','northeast')
% % hold off
% % figure %Box 6
% % hold on
% % plot(TotConc6)
% % plot(TotRes6)
% % plot(TotDiff6)
% % title({'Total concentration, volume,', 'and (Inflow - Outflow) in selection',' (segments 2,6,7,12-15)'})
% % xlabel('t (unit?)')
% % legend({'Concentration in the Box (unit)','Total Volume (unit)','Total Flow Rate'},'Location','northeast')
% % hold off
% figure %Box 7
% hold on
% plot(TotConc7)
% plot(TotRes7)
% plot(TotDiff7)
% title({'Total concentration, volume,', 'and (Inflow - Outflow) in selection',' (segments Box 7)'})
% xlabel('t (unit?)')
% legend({'Concentration in the Box (unit)','Total Volume (unit)','Total Flow Rate'},'Location','northeast')
% hold off
% figure %Box 8
% hold on
% plot(TotConc8)
% plot(TotRes8)
% plot(TotDiff8)
% title({'agent concentration, agent volume,', 'and (Inflow - Outflow) in selection',' (segments Box 8)'})
% xlabel('t (unit?)')
% legend({'Concentration in the Box (unit)','Total Volume (unit)','Total Flow Rate'},'Location','northeast')
% hold off
% 
% % figure %5+6
% % hold on
% % plot(TotConc5+TotConc6)
% % plot(TotRes5+TotRes6)
% % plot(TotDiff5+TotDiff6)
% % title('Boxes 5+6')
% % xlabel('t (unit?)')
% % legend({'Concentration in the Box (unit)','Total Volume (unit)','Total Flow Rate'},'Location','northeast')
% % hold off
% figure %7+8
% hold on
% plot(TotConc7+TotConc8)
% plot(TotRes7+TotRes8)
% plot(TotDiff7+TotDiff8)
% title('Boxes 7+8')
% xlabel('t (unit?)')
% legend({'Concentration in the Box (unit)','Total Volume (unit)','Total Flow Rate'},'Location','northeast')
% hold off

figure %Jolien's TopBox (sum of 1+3)
hold on
plot(TotConc+TotConc3)
plot(TotRes+TotRes3)
plot(TotDiff+TotDiff3)
title('Top Selection (Collaterals)')
xlabel('t [s]')
legend({'Mean contrast flow in the Box (m^3/s)','Amount of contrast (m^3)','In- and Outflow (m^3/s)'},'Location','northeast')
hold off

figure %Jolien's Bottom Box (sum of 2+4)
hold on
plot(TotConc2+TotConc4)
plot(TotRes2+TotRes4)
plot(TotDiff2+TotDiff4)
title('Bottom Selection (Collaterals)')
xlabel('t [s]')
legend({'Mean contrast flow in the Box (m^3/s)','Amount of contrast (m^3)','In- and Outflow (m^3/s)'},'Location','northeast')
hold off

% End of our code