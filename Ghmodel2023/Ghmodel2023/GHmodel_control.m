clear all
clc 
close all
datafile='2022-05-27-23-save.mat';
load(datafile)
b=[0.0118; -0.5740];
T_in=Tin;
T_out=T_out;
Vx_wind=V_wind*3;
Ia=I_out/54*0.51;     %太阳辐射通量密度 （wm2） 太阳光源， 1umol/m2/s=54lux=0.51w/m2
Iax=Ia;    
T_interval=15*60; % 15min;、
As=500;  % 温室覆盖材料表面积
As=500;   %  覆盖层总面积 m2
Av=100;   %  通风面积；
Ag=100;            %温室占地面积                    [m^2]
Hg=8;              %温室平均高度                  [ m ]
Vair=1000;    %温室体积
cair=1.005;    %空气比热容；[kJ/(kg·K)]
pair=1.293;    %空气密度；  密度/(kg/m^3)|t=20℃:    1.293
LAI=2;    %作物叶面积指数；
Lamda=2450;  %KJkg-1,   水的汽化潜热；
Toua=0.5;          % 覆盖材料透光系数  0.5；
kg=0.05;   %覆盖材料的热传递系数  w/m2/K;
T_in_x(1)=T_in(1);
T_in_cal(1)=T_in(1);
dT_cal(1)=0;
dT_actual(1)=0;
Qcool=zeros(size(T_out,1),1);
Qheat=zeros(size(T_out,1),1);
% RoofVent=zeros(size(T_out,1),1);
% SideVent=zeros(size(T_out,1),1);
ShadeCurtain=zeros(size(T_out,1),1);
Output1=zeros(size(T_out,1),2);
% 目标设定
Temp_Ideal_UP=28;
Temp_Ideal_DOWN=15;
for i=2:size(T_out,1)
    ShadeCurtain(i)=1;
    T_in_pred(i)=T_in_cal(i-1);
    %     控制策略写这里
    if T_in_pred(i)<Temp_Ideal_DOWN
        Qheat(i)=20*(Temp_Ideal_DOWN-T_in_pred(i));
        SideVent(i)=0;
        RoofVent(i)=0;
        Qcool(i)=0;
    else
        SideVent(i)=1;
        RoofVent(i)=1;
    end    
    if T_in_pred(i)>Temp_Ideal_UP
        Qcool(i)=80*(T_in_pred(i)-Temp_Ideal_UP);
        SideVent(i)=0;
        RoofVent(i)=0;
        Qheat(i)=0;
        if Ia(i)>200
            ShadeCurtain(i)=1;
        end
    end
    % 后台计算下一个时刻的温度变化状态
    if ShadeCurtain(i)==1
        Iax(i)=1/5*Ia(i);
    end
    Qsolar(i)=As*Iax(i)*Toua*T_interval;   %太阳辐射吸收的能量；
    Qcon(i)=As*kg*(T_in_pred(i)-T_out(i))*T_interval;    % 室内外空气通过覆盖材料热传导引起的交换能量；
    Qplant(i)=Ag*pair*cair*LAI*(0.08*T_in_pred(i))*T_interval;   %作物与室内换热的能量；
    Qvent_Roof(i)=Av*Vx_wind(i)*RoofVent(i)*(T_in_pred(i)-T_out(i))*T_interval; %天窗通风交换的热量
    Qvent_Side(i)=Av*Vx_wind(i)*SideVent(i)*(T_in_pred(i)-T_out(i))*T_interval;  %侧窗通风交换的热量
    Qsoil(i)=Ag*0.05*T_in_pred(i)*T_interval;   %土壤与室内空气换热的能量；
    Qheatx(i)=min(100,Qheat(i))*1000*T_interval;  %80*1000*T_interval;    % 加热系统热量   w
    Qcoolx(i)=min(100,Qcool(i))*1000*T_interval;
    

    dQ(i)=[Qsolar(i)-Qcon(i)-Qplant(i)-Qsoil(i)+Qheatx(i)-Qcoolx(i), Qvent_Roof(i)+Qvent_Side(i)]*[0.0118; -0.5740];
    dT_cal(i)= dQ(i)/(pair*Vair*cair)/T_interval;
    T_in_cal(i)=T_in_cal(i-1)+dT_cal(i);
end



%%
figure; 
plot(t,T_out,'b','LineWidth',2);
title('\bf室内外温度');
hold on
plot(t,T_in_cal,'c','LineWidth',2)
grid on
legend('室外温度','室内温度');
