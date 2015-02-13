% Execute all the needed stuff before doing anything else
clear all
close all

%Assignment 1
battery_model

%Assignment 3
converter_model

%Assignment 4
make_pv_characteristics_table

%Assignment 5
%%%%CHANGE THIS AS THE CURRENT PROFILE 
%%%%See wl_generator.m for the parameters
%%%%Supported distributions: 'c','b', 'u'
Load_current_profile=[ (0:3600*14-1)' (wl_generator('u', 0, 1,3600*14))'];
sim pv_battery_converter_simulation.slx
figure;
plot(Load_current_profile(:,1), Load_current_profile(:,2), simout.time ,simout.signals.values(:,6), Vpv_view.time, simout.signals.values(:,3), simout.time, simout.signals.values(:,1), ipv_req.time, ipv_req.signals.values);

xlabel('Time (s)');
ylabel('Current (A)');
title('Output currents of different module with as-much-as-possible controller');
legend({'Load current', 'Battery current', 'Real PV current', 'Solar irradiation', 'Requested PV crrent'})

figure;
[hAx]=plotyy(SOC_view.time, SOC_view.signals.values, G_simulation_input(:,1), G_simulation_input(:,2));
ylabel(hAx(1), 'Battery State-of-charge');
ylabel(hAx(2), 'Irradiation (Suns)');
legend({'SoC', 'Irradiation'});
title('Evolution of battery SoC w.r.t. irradiation');
xlabel('Time (s)')
