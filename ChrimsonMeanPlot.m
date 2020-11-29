% author: Kennith Lv in SunLab
% Data: 2020/11/29
% function: Load the optogenetics data and convert it 

% input: the .mat file
% output: the mean plot figure & the mean plot data

function MeanPlot = ChrimsonMeanPlot()
MeanPlot = [];

[file, path] = uigetfile('*.mat','Choose .mat file for adding ROIs','\\SunLabNASTS832\SunLabPrv\LvQT\AOTU project\photon_sti');

data = load([path,file]);
num_frames = length(data.traces.raw);
roi_num = size(data.traces.raw,1);
delta = (data.traces.raw./repmat(nanmean(data.traces.raw(:,floor(num_frames*0.02):floor(num_frames*0.05)),2),[1 num_frames]))-1;

colors = linspecer(roi_num);

for n = 1 : roi_num
    
    gcf = figure;
    
    %x轴创建
    x = (1:20)/4;
    for i = 11 : 20
        x(i) = x(i) + 0.5;
    end
    
    for i = 20 : 20: 80
        MeanPlot(i/20,1:20,n) = delta(n,i-9:i+10);
        plot(x,delta(n,i-9:i+10));
        hold on
        if i == 80
            hl = boundedline(x,mean(MeanPlot(:,:,n),1),std(MeanPlot(:,:,n),0,1),'cmap', colors(n,:),'alpha');%汇出平均值及方差
            hl.LineWidth = 4;%更改线的粗细
            patch([x(10) x(11) x(11) x(10)], ...
                [min(ylim) min(ylim), max(ylim) max(ylim)],'black','FaceAlpha',.05)

        end
    end
    xlabel('t/s')
    ylabel('{\Delta}F/F')
    exportgraphics(gcf,[path,num2str(n), '.pdf'],'ContentType','vector',...
        'BackgroundColor','none')

end
save([path,'MeanPlot.mat'],'MeanPlot');
end