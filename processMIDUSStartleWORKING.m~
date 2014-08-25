function processMIDUSStartle(fileName)

%function [PROBEdata] = processStartle(chanData, STLsampleRate, STLtimeAxis, filename)
STL_Channel = 1; % for MIDUS study

% Changed Sept 30 2005 Ram
[STLsampleRate, STLtimeAxis, chanData] = readACQFile(fileName);
num = size(chanData,1);
if (num < 10)
    disp('Some Data Channels are missing ...!');
    if (findstr(fileName,'81') == 4)
        disp('This file is a part of MS081 data set.');
        disp('Two channels are missing.');
        disp('Rearranging data to allow processing');
        tCh = chanData;
        clear chanData;
        n = size(tCh);
        temp(1:1:n(2)) = 0;
        chanData = [tCh(1,:); tCh(2,:); tCh(3,:); temp; temp;
            tCh(4,:); tCh(5,:); tCh(6,:); tCh(7,:)];
    else
        return;
    end
end
% Digital integration
STLdata = integrate_startle(chanData(1,:),STLsampleRate);
STLnumberSamples = size(STLdata,1);

[currentEventTime ProbeType] = processMIDUSProbe(chanData, STLtimeAxis);

% Digital integration assumes startle data on channel 1
STLdata = integrate_startle(chanData(STL_Channel,:), STLsampleRate);
STLnumberSamples = length(STLdata);

%INSERT EDITLATENTSTARTLEONSET HERE
%Eprime naming convention: MIDUSref_startle_order1_FINAL_VERSION-090-090
% OR MIDUSref_startle_order2_FINAL_VERSION-075-075

subjectStartChar = findstr(fileName, 'mrfr') + 4;
subjectEndChar =  findstr(fileName, '_')-1;
taskStartChar = findstr(fileName, 'task') + 4;

subject = fileName(subjectStartChar: subjectEndChar);

task = fileName(taskStartChar: end);

if task ~= -1
    
    %takes out leading zeros
    subjectnum = str2num(regexprep(subject,'^0*',''));
    tasknum = str2num(regexprep(task,'^0*',''));
end

if subjectnum < 10
    
    eprimeSub = ['00', num2str(subjectnum)];
else
    eprimeSub = ['0', num2str(subjectnum)];
end

order = 1;
eprimeFileName = strcat('/study4/midusref/raw-data/EMG/eprime/MIDUSref_startle_order', ...
num2str(order), '_FINAL_VERSION-', eprimeSub, '-', eprimeSub, '.txt');
fid = fopen(eprimeFileName);

if fid == -1
    order = 2;
    eprimeFileName = strcat('/study4/midusref/raw-data/EMG/eprime/MIDUSref_startle_order', ...
    num2str(order), '_FINAL_VERSION-', eprimeSub, '-', eprimeSub, '.txt');
    fid = fopen(eprimeFileName);
end

if fid == -1
    eprimeFileName = strcat('/study4/midusref/raw-data/EMG/eprime/MIDUSref_startle_order1', ...
    '_FINAL_VERSION_no_eyetracking-', eprimeSub, '-', eprimeSub, '.txt');
    fid = fopen(eprimeFileName);
end

if fid == -1
    eprimeFileName = input('Please provide the eprime text file name (including .txt)\n', 's');
end

    


editedCurrentEventTime = editedLatentStartleOnset(eprimeFileName, currentEventTime, tasknum);


%DONE EDITING

for i = 1:length(editedCurrentEventTime(:, 1))
    startleParameters(i) = calculateStartleParameters(STLdata, STLtimeAxis, editedCurrentEventTime(i, 1));
end

% Saving Probe Type information within the startleParameters structure
% Ram, Feb 13 2006
for i=1:1:length(ProbeType)
    startleParameters(i).probe_type = ProbeType(i);
end
global PathFileName;

local_path = pwd;
if isunix == 1
    PathFileName = ['/study/midusref/DATA/EBR/' fileName];
else
    PathFileName = ['\study\midusref\DATA\EBR\' fileName];
end

eval(['save ' PathFileName '_STLDATA STLdata STLnumberSamples STLsampleRate STLtimeAxis']);
eval(['save ' PathFileName '_STLSTAT startleParameters ProbeType']);
eval(['save ' PathFileName '_STL currentEventTime']);

