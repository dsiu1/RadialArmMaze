
warning off;
loadlibrary('C:\windows\system32\kernel32.dll', 'C:\Program Files\MATLAB\R2018b\sys\lcc\include\win.h', 'alias', 'WinAPI');

loadlibrary('DLLPriority','DLLPriority.h','alias','SetP');
[returnVal, counterFreq] = calllib('WinAPI', 'QueryPerformanceFrequency', 0);

[returnVal,t1] = calllib('WinAPI','QueryPerformanceCounter',0);
% do some other stuff
[returnVal,t2] = calllib('WinAPI','QueryPerformanceCounter',0);
% compute t2-t1 and adjust by counterFreq (see attached code file)