%% ChristmasTreeProject.m
% W. Scharpf, 08/07/22

addpath('/Users/williamscharpf/Documents/MATLAB/ChristmasLEDs/DevOps');

%% 1) Set LED Location path

global LED_Loc_Path 

PArea = '/Users/williamscharpf/Documents/MATLAB/ChristmasLEDs/';

LED_Loc_Path = [PArea,'LEDLocations/LEDLoc_20221015/'];

%% 2) Set LED Pattern

global FName

% 2.01) Turn on one at a time
% FName = 'On1attime';
% WorkArea = 'On1attime';

% 2.02) Vertical Flow
% FName = 'VerticalFlow';
% WorkArea = 'VerticalFlow';

% 2.03) Spin1
% FName = 'Spin1';
% WorkArea = 'spin1';

% % 2.04) Spin2
% FName = 'Spin2';
% WorkArea = 'spin2';

% 2.05) Spin3
% FName = 'Spin3';
% WorkArea = 'spin3';

% 2.06) Rotate1
% FName = 'Rotate1';
% WorkArea = 'Rotate1';

% 2.06) On1attime5times
% FName = 'On1attime5times';
% WorkArea = 'On1attime5times';

% 2.07) OnEvery5th
% FName = 'OnEvery5th';
% WorkArea = 'OnEvery5th';

% 2.08) updown1
% FName = 'updown1';
% WorkArea = 'updown1';

% 2.09) Turn on one at a time, XY
% FName = 'On1attime_xy';
% WorkArea = 'On1attime_xy';

% 2.10) xflow
% FName = 'xflow';
% WorkArea = 'xflow';

% 2.11) yflow
% FName = 'yflow';
% WorkArea = 'yflow';

% 2.12) bubbles1
% FName = 'bubbles1';
% WorkArea = 'bubbles1';

% 2.13) bubbles2
FName = 'bubbles2';
WorkArea = 'bubbles2';

% 2.13) bubbles3
% FName = 'bubbles3';
% WorkArea = 'bubbles3';

% % 2.13) CandyCain1
% FName = 'CandyCain1';
% WorkArea = 'CandyCain1';

% % 2.13) CandyCain2
% FName = 'CandyCain2';
% WorkArea = 'CandyCain2';

% % 2.13) CandyCain3
% FName = 'CandyCain3';
% WorkArea = 'CandyCain3';

% % 2.13) CandyCain4
% FName = 'CandyCain4';
% WorkArea = 'CandyCain4';

% 2.14) MovingRing2
% FName = 'MovingRing2';
% WorkArea = 'MovingRing2';

% 3.1) xyflowFast1
% FName = 'xyflowFast1';
% WorkArea = 'xyflowFast1';

% 3.2) zflowFast1
% FName = 'zflowFast1';
% WorkArea = 'zflowFast1';

% 4.1) quickflash
% FName = 'quickflash';
% WorkArea = 'quickflash';

%% 3) Run through the various scripts

cd(WorkArea);

% 3.1) timing table
run(['MakeTimingTable_',FName]);

% 3.2) Generate videos
%displaytimingtable_OrthoAll;
%DisplayTimingTable_top;
%DisplayTimingTable_XZFront;
%DisplayTimingTable_YZFront;

% 3.3) Make file to go on the SD card

MakeSDFile

copyfile(['SD_',FName,'.txt'],'/Users/williamscharpf/Documents/MATLAB/ChristmasLEDs/ArduinoFiles');

% 3.4) return to parent folder
cd ..



