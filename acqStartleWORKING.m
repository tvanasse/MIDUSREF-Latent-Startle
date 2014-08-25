function acqStartle(fileName,studyname,option)

%               File:               acqStartle.m
%               Author:             Ram Subramanian
%               Date Created:       25th Sept 2005
%               Date Last Modified: 22nd Aug 2006
%                                   Now can process MS081.
%   acqStartle(fileName,studyname,option)
%
%   Startle analysis of the .Acq file specified by FILENAME (without
%   extension) FILENAME must be in the current working directory.
%
%   If called with the 'noninteractive' option, only the data
%   processing operations will be carried out, the graphical user
%   interface will not be used. This option is to allow for batch
%   preprocessing of a number of sessions.
%
%
%   2-October-2006 LG added studyname to handle 6 DIN channels
%
%   11-October-2006 added studyname MIDUS_SOC_MAT to handle files with missing DIN7
%   addDIN7.m reads the problem acq files and their Eprime text logs and adds DIN7
%   since we cannot write an acq file, PARsampleRate, PARtimeAxis, chanData are saved
%   in a Matlab file with the same basename as the acq
%
%
%   studies supported 'MIDUS', 'MIDUS_SOC', 'MIDUS_SOC_MAT', 'APPRAISE', 'COGEMO', 'PTSD','EMBEMO','COGEMOPAIN'
%
%   3-Aug-2009 added APPRAISE
%   15-Jul-2010 added COGEMO
%   1-Nov-2010 added PTSD
%   26-Aug-2011 addeed EMBEMO
%   12-Sep-2011 added COGEMOPAIN

global STLdata  STLtimeAxis startleParameters currentTrialNumber parametersChanged 


if((nargin < 1) | (nargin > 3))
   disp('Error: incorrect number of input arguments.')
   help acqStartle.m
   return
end

if(nargin < 3)
   option = [];
end

if(strcmp(lower(option), 'noninteractive'))
   interactive = 0;
else
   interactive = 1;
end


global PathFileName; 

local_path = pwd;
if isunix == 1 
  PathFileName = [local_path '/' fileName];
else
  PathFileName = [local_path '\' fileName];  
end


switch(upper(studyname))
   case {'MIDUS', 'MIDUS_SOC', 'MIDUS_SOC_MAT', 'APPRAISE', 'COGEMO', 'PTSD','EMBEMO','COGEMOPAIN'},
   otherwise
      disp('Error: invalid study mnemonic.')
      help acqStartle.m
      return
end

% We start by checking to see if the ACQ version of the 
% files exists. If they do, we have to rename the files.
%
if ((exist([PathFileName '_ACQ.mat'], 'file')) || (exist([PathFileName '_ACQSTAT.mat'], 'file')))
    
    disp(['Converting files to conform with naming standards ' fileName '...']);
    % Loading the lod files 
    if (exist([PathFileName '_ACQ.mat'], 'file'))
        eval(['load ' PathFileName '_ACQ']);
    end
    
    if (exist([PathFileName '_ACQSTAT.mat'], 'file'))
        eval(['load ' PathFileName '_ACQSTAT']);
    end
    
    % Generating the new files to conform with other programs
    for i=1:1:length(ProbeType)
        startleParameters(i).probe_type = ProbeType(i);
    end
    eval(['save ' PathFileName '_STLSTAT startleParameters ProbeType']);
    eval(['save ' PathFileName '_STL currentEventTime']);
    
    clear startleParameters ProbeType currentEventTime;
    
    if (exist([PathFileName '_ACQ.mat'], 'file'))
        eval(['delete ' PathFileName '_ACQ.mat']);
    end
    if (exist([PathFileName '_ACQSTAT.mat'], 'file'))
        eval(['delete ' PathFileName '_ACQSTAT.mat']);
    end
    
    if ((exist([PathFileName '_PARAM.mat'], 'file')))
        eval(['delete ' PathFileName '_PARAM.mat']);
    end
    if ((exist([PathFileName '_DATA.mat'], 'file')))
        eval(['delete ' PathFileName '_DATA.mat']);
    end
    
    disp(['Convertion of files ' fileName '... SUCCESS']);
end


disp(['Loading ' fileName '...']);
disp(['File Located at ' PathFileName '.']);
disp(['          ']);


if (interactive)
   
  % check if control window already exists
  if (~isempty(findobj('Tag', 'FigureStartleControl')))
    exitStartle
  end

  % check if control window still exists (user hit cancel)
  if (~isempty(findobj('Tag', 'FigureStartleControl')))
    return
  end

  currentTrialNumber = 1;
  parametersChanged = 0;
end

destPathFile=['/study/midusref/DATA/EBR/' fileName];
if ((~exist([destPathFile '_DATA.mat'], 'file'))) && ((~exist([destPathFile '_STLDATA.mat'], 'file'))) 
  if (interactive)
    disp('Processing data file...')
  else
    disp(['Processing data file ' fileName])
  end
  
  eval(['process' upper(studyname) 'StartleWORKING(fileName)'])

else
   if exist([destPathFile '_DATA.mat'], 'file') % added 26-Oct-2006 since processMIDUSStartle saves as _STLDATA
   		eval(['load ' destPathFile '_DATA']);
   else
   		eval(['load ' destPathFile '_STLDATA']);
   end
end



if((~exist([destPathFile '_STLSTAT.mat'], 'file')) || (~exist([destPathFile '_STL.mat'], 'file')))
   if(interactive)
      disp('Calculating startle parameters...')
   else
      disp(['Calculating startle parameters for ' fileName])
   end
   disp('line 163')
   eval(['process' upper(studyname) 'StartleWORKING(fileName)'])
else
   eval(['load ' destPathFile '_STLSTAT']);
   eval(['load ' destPathFile '_STL']);
end


if (interactive)

   eval(['load ' destPathFile '_STLSTAT']);
   eval(['load ' destPathFile '_STL']);
   if exist([destPathFile '_DATA.mat'], 'file') % added 26-Oct-2006 since processMIDUSStartle saves as _STLDATA
   		eval(['load ' destPathFile '_DATA']);
   else
   		eval(['load ' destPathFile '_STLDATA']);
   end
   
   initStartlePlot
   initStartleControl
   drawStartlePlot
end

if (exist(['fileName.mat'], 'file'))
    delete fileName.mat;
end