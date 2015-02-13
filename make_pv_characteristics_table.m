%%PV panel parameters
W=1;
H=10;

%% Load daily solar irradiation profile
load('example_variable_set.mat');   
G_vec = [min(G_log(:,2)):(max(G_log(:,2)) - min(G_log(:,2)))/49:max(G_log(:,2))]/1000;
G_simulation_input = G_log;
G_simulation_input(:,2) = G_simulation_input(:,2)/1000;

%% Generate a table as Ipv = table(G, Vpv)
Vpv_min = 0;
Vpv_max = 0.65;
Vpv_vec = [Vpv_min:(Vpv_max - Vpv_min)/99:Vpv_max];
for i=1:length(Vpv_vec)
    Ipv(:,i) = solar(Vpv_vec(i), G_vec, 25);
    Ppv(:,i) = Vpv_vec(i) * Ipv(:,i); % get Ppv = table(G, Vpv)
end

% This will be used by the current controller, and is a worst-case I(G) table
% Now Ipv is a matrix composed as
%x----------->V
%|i i i i i i 
%|i i i i i i 
%|i i i i i i 
%|i i i i i i 
%|i i i i i i 
%vi i i i i i 
%G
G_Vpv_Ipv=Ipv

% IMPORTANT!!! %
% now we will have different Ppv references for each G value. 
% The simulink block needs a 1-dimensional breakpoint vector for each table
% -> We will interpolate until the maximum is reached (there will be looots of NaN)
Ppv_min = min(min(Ppv));
Ppv_max = max(max(Ppv));
Ppv_vec = [Ppv_min: (Ppv_max - Ppv_min)/200: Ppv_max];

Ppv_to_Ipv=[];
G_to_PpvMax=[];
for i=1:length(G_vec)
  %% Generate a table as Ipv = table(G, Ppv) by using interp1(). 
  %% Please use the smaller value before power knee point. 
  % to use smaller value before the power knee point.
  Ipv_max_idx = find(Ppv(i,:)== max(Ppv(i,:)), 1, 'last');
  Ppv_use=Ppv(i,1:Ipv_max_idx);
  Ipv_use=Ipv(i,1:Ipv_max_idx);
  G_to_PpvMax=[G_to_PpvMax; G_vec(i) Ppv_use(end)];

  %implement here

  Ppv_to_Ipv(i,:,2) = G_vec(i)*1000*ones(1,length(Ppv_vec))';
  Ppv_to_Ipv(i,:,1) = Ppv_vec';
  Ppv_to_Ipv(i,:,3) = interp1(Ppv_use,Ipv_use,Ppv_vec); %, 'linear', 0); % Take some NaN

end
Ppv_to_Ipv(find(Ppv_to_Ipv < 0)) = 0;
surf(Ppv_to_Ipv(:,:,1), Ppv_to_Ipv(:,:,2), Ppv_to_Ipv(:,:,3))
xlabel('Power (W)');
ylabel('Irradiance (W/m2)');
zlabel('Current (A)');

%Ppv_to_Ipv=Ppv_to_Ipv(:,:,3);
%axis([min(min(Ppv_to_Ipv(:,:,1))), max(max(Ppv_to_Ipv(:,:,1))),min(min(Ppv_to_Ipv(:,:,2))), max(max(Ppv_to_Ipv(:,:,2))),min(min(Ppv_to_Ipv(:,:,3))), max(max(Ppv_to_Ipv(:,:,3)))]);
