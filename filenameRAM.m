%%File naming mini GUI
function fullname =  filenameRAM()
    
    fullname = ''; 
    finished = 0; 
    hFigure = figure('units', 'normalized', 'outerposition', [0.4 0.4 0.2 0.2]);
    set(hFigure, 'MenuBar', 'none');
    set(hFigure, 'ToolBar', 'none');
    
    
%     Saving name: Name (Initials), Day_Trial#_Rat, 
% 	Ex. KDRM1_D1_T1_10-17-2018_KAD
%%Future function should pull from most recent data file and try to parse
%%that for default values. 



    hRatName = uicontrol('Style','edit',...
    'units', 'normalized', 'Position',[0.30 0.8 0.5 0.15],...
    'String','');
    hRatNameTxt = uicontrol('Style','text',...
    'units', 'normalized', 'Position',[0.05, 0.8, 0.24, 0.15],...
    'String','Rat Name (KDRM1, etc)');
    
    hTrainingDay = uicontrol('Style','edit',...
    'units', 'normalized', 'Position',[0.30 0.55 0.5 0.15],...
    'String','');
    hTrainingDayTxt = uicontrol('Style','text',...
    'units', 'normalized', 'Position',[0.05, 0.55, 0.24, 0.15],...
    'String','Training Day (D1, D2, etc)');

    hDate = uicontrol('Style','edit',...
    'units', 'normalized', 'Position',[0.30 0.30 0.5 0.15],...
    'String','');
    hDateTxt = uicontrol('Style','text',...
    'units', 'normalized', 'Position',[0.05, 0.30, 0.24, 0.15],...
    'String','Date (MM-DD-YYYY)');

    hHumanName = uicontrol('Style','edit',...
    'units', 'normalized', 'Position',[0.30 0.05 0.5 0.15],...
    'String','');
    hHumanTxt = uicontrol('Style','text',...
    'units', 'normalized', 'Position',[0.05, 0.05, 0.24, 0.15],...
    'String','Initials (KAD, DS, etc)');

    hOK = uicontrol('Style','pushbutton',...
    'units', 'normalized', 'Position',[0.82, 0.15, 0.15, 0.10],...
    'String','OK', 'callback', {@parseFileName, hRatName, hTrainingDay, hDate, hHumanName});
    
    hCancel = uicontrol('Style','pushbutton',...
    'units', 'normalized', 'Position',[0.82, 0.05, 0.15, 0.10],...
    'String','Cancel', 'callback', {@cancelButton});

    function parseFileName(source, eventdata, RatName, TrainingDay, CurDate, Initials)
        RatName = RatName.String;
        TrainingDay = TrainingDay.String;
        CurDate = CurDate.String;
        Initials = Initials.String;
        outputstr = {RatName TrainingDay CurDate Initials}; 
        outputstr = outputstr(~cellfun(@isempty, outputstr)); 
        fullname = strjoin(outputstr, '_'); 
%         fullname = [RatName '_' TrainingDay '_' CurDate '_' Initials];
        close; 
        
        
    end
    function cancelButton(source, eventdata)
        fullname = '';
        close;
    end

    uiwait(hFigure)
    
end
