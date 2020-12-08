% author: Kennith Lv in SunLab
% Data: 2020/11/29
% function: Load the optogenetics data and convert it 

% output: the mean plot figure & the mean plot data

clear

% load the selected data and convert all the data into one matrix
data = [];

while 1
    input = input('Cotinue? (y or n)','s');
    if isequal(input,'n')
        clear input
        break;
    elseif isequal(input,'y')
        [file, path] = uigetfile('*.mat','Choose .mat file','D:\20201207\brain1_left');
        disp(['Load data from',path,file])
        delta = load([path,file]);
        data = cat(1,data,delta.MeanPlot);
        
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


% here is the capture parameter
delta_points = 20; % points between every capture
frame_rate = 4;
duration = 0.5; % stimulation duration (s)

x = (1:delta_points)/frame_rate;
for i = delta_points/2 + 1 : delta_points
    x(i) = x(i) + 0.5;
end

colors = linspecer(size(data,3));

for roi_number = 1 : size(data,3)% roi number
    gcf = figure;
    roi_data = [];
    for trace_number = 1 : size(data,1)% trace number
        roi_data = cat(1,roi_data,data(trace_number,:,roi_number));
        plot(x,data(trace_number,:,roi_number));
        hold on
    end
    
    save([savepath,'roi_',num2str(roi_number),'.mat'],'roi_data');
    hl = boundedline(x,mean(data(:,:,roi_number),1),std(data(:,:,roi_number),0,1),'cmap', colors(roi_number,:),'alpha');%汇出平均值及方差
    hl.LineWidth = 4;%更改线的粗细
    patch([x(delta_points/2) x(delta_points/2+1) x(delta_points/2+1) x(delta_points/2)], ...
        [min(ylim) min(ylim), max(ylim) max(ylim)],'black','FaceAlpha',.05)
    xlabel('t/s')
    ylabel('{\Delta}F/F')
    
     exportgraphics(gcf,[savepath,'roi_',num2str(roi_number), '.pdf'],'ContentType','vector',...
         'BackgroundColor','none')
     exportgraphics(gcf,[savepath,'roi_',num2str(roi_number), '.png'])
end
save([savepath,'rois_data.mat'],'data');