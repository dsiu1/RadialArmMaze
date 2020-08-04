
function obj = SerialInit()
    comPort = 'COM4';
    %%Check if any open already
    portName = {strcat('Serial-', comPort)};
    curSerial = instrfind;
    if(isempty(curSerial))
        obj = serial(comPort);
    
        set(obj,'DataBits',8);
        set(obj,'StopBits',1);
        set(obj,'BaudRate',9600);
        set(obj,'Parity','none');
        fopen(obj);
        return 
    end
    getPortInd = find(ismember(curSerial.Name, portName));
    getOpenInd = find(ismember(curSerial.Status, {'open'}));
    for i = 1:length(getOpenInd)
        if(find(getPortInd == getOpenInd(i)))
            fclose(curSerial(getOpenInd(i)));
        end
    end
    obj = serial(comPort);
    
    set(obj,'DataBits',8);
    set(obj,'StopBits',1);
    set(obj,'BaudRate',9600);
    set(obj,'Parity','none');
    fopen(obj);
end
