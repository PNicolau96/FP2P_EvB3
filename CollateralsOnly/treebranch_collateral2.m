function S=treebranch_geometry(Sin)
S=Sin;
S.geom.version='treebranch version oct 08 2021';



IE(1).nodes=[1 2]; % this element connects nodes 1 and 2;  
IE(2).nodes=[1 3];
IE(3).nodes=[2 4];
IE(4).nodes=[3 6];
IE(5).nodes=[3 7];

IE(6).nodes=[4 5];
IE(7).nodes=[4 8];
IE(8).nodes=[4 9];
IE(9).nodes=[5 10];
IE(10).nodes=[5 11];
IE(11).nodes=[6 12];
IE(12).nodes=[6 13];

IE(13).nodes=[7 14];
IE(14).nodes=[7 15];

IE(15).nodes=[8 16];
IE(16).nodes=[8 17];
IE(17).nodes=[9 18];
IE(18).nodes=[9 19];
IE(19).nodes=[10 20];
IE(20).nodes=[10 21];
IE(21).nodes=[11 22];
IE(22).nodes=[11 23];
IE(23).nodes=[12 24];
IE(24).nodes=[12 25];
IE(25).nodes=[13 26];
IE(26).nodes=[13 27];
IE(27).nodes=[14 28];
IE(28).nodes=[14 29];
IE(29).nodes=[15 30];
IE(30).nodes=[15 31];



IE(31).nodes=[16 32];
IE(32).nodes=[17 32];
IE(33).nodes=[18 33];
IE(34).nodes=[19 33];
IE(35).nodes=[20 34];
IE(36).nodes=[21 34];
IE(37).nodes=[22 35];
IE(38).nodes=[23 35];
IE(39).nodes=[24 36];
IE(40).nodes=[25 36];

IE(41).nodes=[26 37];
IE(42).nodes=[27 37];
IE(43).nodes=[28 38];
IE(44).nodes=[29 38];
IE(45).nodes=[30 39];
IE(46).nodes=[31 39];
IE(47).nodes=[32 40];
IE(48).nodes=[33 40];
IE(49).nodes=[34 41];
IE(50).nodes=[35 41];

IE(51).nodes=[36 42];
IE(52).nodes=[37 42];
IE(53).nodes=[38 43];
IE(54).nodes=[39 43];
IE(55).nodes=[40 44];
IE(56).nodes=[41 44];
IE(57).nodes=[42 45];
IE(58).nodes=[43 45];
IE(59).nodes=[44 46];
IE(60).nodes=[45 46];



% table for elements that connect to sources/sinks and a single node
SE(1).node=1;
SE(2).node=46;% note this is the venous outflow sink

[IN,nin]=MakeNodeTable(IE,SE);



l=1e-3;
d=sqrt(2); % keep lengths 1 in this example
dx=l*cos(pi/3); dy=l*sin(pi/3); % 60 degrees angles
dx1=l*cos(pi/7);dy1=l*sin(pi/7);
dx2=l*cos(pi/20);dy2=l*sin(pi/20);
dx3=l*cos(pi/40);dy3=l*sin(pi/40);

IN(1).pos=[1e-3 1e-3]; % (m), x and y value
IN(2).pos=IN(1).pos + [dx -dy];
IN(3).pos=IN(1).pos + [dx dy];

IN(4).pos=IN(2).pos + [dx1 -dy1];
IN(5).pos=IN(2).pos + [dx1 dy1];
IN(6).pos=IN(3).pos + [dx1 -dy1];
IN(7).pos=IN(3).pos + [dx1 dy1];

IN(8).pos=IN(4).pos + [dx2 -dy2];
IN(9).pos=IN(4).pos + [dx2 dy2];
IN(10).pos=IN(5).pos + [dx2 -dy2];
IN(11).pos=IN(5).pos + [dx2 dy2];
IN(12).pos=IN(6).pos + [dx2 -dy2];
IN(13).pos=IN(6).pos + [dx2 dy2];
IN(14).pos=IN(7).pos + [dx2 -dy2];
IN(15).pos=IN(7).pos + [dx2 dy2];

IN(16).pos=IN(8).pos + [dx3 -dy3];
IN(17).pos=IN(8).pos + [dx3 dy3];
IN(18).pos=IN(9).pos + [dx3 -dy3];
IN(19).pos=IN(9).pos + [dx3 dy3];
IN(20).pos=IN(10).pos + [dx3 -dy3];
IN(21).pos=IN(10).pos + [dx3 dy3];
IN(22).pos=IN(11).pos + [dx3 -dy3];
IN(23).pos=IN(11).pos + [dx3 dy3];
IN(24).pos=IN(12).pos + [dx3 -dy3];
IN(25).pos=IN(12).pos + [dx3 dy3];
IN(26).pos=IN(13).pos + [dx3 -dy3];
IN(27).pos=IN(13).pos + [dx3 dy3];
IN(28).pos=IN(14).pos + [dx3 -dy3];
IN(29).pos=IN(14).pos + [dx3 dy3];
IN(30).pos=IN(15).pos + [dx3 -dy3];
IN(31).pos=IN(15).pos + [dx3 dy3];

IN(32).pos=IN(16).pos + [dx3 dy3];
IN(33).pos=IN(18).pos + [dx3 dy3];
IN(34).pos=IN(20).pos + [dx3 dy3];
IN(35).pos=IN(22).pos + [dx3 dy3];
IN(36).pos=IN(24).pos + [dx3 dy3];
IN(37).pos=IN(26).pos + [dx3 dy3];
IN(38).pos=IN(28).pos + [dx3 dy3];
IN(39).pos=IN(30).pos + [dx3 dy3];

IN(40).pos=IN(32).pos + [dx2 dy2];
IN(41).pos=IN(34).pos + [dx2 dy2];
IN(42).pos=IN(36).pos + [dx2 dy2];
IN(43).pos=IN(38).pos + [dx2 dy2];

IN(44).pos=IN(40).pos + [dx1 dy1];
IN(45).pos=IN(42).pos + [dx1 dy1];

IN(46).pos=IN(44).pos + [dx dy];

for i=1:length(IN)
	IN(i).x=IN(i).pos(1);
	IN(i).y=IN(i).pos(2);
end





%% define the lengths of the internal elements / don't change this
% calculate the lengths of the segments from the positions of the nodes,
% assuming straight segments
% might be obvious in some cases like the wheatstone, but not in others

IE=LengthFromPosition(IE,IN); 
%% define the (initial) radius 
[IE.r0]=deal(S.r0);
IE(2).r=0.9*S.r0; %  (m) <== smaller radius

%% define the lengths and other properties of source-connecting elements
% for the simulation, only the conductance is relevant. For plotting, we
% still need to add positions. 
SE(1).l=1e-3;       % m length
SE(1).r=1e-4;      % m internal radius
SE(1).G=pi*SE(1).r^4/(8*S.fluidviscosity*SE(1).l);

SE(2).l=1e-3;       % m length
SE(2).r=1e-4;      % m internal radius
SE(2).G=pi*SE(2).r^4/(8*S.fluidviscosity*SE(2).l);

%% define the external pressures
% define source and sink pressures in N/m2 
% % SE(1).sourceP=100*133;		% (N/m2)
% % SE(2).sourceP=5*133;		% (N/m2)

% note that these values might be changing in time, if they are chosen as
% input variables. In that case it should not be necessary to initialize
% them here. 

SE(find(S.sources)).sourceP=S.sourceP;		% (N/m2)
SE(find(~S.sources)).sourceP=S.sinkP;		% (N/m2)
%% collect the elemens and nodes in S
S.IE=IE;
S.IN=IN;
S.SE=SE;



