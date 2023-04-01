% W. Scharpf, 22Oct22
%
% This script combines various SD files into a single SD file. This script
% also adds a fading between SD files

%% 1) setup
clear

% files to merge

FName{1} = 'SD_Spin1';          %
FName{2} = 'SD_bubbles3a';      %
FName{3} = 'SD_Spin2';          %
FName{4} = 'SD_MovingRing1';    %
FName{5} = 'SD_Spin3';          % multi color spin and twist,medium
FName{6} = 'SD_CandyCain1';	    % keep
FName{7} = 'SD_zflowFast1';     % keep
FName{8} = 'SD_bubbles2';       % keep
FName{9} = 'SD_CandyCain2';     % keep
FName{10} = 'SD_bubbles3b';     % Keep
FName{11} = 'SD_CandyCain4';    % Keep
FName{12} = 'SD_MovingRing2';	% Keep	
FName{13} = 'SD_CandyCain3';	% Keep
FName{14} = 'SD_On1attime';		% keep
FName{15} = 'SD_xyflowFast1';   % keep

%  Output file
FNameOut = '20221106_FNout';

%% 2) Merge Files

tic
MergeSDFiles_2files_fade(FName{1},FName{2},FNameOut,'n');
disp(['first 2, toc=',toc]);

for ii=3:14
    disp(['ii=',num2str(ii)]);
    MergeSDFiles_2files_fade(FNameOut,FName{ii},FNameOut,'n');
    disp(['toc=',num2str(toc)]);
end

MergeSDFiles_2files_fade(FNameOut,FName{15},FNameOut,'y');