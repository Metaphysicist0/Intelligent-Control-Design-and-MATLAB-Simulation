function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
switch flag,                               %%%%%%%%判断flag，看当前处于哪个状态
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;     %%flag=0表示处于初始化状态，此时用函数mdlInitializeSizes进行初始化 
case 3,                                     %%%flag=3表示此时要计算输出
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;%用于设置模块参数的结构体用simsizes来生成
sizes.NumContStates  = 0;%模块连续状态变量的个数
sizes.NumDiscStates  = 0;%模块离散状态变量的个数 
sizes.NumOutputs     = 4;%模块输出变量的个数
sizes.NumInputs      = 0;%模块输入变量的个数
sizes.DirFeedthrough = 1;%模块是否存在直接贯通（直接贯通我的理解是输入能  %直接控制输出） 
sizes.NumSampleTimes = 1;%模块的采样时间个数，至少是一个
sys = simsizes(sizes);%设置完后赋给sys输出 
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)%输出为期望轨迹和相应导数
x1d=sin(3*t);
dx1d=3*cos(3*t);
x2d=cos(3*t);
dx2d=-3*sin(3*t);

sys(1)=x1d;
sys(2)=x2d;
sys(3)=dx1d;
sys(4)=dx2d;