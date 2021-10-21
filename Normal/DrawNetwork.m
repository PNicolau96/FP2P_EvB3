function hfig = DrawNetwork(S,fignum)

% FP2P: this is very basic drawing of the topology, you could extend this
% to color-coded or line width-coded plots of radius, flow, WSS, ... 
% you could also make multiple subplots in a single plot


hfig=figure(fignum);clf; hold on 

for i=1:S.nin
	plot(S.IN(i).x,S.IN(i).y,'og')
end
for j=1:S.nie
	 xx=[S.IN(S.IE(j).nodes).x];yy=[S.IN(S.IE(j).nodes).y]; %% xx are x values of left and right node
	 plot(xx,yy,'-b')
end
v=find([S.IN.nsources]); % these indices in IN are connected to SE
for k=1:length(v)
	 plot(S.IN(v(k)).x,S.IN(v(k)).y,'or')
end
daspect([ 1 1 1]) % data aspect ratio same scale in all directions
hold off

