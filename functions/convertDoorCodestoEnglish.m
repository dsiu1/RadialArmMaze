function logfile_ENG = convertDoorCodestoEnglish(logfile, Codes)
    

    logfile_ENG = logfile;
    if(size(logfile,2) > 1)
        for i = 1:size(Codes,1)
            getIndex = ismember(logfile(:,3), Codes(i,1));
            logfile_ENG(getIndex,3) = Codes(i,2);
        end
    %%If inputting a templog variable
    else
        for i = 1:size(Codes,1)
            getIndex = ismember(logfile, Codes(i,1));
            logfile_ENG(getIndex) = Codes(i,2);
        end
    end
end