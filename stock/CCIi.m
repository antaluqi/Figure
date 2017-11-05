function out=CCIi(KData,Len)
L=size(KData,1);      % ���ݳ���
% Close=cell2mat(KData(:,3));
% High=cell2mat(KData(:,4));
% Low=cell2mat(KData(:,5));

Close=KData(:,3);
High=KData(:,4);
Low=KData(:,5);

%----------------------------
if isempty(KData)     % �������Ϊ�������Ϊ��
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
            TYP=(High+Low+Close)/3;
            MATYP=MAi(TYP,Len);
            DataTYP=[];
            for j=0:Len-1
                DataTYP(:,j+1)=TYP(Len-j:L-j);
            end
            MD=NaN(L,1);
            MD(Len:end)=mad(DataTYP')';
            CCI=(TYP-MATYP)./(0.015*MD);
            out=CCI;
     %-------------------------------------------------------------------------------       
            
        end
   end
end

%----------------------------








