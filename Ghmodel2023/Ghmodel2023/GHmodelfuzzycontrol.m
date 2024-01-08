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
Qcool=zeros(size(T_out,1),1);   %将制冷输入初始化为0，长度和 T_out一致。
Qheat=zeros(size(T_out,1),1);  %将制热输入初始化为0，长度和 T_out一致。
RoofVent=zeros(size(T_out,1),1);  %将天窗输入初始化为0，长度和 T_out一致。
SideVent=ones(size(T_out,1),1);   %将侧窗输入初始化为0，长度和 T_out一致。
ShadeCurtain=zeros(size(T_out,1),1); %将遮阳网输入初始化为0，长度和 T_out一致。
Output1=zeros(size(T_out,1),4);  
% 目标设定
Temp_Ideal_UP=28;  % 目标温度上限，开启制冷
Temp_Ideal_DOWN=15;  %目标温度下限，开启加热
Ghfuzzy1=readfis('Ghfuzzy.fis');   % 导入模糊控制策略 ， 模糊控制策略需要用到模糊逻辑工具箱，我们的仿真实验平台需要实现类似功能
for i=2:size(T_out,1)  
    T_in_pred(i)=T_in_cal(i-1);   %预测温度初始化为 上一时刻的计算温度   
    %     控制策略写这里，学生可以嵌入自己的控制策略  
    [Output1(i,:)]=evalfis(Ghfuzzy1,[T_in_pred(i), Ia(i)]);   % 应用模糊控制计算出 控制输出，可以赋给控制变量，包括制冷，加热，天窗，侧窗等。
     %太阳辐射通量密度Ia 预测温度变化T_in_pred
     SideVent(i)=Output1(i,1);  %天窗
     RoofVent(i)=Output1(i,2);    %侧窗
    if T_in_pred(i)<Temp_Ideal_DOWN  %如果当前温度低于下限温度
        Qheat(i)=Output1(i,3).*20*(Temp_Ideal_DOWN-T_in_pred(i));  %   制热输入能量计算 
        Qcool(i)=Output1(i,4);  %制热时 制冷为0；
    else if T_in_pred(i)>Temp_Ideal_UP    %如果当前温度高于上限温度
        Qcool(i)=Output1(i,4).*80*(T_in_pred(i)-Temp_Ideal_UP);  %制冷输入能量计算
        Qheat(i)=Output1(i,3);
        if Ia(i)>200 
            ShadeCurtain(i)=1;  %如果温度高于上限温度，且光照强烈，则遮阳网打开。
        end
    else
        Qheat(i)=0;  % 其他情况都关了保持原状即可 
        Qcool(i)=0;  % 其他情况关了保持原状；
    end
    end
    %如上是控制策略，计算出控制变量
    
    % 如下是后台需要根据控制策略计算下一个时刻的温度变化状态
    if ShadeCurtain(i)==1
        Iax(i)=1/3*Ia(i);  %如果遮阳网打开，则光照为原来的1/3.
    end
    Qsolar(i)=As*Iax(i)*Toua*T_interval;   %太阳辐射吸收的能量；
    Qcon(i)=As*kg*(T_in_pred(i)-T_out(i))*T_interval;    % 室内外空气通过覆盖材料热传导引起的交换能量；
    Qplant(i)=Ag*pair*cair*LAI*(0.08*T_in_pred(i))*T_interval;   %作物与室内换热的能量；
    Qvent_Roof(i)=Av*Vx_wind(i)*RoofVent(i)*(T_in_pred(i)-T_out(i))*T_interval; %天窗通风交换的热量
    Qvent_Side(i)=Av*Vx_wind(i)*SideVent(i)*(T_in_pred(i)-T_out(i))*T_interval;  %侧窗通风交换的热量
    Qsoil(i)=Ag*0.05*T_in_pred(i)*T_interval;   %土壤与室内空气换热的能量；
    Qheatx(i)=min(100,Qheat(i))*1000*T_interval;  % 将Qheatx限制在0 到100之间   % 加热系统热量   w
    Qcoolx(i)=min(100,Qcool(i))*1000*T_interval;    %同上
    dQ(i)=[Qsolar(i)-Qcon(i)-Qplant(i)-Qsoil(i)+Qheatx(i)-Qcoolx(i), Qvent_Roof(i)+Qvent_Side(i)]*[0.0118; -0.5740];  % 计算出温室的能量输入
    dT_cal(i)= dQ(i)/(pair*Vair*cair)/T_interval; %温度变化，根据能量输出公式
    T_in_cal(i)=max(T_out(i)+2,T_in_cal(i-1)+dT_cal(i));  % 计算下一个时刻的温室温度，需要比室外温度一直高2度。
end

%如下是画图部分，显示室内外温度，

figure;  
plot(t,T_out,'b','LineWidth',2);
title('\bf室内外温度-fuzzy control');
hold on
plot(t,T_in_cal,'c','LineWidth',2)
grid on
legend('室外温度','室内温度');

