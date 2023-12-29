%%%%%%%%被控对象的s函数实现

function [sys,x0,str,ts] = spacemodel(t,x,u,flag)%%%%%%%s函数格式都是固定的
switch flag,                                     %判断flag，看当前处于哪个状态
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;%%flag=0表示处于初始化状态，此时用函数mdlInitializeSizes进行初始化
case 1,                        %%%flag=1表示此时要计算连续状态的微分
    sys=mdlDerivatives(t,x,u);
case 3,                        %%%flag=3表示此时要计算输出
    sys=mdlOutputs(t,x,u);
case {2,4,9}                   %%%flag=2表示此时要计算下一个离散状态
    sys=[]; 
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;        %用于设置模块参数的结构体用simsizes来生成
sizes.NumContStates  = 2;%模块连续状态变量的个数
sizes.NumDiscStates  = 0;%模块离散状态变量的个数 
sizes.NumOutputs     = 2;%模块输出变量的个数（输出和输出的导数）
sizes.NumInputs      = 2;%模块输入变量的个数 （模块的控制变量）
sizes.DirFeedthrough = 0;%模块是否存在直接贯通（直接贯通我的理解是输入能  %直接控制输出） 这里状态方程D为零故不存在
sizes.NumSampleTimes = 1;%模块的采样时间个数，至少是一个
sys = simsizes(sizes);   %设置完后赋给sys输出 
x0  = [0;1];%%%初值
str = [];%这个就不用说了，保留参数嘛，置[]就可以了，反正没什么用
ts  = [0 0];%采样周期设为0表示是连续系统
function sys=mdlDerivatives(t,x,u)
A=[-2 3;1 1];
C=[1 0;0 1];
B=[1 1;0 1];
Gama=0.95;
norm(eye(2)-C*B*Gama);  % Must be smaller than 1.0

U=[u(1);u(2)];
dx=A*x+B*U;
sys(1)=dx(1);
sys(2)=dx(2);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);