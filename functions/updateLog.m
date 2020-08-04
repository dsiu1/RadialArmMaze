%%Parses events and logs. Only works within mainRAM because of the global
%%variable requirements
%%Input: updateLog({'eventcode'}) 
function [numEvents, LOG_OUTPUT] = updateLog(event)
    global longchar time_log ses_timer trial_timer obj TEMP_LOG phase_log trial_time_log TRIALNR pos_log position_legend CUR_POSITION
    
    %%Ensures the events are in the right dimension (n x 1)
    parsedEvent = [event{:}]';
    if(size(parsedEvent, 2) > size(parsedEvent, 1))
        parsedEvent = parsedEvent';
    end
    
    %%Need to store everything into one large array since partial
    %%messages may be clipped from polling too quickly
    longchar = [longchar; parsedEvent];
    [convertToChar, ~] = ParseArduinoOutput(obj,longchar);
    TEMP_LOG = strsplit(convertToChar)';
    
    %%Append to remaining log data based on new entries
    numEvents = length(TEMP_LOG)-length(time_log);
    phase_log(end+1:end+numEvents,1) = repmat(TRIALNR, numEvents,1); 
    trial_time_log(end+1:end+numEvents,1) = repmat(toc(trial_timer), numEvents, 1);
    time_log(end+1:end+numEvents,1) = repmat(toc(ses_timer), numEvents, 1);
    pos_log(end+1:end+numEvents,1) = repmat(position_legend(CUR_POSITION+1), numEvents,1);
    
    disp(TEMP_LOG); 
%     disp(['Time log length: ' num2str(length(time_log))]);
%     disp(['TEMP log length: ' num2str(length(TEMP_LOG))]);   
%     disp(['Trial Time log length: ' num2str(length(trial_time_log))]); 
    LOG_OUTPUT = TEMP_LOG; 
end