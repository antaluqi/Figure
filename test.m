df=py.tushare.get_k_data('600926','2017-01-01','2017-11-13');
dlist=df.values.transpose.tolist;
c=cellfun(@cell,cell(dlist),'UniformOutput',0);
Val=[cellfun(@char,cell(c{1}),'UniformOutput',0)',cell(c{2})',cell(c{3})',cell(c{4})',cell(c{5})',cell(c{6})'];
Name={'Date','Open','High','Close','Low','Volume'};
cell2table([Val(:,1),Val(:,2:6)],'VariableNames',Name)
