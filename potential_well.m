L=10; %势阱宽度
n=1;%量子数
N=10000; %需要随机数的个数
position=zeros(N,1); %存放随机数的数列
i=0;
f1=@(t) 1/L*((sin(3*pi*t/L)+sin(3*pi*t/L)).^2);

f2=@(t) 0;
tt=linspace(0,10,1000);
ff=f1(tt).*(tt<=10);%根据公式计算概率密度
s=trapz(tt,ff);  %计算整个区间概率密度的积分
ff=ff/s;         %归一化概率密度
 
 
while i<N
    t=rand(1)*10;%生成[0,10]在阱内均匀分布随机数
    if t<=10 && t>=0
        f=f1(t)/s;
    else
        f=f2(t)/s;
    end         %分别计算阱内和阱外的密度函数值f(t)
    r=rand(1);  %生成[0,1]均匀分布随机数
    if r<=f     %如果随机数r小于f(t)，接纳该t并加入序列a中
        i=i+1;
        position(i)=t;
    end
end
 
%以上为生成随机数列a的过程，以下为统计检验随机数列是否符合分布
num=100;         %分100个区间统计
[x,c]=hist(position,num);    %统计不同区间出现的个数
dc=10/num;        %区间大小
x=x/N/dc;         %根据统计结果计算概率密度
 
bar(c,x,1); hold on;  %根据统计结果画概率密度直方图
plot(tt,ff,'r'); hold off; %根据公式画概率密度曲线
