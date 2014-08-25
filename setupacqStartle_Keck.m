%switch(computer)
%    case 'PCWIN'
%    	rmpath W:\d1\local\matlab\acqknowledge\PAR_startle
%    	addpath W:\d1\local\matlab\acqknowledge\StartleProcessing -begin
%    case { 'SOL','SOL2', 'LNX86', 'GLNX86', 'GLNXA64', 'MAC' }
%    	rmpath /d1/local/matlab/acqknowledge/PAR_startle
%    	addpath /d1/local/matlab/acqknowledge/StartleProcessing -begin
%end

switch(computer)
    case 'PCWIN'
        addpath \apps\brogden\matlab\Ledalab\main\import
    	addpath \apps\brogden\matlab\acqknowledge\StartleProcessing -begin
        addpath \apps\brogden\biopac
		addpath \study\midusref\DATA\DataScripts -begin
		addpath \apps\brogden\matlab\startle1\general -begin
    case { 'SOL','SOL2', 'LNX86', 'GLNX86', 'GLNXA64', 'MAC' }
        addpath /apps/brogden/matlab/Ledalab/main/import
    	addpath /apps/brogden/matlab/acqknowledge/StartleProcessing -begin
        addpath /apps/brogden/matlab/biopac
		addpath /study/midusref/DATA/DataScripts -begin
		addpath /apps/brogden/matlab/startle1/general -begin
end