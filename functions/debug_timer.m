
storecells = {};
longchar = '';

logfile = {'Session Time (ms)', 'Event', 'Trial nr', 'Accuracy'};
disp(logfile);
maxduration = 60;
ses_timer = tic; 
time_log = toc(ses_timer);
while(toc(ses_timer) < maxduration)
        pause(0.001);
        
        if(obj.BytesAvailable > 0)
            storecells{end+1,1} = fread(obj, obj.BytesAvailable);
            storecells{end,2} = toc(ses_timer);
            
            longchar = [longchar; storecells{end,1}];
            [convertToChar exportArray] = ParseArduinoOutput(obj,longchar);
            C = strsplit(convertToChar)';
            
            %%Extending time log based on the messages received. 
            time_log(end+1:end+length(C)-length(time_log)) = toc(ses_timer); 
            
            
        end

end
toc(ses_timer)