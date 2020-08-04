function deactivateGUI(hGUI)
    hButtons = get(hGUI, 'Children');
    
    for i = 1:length(hButtons)
        if(strcmp(hButtons(i).Type, 'uicontrol'))
            hButtons(i).Enable = 'off';
        end
    end
end