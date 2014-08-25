function [currentEventTime ProbeType] = processMIDUSProbe(dat, PARtimeAxis)
%function [PROBEdata currentEventTime ProbeType] = processProbe(chanData, PARtimeAxis)
% This file goes through the three din channels and then marks the points
% where the probes occured 
% - Ram 10/5/05

% Combining all probe channels
%sr = PARsampleRate;
% dat = chanData; 
% load PAR_Channel;
% - Larry 10/11/2006 MIDUS version added final code to allow for slight offsets between DIN signals

% Finding the onset of the events
% Correcponding to DIN1 or ch7
difDIN1=diff(dat(7,:));  
din1Spikes = find(abs(difDIN1) > 3);
din1Probes = [];
for iEvent=1:2:length(din1Spikes)
    if din1Spikes(iEvent+1) - din1Spikes(iEvent) < 155
        din1Probes = [din1Probes din1Spikes(iEvent)];
    end
end

% Correcponding to DIN2 or ch8
difDIN2=diff(dat(8,:));  
din2Spikes = find(abs(difDIN2) > 3);
din2Probes = [];
for iEvent=1:2:length(din2Spikes)
    if din2Spikes(iEvent+1) - din2Spikes(iEvent) < 155
        din2Probes = [din2Probes din2Spikes(iEvent)];
    end
end

% Correcponding to DIN3 or ch9
difDIN3=diff(dat(9,:));  
din3Spikes = find(abs(difDIN3) > 3);
din3Probes = [];
for iEvent=1:2:length(din3Spikes)
    if din3Spikes(iEvent+1) - din3Spikes(iEvent) < 155
        din3Probes = [din3Probes din3Spikes(iEvent)];
    end
end

% Correcponding to DIN4 or ch10
difDIN4=diff(dat(10,:));  
din4Spikes = find(abs(difDIN4) > 3);
din4Probes = [];
for iEvent=1:2:length(din4Spikes)
    if din4Spikes(iEvent+1) - din4Spikes(iEvent) < 155
        din4Probes = [din4Probes din4Spikes(iEvent)];
    end
end

% Combining all onset times into 1 timeline
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

clear tmpProbes;
tmpProbes = allProbes;

% determining the type of probe
%PROBEdata = difDIN1;
%PROBEdata = union(PROBEdata,difDIN2);
%PROBEdata = union(PROBEdata,difDIN3);
%PROBEdata = union(PROBEdata,difDIN4);

ProbeType(1:1:length(tmpProbes)) = 0;
for i=1:1:length(tmpProbes)
    if min(abs(din1Probes - tmpProbes(i))) < 10 %allow for slight offsets 10 samples 11-Oct-2006
        ProbeType(i) = ProbeType(i)+1;
    end
    if min(abs(din2Probes - tmpProbes(i))) < 10
        ProbeType(i) = ProbeType(i)+2;
    end
    if min(abs(din3Probes - tmpProbes(i))) < 10
        ProbeType(i) = ProbeType(i)+4;
    end
    if min(abs(din4Probes - tmpProbes(i))) < 10
        ProbeType(i) = ProbeType(i)+8;
    end
end

event_time_index = tmpProbes;
currentEventTime = PARtimeAxis(event_time_index)';