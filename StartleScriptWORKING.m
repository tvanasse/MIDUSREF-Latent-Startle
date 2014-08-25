function StartleScript()
%Luke Hinsenkamp 09/24/2012
%Takes input of subject numbers (comma, space, or both separated) and processes startle data. 
%When finished (or if "s"/"skip" is entered as subject), gives option to open files in startle scoring gui. 
%Loops on "another data file in gui" y/n question until user says says "n".


w=warning('off','MATLAB:dispatcher:nameConflict');
addpath /apps/brogden/matlab/biopac;
addpath /apps/brogden/matlab ;
addpath /study/midusref/DATA/DataScripts -begin
addpath(genpath('/study4/midusref/raw-data/EMG/eprime'))
addpath(genpath('/study4/midusref/DATA/DataScripts/NEW_Scripts'))
cd /study/midusref/DATA/EBR;
currentdir=pwd;
eval('setupacqStartle_Keck');

disp(' ');
disp('-------------------------------------------');
disp('Please type Subject Numbers, separated by commas, spaces, or both.');
disp(' ');
disp('Or type "skip" to open files for viewing');
disp(' ');
SubString=input('For example, mrfr997 and mrfr998 would be "997,998" "997 998" or "997, 998": \n-------------------------------------------\n','s');

zero='0000';  %Will be used to add leading zeros back to single and double digit subject IDs (had trouble efficiently  handling single & double digit SubIDs)

SubList=str2num(SubString);

if SubString(1) >0;

	SubList=str2num(SubString);

	for x=1:length(SubList);
		
		
		if length(num2str(SubList(x)))<3;
			sub=[zero(1:3-length(num2str(SubList(x)))) num2str(SubList(x))];
		else
			sub=num2str(SubList(x));
		end
		
		eval(['cd /study/midusref/raw-data/EMG/mrfr' sub]); 
        
        		
% 		if length(dir(['/study/midusref/DATA/EBR/mrfr' sub '*']))>0  %non-specific test for existence of processed files (comment out if re-running one of the files)
% 			fprintf('%s is already processed', sub);	
		if length(dir(['/study/midusref/raw-data/EMG/mrfr' sub '/mrfr' sub '*']))>0  %if files exist in raw-data folder:
			fprintf('%s is now being processed', sub);
			
			
			%%############   Evaluating Practice block    ############%%
			
			pracname=dir(['mrfr' sub '_prac*']);
% 			if length(pracname)==1
% 				acqStartleWORKING(pracname.name(1:length(pracname.name)-4),'MIDUS','noninteractive');  %would probably be more neat to put in y=0:4 and make the 0 condition be prac, but this is easier... NOTE: "prac" shouldn't have any numbers after it!
% 			elseif length(pracname)>1
% 				disp(' ');
% 				disp('-------------------------------------------');
% 				disp(' ');
% 				disp('There are multiple prac files. Please pick one.');
% 				disp('Note: Usually they"re around 4mb');
% 				for x=1:length(pracname)
% 					fprintf('(%d)  %s  size: %.0f kb\n',x,pracname(x).name,(pracname(x).bytes)/1000)
% 				end
% 				pracchoice=input('Type 1 for first, 2 for second, etc., and hit enter\n');
% 				pracname=pracname(pracchoice);
% 			% if length(pracname.name)>0
% 				% acqStartleWORKING(pracname.name(1:length(pracname.name)-4),'MIDUS','noninteractive');  %would probably be more neat to put in y=0:4 and make the 0 condition be prac, but this is easier... NOTE: "prac" shouldn't have any numbers after it!
% 			else
% 				disp('Couldn''t find the prac file. Skipping it.')
% 			end
			
			
			%#######                  Four Task Blocks                     #######%
			%#######                                                       #######%
			%#######    This will work for "task1-4" OR "task0001-0004"    #######%
			
			for y=1:4 
				if exist(['/study/midusref/raw-data/EMG/mrfr' sub '/mrfr' sub '_task' num2str(y) '.acq']); 
					acqStartleWORKING(['mrfr' sub '_task' num2str(y)],'MIDUS', 'noninteractive');  %noninteractive option means no pop-up boxes
				elseif exist(['/study/midusref/raw-data/EMG/mrfr' sub '/mrfr' sub '_task000' num2str(y) '.acq']);
					disp(['File: ../raw-data/EMG/mrfr' sub '/mrfr' sub '_task' num2str(y) '.acq  does not exist; trying _task000' num2str(y) '.']);
					acqStartleWORKING(['mrfr' sub '_task000' num2str(y)],'MIDUS', 'noninteractive');  %noninteractive option means no pop-up boxes
				else
					disp(['File: ../raw-data/EMG/mrfr' sub '/mrfr' sub '_task000' num2str(y) '.acq  does not exist either; moving on.']);
				end
			end
		else
			fprintf('Sorry, there are no data for mrfr%s. \n Check the /study/midusref/raw-data/EMG folder!\n',sub)
			return
		end
	end
end

cd(currentdir)
%calling up each file for editing *New fxn might be better...(?)
nextstep=input('\n Open a datafile in gui? (y/n)\n','s');

while nextstep=='y' || nextstep=='Y'
	sub=input('\n Subject Number?\n','s');
	disp(' ')
	if length(num2str(sub))<3;
		sub=[zero(1:3-length(num2str(sub))) num2str(sub)];
	else
		sub=num2str(sub);
	end
	if length(dir(['/study/midusref/DATA/EBR/mrfr' sub '*']))>0;
		subfiles=dir(['/study/midusref/DATA/EBR/mrfr' sub '*L.mat']);
		for n=1:length(subfiles)
			fprintf('Option Number (%d):   %s \n', n, subfiles(n).name);
		end
		tasknum=input('\nEnter "Option Number" to open that file:\n');
		acqStartleWORKING(subfiles(tasknum).name(1:length(subfiles(tasknum).name)-8),'MIDUS');
		nextstep=input('\nOpen another datafile in gui? (y/n, once other file is closed)\n','s');
	else
		fprintf('Sorry, subject %s has not been processed yet.\n',sub);
		nextstep=input('\nOpen another datafile in gui? (y/n, once other file is closed)\n','s');
	end
end

