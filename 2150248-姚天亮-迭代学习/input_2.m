function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
switch flag,                               %%%%%%%%�ж�flag������ǰ�����ĸ�״̬
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;     %%flag=0��ʾ���ڳ�ʼ��״̬����ʱ�ú���mdlInitializeSizes���г�ʼ�� 
case 3,                                     %%%flag=3��ʾ��ʱҪ�������
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
sizes.NumOutputs     = 4;%ģ����������ĸ���
sizes.NumInputs      = 0;%ģ����������ĸ���
sizes.DirFeedthrough = 1;%ģ���Ƿ����ֱ�ӹ�ͨ��ֱ�ӹ�ͨ�ҵ������������  %ֱ�ӿ�������� 
sizes.NumSampleTimes = 1;%ģ��Ĳ���ʱ�������������һ��
sys = simsizes(sizes);%������󸳸�sys��� 
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)%���Ϊ�����켣����Ӧ����
x1d=sin(3*t);
dx1d=3*cos(3*t);
x2d=cos(3*t);
dx2d=-3*sin(3*t);

sys(1)=x1d;
sys(2)=x2d;
sys(3)=dx1d;
sys(4)=dx2d;