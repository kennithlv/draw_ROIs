% author: Kennith Lv in SunLab
% Data: 2020/12/01
% function: Load the optogenetics data and convert it 

% output: the mean plot figure & the mean plot data

clear

% here is the capture parameter
delta_points = 20; % points between every capture
frame_rate = 4;
duration = 0.5; % stimulation duration (s)

x = (1:delta_points)/frame_rate;
for i = delta_points/2 + 1 : delta_points
    x(i) = x(i) + 0.5;
end

% load the selected data and convert all the data into one matrix
alldata = [];
gcf = figure;

while 1
    input = input('Cotinue? (y or n)','s');
    if isequal(input,'n')
        clear input
        break;
    elseif isequal(input,'y')
        [file, path] = uigetfile('*.mat','Choose .mat file for adding ROIs','\\SunLabNASTS832\SunLabPrv\LvQT\AOTU project\photon_sti');
        disp(['Load data from',path,file])
        delta = load([path,file]);
        data = delta.roi_data;
        alldata = cat(1,alldata,data);
        for trace_number = 1 : size(data,1)% trace number
            plot(x,data(trace_number,:));
            hold on
        end
        %hl = plot(x,mean(data,1),'Color', colors(colors_index,:));%汇出平均值
        hl = plot(x,mean(data,1));%汇出平均值
        hl.LineWidth = 4;%更改线的粗细
        clear input
    else
        clear input
        continue;
    end   
end


% here is the savepath 
savepath = '\\SunLabNASTS832\SunLabPrv\LvQT\AOTU project\photon_sti\201124\';
disp(savepath)
input = input('Confirm? (y or n)','s');
if isequal(input,'y')
    clear input
else
    clear savepath
    clear input
    savepath = input('New savepath (end with \):' , 's');
    if savepath(end) ~= '\'
        savepath(end+1) = '\'; 
    end
end




%save([savepath,'roi_',num2str(roi_number),'.mat'],'roi_data');
hl = boundedline(x,mean(alldata,1),std(alldata,0,1),'r','alpha');%汇出平均值及方差
hl.LineWidth = 8;%更改线的粗细
patch([x(10) x(11) x(11) x(10)], ...
    [min(ylim) min(ylim), max(ylim) max(ylim)],'black','FaceAlpha',.05)
xlabel('t/s')
ylabel('{\Delta}F/F')

filename = input('The filename of the file: ','s');

exportgraphics(gcf,[savepath,filename, '.pdf'],'ContentType','vector',...
    'BackgroundColor','none')
exportgraphics(gcf,[savepath,filename, '.png'])