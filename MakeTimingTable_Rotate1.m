%% 0) MakeTimingTable_Spin3.m
% This script generates the timing table for a rotate about an axis sequence. 

%% 1) Set up
clear 
tic

global FName LED_Loc_Path 

%FName = 'On1attime';
LED_loc = readtable([LED_Loc_Path,'LED_loc.xlsx']);


%% 2) Section to modify
LED_red = [];
LED_green = [];
LED_blue = [];

tt = -20;
tinc = 0.1;
tmax = 20;

jj = 0;
while tt<tmax
    jj = jj + 1;
    disp(['tt=',num2str(tt)]);
    for ii =1:height(LED_loc)
        
        xx0 = LED_loc.xx(ii);
        yy0 = LED_loc.yy(ii);
        zz0 = LED_loc.zz(ii) - 3;
        
        phi = tt*(pi/180)*10;
        M = [cos(phi) 0 -sin(phi);
                 0    1     0;
             sin(phi)  0   cos(phi)];
        XYZ0 = [xx0; yy0; zz0];
        XYZ1 = M*XYZ0;
        xx1 = XYZ1(1);
        yy1 = XYZ1(2);
        zz1 = XYZ1(3);
        
        theta = (180/pi)*atan2(xx1,yy1) + 180;
        C_theta = floor(theta/60);
        switch C_theta
            case 0
                LED_red(jj,ii) = 50;
                LED_green(jj,ii) = 0;
                LED_blue(jj,ii) = 0;
            case 1
                LED_red(jj,ii) = 50;
                LED_green(jj,ii) = 50;
                LED_blue(jj,ii) = 0;
            case 3
                LED_red(jj,ii) = 0;
                LED_green(jj,ii) = 50;
                LED_blue(jj,ii) = 0;
            case 3
                LED_red(jj,ii) = 0;
                LED_green(jj,ii) = 50;
                LED_blue(jj,ii) = 50;
            case 4
                LED_red(jj,ii) = 0;
                LED_green(jj,ii) = 0;
                LED_blue(jj,ii) = 50;
            otherwise
                LED_red(jj,ii) = 50;
                LED_green(jj,ii) = 0;
                LED_blue(jj,ii) = 50;
        end
    end
    tt = tt + tinc;
end


%% 3) Save Timing Table
disp('Save Table File');
save(['TimingTable_',FName],'LED_red','LED_green','LED_blue');
toc