function createMidusACQcorrugator(srcDir,destDir,task1FileName,task2FileName,task3FileName,task4FileName)
%
%
% function createMidusACQcorrugator(srcDir,destDir,task1FileName,task2FileName,task3FileName,task4FileName)
%
% INPUT:
% srcDir: directory containing four Biopac .acq TASK files
% destDir: directory into which the output .DAT, .MASK and _CFG.m files are written
% task1FileName,task2FileName,task3FileName,task4FileName: four .acq task files
%
% this function reads in the four task  acq files, concatenates them, extracts the corrugator channel
% corrugator = channel 1 of output .DAT file
% and creates three DIN event channels; DIN1 = channel 2 neg picture; DIN2 = channel 3 neu picture;
% DIN3 = channel 4 pos picture of output .DAT file;
%
% OUTPUT:
% MS###_acq_corr.DAT, MS###_acq_corr.MASK, MS###_acq_corr_CFG.m
%
% 10-Feb-2006  LG

% srcDir = 'W:\exp\midus\data\keck_startle\ms067\'
% destDir = '';
% task1FileName = 'MS067_TASK0008';
% task2FileName = 'MS067_TASK0009';
% task3FileName = 'MS067_TASK0010';
% task4FileName = 'MS067_TASK0011';

% create or open log file in source directory
%logHeader('createMidusACQcorrugator',srcDir,destDir,task1FileName,task2FileName,task3FileName,task4FileName);  


baseFileName = [task1FileName(1:7) '_acq_corr'];
% for MIDUSref data the assumed channel layout is:
rawStlChannel = 1;
zygoChannel = 2;
corrugator = 3;
DIN1 = 7;
DIN2 = 8;
DIN3 = 9;
DIN4 = 10;

% if nargin < 7
%   help epochMidusAcqStartle;
%   return;
% end

                     
[acqsr,nVarSampleDivider,dat1]=readACQFile([srcDir task1FileName]);
[acqsr,nVarSampleDivider,dat2]=readACQFile([srcDir task2FileName]);
[acqsr,nVarSampleDivider,dat3]=readACQFile([srcDir task3FileName]);
[acqsr,nVarSampleDivider,dat4]=readACQFile([srcDir task4FileName]);


dat = [dat1 dat2 dat3 dat4];
clear dat1 dat2 dat3 dat4 

difDIN1=diff(dat(DIN1,:));
difDIN2=diff(dat(DIN2,:));
difDIN3=diff(dat(DIN3,:));
difDIN4=diff(dat(DIN4,:));
din1Spikes = find(abs(difDIN1) > 3);
din2Spikes = find(abs(difDIN2) > 3);
din3Spikes = find(abs(difDIN3) > 3);
din4Spikes = find(abs(difDIN4) > 3);

% picture events are long 'boxcar' rather than short spike
din1Probes = [];
for iEvent=1:2:length(din1Spikes)
    if din1Spikes(iEvent+1) - din1Spikes(iEvent) < 100
        din1Probes = [din1Probes din1Spikes(iEvent)];
    end
end
din2Probes = [];
for iEvent=1:2:length(din2Spikes)
    if din2Spikes(iEvent+1) - din2Spikes(iEvent) < 100
        din2Probes = [din2Probes din2Spikes(iEvent)];
    end
end
din3Probes = [];
for iEvent=1:2:length(din3Spikes)
    if din3Spikes(iEvent+1) - din3Spikes(iEvent) < 100
        din3Probes = [din3Probes din3Spikes(iEvent)];
    end
end
din4Probes = [];
for iEvent=1:2:length(din4Spikes)
    if din4Spikes(iEvent+1) - din4Spikes(iEvent) < 100
        din4Probes = [din4Probes din4Spikes(iEvent)];
    end
end

tmpProbes = din1Probes;
tmpProbes = union(tmpProbes,din2Probes);
tmpProbes = union(tmpProbes,din3Probes);
tmpProbes = union(tmpProbes,din4Probes);

%remove extra slight offset probes from allProbes
allProbes(1) = tmpProbes(1);
lastProbe = allProbes(1);
probeCount = 1;
for i=2:length(tmpProbes)
    if tmpProbes(i)-lastProbe > 10  %this is a new probe
        probeCount = probeCount + 1;
        allProbes(probeCount) = tmpProbes(i);
        lastProbe = allProbes(probeCount);
    end
end

%step through allProbes and compute values
% probes are nearly simultaneous spikes on DIN channels with 1s,2s,4s and 8s places for DIN1-DIN4
allProbeValues = zeros(1,length(allProbes));
for iProbe=1:length(allProbes)   
    if min(abs(din1Probes - allProbes(iProbe))) < 10
        allProbeValues(iProbe) = allProbeValues(iProbe) + 1;
    end
    if min(abs(din2Probes - allProbes(iProbe))) < 10
        allProbeValues(iProbe) = allProbeValues(iProbe) + 2;
    end
    if min(abs(din3Probes - allProbes(iProbe))) < 10
        allProbeValues(iProbe) = allProbeValues(iProbe) + 4;
    end
    if min(abs(din4Probes - allProbes(iProbe))) < 10
        allProbeValues(iProbe) = allProbeValues(iProbe) + 8;
    end
end

din1Pics = [];
for iEvent=1:2:length(din1Spikes)
    if din1Spikes(iEvent+1) - din1Spikes(iEvent) > 100
        din1Pics = [din1Pics din1Spikes(iEvent)];
    end
end
din2Pics = [];
for iEvent=1:2:length(din2Spikes)
    if din2Spikes(iEvent+1) - din2Spikes(iEvent) > 100
        din2Pics = [din2Pics din2Spikes(iEvent)];
    end
end
din3Pics = [];
for iEvent=1:2:length(din3Spikes)
    if din3Spikes(iEvent+1) - din3Spikes(iEvent) > 100
        din3Pics = [din3Pics din3Spikes(iEvent)];
    end
end
din4Pics = [];
for iEvent=1:2:length(din4Spikes)
    if din4Spikes(iEvent+1) - din4Spikes(iEvent) > 100
        din4Pics = [din1Pics din4Spikes(iEvent)];
    end
end
allPics = din1Pics;
allPics = union(allPics,din2Pics);
allPics = union(allPics,din3Pics);
allPics = union(allPics,din4Pics);

numPics = length(allPics);
if numPics ~= 90
    msg = ['WARNING number of picture events not 90 (numPics: ' num2str(numPics) ')'];
    %displog(msg);
end
% get corrugator channel
corr = dat(corrugator,:);
clear dat;
ns = length(corr);
% initialize DAT and MASK
allChannelData = zeros(ns,4);
allChannelMask = ones(ns,4);
allChannelData(:,1) = corr';

% add picture events to channels 2-4 as 5 sample wide spikes
allChannelData(din1Pics,2) = 1;
allChannelData(din1Pics+1,2) = 1;
allChannelData(din1Pics+2,2) = 1;
allChannelData(din1Pics+3,2) = 1;
allChannelData(din1Pics+4,2) = 1;

allChannelData(din2Pics,3) = 1;
allChannelData(din2Pics+1,3) = 1;
allChannelData(din2Pics+2,3) = 1;
allChannelData(din2Pics+3,3) = 1;
allChannelData(din2Pics+4,3) = 1;

allChannelData(din3Pics,4) = 1;
allChannelData(din3Pics+1,4) = 1;
allChannelData(din3Pics+2,4) = 1;
allChannelData(din3Pics+3,4) = 1;
allChannelData(din3Pics+4,4) = 1;


cmd = ['save ' destDir baseFileName '.DAT allChannelData -mat'];
eval(cmd);

allChannelMask = ones(size(allChannelData));

cmd = ['save ' destDir baseFileName '.MASK allChannelMask -mat'];
eval(cmd);

% create and save _CFG file
fileName = [destDir baseFileName '_CFG'];
msg = ['Saving config data in Matlab-format ' fileName ' ...'];
disp(msg);
NChan = 4;
NSamp = fix(size(allChannelData,1));
NEvent = 3;
rawVersion = [];
timeStamp = [];
EventCodes = [68 73 78 49;
              68 73 78 50;
              68 73 78 51];
Samp_Rate = 1000;
gain = [];
bits = [];
range = [];
scale = [];
msg = 'rawVersion,timeStamp,EventCodes,Samp_Rate,NChan,gain,bits,range,scale,NSamp,NEvent,thisMsg';
asave(fileName,rawVersion,timeStamp,EventCodes,Samp_Rate,NChan,gain,bits,range,scale,NSamp,NEvent,msg);














