% setupP1DigitalTwin: Script to set up and run the digital twin to mimic the
% behavior of P1 from a recorded data run

% Add the main P1 control repo directory and scripts subdirectory to the
% path so setup and plotting scripts can be found
addpath('../p1/')
addpath('../p1/_scripts/')

% Load a data set that will be used to test the digital twin's performance
%load("~/Documents/MATLAB/p1/data/P1_Testing_2024-07-26_PM/p1_MPU_9_2024-07-26_16-31-37.mat");    % A slaloming maneuver
load("~/Documents/MATLAB/p1/data/P1_Testing_2024-07-26_PM/p1_MPU_10_2024-07-26_16-27-33.mat");    % A simple curve

% Once the data set is loaded, parse the variables to obtain real-world
% signals in structures
parseP1data;

% Extract the recorded handwheel signal and put it into a timeseries format
% to feed in as input to the digital twin
handwheel_input = timeseries(Driver.handwheel_primary,rt_tout);
% Zero any NaN values (which typically appear right at the beginning before
% the handwheel gets properly initialized)
handwheel_input.Data(isnan(handwheel_input.Data)) = 0;

% Extract the recorded accelerator signal and put it into a timeseries
% format to feed in as input to the digital twin
accelerator_input = timeseries(Driver.accel_pedal,rt_tout);

% Extract the initial GPS Latitude, Longitude, and Heading to set the start
% location for the simulation. Use the first 50 non-zero points to average
% out variation in the GPS reading once the GPS gets the position fix
GPS_Lat0 = mean(GPS.Lat(find(0 ~= GPS.Lat,50)));
GPS_Long0 = mean(GPS.Long(find(0 ~= GPS.Long,50)));
% The heading has to be adjusted to match vehicle global yaw angles, which
% go counterclockwise from East, whereas GPS heading goes clockwise from
% North
GPS_Hdg0 = pi/2 - mean(GPS.Hdg(find(0 ~= GPS.Hdg,50)))*pi/180;

% Set the simulation end time to match the experimental data elapsed time
tfinal = rt_tout(end);

% Clear out all variables except the ones needed as inputs to the
% simulation
clearvars -except long_speed_input handwheel_input accelerator_input GPS_Lat0 GPS_Long0 GPS_Hdg0 tfinal

