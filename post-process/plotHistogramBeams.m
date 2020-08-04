arm_entries = find(ismember(trial_log(:,3), BEAM_REWARD_ON_ENG));
arm_exits = find(ismember(trial_log(:,3), BEAM_REWARD_OFF_ENG));


newlog_entries = trial_log(arm_entries, 1);
newlog_exits = trial_log(arm_exits, 1); 


figure;
hist([newlog_exits{:}] - [newlog_entries{:}], 1000);