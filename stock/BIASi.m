function out=BIASi(FieldData,LeadLen,LagLen)
L=size(FieldData,1);      % 数据长度
if isempty(FieldData)     % 如果数据为空则输出为空
    out=[];
else
    out=[];
    LeadMA=MAi(FieldData,LeadLen);
    LagMA=MAi(FieldData,LagLen);
    bias=100*(LeadMA-LagMA)./LagMA;
    % out=num2cell([out,bias]);
    out=[out,bias];
end