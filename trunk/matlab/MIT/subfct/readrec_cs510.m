% C = READREC_CS510(fnam,NZ,fldprec)
%
% Get one record from the CS510 run
%
% fnam : string to the file (include path)
% NZ   : number of levels to read
% fldprec : float32 or float64
% ouput is: C(510,510,NZ,6)
%
%

function C = readrec_cs510(fnam,NZ,fldprec)

fmt = 'ieee-be';
nx  = 510;
ny  = 510;


fid  = fopen(fnam,'r',fmt);
C    = fread(fid,6*nx*ny*NZ,fldprec);
fclose(fid);
C    = reshape(C,[6*nx ny NZ]);


