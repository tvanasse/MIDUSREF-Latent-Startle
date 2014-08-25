function MidusCorrAndZygo()
%Luke Hinsenkamp 09/26/2012
%Takes input of subject numbers (comma, space, or both separated) 
%and processes both corrugator and zygomatic data.


w=warning('off','MATLAB:dispatcher:nameConflict');

addpath /apps/brogden/matlab/biopac;
%below finds "logHeader.m", at least.
addpath /apps/brogden/matlab ;
addpath /study/midusref/DATA/DataScripts -begin;
%below enables eegscore, to view/score data
addpath /apps/brogden/matlab/eegs;
addpath /apps/brogden/matlab/Ledalab/main/import %enables "load_acq" within "read_acq" (if eegscore is crashing when trying to load, you needed to do this)


disp(' ');
disp('-------------------------------------------');
disp('Please type Subject Numbers, separated by commas, spaces, or both.');
disp(' ');

SubString=input('For example, mrfr997 and mrfr998 would be "997,998" "997 998" or "997, 998": \n-------------------------------------------\n','s');
destDir='/study/midusref/DATA/';
zero='0000';  %Will be used to add leading zeros back to single and double digit subject IDs (had trouble efficiently handling single & double digit SubIDs while allowing up to three digits)

SubList=str2num(SubString);

if SubString(1) >0;
	zero='0000';  %Will be used to add leading zeros back to single and double digit subject IDs

	SubList=str2num(SubString);

	for x=1:length(SubList);
			
		if length(num2str(SubList(x)))<3;
			sub=[zero(1:3-length(num2str(SubList(x)))) num2str(SubList(x))];
			eval(['cd /study/midusref/raw-data/EMG/mrfr' sub]);  
		else
			sub=num2str(SubList(x));
			eval(['cd /study/midusref/raw-data/EMG/mrfr' sub]);  
		end
		srcDir=['/study/midusref/raw-data/EMG/mrfr' sub '/'];
		rawdata=dir(['/study/midusref/raw-data/EMG/mrfr' sub '/mrfr' sub '_task*']);
		if length(dir(['/study/midusref/DATA/Corr_Processed/mrfr' sub '*']))>0  && length(dir(['/study/midusref/DATA/Zygo_Processed/mfr' sub '*']))>0 	  %Test for existence of processed Corr & Zygo files (comment out if re-running one of the files--must also comment out the createMidusACQxxxx line below or you'll overwrite the zygo/corr data you're not trying to redo!)
			fprintf('The Corr and Zygo data for %s have already been processed\n', sub);	
		elseif length(rawdata)>0  %if files exist in raw-data folder:
			fprintf('%s is now being processed\n', sub);
			createMidusACQzygo(srcDir,[destDir 'Zygo_Processed/'],rawdata(1).name(1:length(rawdata(1).name)-4),rawdata(2).name(1:length(rawdata(2).name)-4),rawdata(3).name(1:length(rawdata(3).name)-4),rawdata(4).name(1:length(rawdata(4).name)-4)); %this is long because it's removing the file extensions
			createMidusACQcorrugator(srcDir,[destDir 'Corr_Processed/'],rawdata(1).name(1:length(rawdata(1).name)-4),rawdata(2).name(1:length(rawdata(2).name)-4),rawdata(3).name(1:length(rawdata(3).name)-4),rawdata(4).name(1:length(rawdata(4).name)-4));		%this is long because it's removing the file extensions	
		else
			fprintf('Sorry, there are no data for mrfr%s. \n Check the /study/midusref/raw-data/EMG folder!\n',sub)
			return
		end
	end
end
cd /study/midusref/DATA/;
