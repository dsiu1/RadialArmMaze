%%Dispenses reward when given arm number

%%Ex: reward_dispense(obj, 1) or reward_dispense(obj, 'FT01')
function CODE_OUT = reward_dispense(obj, varargin)
    global FOOD_DISPENSE
    CODE_OUT = FOOD_DISPENSE;
    %%Possible user input close_doors(door_num) and forgot the object.
    if(~isa(obj, 'serial'))
        errordlg('No serial object detected!');
        CODE_OUT = {''};
        return;
    end
    if(~isempty(varargin))
        PORT_ID = varargin{1};
        %%Check if input is a number first
        if(isnumeric(PORT_ID))

            PORT_ID = {strcat('FT0', num2str(PORT_ID))};
        end  
        %%If it is a string,
        %%Check if it contains the proper code (FT01, FT02)
        if(contains(PORT_ID, FOOD_DISPENSE))
            CODE_OUT = PORT_ID;
        else
            errordlg('Wrong reward code')
        end
    end
    
    %%Dispense reward
    for i = 1:length(CODE_OUT)
        fprintf(obj, CODE_OUT{i});
    end

    %%For some reason strsplit cannot handle forced '\n' or '\t' very well
    %%so need to replace them with spaces
    CODE_OUT = strcat('\t', CODE_OUT, '\t');
    CODE_OUT = strrep(CODE_OUT, '\t', ' ');
end 