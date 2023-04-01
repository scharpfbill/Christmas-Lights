function MergeSDFiles_2files_fade(FName_in1,FName_in2,FName_out,flag1)
% W. Scharpf, 22Oct22
%
% This script combines various SD files into a single SD file. This script
% also adds a fading between SD files
%
% Useage:
%  MergeSDFiles_2files_fade(FName_in1,FName_in2,FName_out,flag1)
%    FName_in1, FName_in2 - Name of fiels to be merged
%    flag1 - 'y' or 'n', create a 2nd fade between last and first file.

%% 1) setup

UpD_sec = 20; % LED updates per sec
Transiton_time = 3; % seconds
NT = floor(Transiton_time*UpD_sec); % number of updates in the transitions

N_strings = 7;
N_colors = 3;
N_LEDSperString = 50;
N_linesperUpdate = 7;

%% 2) Read in 1st file
disp('');
disp([FName_in1,' + ',FName_in2,' -> ',FName_out]);
disp('Reading 1st file');

SD_file = [FName_in1,'.txt'];

fileID = fopen(SD_file,'r');

LineNumb = 0;
while ~feof(fileID)

    A = fscanf(fileID,'%s',1);
    if (A ~= "")
        
        LineNumb = LineNumb+1;
        LEDA(LineNumb,1) = str2double(A(1:5));
        LEDA(LineNumb,2) = str2double(A(6:8));
        for ii=1:N_LEDSperString*N_colors
            LEDA(LineNumb,ii+2) = str2double(A(3*ii+7:3*ii+9));
        end
        
    end
    
end

fclose(fileID);


%% 3) Read in 2nd file
disp('Reading 2nd file')

SD_file = [FName_in2,'.txt'];

fileID = fopen(SD_file,'r');

LineNumb = 0;
while ~feof(fileID)

    B = fscanf(fileID,'%s',1);
    if (B ~= "")
        
        LineNumb = LineNumb+1;
        LEDB(LineNumb,1) = str2double(B(1:5));
        LEDB(LineNumb,2) = str2double(B(6:8));
        for ii=1:N_LEDSperString*N_colors
            LEDB(LineNumb,ii+2) = str2double(B(3*ii+7:3*ii+9));
        end
        
    end
    
end
fclose(fileID);


%% 4) Creating Transition from 1 to 2
disp('Creating Transition from 1 to 2');

LEDAlast = LEDA(size(LEDA,1)-(N_linesperUpdate-1):size(LEDA,1),:);
LEDBfirst = LEDB(1:N_linesperUpdate,:); 

LineNumb = 0;
for ii =0:NT
    for jj=0:(N_linesperUpdate-1)
        LineNumb = LineNumb + 1;
        LEDC(LineNumb,1) = LineNumb-1;
        LEDC(LineNumb,2) = jj;
        for kk=1:N_LEDSperString*N_colors
            LEDC(LineNumb,kk+2) = floor((ii/NT)*(LEDBfirst(jj+1,kk+2) - ...
                LEDAlast(jj+1,kk+2)) + LEDAlast(jj+1,kk+2));
        end
    end
end


%% 5) Creating Transition from 2 to 1
if flag1 == 'y'
    disp('Creating Transition from 2 to 1')

    LEDBlast = LEDB(size(LEDB,1)-(N_linesperUpdate-1):size(LEDB,1),:);
    LEDAfirst = LEDA(1:N_linesperUpdate,:);

    LineNumb = 0;
    for ii =0:NT
        for jj=0:(N_linesperUpdate-1)
            LineNumb = LineNumb + 1;
            LEDD(LineNumb,1) = LineNumb-1;
            LEDD(LineNumb,2) = jj;
            for kk=1:N_LEDSperString*N_colors
                LEDD(LineNumb,kk+2) = floor((ii/NT)*(LEDAfirst(jj+1,kk+2) - ...
                    LEDBlast(jj+1,kk+2)) + LEDBlast(jj+1,kk+2));
            end
        end
    end

end

%% 6) write out merged file
disp('write out merged file')

SD_file = [FName_out,'.txt'];
fileID = fopen(SD_file,'w');

% Writing First file
disp('Writing First file');
for ii = 1:size(LEDA,1)
    fprintf(fileID,'%05d%03d:',LEDA(ii,1),LEDA(ii,2));
    for jj = 1:N_LEDSperString*N_colors
        fprintf(fileID,'%03i',LEDA(ii,jj+2));
    end
    fprintf(fileID,'|\n');
end

% Writing Transition from 1 to 2
disp('Writing Transition from 1 to 2');
for ii = 1:size(LEDC,1)
    fprintf(fileID,'%05d%03d:',LEDC(ii,1),LEDC(ii,2));
    for jj = 1:N_LEDSperString*N_colors
        fprintf(fileID,'%03i',LEDC(ii,jj+2));
    end
    fprintf(fileID,'|\n');
end

% Writing Second file
disp('Writing Second file');
for ii = 1:size(LEDB,1)
    fprintf(fileID,'%05d%03d:',LEDB(ii,1),LEDB(ii,2));
    for jj = 1:N_LEDSperString*N_colors
        fprintf(fileID,'%03i',LEDB(ii,jj+2));
    end
    fprintf(fileID,'|\n');
end

if flag1 == 'y'
    % Writing Transition from 2 to 1
    disp('Writing Transition from 2 to 1');
    for ii = 1:size(LEDD,1)
        fprintf(fileID,'%05d%03d:',LEDD(ii,1),LEDD(ii,2));
        for jj = 1:N_LEDSperString*N_colors
            fprintf(fileID,'%03i',LEDD(ii,jj+2));
        end
        fprintf(fileID,'|\n');
    end

end

fclose(fileID);

