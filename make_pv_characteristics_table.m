clear all

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

for i=1:length(G_vec)
  Ipv_use=[];
  Ppv_use=[];
  %% Generate a table as Ipv = table(G, Ppv) by using interp1(). 
  %% Please use the smaller value before power knee point. 
  Ppv_min(i) = min(Ppv(i,:));
  Ppv_max(i) = max(Ppv(i,:));
  Ppv_vec(i,:) = [Ppv_min(i): (Ppv_max(i) - Ppv_min(i))/99: Ppv_max(i)];
  % to use smaller value before the power knee point.
  Ipv_max_idx = find(Ppv(i,:)== max(Ppv(i,:)), 1, 'last');
  Ppv_use(i,:)=Ppv(i,1:Ipv_max_idx);
  Ipv_use(i,:)=Ipv(i,1:Ipv_max_idx);

  %implement here

  Ppv_to_Ipv(i,:,2) = G_vec(i)*1000*ones(1,length(Ppv_vec(i,:)))';
  Ppv_to_Ipv(i,:,1) = Ppv_vec(i,:);
  Ppv_to_Ipv(i,:,3) = interp1(Ppv_use(i,:),Ipv_use(i,:),Ppv_vec(i,:));

end
Ppv_to_Ipv(find(Ppv_to_Ipv < 0)) = 0;
surf(Ppv_to_Ipv(:,:,1), Ppv_to_Ipv(:,:,2), Ppv_to_Ipv(:,:,3))
xlabel('Irradiance (W/m2)');
ylabel('Power (W)');
zlabel('Current (A)');
%axis([min(min(Ppv_to_Ipv(:,:,1))), max(max(Ppv_to_Ipv(:,:,1))),min(min(Ppv_to_Ipv(:,:,2))), max(max(Ppv_to_Ipv(:,:,2))),min(min(Ppv_to_Ipv(:,:,3))), max(max(Ppv_to_Ipv(:,:,3)))]);
