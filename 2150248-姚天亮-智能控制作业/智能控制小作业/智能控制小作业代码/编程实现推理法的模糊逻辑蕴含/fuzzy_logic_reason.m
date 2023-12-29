%输入两个矩阵
A=[1 0.5 0 0 0];B=[0 0 0 0.5 1];
%Zadeh法
C1=A'*B;   %C1=A*B
C2=ones(size(A));
C3=C2-A;   %A取反
C4=C3'*C2;  %C3=A反*E
R1=max(C1,C4);
disp('Zadeh法:')
disp(R1)
%Mamdani法
D1=A'*ones(size(B));
D2=ones(size(A'))*B;
R2=min(D1,D2);
disp('Mamdani法:')
disp(R2)
