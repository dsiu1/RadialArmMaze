

function Codes = loadCodes()
    DOOR_ON = {'D010', 'D020', 'D030', 'D040', 'D050', 'D060', 'D070', 'D080'};
    DOOR_OFF = {'D011', 'D021', 'D031', 'D041', 'D051', 'D061', 'D071', 'D081'};
    FOOD_DISPENSE = {'FT01', 'FT02', 'FT03' , 'FT04', 'FT05', 'FT06', 'FT07' ,'FT08'};

    %%Inputs
    BEAM_DOOR_ON = {'MS10', 'MS20', 'MS30', 'MS40', 'MS50', 'MS60', 'MS70', 'MS80'};
    BEAM_DOOR_OFF = {'MX10', 'MX20', 'MX30', 'MX40', 'MX50', 'MX60', 'MX70', 'MX80'};

    BEAM_REWARD_ON = {'MS11', 'MS21', 'MS31', 'MS41', 'MS51', 'MS61', 'MS71', 'MS81'};
    BEAM_REWARD_OFF = {'MX11', 'MX21', 'MX31', 'MX41', 'MX51', 'MX61', 'MX71', 'MX81'};

    FOOD_DETECT_ON = {'MF01', 'MF02', 'MF03', 'MF04', 'MF05', 'MF06', 'MF07', 'MF08'};
    FOOD_DETECT_OFF = {'MF01X', 'MF02X', 'MF03X', 'MF04X', 'MF05X', 'MF06X', 'MF07X', 'MF08X'};
    Arms = 8;
    DOOR_ON_ENG = strcat('DOOR_DOWN_', cellfun(@num2str,num2cell(1:Arms), 'UniformOutput', 0));
    DOOR_OFF_ENG = strcat('DOOR_UP_', cellfun(@num2str,num2cell(1:Arms), 'UniformOutput', 0));
    FOOD_DISPENSE_ENG = strcat('FOOD_OUT_', cellfun(@num2str,num2cell(1:Arms), 'UniformOutput', 0));

    BEAM_DOOR_ON_ENG = strcat('BEAM_1_ON_ARM_', cellfun(@num2str,num2cell(1:Arms), 'UniformOutput', 0));
    BEAM_DOOR_OFF_ENG = strcat('BEAM_1_OFF_ARM_', cellfun(@num2str,num2cell(1:Arms), 'UniformOutput', 0));

    BEAM_REWARD_ON_ENG = strcat('BEAM_2_ON_ARM_', cellfun(@num2str,num2cell(1:Arms), 'UniformOutput', 0));
    BEAM_REWARD_OFF_ENG = strcat('BEAM_2_OFF_ARM_', cellfun(@num2str,num2cell(1:Arms), 'UniformOutput', 0));

    FOOD_DETECT_ON_ENG = strcat('FOOD_DETECT_', cellfun(@num2str,num2cell(1:Arms), 'UniformOutput', 0));
    FOOD_DETECT_OFF_ENG = strcat('FOOD_DETECT_', cellfun(@num2str,num2cell(1:Arms), 'UniformOutput', 0));

    Codes = [DOOR_ON DOOR_OFF FOOD_DISPENSE ...
             BEAM_DOOR_ON BEAM_DOOR_OFF ...
             BEAM_REWARD_ON BEAM_REWARD_OFF ... 
             FOOD_DETECT_ON FOOD_DETECT_OFF;

             DOOR_ON_ENG DOOR_OFF_ENG FOOD_DISPENSE_ENG ...
             BEAM_DOOR_ON_ENG BEAM_DOOR_OFF_ENG ...
             BEAM_REWARD_ON_ENG BEAM_REWARD_OFF_ENG ...
             FOOD_DETECT_ON_ENG FOOD_DETECT_OFF_ENG]';
end