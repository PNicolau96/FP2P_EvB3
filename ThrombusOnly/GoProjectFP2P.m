% GoProject is a script file that runs all the simulations and analysis of
% the project. Purpose is to have 'one big final run' to generate all the
% needed results and carefully document what was being simulated. 

% During the project simulations can be added, deleted or 'ourcommented'
% but the final set should be all the simulations of the project. 

% The individual simulations each rebuild the initial network from scratch;
% if there is randomness in the network, these are still different,
% otherwise the initial networks may be identical (depending on which
% parameters you vary), but evolve differently

% This code and that of all the used functions should be stored in a
% repository after the final run has finished. 

% example code to demonstrate creation and initial draing of a static
% network


%% DEFINE YOUR MODEL PARAMETERS HERE
% FP2P you need to set up this function below for your specific problem
S=ModelPars; % set the default parameters, this function defines the whole model, which is stored in structure S

%% CREATE THE NETWORK TOPOLOGY
% FP2P don't change this function, it creates the whole network 
S=DefineTopology(S); % set up the whole connectivity of the network, based on parameters given in above function
% S now contains anything we need to determine for the default model, any
% changes from this or further specifications should be explicit in the parts below, but should not
% be set implicit in the called functions below. 

% FP2P we defined the sources and sinks, but their values were not yet
% included in the network, this is done below, don't change
[S.SE(find(S.sources)).sourceP]=deal(S.sourceP);
[S.SE(find(~S.sources)).sourceP]=deal(S.sinkP);

%% Illustration of building blocks
% FP2P the code below provides a single simulation of a network, resolving
% the local pressures and flows. Depending on your assignment, you might
% have to iterate these steps (for thrombi), use them in an ODE function that provides
% dX=f(X), with X the state (for adaptation), or do a single simulation and then
% simulate/determine transport of contrast. 
%% SUPPRESS WARNINGS
% you might get networks where vessels become very small, causing nearly
% singular matrices when solving the Kirchoff laws, this helps suppressing
% these warnings. 
warning('off','MATLAB:singularMatrix')
warning('off','MATLAB:nearlySingularMatrix')
S.SingularMatrixWarning='off';
%% GET THE CURRENT RADIUS
% FP2P in a static netwok, r remains r0. In a dynamic network, it
% changes....
%[S.IE.r]=vout([S.IE.r0]);

%% CALCULATE REQUIRED DERIVED VARIABLES ON PER SEGMENT BASE THAT ARE NEEDED FOR NETWORK CALCULATIONS
% for some, this can be done on a per-segment basis, like conductance
% for others, this requires processing the whole network, like pressure and
% flow. 
% note this combined use of [ ] and vout to avoid looping over all IE
% FP2P this calculates the conductance of all elements based on their
% radius and length, and viscosity, Poiseuille law. 
[S.IE.G]=vout(conductance([S.IE.r],[S.IE.l],S.fluidviscosity));

%% CALCULATE NODE PRESSURES AND ELEMENT FLOWS
% solvehemodyn uses the conductances and source pressures, and returns for
% all nodes the pressures as field and for all elements the flow and mean
% (midway) pressure 
[S.IN,S.IE, S.SE]=solvehemodyn(S.IN,S.IE,S.SE);

n=70;
contrastAgend(S,n);
%% CALCULATE FURTHER REQUIRED DERIVED VARIABLES THAT RELY ON THE NETWORK
% calculation of shear stress
[S.IE.WSS]=vout(calcshearstress([S.IE.Q],[S.IE.r],S.fluidviscosity));

%% Draw the network, very basic
DrawNetwork(S,40); % second argument is figure number

%% TransportOrder
%[S,TransportOrder]=GetTransportOrder(S)

