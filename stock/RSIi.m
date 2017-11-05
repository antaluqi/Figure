function out=RSIi(FieldData,Len)
L=size(FieldData,1);      % ���ݳ���
if isempty(FieldData)     % �������Ϊ�������Ϊ��
    out=[];
else
   out=[]; 
   for i=1:length(Len) % ÿһ��������ѭ��
        N=Len(i);
        if L<N                       % ������ݳ���С�ڲ���N�������ΪNaN
            out=[out,NaN(L,1)];
        else    
            % ���������������м���
            %-------------------------------------------------------------------------------

Close=FieldData;
CloseDiff=zeros(L,1);
CloseDiff(2:end)=Close(2:end)-Close(1:end-1);
Rise=max(CloseDiff,0);
All=abs(CloseDiff);
RSI=100*SMAi(Rise,Len)./SMAi(All,Len);
out=RSI;

     %-------------------------------------------------------------------------------       
            
        end
   end
end










