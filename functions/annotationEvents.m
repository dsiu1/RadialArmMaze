function annotationEvents(hAnnotChildren, Codes)
    global TEMP_LOG
    %%Updates left hand annotations
    if ~isempty(hAnnotChildren)
        % do something with the annotation handles...
        max_messages = 60;
        if(length(TEMP_LOG) < max_messages)
            hAnnotChildren.String = convertDoorCodestoEnglish(TEMP_LOG, Codes);
        else
            hAnnotChildren.String = convertDoorCodestoEnglish(TEMP_LOG(end-(max_messages-1):end), Codes);
        end

    end
end