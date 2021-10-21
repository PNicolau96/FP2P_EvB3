function IE=LengthFromPosition(IE,IN)
% % calculates the length of the segments based on the position of the nodes,
% % works for 2D and 3D
% rng('default');
% for i=1:length(IE)
%     if i>= 10 && i <= 55
%         % Radomly change some vessel lengths for segments 10 - 55:
%         rng(i);
%         random_l = rand(1) * (0.05 - 0.0005) + 0.0005;
%         IE(i).l = random_l;
%         %IE(i).r = rand(1) * 10^(-6) * (5 - 1) + 10^(-6);
%         %IE(i).l = 0.1;
%     else
%         IE(i).l=norm(IN(IE(i).nodes(1)).pos-IN(IE(i).nodes(2)).pos);
%     end
% end

%radii
IE(1).r=0.001;%Simulated Thrombus
IE(2).r=2.07;

IE(3).r=0.96;
IE(4).r=0.98;
IE(5).r=1.04;
IE(6).r=1.35;

IE(7).r=0.76;
IE(8).r=0.76;
IE(9).r=0.78;
IE(10).r=0.53;
IE(11).r=0.83;
IE(12).r=0.83;
IE(13).r=1.07;
IE(14).r=1.07;

IE(15).r=0.6;
IE(16).r=0.6;
IE(17).r=0.6;
IE(18).r=0.6;
IE(19).r=0.62;
IE(20).r=0.62;
IE(21).r=0.62;
IE(22).r=0.62;
IE(23).r=0.66;
IE(24).r=0.66;
IE(25).r=0.66;
IE(26).r=0.66;
IE(27).r=0.85;
IE(28).r=0.85;
IE(29).r=0.85;
IE(30).r=0.85;

IE(31).r=0.6;
IE(32).r=0.6;
IE(33).r=0.6;
IE(34).r=0.6;
IE(35).r=0.62;
IE(36).r=0.62;
IE(37).r=0.62;
IE(38).r=0.62;
IE(39).r=0.66;
IE(40).r=0.66;
IE(41).r=0.66;
IE(42).r=0.66;
IE(43).r=0.85;
IE(44).r=0.85;
IE(45).r=0.85;
IE(46).r=0.85;

IE(47).r=1.52;
IE(48).r=1.52;
IE(49).r=1.56;
IE(50).r=1.06;
IE(51).r=1.66;
IE(52).r=1.66;
IE(53).r=2.14;
IE(54).r=2.14;

IE(55).r=1.92;
IE(56).r=1.96;
IE(57).r=2.08;
IE(58).r=2.7;

IE(59).r=3.22;
IE(60).r=4.14;

%lengths
IE(1).l=30.1;
IE(2).l=4.7;

IE(3).l=6.8;
IE(4).l=6.9;
IE(5).l=2.5;
IE(6).l=27.8;

IE(7).l=5.4;
IE(8).l=5.4;
IE(9).l=5.48;
IE(10).l=10.56;
IE(11).l=1.98;
IE(12).l=1.98;
IE(13).l=22.06;
IE(14).l=22.06;

IE(15).l=4.28;
IE(16).l=4.28;
IE(17).l=4.28;
IE(18).l=4.28;
IE(19).l=4.35;
IE(20).l=4.35;
IE(21).l=4.35;
IE(22).l=4.35;
IE(23).l=1.57;
IE(24).l=1.57;
IE(25).l=1.57;
IE(26).l=1.57;
IE(27).l=17.51;
IE(28).l=17.51;
IE(29).l=17.51;
IE(30).l=17.51;

IE(31).l=4.28;
IE(32).l=4.28;
IE(33).l=4.28;
IE(34).l=4.28;
IE(35).l=4.35;
IE(36).l=4.35;
IE(37).l=4.35;
IE(38).l=4.35;
IE(39).l=1.57;
IE(40).l=1.57;
IE(41).l=1.57;
IE(42).l=1.57;
IE(43).l=17.51;
IE(44).l=17.51;
IE(45).l=17.51;
IE(46).l=17.51;

IE(47).l=5.4;
IE(48).l=5.4;
IE(49).l=5.48;
IE(50).l=10.56;
IE(51).l=1.98;
IE(52).l=1.98;
IE(53).l=22.06;
IE(54).l=22.06;

IE(55).l=6.8;
IE(56).l=6.9;
IE(57).l=2.5;
IE(58).l=27.8;

IE(59).l=30.1;
IE(60).l=4.7;

for i=1:length(IE)
    IE(i).l=IE(i).l*10^(-3);
    IE(i).r=IE(i).r*10^(-3);
end

