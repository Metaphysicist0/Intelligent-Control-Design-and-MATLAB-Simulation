%%%%%%%%���ض����s����ʵ��

function [sys,x0,str,ts] = spacemodel(t,x,u,flag)%%%%%%%s������ʽ���ǹ̶���
switch flag,                                     %�ж�flag������ǰ�����ĸ�״̬
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;%%flag=0��ʾ���ڳ�ʼ��״̬����ʱ�ú���mdlInitializeSizes���г�ʼ��
case 1,                        %%%flag=1��ʾ��ʱҪ��������״̬��΢��
    sys=mdlDerivatives(t,x,u);
case 3,                        %%%flag=3��ʾ��ʱҪ�������
    sys=mdlOutputs(t,x,u);
case {2,4,9}                   %%%flag=2��ʾ��ʱҪ������һ����ɢ״̬
    sys=[]; 
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;        %��������ģ������Ľṹ����simsizes������
sizes.NumContStates  = 2;%ģ������״̬�����ĸ���
sizes.NumDiscStates  = 0;%ģ����ɢ״̬�����ĸ��� 
sizes.NumOutputs     = 2;%ģ����������ĸ��������������ĵ�����
sizes.NumInputs      = 2;%ģ����������ĸ��� ��ģ��Ŀ��Ʊ�����
sizes.DirFeedthrough = 0;%ģ���Ƿ����ֱ�ӹ�ͨ��ֱ�ӹ�ͨ�ҵ������������  %ֱ�ӿ�������� ����״̬����DΪ��ʲ�����
sizes.NumSampleTimes = 1;%ģ��Ĳ���ʱ�������������һ��
sys = simsizes(sizes);   %������󸳸�sys��� 
x0  = [0;1];%%%��ֵ
str = [];%����Ͳ���˵�ˣ������������[]�Ϳ����ˣ�����ûʲô��
ts  = [0 0];%����������Ϊ0��ʾ������ϵͳ
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