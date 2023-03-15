% Plot and post process maestro data from wire walkers
% Katie Pocock 2022.08.10

% this script requires the RBR RSKtools package, downloaded here: http://www.rbr-global.com/support/matlab-tools

% generate rsk structure with all metadata
rsk = RSKopen('209760_20221206_1527.rsk');  

% If desired read a subset of the data to remove data collected out of the
% water
starttime = datenum(2022, 11, 22, 4, 19, 00); %remove data from when WW was stuck for first few days
endtime = datenum(2022, 12, 02, 18, 11, 00); %remove last few days of data when not many profiles done
rsk = RSKreaddata(rsk, 't1', starttime, 't2', endtime); 

% % read all data from structure
% rsk = RSKreaddata(rsk); 

% print a list of all the channels in the rsk file
RSKprintchannels(rsk);

% NOTE: dataset only include non-derived variables (1-8 only)

% organize data into profiles
rsk = RSKfindprofiles(rsk);

% plot pressure time series to check profile detection
% handles = RSKplotdata(rsk, 'channel', 'Pressure','showcast',true)

% derive variables
rsk = RSKderiveseapressure(rsk);
rsk = RSKderivedepth(rsk);
rsk = RSKderivevelocity(rsk);

% handles = RSKplotdata(rsk, 'channel', {'Pressure','Velocity'},'showcast',true)

%% Plot vertical profiles

rsk = RSKopen('209760_20221206_1527.rsk');  
rsk = RSKreaddata(rsk)

rsk = RSKfindprofiles(rsk);
rsk = RSKreadprofiles(rsk);

rsk = RSKderiveseapressure(rsk);
rsk = RSKderivesalinity(rsk);

handles = RSKplotprofiles(rsk, 'channel', {'Conductivity', 'Temperature', 'Salinity'}, 'direction', 'up','profile', [8:10]);

%% Contour plots

rsk = RSKbinaverage(rsk, 'binBy', 'Sea Pressure', 'binSize', 1,'boundary', [60 0],'direction', 'up','visualize', 10);

figure
[im_hdl,ax_hdl] = RSKimages(rsk,'channel',{'Temperature','Salinity','Dissolved O2','Chlorophyll'},'direction','up');
