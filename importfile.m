function [x_time_ms,sti_info] = importfile(filename, dataLines)
%% 输入处理

% 如果不指定 dataLines，请定义默认范围
if nargin < 2
    dataLines = [6, Inf];
end

%% Get the information of the file
var = detectImportOptions(filename);

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 3);

% 指定范围和分隔符
opts.DataLines = dataLines;
opts.Delimiter = "\t";

% 指定列名称和类型
opts.VariableNames = [var.VariableNames];
opts.VariableTypes = [var.VariableTypes];
% 指定文件级属性
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% 指定变量属性
%opts = setvaropts(opts, ["VarName34", "VarName35"], "WhitespaceRule", "preserve");
%opts = setvaropts(opts, ["VarName34", "VarName35"], "EmptyFieldRule", "auto");
%opts = setvaropts(opts, "Time", "InputFormat", "HH:mm:ss");

% 导入数据
table = readtable(filename, opts);
x_time_ms = table{:,3}; % get the time infomation 
sti_info = table{:,end};% get the stimulation infomationh
end