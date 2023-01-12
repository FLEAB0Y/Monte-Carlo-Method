clear, clc, clf, tic
mu = 2; sigma = 3;      % 用于正态函数的模拟
f1 = @(x) sqrt(1-x.^2);
f2 = @(x) sin(x) ./ x;
f3 = @(x) exp(x);
f4 = @(x) 0.3 * exp(-0.2*x.^2) + 0.7 * exp(-0.2*(x - 10).^2);
f5 = @(x) 1 / (sigma * sqrt(2 * pi)) * exp(-(x - mu).^2/(2 * sigma^2));
f6 = @(x) x./(exp(x.*10)-1).*100;
func = f6;
uniform_sample = @(a, b) a + rand() * (b - a);
num_sample = 1000000;   % 总共需要步的步数（个状态）
num_skip = 10000;       % 经过该步数之后才算做有效数据

X = zeros(1, num_sample + num_skip);% 初始状态设置为0
for i = 2:(num_sample + num_skip)   % 需要num_sample步+num_skip步
    xnow = X(i-1);                  
    xnext = uniform_sample(0, 1);   % 随机采样的结果，采用(0,1)上的均匀采样
    r = min(1, func(xnext)/func(xnow)); % 用于与接收
    u = rand();
    if (u <= r)         % 接收新采样得到的数据作为下一个状态值
        X(i) = xnext;
    else                % 拒绝，并保持当前值
        X(i) = xnow;
    end
end
plot(1:num_sample, X(num_skip + (1:num_sample)));
% mean(X(num_skip +(1 :num_sample)));
% std(X(num_skip +(1 :num_sample)));

% 将区间分为num_seg个区段，统计落到每个区段上值的个数(histcounts)
num_seg = 50;         
[counts, interval] = histcounts(X(num_skip + (1:num_sample)), num_seg);
% 每个区段的中点值
points = (interval(1:end - 1) + interval(2:end)) / 2;
figure(1);clf;
bar(points, counts/num_sample);     % 将每个区段的数量绘制出来

x = linspace(0, 1, num_seg); y = func(x);
hold on; plot(x, func(x) / sum(func(x)));   % 理论的分布
% 计算模拟积分值与真实积分值并对比
rand_calc = (num_sample ./ counts) * func(points)' / num_seg^2;  
real_calc = integral(func, 0, 1);
delta1 = abs(rand_calc - real_calc);
fprintf("rand_calc = %.16f\n", rand_calc);
fprintf("real_calc = %.16f\n", real_calc);
fprintf("积分误差 = %.16f\n", delta1);
toc

% 随机模拟出的分布函数与真实分布函数的比较
F1(1) = 0; F2(1) = 0;   % 初始化分布函数的值
for i = 2:num_seg
    F1(i) = F1(i-1) + counts(i) / num_sample;
    F2(i) = F2(i-1) + y(i) / sum(y);
end
figure(2); clf; 
plot(x, [F1', F2']);    % 绘制两个分布函数
delta2 = max(F1-F2);    % 随机模拟准确度的度量方法之一
fprintf("分布误差 = %.16f\n", delta2);
