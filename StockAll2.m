classdef StockAll2<handle
        properties
        CodeList
        NameList
        KDataAll
        FlashData
        TempData
    end %  properties
    methods
        function obj=StockAll2 % ���캯��
            tic
            StockList=StockAll.StockList; % ���ش����б�
            toc
            SLCode=StockAll.CodeCheck(StockList(:,1))'; % �����׼��
            obj.CodeList=SLCode(strmatch('s',SLCode));    % ѡ����������sh,sz��ͷ�Ĺ�Ʊ����
        end

    end
    methods (Static)
        function List=StockList % ���ع�Ʊ�������ƶ��ձ�
            % e.g.: List=Stock.StockList
            %----------------------------------------------��ȡ�ӿ�����
            [sourcefile, status] =urlread(sprintf('http://quote.eastmoney.com/stocklist.html'),'Charset','GBK');
            if ~status
                error('��ȡ����\n')
            end
            %----------------------------------------------������������
            expr1='<li><a target="_blank" href="http://quote.eastmoney.com/.*?">(.*?)\((\d+)\)</a></li>';
            [~, date_tokens]= regexp(sourcefile, expr1, 'match', 'tokens');
            a=[date_tokens{:}];
            %----------------------------------------------�������
            List=[a(2:2:end);a(1:2:end)]';
        end % StockList
        function out=CodeCheck(in) % ��׼���������
            if ~iscell(in) % ת����Ϊcell�������� '600001'ת��Ϊ{'600001'}����
                in={in};
            end
            out=[];
                  for i=1:length(in) % ��cell�����е�ÿһ����Ա���б�������
                      C=in{i};
                      if ~ischar(C)
                          error('�������Ϊ�ַ���')
                      end
                      if  length(C)==6 && (strcmp(C(1),'6') || strcmp(C,'000001')) % ���д���
                          out{i}= ['sh',C];
                      elseif length(C)==6 && (strcmp(C(1),'0') || strcmp(C(1),'3')) && ~strcmp(C,'000001') % ���д���
                          out{i}= ['sz',C];
                      else % ���ఴԭ�����
                          out{i}=[C];
                      end
                  end
            
        end % CodeCheck        
        function info=DownloadKData(CodeList)% ��������K������
            CodeList=Stock.CodeCheck(CodeList); % ���������׼��
            L=length(CodeList);
            for i=1:L
                Code=CodeList{i};
                
            end
        end
    end
end