function out=LBi(FieldData,Len)
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

Volume=FieldData;
for j=1:Len
    DataVolume(:,j)=Volume(5-j+1:L-j+1);
end
VolumeLen=NaN(L,1);
VolumeLen(6:end)=sum(DataVolume(1:end-1,:),2);
out=Len*Volume./VolumeLen;

     %-------------------------------------------------------------------------------       
            
        end
   end
end




