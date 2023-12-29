clear all
clc 
close all
datafile='2022-06-07-23-save.mat';
load(datafile)
% load('model_b')
b=[0.0118; -0.5740];
T_in=Tin;
T_out=T_out;
Vx_wind=V_wind*3;
Ia=I_out/54*0.51;     %̫������ͨ���ܶ� ��wm2�� ̫����Դ�� 1umol/m2/s=54lux=0.51w/m2
Iax=Ia;    
T_interval=15*60; % 15min;��
As=500;  % ���Ҹ��ǲ��ϱ����
As=500;   %  ���ǲ������ m2
Av=100;   %  ͨ�������
Ag=100;            %����ռ�����                    [m^2]
Hg=8;              %����ƽ���߶�                  [ m ]
Vair=1000;    %�������
cair=1.005;    %���������ݣ�[kJ/(kg��K)]
pair=1.293;    %�����ܶȣ�  �ܶ�/(kg/m^3)|t=20��:    1.293
LAI=2;    %����Ҷ���ָ����
Lamda=2450;  %KJkg-1,   ˮ������Ǳ�ȣ�
Toua=0.5;          % ���ǲ���͸��ϵ��  0.5��
kg=0.05;   %���ǲ��ϵ��ȴ���ϵ��  w/m2/K;
T_in_x(1)=T_in(1);
T_in_cal(1)=T_in(1);
dT_cal(1)=0;
dT_actual(1)=0;
Qcool=zeros(size(T_out,1),1);   %�����������ʼ��Ϊ0�����Ⱥ� T_outһ�¡�
Qheat=zeros(size(T_out,1),1);  %�����������ʼ��Ϊ0�����Ⱥ� T_outһ�¡�
RoofVent=zeros(size(T_out,1),1);  %���촰�����ʼ��Ϊ0�����Ⱥ� T_outһ�¡�
SideVent=ones(size(T_out,1),1);   %���ര�����ʼ��Ϊ0�����Ⱥ� T_outһ�¡�
ShadeCurtain=zeros(size(T_out,1),1); %�������������ʼ��Ϊ0�����Ⱥ� T_outһ�¡�
Output1=zeros(size(T_out,1),4);  
% Ŀ���趨
Temp_Ideal_UP=28;  % Ŀ���¶����ޣ���������
Temp_Ideal_DOWN=15;  %Ŀ���¶����ޣ���������
Ghfuzzy1=readfis('Ghfuzzy.fis');   % ����ģ�����Ʋ��� �� ģ�����Ʋ�����Ҫ�õ�ģ���߼������䣬���ǵķ���ʵ��ƽ̨��Ҫʵ�����ƹ���
for i=2:size(T_out,1)  
    T_in_pred(i)=T_in_cal(i-1);   %Ԥ���¶ȳ�ʼ��Ϊ ��һʱ�̵ļ����¶�   
    %     ���Ʋ���д���ѧ������Ƕ���Լ��Ŀ��Ʋ���  
    [Output1(i,:)]=evalfis(Ghfuzzy1,[T_in_pred(i), Ia(i)]);   % Ӧ��ģ�����Ƽ���� ������������Ը������Ʊ������������䣬���ȣ��촰���ര�ȡ�
     %̫������ͨ���ܶ�Ia Ԥ���¶ȱ仯T_in_pred
     SideVent(i)=Output1(i,1);  %�촰
     RoofVent(i)=Output1(i,2);    %�ര
    if T_in_pred(i)<Temp_Ideal_DOWN  %�����ǰ�¶ȵ��������¶�
        Qheat(i)=Output1(i,3).*20*(Temp_Ideal_DOWN-T_in_pred(i));  %   ���������������� 
        Qcool(i)=Output1(i,4);  %����ʱ ����Ϊ0��
    else if T_in_pred(i)>Temp_Ideal_UP    %�����ǰ�¶ȸ��������¶�
        Qcool(i)=Output1(i,4).*80*(T_in_pred(i)-Temp_Ideal_UP);  %����������������
        Qheat(i)=Output1(i,3);
        if Ia(i)>200 
            ShadeCurtain(i)=1;  %����¶ȸ��������¶ȣ��ҹ���ǿ�ң����������򿪡�
        end
    else
        Qheat(i)=0;  % ������������˱���ԭ״���� 
        Qcool(i)=0;  % ����������˱���ԭ״��
    end
    end
    %�����ǿ��Ʋ��ԣ���������Ʊ���
    
    % �����Ǻ�̨��Ҫ���ݿ��Ʋ��Լ�����һ��ʱ�̵��¶ȱ仯״̬
    if ShadeCurtain(i)==1
        Iax(i)=1/3*Ia(i);  %����������򿪣������Ϊԭ����1/3.
    end
    Qsolar(i)=As*Iax(i)*Toua*T_interval;   %̫���������յ�������
    Qcon(i)=As*kg*(T_in_pred(i)-T_out(i))*T_interval;    % ���������ͨ�����ǲ����ȴ�������Ľ���������
    Qplant(i)=Ag*pair*cair*LAI*(0.08*T_in_pred(i))*T_interval;   %���������ڻ��ȵ�������
    Qvent_Roof(i)=Av*Vx_wind(i)*RoofVent(i)*(T_in_pred(i)-T_out(i))*T_interval; %�촰ͨ�罻��������
    Qvent_Side(i)=Av*Vx_wind(i)*SideVent(i)*(T_in_pred(i)-T_out(i))*T_interval;  %�രͨ�罻��������
    Qsoil(i)=Ag*0.05*T_in_pred(i)*T_interval;   %���������ڿ������ȵ�������
    Qheatx(i)=min(100,Qheat(i))*1000*T_interval;  % ��Qheatx������0 ��100֮��   % ����ϵͳ����   w
    Qcoolx(i)=min(100,Qcool(i))*1000*T_interval;    %ͬ��
    dQ(i)=[Qsolar(i)-Qcon(i)-Qplant(i)-Qsoil(i)+Qheatx(i)-Qcoolx(i), Qvent_Roof(i)+Qvent_Side(i)]*[0.0118; -0.5740];  % ��������ҵ���������
    dT_cal(i)= dQ(i)/(pair*Vair*cair)/T_interval; %�¶ȱ仯���������������ʽ
    T_in_cal(i)=max(T_out(i)+2,T_in_cal(i-1)+dT_cal(i));  % ������һ��ʱ�̵������¶ȣ���Ҫ�������¶�һֱ��2�ȡ�
end

%�����ǻ�ͼ���֣���ʾ�������¶ȣ�

figure;  
plot(t,T_out,'b','LineWidth',2);
title('\bf�������¶�-fuzzy control');
hold on
plot(t,T_in_cal,'c','LineWidth',2)
grid on
legend('�����¶�','�����¶�');

