function out=KDJi(KData,Len,M1,M2);
L=size(KData,1);
% Close=cell2mat(KData(:,3));
% High=cell2mat(KData(:,4));
% Low=cell2mat(KData(:,5));
Close=KData(:,3);
High=KData(:,4);
Low=KData(:,5);

HH=HHighi(High,Len);
LL=LLowi(Low,Len);


RSV=100*(Close-LL)./(HH-LL);
K=SMAi(RSV,M1);
D=SMAi(K,M2);
J=3*K-2*D;
out=[K,D,J];