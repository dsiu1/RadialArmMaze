global BAITED filename
Codes = loadCodes();
% processByTrial(logfile, Codes); 
%%For each arm
%%Time of entry
%%Time of exit
%%= duration of visit
%%re-entry in baited arm 
%%First IR beam vs 2nd IR beam entry across days
%%Total number of entries
%%Total number of nose pokes 
%%Last arm entry time
ratname = strtok(filename);
datafiles = dir('./data');
[~, idx] = sort([datafiles.datenum]);
datafiles = datafiles(idx); 
anyfiles = [];
all_rats = {'Rat0062', 'FTF1', 'FTF2', 'FTF3', 'FTF4', 'FTM1', 'FTM2', 'FTM3', 'FTM4'};

for cur_rats = 1:length(all_rats)
    rodent_name = all_rats{cur_rats};
    for i = 3:size(datafiles,1)
        [~,~,ext] = fileparts(datafiles(i).name); 
        anyfiles(i) = ~isempty(strfind(datafiles(i).name, rodent_name)) && strcmp(ext, '.mat');
    end
    file_ind = find(anyfiles);

    day_axes = 1;
    store_refmem = [];
    legend_names = {};
    tickLabels = {}; 
    
    figure('units', 'normalized', 'outerposition', [0 0 1 1]); 
    %%By data
    for i = 1:length(file_ind)
        %%By Trial
        RAM_file = datafiles(file_ind(i)).name; 
        load(['./data/' RAM_file]);
        split_file = strsplit(RAM_file, '_');
        
        day_ind = 2;
        day_num = split_file{day_ind}; 
        while isempty(strfind(day_num, 'D'))
            day_ind = day_ind + 1;
            day_num = split_file{day_ind};
        end
        
        [reference_mem, working_mem, total_entered, total_nosepoke] = processByTrial(logfile, Codes);
        cur_size = day_axes(end)+2; 
        day_axes = [day_axes cur_size:cur_size+length(working_mem)-1];
        store_refmem = [store_refmem; reference_mem];
        tickLabels = [tickLabels strcat('T', cellfun(@num2str, num2cell(1:length(working_mem)), 'UniformOutput', 0))];
        subplot(2,2,1);
        hold on;
        plot(cur_size:cur_size+length(working_mem)-1, reference_mem, 'o-'); 

        subplot(2,2,2);
        hold on;
        plot(cur_size:cur_size+length(working_mem)-1, working_mem, 'o-'); 

        subplot(2,2,3);
        hold on;
        plot(cur_size:cur_size+length(working_mem)-1, total_entered, 'o-'); 

        subplot(2,2,4);
        hold on;
        plot(cur_size:cur_size+length(working_mem)-1, total_nosepoke, 'o-'); 
        legend_names(i) = join(split_file(1:day_ind), ' '); 
    end
    day_axes(1) = [];
    ylabel_store = {'Reference Memory Errors', 'Working Memory Errors', 'Total Arm Entries', 'Total Nose Pokes'};

    for i = 1:4
        subplot(2,2,i);
        legend(legend_names);
        xlabel('Time');
        ylabel(ylabel_store{i});  
        ylim([0 30]);
        set(gca, 'XTick', day_axes, 'XTickLabel', tickLabels);
    end

    suptitle(rodent_name);
    print(gcf, rodent_name, '-dpng')
end
%%Processing data by trials
function [reference_mem, working_mem, total_entered, total_nosepoke] = processByTrial(logfile, Codes)
    global BAITED
    
    %%The paper allows either 8 ATTEMPTS or if 4 baited arms entered
    %%Hence why their reference memory errors were <4 usually
    %%Should we allow all arms entered or just 8 times like them?
    %%Likely plot 5 trials worth
    %%Do I trust my algorithm for the most part? How would I process it
    %%post-hoc? Paper had people score manually
    logfile_ENG = convertDoorCodestoEnglish(logfile, Codes);
    Arms = 8; 
    BEAM_REWARD_ON_ENG = strcat('BEAM_2_ON_ARM_', cellfun(@num2str,num2cell(1:Arms), 'UniformOutput', 0));
    BEAM_REWARD_OFF_ENG = strcat('BEAM_2_OFF_ARM_', cellfun(@num2str,num2cell(1:Arms), 'UniformOutput', 0));
    FOOD_DETECT_ON_ENG = strcat('FOOD_DETECT_', cellfun(@num2str,num2cell(1:Arms), 'UniformOutput', 0));



    trials = logfile{end,4};
    reference_mem = zeros(trials,1);
    working_mem = zeros(trials,1);
    total_entered = zeros(trials, 1); 
    total_nosepoke = zeros(trials, 1); 
    
    for t = 1:trials
        first_ind = find([logfile_ENG{2:end,4}] == t, 1, 'first')+1;
        last_ind = find([logfile_ENG{2:end,4}] == t, 1, 'last')+1;
        trial_log = logfile_ENG(first_ind:last_ind, :);

        arm_entries = find(ismember(trial_log(:,3), BEAM_REWARD_ON_ENG));
        arm_exits = find(ismember(trial_log(:,3), BEAM_REWARD_OFF_ENG));
        
        
        if(isempty(arm_entries))
            disp(['No arm entries at trial ' num2str(t)]);

            continue;
        end
        armlog = trial_log(arm_entries, 3);
        unique_entries = armlog(1);
        prev_entry = '';

        for i = 1:length(armlog)
            cur_entry = armlog{i};
            if(strcmp(prev_entry, cur_entry))
                continue;
            end
            prev_entry = cur_entry;
            arm_num = str2num(cur_entry(end));


            %%Working memory calculation: Enter same arm within same trial 
            if(ismember({cur_entry}, unique_entries))
                working_mem(t,1) = working_mem(t,1) + 1;
            end

            %%Reference memory calculation: Enter non-baited
            if(isempty(find(BAITED == arm_num,1)))
                reference_mem(t,1) = reference_mem(t,1) + 1;
            end

            unique_entries{end+1,1} = cur_entry;
            total_entered(t,1) = total_entered(t,1) + 1; 

        end
        
        
        
        %%%Now checking for nosepokes
        nosepokes = find(ismember(trial_log(:,3), FOOD_DETECT_ON_ENG)); 
        if(isempty(nosepokes))
            disp(['No nosepokes at trial ' num2str(t)]);

            continue;
        end
        noselog = trial_log(nosepokes,  3);
        unique_entries = noselog(1);
        prev_entry = '';
        
        for i = 1:length(noselog)
            cur_entry = noselog{i};
            if(strcmp(prev_entry, cur_entry))
                continue;
            end
            prev_entry = cur_entry;

            unique_entries{end+1,1} = cur_entry;
            total_nosepoke(t,1) = total_nosepoke(t,1) + 1;
        end
        

    end
end