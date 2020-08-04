%%Helper function to simply plot the rat diagram
function hDiag = PlotArms()
    %%Reads in RAM_diagram and sets the axes
    diagram = imread('C:\Users\ahmedlab\Documents\MATLAB\radial_arm_maze\RAM_diagram.png');
    hDiag = subplot(5,5,1:20);  
    hold off;
    imagesc(diagram);
    set(hDiag,'XTickLabel',[])
    set(hDiag,'YTickLabel',[])
    hold on; 

end