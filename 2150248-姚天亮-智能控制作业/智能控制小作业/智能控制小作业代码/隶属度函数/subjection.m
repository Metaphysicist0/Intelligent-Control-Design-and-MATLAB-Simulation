x=-10:0.01:10;
figure;

sigma1=3;sigma2=4;c11=2;c12=1;
y11=gaussmf(x,[sigma1,c11]);
y12=gaussmf(x,[sigma2,c11]);
y13=gaussmf(x,[sigma2,c12]);
subplot(2,3,1);
plot(x,y11,'-',x,y12,'--',x,y13,'--');
grid;
legend('sigma=3,c=2','sigma=4,c=2','sigma=4,c=1');
axis([-10 10 0 1.1]);

a21=5;a22=2;b21=2;b22=4;c21=0;c22=1;
y21=gbellmf(x,[a21,b21,c21]);
y22=gbellmf(x,[a21,b21,c22]);
y23=gbellmf(x,[a22,b21,c22]);
y24=gbellmf(x,[a21,b22,c21]);
subplot(2,3,2);
plot(x,y21,'-',x,y22,'-',x,y23,'-',x,y24,'-');
grid;
legend('a=5,b=2,c=0','a=5,b=2,c=1','a=3,b=2,c=0','a=5,b=4,c=0');
axis([-10 10 0 1.1]);

a31=2;a32=-2;a33=-1;c3=0;
y31=sigmf(x,[a31,c3]);
y32=sigmf(x,[a32,c3]);
y33=sigmf(x,[a33,c3]);
subplot(2,3,3);
plot(x,y31,'-',x,y32,'--',x,y33,'--');
grid;
legend('a1=2','a2=-2','a3=-1');
axis([-10 10 0 1.1]);

a4=-8;a41=-6;b4=-4;b41=-6;c4=4;c41=6;d4=8;d41=6;
y4=trapmf(x,[a4,b4,c4,d4]);
y41=trapmf(x,[a41,b4,c4,d4]);
y42=trapmf(x,[a4,b41,c4,d4]);
y43=trapmf(x,[a4,b4,c41,d4]);
y44=trapmf(x,[a4,b4,c4,d41]);
subplot(2,3,4);
plot(x,y4,'-',x,y41,'-',x,y42,'-',x,y43,'-',x,y44,'-');
grid;
legend('a=-8,b=-4,c=4,d=8','a=-6,b=-4,c=4,d=8','a=-8,b=-6,c=4,d=8','a=-8,b=-4,c=6,d=8','a=-8,b=-4,c=4,d=6');
axis([-10 10 0 1.1]);

a5=-4;a51=-2;b5=2;b51=4;c5=7;c51=5;
y5=trimf(x,[a5,b5,c5]);
y51=trimf(x,[a51,b5,c5]);
y52=trimf(x,[a5,b51,c5]);
y53=trimf(x,[a5,b5,c51]);
subplot(2,3,5);
plot(x,y5,'-',x,y51,'-',x,y52,'-',x,y53,'-');
grid;
legend('a=-4,b=2,c=7','a=-2,b=2,c=7','a=-4,b=4,c=7','a=-4,b=2,c=5');
axis([-10 10 0 1.1]);

a6=-4;a61=-2;b6=7;b61=5;
y6=zmf(x,[a6,b6]);
y61=zmf(x,[a61,b6]);
y62=zmf(x,[a6,b61]);
subplot(2,3,6);
plot(x,y6,'-',x,y61,'-',x,y62,'-');
grid;
legend('a=-4,b=7','a=-2,b=7','a=-4,b=5');
axis([-10 10 0 1.1]);