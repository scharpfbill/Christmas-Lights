clear 
tic

global FName

NStrings = 7;
NLEDsperString = 50;

load(['TimingTable_',FName,'.mat']);

SD_file = ['SD_',FName,'.txt'];

fileID = fopen(SD_file,'w');

rec = 0;
for nn = 1:size(LED_red,1)
    for ii=0:(NStrings-1)
        fprintf(fileID,'%05d%03d:',rec,ii);
        rec = rec + 1;    
        if rec > 999
            rec = 0;
        end
        for jj=0:(NLEDsperString-1)
                    
            fprintf(fileID,'%03i',LED_red(nn,1+jj+ii*50));
            fprintf(fileID,'%03i',LED_green(nn,1+jj+ii*50));
            fprintf(fileID,'%03i',LED_blue(nn,1+jj+ii*50));
            
        end
        fprintf(fileID,'|\n');
    end
end
            
fclose(fileID);

copyfile(SD_file,'/Users/williamscharpf/Documents/MATLAB/ChristmasLEDs/ArduinoFiles')