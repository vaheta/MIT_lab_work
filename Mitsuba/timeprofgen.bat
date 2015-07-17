:: enter full path to matlab bin file
set arg1="C:\Program Files\MATLAB\R2014a\bin\matlab.exe"
:: enter full path to mitsuba bin file
set arg2="C:\Users\Public\mitsuba-d8d7c7ded41a\dist\mitsuba.exe"
:: enter full path to scene file
set arg3=C:\Users\Public\corner\corner.xml
:: enter full path to matlab script folder
set arg4=C:\Users\Public\tofsim\

%arg2% -DmaxDepth=2 -Dintegrator=timeofflight -o %arg4%tof2.m %arg3%
%arg2% -DmaxDepth=3 -Dintegrator=timeofflight -o %arg4%tof3.m %arg3%
%arg2% -DmaxDepth=4 -Dintegrator=timeofflight -o %arg4%tof4.m %arg3%
%arg2% -DmaxDepth=5 -Dintegrator=timeofflight -o %arg4%tof5.m %arg3%

%arg2% -DmaxDepth=2 -Dintegrator=path -o %arg4%amp2.m %arg3%
%arg2% -DmaxDepth=3 -Dintegrator=path -o %arg4%amp3.m %arg3%
%arg2% -DmaxDepth=4 -Dintegrator=path -o %arg4%amp4.m %arg3%
%arg2% -DmaxDepth=5 -Dintegrator=path -o %arg4%amp5.m %arg3%

%arg1% -nodisplay -nosplash -nodesktop -r "run('%arg4%timeprofgen.m');"