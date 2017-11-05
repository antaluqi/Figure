classdef StockAll2<handle
        properties
        CodeList
        NameList
        KDataAll
        FlashData
        TempData
    end %  properties
    methods
        function obj=StockAll2 % 构造函数
            tic
            StockList=StockAll.StockList; % 下载代码列表
            toc
            SLCode=StockAll.CodeCheck(StockList(:,1))'; % 代码标准化
            obj.CodeList=SLCode(strmatch('s',SLCode));    % 选出沪深两市sh,sz开头的股票代码
        end

    end
    methods (Static)
        function List=StockList % 下载股票代码名称对照表
            % e.g.: List=Stock.StockList
            %----------------------------------------------读取接口数据
            [sourcefile, status] =urlread(sprintf('http://quote.eastmoney.com/stocklist.html'),'Charset','GBK');
            if ~status
                error('读取错误\n')
            end
            %----------------------------------------------分析重组数据
            expr1='<li><a target="_blank" href="http://quote.eastmoney.com/.*?">(.*?)\((\d+)\)</a></li>';
            [~, date_tokens]= regexp(sourcefile, expr1, 'match', 'tokens');
            a=[date_tokens{:}];
            %----------------------------------------------数据输出
            List=[a(2:2:end);a(1:2:end)]';
        end % StockList
        function out=CodeCheck(in) % 标准化输入代码
            if ~iscell(in) % 转换成为cell数组输入 '600001'转变为{'600001'}输入
                in={in};
            end
            out=[];
                  for i=1:length(in) % 对cell数组中的每一个成员进行遍历操作
                      C=in{i};
                      if ~ischar(C)
                          error('输入必须为字符串')
                      end
                      if  length(C)==6 && (strcmp(C(1),'6') || strcmp(C,'000001')) % 沪市代码
                          out{i}= ['sh',C];
                      elseif length(C)==6 && (strcmp(C(1),'0') || strcmp(C(1),'3')) && ~strcmp(C,'000001') % 深市代码
                          out{i}= ['sz',C];
                      else % 其余按原样输出
                          out{i}=[C];
                      end
                  end
            
        end % CodeCheck        
        function info=DownloadKData(CodeList)% 批量下载K线数据
            CodeList=Stock.CodeCheck(CodeList); % 代码输入标准化
            L=length(CodeList);
            for i=1:L
                Code=CodeList{i};
                
            end
        end
    end
end