close all; 

global obj maxduration trial_duration ses_timer trial_timer filename BAITED
global FOOD_DETECT_ON BEAM_DOOR_ON BEAM_DOOR_OFF BEAM_REWARD_ON BEAM_REWARD_OFF 
global DOOR_ON DOOR_OFF FOOD_DISPENSE logfile


%%%Main Script
%%Use: Press Run button. Enter file name. After all trials enter the notes.
g = RAM_GUI();
filename = filenameRAM();

%%Just parses if cancel button pressed or if the file already exists
if(isempty(filename))
    disp('Cancel Pressed');
    close;
    return;
end

if(exist(strcat('./data/', filename, '.mat'), 'file'))
    disp('That file already exists. Please run mainRAM again with a different name')
    close;
    return;
end


%%Initialize constant variables. 
trial_duration = 300; %%300 seconds = 5 minutes
maxduration = 6000; %%6000 seconds = 100 minutes

%%Outputs

DOOR_ON = {'D010', 'D020', 'D030', 'D040', 'D050', 'D060', 'D070', 'D080'};
DOOR_OFF = {'D011', 'D021', 'D031', 'D041', 'D051', 'D061', 'D071', 'D081'};
% DOOR_ON = {'D040', 'D050', 'D060'};
% DOOR_OFF = {'D041', 'D051', 'D061'};
FOOD_DISPENSE = {'FT01', 'FT02', 'FT03' , 'FT04', 'FT05', 'FT06', 'FT07' ,'FT08'};

%%Inputs
BEAM_DOOR_ON = {'MS10', 'MS20', 'MS30', 'MS40', 'MS50', 'MS60', 'MS70', 'MS80'};
BEAM_DOOR_OFF = {'MX10', 'MX20', 'MX30', 'MX40', 'MX50', 'MX60', 'MX70', 'MX80'};

BEAM_REWARD_ON = {'MS11', 'MS21', 'MS31', 'MS41', 'MS51', 'MS61', 'MS71', 'MS81'};
BEAM_REWARD_OFF = {'MX11', 'MX21', 'MX31', 'MX41', 'MX51', 'MX61', 'MX71', 'MX81'};

FOOD_DETECT_ON = {'MF01', 'MF02', 'MF03', 'MF04', 'MF05', 'MF06', 'MF07', 'MF08'};
FOOD_DETECT_OFF = {'MF01X', 'MF02X', 'MF03X', 'MF04X', 'MF05X', 'MF06X', 'MF07X', 'MF08X'};

%%Baited doors
BAITED = [2, 4, 6, 7];



% Initialize Serial object and start RAM task
obj = SerialInit();
activateGUI(g); 
display(['Running: '  filename]);
ses_timer = tic;
trial_timer = tic;
store_all = RAM_control(obj);
display(['Finished: '  filename]); 

%%Processing working memory and errors
% mainProcessingRAM;
% plotMemory;
