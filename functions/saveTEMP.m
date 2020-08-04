function saveTEMP
    global longchar time_log TEMP_LOG phase_log pos_log trial_time_log
    save('./data/TEMP_STORE', 'longchar', 'time_log', 'TEMP_LOG', 'phase_log', 'pos_log', 'trial_time_log'); 
end
