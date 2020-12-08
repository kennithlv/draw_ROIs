% author: Kennith Lv in SunLab
% Data: 2020/11/29
% function: Load the optogenetics data and convert it 

% output: the mean plot figure & the mean plot data

function MeanPlot = ChrimsonMeanPlot()


MeanPlot = [];

[file, path] = uigetfile('*.mat','Choose traces.mat file for loading datas','D:\20201207\brain1_left');
data = load([path,file]);
num_frames = length(data.traces.raw);
roi_num = size(data.traces.raw,1);
delta = (data.traces.raw./repmat(nanmean(data.traces.raw(:,floor(num_frames*0.02):floor(num_frames*0.05)),2),[1 num_frames]))-1;

colors = linspecer(roi_num);


% load the txt file to divide the data
[file_txt, path_txt] = uigetfile(['\*.txt'],'Choose .txt file to load time label');
[x_time_ms,sti_info] = importfile(fullfile(path_txt,file_txt));
opto_sti_index = find(~cellfun(@isempty,sti_info) == 1);

frame_rate = 4;
delta_points = unique(diff(opto_sti_index));


%x轴创建
x = (1:delta_points)/4;
for i = delta_points/2+1 : delta_points
    x(i) = x(i) + 0.5;
end

for n = 1 : roi_num
    
    gcf = figure;
    traces_num_inOneTrial = 1;
    for i = opto_sti_index(1) : delta_points: opto_sti_index(end)
        %caculate the baseline
        base = mean(delta(n,i-delta_points/2+1:i-1));
        delta(n,i-delta_points/2+1:i+delta_points/2) = delta(n,i-delta_points/2+1:i+delta_points/2) - base;
        MeanPlot(traces_num_inOneTrial,1:delta_points,n) = delta(n,i-delta_points/2+1:i+delta_points/2);
        traces_num_inOneTrial = traces_num_inOneTrial + 1;
        plot(x,delta(n,i-delta_points/2+1:i+delta_points/2));
        hold on
        if i == opto_sti_index(end)
            hl = boundedline(x,mean(MeanPlot(:,:,n),1),std(MeanPlot(:,:,n),0,1),'cmap', colors(n,:),'alpha');%汇出平均值及方差
            hl.LineWidth = 4;%更改线的粗细
            patch([x(delta_points/2) x(delta_points/2+1) x(delta_points/2+1) x(delta_points/2)], ...
                [min(ylim) min(ylim), max(ylim) max(ylim)],'black','FaceAlpha',.05)
        end
    end
    xlabel('t/s')
    ylabel('{\Delta}F/F')
    mkdir(fullfile(path,'rois'))
    exportgraphics(gcf,[fullfile(path,'rois'),'\roi_',num2str(n), '.pdf'],'ContentType','vector',...
        'BackgroundColor','none')
    exportgraphics(gcf,[fullfile(path,'rois'),'\roi_',num2str(n), '.png'])

end
save([path,'MeanPlot.mat'],'MeanPlot');
end