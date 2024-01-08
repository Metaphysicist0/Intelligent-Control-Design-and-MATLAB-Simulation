function [Y] = fuzzy_matrix_synthetic(X1,X2)
%功能：模糊关系的合成运算
%
[m1,n1]=size(X1);
[m2,n2]=size(X2);

if(n1~=m2)        %检查矩阵时候输入错误
    error="输入的矩阵错误，请检查时候能进行合成运算"
    return
end

temp=rand(1,n1);
Y=rand(m1,n2);
for i=1:m1
    for j=1:n2
        for k=1:n1
            temp(k)=min(X1(i,k),X2(k,j));
            Y(i,j)=max(temp);
        end
    end
end
            
        
end


