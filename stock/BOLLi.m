function out=BOLLi(FieldData,Len,Width)
L=size(FieldData,1);      % ���ݳ���
if isempty(FieldData)     % �������Ϊ�������Ϊ��
    out=[];
else
    out=[];
    ma=MAi(FieldData,Len);
    std=STDi(FieldData,Len);
    bollup=ma+Width*std;
    bolldown=ma-Width*std; 
    out=[out,ma,bollup,bolldown];
end