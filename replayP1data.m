% replayP1Data: Script to set up and run the digital twin to mimic the
% behavior of P1 from a recorded data run

%load("~/Documents/MATLAB/p1/data/P1_Testing_2024-07-26_PM/p1_MPU_9_2024-07-26_16-31-37.mat");
load("~/Documents/MATLAB/p1/data/P1_Testing_2024-07-26_PM/p1_MPU_10_2024-07-26_16-27-33.mat");
parseP1data;

long_speed_input = timeseries(GPS.HorSpd,rt_tout);
long_speed_input.Data(long_speed_input.Data < 0.1) = 0.1;

handwheel_input = timeseries(Driver.handwheel_primary,rt_tout);
handwheel_input.Data(isnan(handwheel_input.Data)) = 0;

accelerator_input = timeseries(Driver.accel_pedal,rt_tout);

GPS_Lat0 = mean(GPS.Lat(find(0 ~= GPS.Lat,50)));
GPS_Long0 = mean(GPS.Long(find(0 ~= GPS.Long,50)));
GPS_Hdg0 = pi/2 - mean(GPS.Hdg(find(0 ~= GPS.Hdg,50)))*pi/180;

tfinal = rt_tout(end);

clearvars -except long_speed_input handwheel_input accelerator_input GPS_Lat0 GPS_Long0 GPS_Hdg0 tfinal

p1_params_new

