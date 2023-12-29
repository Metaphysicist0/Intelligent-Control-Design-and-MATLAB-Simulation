function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end 
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;%��������ģ������Ľṹ����simsizes������
sizes.NumContStates  = 0;%ģ������״̬�����ĸ���
sizes.NumDiscStates  = 0;%ģ����ɢ״̬�����ĸ��� 
sizes.NumOutputs     = 2;%ģ����������ĸ���
sizes.NumInputs      = 4;%ģ����������ĸ���
sizes.DirFeedthrough = 1;%ģ���Ƿ����ֱ�ӹ�ͨ��ֱ�ӹ�ͨ�ҵ������������  %ֱ�ӿ�������� 
sizes.NumSampleTimes = 1;%ģ��Ĳ���ʱ�������������һ��
sys = simsizes(sizes);%������󸳸�sys��� 
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)%%%%%%%%%����ƫ��������PD��
e1=u(1);e2=u(2);
de1=u(3);de2=u(4);

e=[e1 e2]';
de=[de1 de2]';

%%%%%%%% put your code  here
Kp = 2.5;
Gama = 0.95;
Kd = Gama*eye(2);

Tol = Kp*e+Kd*de
%%%%%%%%%%%%%%%%%%%%

sys(1)=Tol(1);
sys(2)=Tol(2);