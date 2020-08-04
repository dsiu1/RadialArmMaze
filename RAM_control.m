%%Danny Siu
%%10/07/18
%%Purpose: Control radial 8 arm maze and to close doors after exiting arm
%%Project specifications
%%5 minute sessions or when 4 baited arms are entered

%%10/14/18
%%Need to separate photobeams further apart to properly detect if rat has
%%stayed still or turned around
%%Alternative algorithms
%%Predictive time locking
%%Scenarios
%%1) Rat entered
%%2) Rat pokes head in, but does not fully enter
%%Hist the distribution. If there's a second mode that's a really short
%%duration then we can determine the minimum duration we should be ignoring

function storecells = RAM_control(obj)

    global maxduration logfile trial_duration ses_timer  phase_log pos_log 
    global trial_timer curtime BAIT_ENTERED BAITED longchar time_log TRIALNR trial_time_log
    global FOOD_DETECT_ON BEAM_DOOR_ON BEAM_DOOR_OFF BEAM_REWARD_ON BEAM_REWARD_OFF
    global position_legend CUR_POSITION
    finishUp = onCleanup(@()fclose(obj));
    
    %%GUI image positions
    %%Thus far these positions are pretty hard coded
    sq_size = 5;
    x_pos = [180 217 230 215 176 136 115 140];
    y_pos = [145 160 195 235 250 230 200 150];
    arm_positions = {[x_pos;x_pos+sq_size] [y_pos;y_pos+sq_size]};
    Codes = loadCodes();
    
    %%Load RAM photo
    hDiag = PlotArms();
    % get the handle of the hidden annotation axes
    hAnnotAxes = findall(gcf,'Tag','scribeOverlay');
     % get its children handles
    if ~isempty(hAnnotAxes)
         hAnnotChildren = get(hAnnotAxes,'Children');
         hAnnotChildren.Interpreter = 'none';
         hAnnotChildren.FontSize = 8;
         % do something with the annotation handles...
    end
    %%Initialize log storage
    pos_log = {};
    phase_log = [];
    time_log = [];
    trial_time_log = [];
    storecells = {};
    longchar = '';
    TEMP_LOG = '';
    time_in_pos = tic;
    curtime = toc(ses_timer);
    IN_ARM = 0; 
    CUR_POSITION = 0; %Where 0 = center, 1:8 = arms; 
    position_legend = {'Center', 'Arm 1', 'Arm 2', 'Arm 3', 'Arm 4', 'Arm 5', 'Arm 6', 'Arm 7', 'Arm 8'}; 
    BAIT_ENTERED = zeros(size(BAITED));
    
    bad_data = {};
    count = 1;
    TRIALNR = 1;
    logfile = {'Session Time (ms)', 'Trial Time (ms)', 'Event', 'Trial nr', 'Position'};

%     display(['This is now run: ' num2str(count)]);
    t = timer('StartDelay',5);
%     hTitle = title('TempTitle');
    while(toc(ses_timer) < maxduration)
        pause(0.0001);
        curtime = toc(ses_timer);
        titletxt = [{sprintf('Session Timer: %-20.2f Position: %-12s', toc(ses_timer),position_legend{CUR_POSITION+1})};...
                    {sprintf('Trial Timer: %-20.2f Trial Number: %-6d', toc(trial_timer), TRIALNR)}];
                
        %%If closed then it will not re-title
        %%Cannot hTitle.String since PlotArms() resets the figure
        if(ishghandle(hDiag))
            title(titletxt);
        end

        if(obj.BytesAvailable > 3)
            
            storecells{end+1,1} = fread(obj, obj.BytesAvailable);
            %%Extending time log based on the messages received. 
            [NEW_MESSAGE_N, TEMP_LOG] = updateLog(storecells(end,1));
            annotationEvents(hAnnotChildren, Codes);
            
            detect_food = ismember(FOOD_DETECT_ON, TEMP_LOG(end-(NEW_MESSAGE_N-1):end));
            arm_number = find(detect_food);
            %%If food has been poked
            if(find(detect_food))
                check_baited = find(BAITED == arm_number);
                %%Only dispense food if they have not entered the arm
                %%already
                if(check_baited & ~BAIT_ENTERED(check_baited))
                    FOOD_DISPENSED = reward_dispense(obj, arm_number);
                    BAIT_ENTERED(check_baited) = 1;
                    updateLog(FOOD_DISPENSED); 
                     
                    
                end
                IN_ARM = 1;
                CUR_POSITION = arm_number;
                subplot(hDiag);               
                hold on; imagesc([x_pos(arm_number) x_pos(arm_number)+sq_size], ...
                                 [y_pos(arm_number) y_pos(arm_number)+sq_size], 4)
            end
            
            
            %%Now check if rat is in center via photobeams
            %%Rat_position_state
            %%If in arm
                %%Check these
            
            if(IN_ARM)
                
                %%Perfect sequence: MS11 MS10 MX11 MX10
                max_length = length(TEMP_LOG);
                check_prev = inf;
                if(max_length < check_prev)
                    check_prev = max_length - 1;
                end
                log_snippet = TEMP_LOG(end-check_prev:end);
                time_snippet = time_log(end-check_prev:end);
                reward_beam_off = find(ismember(log_snippet, BEAM_REWARD_OFF), 1, 'last');
                reward_beam_on = find(ismember(log_snippet, BEAM_REWARD_ON), 1, 'last');
                door_beam_off = find(ismember(log_snippet, BEAM_DOOR_OFF ), 1, 'last');
                
                time_reward_off = time_snippet(reward_beam_off);
                time_reward_on = time_snippet(reward_beam_on);
                time_door_off = time_snippet(door_beam_off);
                %%If really exited, close doors for 5s and re-open
                %%AND 0.5s delay
                min_dur = 0.1; 
                time_diff = time_reward_off - time_reward_on
                if((reward_beam_off < door_beam_off) & (reward_beam_on < reward_beam_off) & (time_diff > min_dur) & toc(time_in_pos) > 3)
                    
%                     
                    %%Unless all baited arms have been entered, then doors
                    %%stay closed
                    if(sum(BAIT_ENTERED) == length(BAITED))
                        msgbox('All arms have been entered')
                        CUR_POSITION = 0;
%                         DOOR_OFF = close_doors(obj);
%                         updateLog(DOOR_OFF)
%                         saveTEMP();
%                         continue;
                    end
                    %%%Pause 5s and re-open. 
%                     t.StartFcn = {@timerTrialStart, obj};
%                     t.TimerFcn = {@timerTrialEnd, obj};
%                     start(t)
                    
                    
                end

            %%Else if in center
                %%Be ready to check which arm they entered
            elseif(~IN_ARM)
                

                max_length = length(TEMP_LOG);
                check_prev = inf;
                if(max_length < check_prev)
                    check_prev = max_length - 1;
                end
                log_snippet = TEMP_LOG(end-check_prev:end);
                time_snippet = time_log(end-check_prev:end);
                reward_beam_off = find(ismember(log_snippet, BEAM_REWARD_OFF), 1, 'last');
                door_beam_on = find(ismember(log_snippet, BEAM_DOOR_ON), 1, 'last');
                door_beam_off = find(ismember(log_snippet, BEAM_DOOR_OFF ), 1, 'last');
                
                time_reward_off = time_snippet(reward_beam_off);
                time_door_on = time_snippet(door_beam_on);
                time_door_off = time_snippet(door_beam_off);
                min_dur = 0.1; 
                time_diff = time_door_off - time_door_on
                %%If really in arm, set IN_ARM to 1
                if((door_beam_off < reward_beam_off) & (door_beam_on < door_beam_off) & (time_diff > min_dur) | find(detect_food))
                    %%Check if arm entered
                    IN_ARM = 1;
                    time_in_pos = tic; 
                end
                    
               

            end
            
            
                
            
        end

        
        
%         if(sum(BAIT_ENTERED) == length(BAITED) || toc(trial_timer) > trial_duration)
%             trial_timer = tic;
%             TRIALNR = TRIALNR+1;
%         end
%         
  
    end
%     delete(t);
    function timerTrialStart(~,~,obj)
        CUR_POSITION = 0;
        IN_ARM = 0;
        DOOR_OFF = close_doors(obj);
        updateLog(DOOR_OFF)
        saveTEMP();
    end
    function timerTrialEnd(~,~, obj)
        DOOR_ON = open_doors(obj);
        updateLog(DOOR_ON)
        saveTEMP();
        time_in_pos = tic;
        
    end

  
    
    %%%Save the data
    function closeObj(obj)
        
        fclose(obj);
        %%Need to reset temp log when outputs are given



    end
    
end
