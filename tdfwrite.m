function tdfwrite(filename,st,app)
%
% function tdfwrite(filename,st)
%
% Saves structure st into filename
% st is a structure created with st=tdfread('file.tab');
%
% st is a structure with several fields.  Each field is a vector of numbers
% or a matrix of char. Field names are used as headers of each column.
%
% Warning: General format %.20g is used for numerical values. It works fine most
% of the time. Some applications may need to change the output format.
%
% Rafael Palacios, Oct 2009
%
% LDH 12-04-12: added ability to append in function call and lines 37-42. Line 41 is only original in that block from RP 2009.
%-------**To append, set VAR3 as 1 (or anything...) to *not* append, do not import anything for that variable**
%

%%Error checking
error(nargchk(2, 3, nargin));  %2 arguments required, 3 maximum
if (~ischar(filename))
    error('First argument must be the name of the file');
end
if (~isstruct(st))
    error('Second argument must be a strcuture');
end
%Field names
names=fieldnames(st);
rows=size(getfield(st,names{1}),1);
for j=2:length(names)
    if (rows~=size(getfield(st,names{j}),1))
        error('Field $s has a different length than first field (%s)',names{j},names{1});
    end
end

%%%%LDH changed 'w' write only to 'a' append 12/4/12
if exist('app')
	[fp,message]=fopen(filename,'a');
else
	[fp,message]=fopen(filename,'w');
end

if (fp==-1)
    error('Error opening file: %s',message);
end
%header
fileinfo=dir(filename);
if fileinfo.bytes<50 
	fprintf(fp,'%s',names{1});
	fprintf(fp,'\t%s',names{2:end});
	fprintf(fp,'\n');
end
%values
for i=1:rows
    for j=1:length(names)
        if (j~=1)
            fprintf(fp,'\t');
        end
        v=getfield(st,names{j});
        if (ischar(v(1,1)))
            fprintf(fp,'%s',v(i,:));
        else
            fprintf(fp,'%.20g',v(i));  %general format
        end
    end
    fprintf(fp,'\n');
end
fclose(fp);
