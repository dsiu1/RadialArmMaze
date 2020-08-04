%%Open doors in RAM

%%Ex. open_doors(obj) or open_doors(obj, DOOR_ON) 
%%or for a single door open_doors(obj, {'D010'}) 
function CODE_OUT = open_doors(obj, varargin)
    global DOOR_ON
    CODE_OUT = DOOR_ON;
    
    %%Possible user input close_doors(door_num) and forgot the object.
    if(~isa(obj, 'serial'))
        errordlg('No serial object detected!');
        CODE_OUT = {''};
        return;
    end
    
    if(~isempty(varargin))
        DOOR_ID = varargin{1};
        %%Check if input is a number first
        if(isnumeric(DOOR_ID))
            DOOR_ID = {strcat('D0', num2str(DOOR_ID), '0')};
        end
        %%If it is a string,
        %%Check if it contains the proper code (FT01, FT02)
        if(contains(DOOR_ID, CODE_OUT))
            CODE_OUT = DOOR_ID;
        else
            errordlg('Wrong reward code')
            CODE_OUT = {''};
            return; 
        end
        

    end
    
    %%Sending commands to system
    for i = 1:length(CODE_OUT)
        fprintf(obj, CODE_OUT{i});
    end
    
    %%For some reason strsplit cannot handle forced '\n' or '\t' very well
    %%so need to replace them with spaces
    CODE_OUT = strcat('\t', CODE_OUT, '\t');
    CODE_OUT = strrep(CODE_OUT, '\t', ' ');
end 