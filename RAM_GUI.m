
function guifig = RAM_GUI
    global obj ses_timer trial_timer curtime maxduration BAIT_ENTERED BAITED hDiag TRIALNR
    global phase_log trial_time_log logfile time_log TEMP_LOG filename pos_log

    guifig = figure('units', 'normalized', 'outerposition', [0.15 0.075 0.65 0.9]); 
    guifig.DeleteFcn = @hStopSessionButton;
    %%Session buttons
    hStart = uicontrol('Style', 'pushbutton', 'String', 'START', 'Backgroundcolor', 'g',...
            'units', 'normalized', 'Position', [0.25, 0.20, 0.1, 0.05], 'Callback', {@hStartButton}, 'Enable', 'off');

    startTxt = uicontrol('Style','text', ...
        'units', 'normalized', 'Position',[0.20, 0.25 ,0.2,0.025],...
        'String','START SESSION', 'Enable', 'off');


    hStartTrial = uicontrol('Style', 'pushbutton', 'String', 'OPEN',...
            'units', 'normalized', 'Position', [0.45, 0.20, 0.1, 0.05], 'Callback', {@hStartTrialButton}, 'Enable', 'off');

    trialTxt = uicontrol('Style','text',...
        'units', 'normalized', 'Position',[0.40, 0.25 ,0.2,0.025],...
        'String','START NEXT TRIAL', 'Enable', 'off');

    hEndTrial = uicontrol('Style', 'pushbutton', 'String', 'CLOSE',...
            'units', 'normalized', 'Position', [0.45, 0.075, 0.1, 0.05], 'Callback', {@hEndTrialButton}, 'Enable', 'off');

    endTxt = uicontrol('Style','text',...
        'units', 'normalized', 'Position',[0.40, 0.125 ,0.2,0.025],...
        'String','CLOSE DOORS', 'Enable', 'off');
    hStopSession = uicontrol('Style', 'pushbutton', 'String', 'END', 'Backgroundcolor', 'r',...
            'units', 'normalized', 'Position', [0.65, 0.20, 0.1, 0.05], 'Callback', {@hStopSessionButton}, 'Enable', 'off');

    stopTxt = uicontrol('Style','text',...
        'units', 'normalized', 'Position',[0.60, 0.25 ,0.2,0.025],...
        'String','END SESSION', 'Enable', 'off');


    %%%Debugging buttons

    OpenTestTxt = uicontrol('Style','popupmenu',...
        'units', 'normalized', 'Position',[0.87, 0.15, 0.029, 0.05],...
        'String',{'1', '2', '3', '4' ,'5' ,'6' ,'7' ,'8'}, 'Enable', 'off');
    hOpenTest = uicontrol('Style', 'pushbutton', 'String', 'OPEN TESTER',...
            'units', 'normalized', 'Position', [0.90, 0.172, 0.1, 0.03], 'Callback', {@hOpenTester, OpenTestTxt}, 'Enable', 'off');

    CloseTestTxt =uicontrol('Style','popupmenu',...
        'units', 'normalized', 'Position',[0.87, 0.12, 0.029, 0.05],...
        'String',{'1', '2', '3', '4' ,'5' ,'6' ,'7' ,'8'}, 'Enable', 'off');
    hClose = uicontrol('Style', 'pushbutton', 'String', 'CLOSE TESTER',...
            'units', 'normalized', 'Position', [0.90, 0.142, 0.1, 0.03], 'Callback', {@hCloseTester, CloseTestTxt}, 'Enable', 'off');



    RewardTestTxt = uicontrol('Style','popupmenu',...
        'units', 'normalized', 'Position',[0.87, 0.09, 0.029, 0.05],...
        'String',{'1', '2', '3', '4' ,'5' ,'6' ,'7' ,'8'}, 'Enable', 'off');
%     RewardTestTxt = uicontrol('Style','edit',...
%         'units', 'normalized', 'Position',[0.87, 0.05, 0.029, 0.05],...
%         'String','1', 'Enable', 'off');
    hReward = uicontrol('Style', 'pushbutton', 'String', 'REWARD TESTER',...
            'units', 'normalized', 'Position', [0.90, 0.112, 0.1, 0.03], 'Callback', {@hRewardTester, RewardTestTxt}, 'Enable', 'off');


    
    hNotesText = uicontrol('Style', 'edit', 'String', '',...
    'units', 'normalized', 'Position', [0.25, 0.025, 0.45, 0.02]);
    hNotes = uicontrol('Style', 'pushbutton', 'String', 'Write',...
        'units', 'normalized', 'Position', [0.71, 0.025, 0.06, 0.02], 'Callback', {@addNotes, hNotesText});
    hNotesAll = annotation('textbox', [0.01 0.01 0.11 0.915], 'String', {''});
    Codes = loadCodes();
    
    %%GUI Functions
    %%
    function hStartButton(source, eventdata)
        
        ses_timer = tic;
        trial_timer = tic;
        curtime = toc(ses_timer);

        DOOR_ON = open_doors(obj);
        updateLog(DOOR_ON);
        annotationEvents(hNotesAll, Codes);


    end

    function hStartTrialButton(source, eventdata)
        trial_timer = tic;

        DOOR_ON = open_doors(obj); 
        updateLog(DOOR_ON);
        annotationEvents(hNotesAll, Codes);
        saveTEMP();

        BAIT_ENTERED = zeros(size(BAITED));
        TRIALNR = TRIALNR + 1; 
        hDiag = PlotArms(); 

    end

    function hEndTrialButton(source, eventdata)
        DOOR_OFF = close_doors(obj);
        updateLog(DOOR_OFF);
        annotationEvents(hNotesAll, Codes);
        saveTEMP();
    end

    function hStopSessionButton(source,eventdata)
  
        if(strcmp(obj.Status,'open'))
%             DOOR_OFF = close_doors(obj); 
%             annotationEvents(hNotesAll, Codes);
%             updateLog(DOOR_OFF);  
%             saveTEMP();
%         
%             %%%Save the data
% 
%             if(length(time_log) ~= length(TEMP_LOG))
%                 disp(['Time log length: ' num2str(length(time_log))]);
%                 disp(['TEMP log length: ' num2str(length(TEMP_LOG))]);   
%             end
            deactivateGUI(guifig); 
            %%Need to reset temp log when outputs are given
            n = length(time_log);
            logfile(end+1:end+n, 1:5) = [num2cell(time_log) ...
                                         num2cell(trial_time_log) ...
                                         TEMP_LOG ...
                                         num2cell(phase_log) ... 
                                         pos_log];
            notes = inputdlg('Notes: State any issues with the recording');
            save(['./data/' filename], 'logfile', 'notes');
        end
        trial_timer = tic;
        maxduration = -9999;
    end

    function hOpenTester(source, eventdata, OpenTestTxt)
        event_input = OpenTestTxt.Value;
        DOOR_ON = open_doors(obj, event_input); 
        updateLog(DOOR_ON);  
        annotationEvents(hNotesAll, Codes);
        saveTEMP();
    end

    function hCloseTester(source, eventdata, CloseTestTxt)
        event_input = CloseTestTxt.Value;
        DOOR_OFF = close_doors(obj, event_input); 
        updateLog(DOOR_OFF);  
        annotationEvents(hNotesAll, Codes);
        saveTEMP();
    end

    function hRewardTester(source, eventdata, RewardTestTxt)
        event_input = RewardTestTxt.Value;
        REWARD_DISPENSE = reward_dispense(obj, event_input); 
        updateLog(REWARD_DISPENSE);  
        annotationEvents(hNotesAll, Codes);
        saveTEMP();

    end

    function addNotes(source,eventdata, notes)
        
        hypSaveLocation = './data/';
        notesFile = [hypSaveLocation filename '_notes.csv'];
        if ~exist(hypSaveLocation, 'dir')
            mkdir(hypSaveLocation);
        end  
        notes_str = notes.String;
        NID = fopen(notesFile, 'a');
        fprintf(NID, '%s\t\n', notes_str);
        fclose(NID);
        
        toWords = strsplit(notes_str, ' ');
        notes_str = [join(toWords, '_') ' '];
        updateLog(notes_str);
        annotationEvents(hNotesAll, Codes);
        hNotesText.String = '';
%         loadNotes()
    end

%     function closedEarly(~,~, s)
%         errordlg('Closed Early!')
%         
%     end
end
