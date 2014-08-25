function [editedCurrentEventTime] = editLatentStartleOnset(eprimeFileName, currentEventTimes, tasknum)
% This function changes the currentEventTime 50ms before
% the Startle.offset according to the Eprime files, rather than the
% Startle.onset time marked by the DIN channels.  This is due to incompatiblity of E-Prime
% 2.0.8.90a with Windows 7, causing sound latency.

%eprimeFileName = 'MIDUSref_startle_order1_FINAL_VERSION-003-003.txt';


fid = fopen(eprimeFileName,'r');

timeOnMat = zeros([1,86]);
timeOffMat = zeros([1,86]);

countStlOn = 0;
countStlOff = 0;

for k=1:172
    if mod(k,2) ~= 0
        line = read_to_line(fid,'StartleProbe.OnsetTime:');
        countStlOn = countStlOn +1;
    else
        line = read_to_line(fid,'StartleProbe.OffsetTime:');
        countStlOff = countStlOff +1;
    end
    
    
    startCharOn = findstr(line,':') + 1;
    
    timeOn = line(startCharOn:end);
    
    timeOnNew = '';
    for j= 1: 1:length(timeOn);
        if uint16(timeOn(j)) ~= 0;
            
            timeOnNew = strcat(timeOnNew, timeOn(j));
            
            
        end
    end
    
    timeNewNum = str2num(timeOnNew);
    
    if mod(k,2) ~= 0
        timeOnMat(1,countStlOn) = timeNewNum;
    else
        timeOffMat(1, countStlOff) = timeNewNum;
        
    end
end
%
% timeOnMat
% timeOffMat


diff = zeros([81,1]);
for i = 1:86
    diff(i,1) = timeOffMat(1,i)/1000-timeOnMat(1,i)/1000-.050;
end


if tasknum == 1
    
    cuttDiff = diff(6:25,1);
    
    
else if tasknum == 2
        
        cuttDiff = diff(26:46,1);
        
        
    else if tasknum ==3
            
            cuttDiff = diff(47:66,1);
            
            
        else
            cuttDiff = diff(67:86,1);
            
            
        end
    end
end

for i=1:1:length(currentEventTimes)
    
    editedCurrentEventTime(i,1) = currentEventTimes(i,1) + cuttDiff(i,1);
    
end






    function g = read_to_line(fid,pattern)
        %
        % read lines from file fid until pattern is found
        % line = -1 if end of file encountered
        % taskSessionEnd is set to 1 if Procedure: pause
        % is encountered indicating the end of task session
        %
        
        patternFound = 0;
        while ~patternFound
            g = fgetl(fid);
            if g == -1
                return;
            end
            
            %creates new string because space values have different numeric
            %codes in Editor and Command Window (compare unit16(g) and
            %unit16(pattern)
            
            g = strtrim(g);
            
            gnew = '';
            for i= 1: 1:length(g);
                if uint16(g(i)) ~= 0;
                    
                    gnew = strcat(gnew, g(i));
                end
            end
            
            
            if ~isempty(strfind(gnew,pattern))
                patternFound = 1;
                %                 endtime = timeOn;
                
                
            end
        end
        
    end
fclose(fid);

end


