gcf = figure;
x = rand(1,20);
plot(x);
saveas(gcf,'test.fig')

a = openfig('test.fig');
hold on
x = rand(1,20);
plot(x);