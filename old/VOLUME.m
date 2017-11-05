classdef VOLUME<indicationBase
    properties
        
    end
    methods
        function obj=VOLUME(hMainFigure)
            if nargin ==0
                hMainFigure=[];
            end
            obj=obj@indicationBase(hMainFigure);
            obj.type='VOLUME';
            obj.axesName='IndicatorsAxes1';
            obj.propNo=1;     % ָ�����1��
            obj.DataNo=2;     % ��������1��
            obj.pField={'Volume'};% �����б�ͷ��ǰ׺
        end
        function calculation(obj) % ��������
            if ~isempty(obj.parent) && ~isempty(obj.parent.DataSource)
                if ~isempty(obj.parent) && isa(obj.parent,'MainFigure') && ~isempty(obj.parent.indObjArr)
                    candleObj=findobj(obj.parent.indObjArr,'type','CANDLE');
                else
                    candleObj=[];
                end
                if ~isempty(candleObj) && ~isempty(candleObj.Data)
                   % iUp=fts2mat(candleObj.Data.Open)<=fts2mat(candleObj.Data.Close);
                    iUp=candleObj.Data(:,5)<=candleObj.Data(:,4);%---------------------------------
                    iDown=~iUp;
                   % VolumeData=[candleObj.Data.dates,fts2mat(candleObj.Data.Volume)];
                    VolumeData=candleObj.Data(:,[1,6]);
                else
                    tableData=S.HistoryDaily(today-720,today); % ����
                    iUp=fts2mat(tableData.Open)<=fts2mat(tableData.Close);
                    iDown=~iUp;                   
                    VolumeData=[datenum(tableData.Date),tableData.Volume];% ȡ����Ӧ�ֶ�����
                end

                obj.Data=[VolumeData(:,1),VolumeData(:,2).*iUp,VolumeData(:,2).*iDown];
            else
                error('MainFigureû������Դ')
            end
        end
        function plot(obj)
            delete(obj.hthis)
            if obj.show==1
                if isempty(obj.Data)
                    obj.hthis=[];
                elseif size(obj.Data,2)==obj.DataNo+1
                    haxes=findobj(obj.parent.hfig,'tag',obj.axesName);
                   % up=bar(obj.Data(:,1),obj.Data(:,2),'parent',haxes,'facecolor','r');
                   % down=bar(obj.Data(:,1),obj.Data(:,3),'parent',haxes,'facecolor','g');
                    up=bar(obj.Data(:,2),'parent',haxes,'facecolor','r');
                    down=bar(obj.Data(:,3),'parent',haxes,'facecolor','g');                  
                    obj.hthis=[up,down];
                else
                    error('BOLL����Data��������')
                end
            end
        end
        function reload(obj)
            reLoadData=obj.parent.Data;
            if ~isempty(reLoadData)
                iUp=fts2mat(reLoadData.Open)<=fts2mat(reLoadData.Close);
                iDown=~iUp;
                VolumeData=fts2mat(extfield(reLoadData,strcat(obj.pField))); % ȡ������BOll15_2��MA10���ֶ����ݣ����������ݶκϲ�
                obj.Data=[reLoadData.dates,VolumeData.*iUp,VolumeData.*iDown];
            else
                obj.calculation;
            end

        end
        function str=getValueStr(obj,x)
           % [~,i]=min(abs(obj.Data(:,1)-round(x)));
           i=max(min(round(x),size(obj.Data,1)),1);%---------------------------
            if isempty(i)
                str='Volume:';
                return
            end
           % str=['Volume: ',sprintf('%8.0f',obj.Data(i,2)+obj.Data(i,3)),'   '];
           str=['Volume: ',sprintf('%8.0f',obj.Data(i,2)+obj.Data(i,3)),'   ']; 
        end
    end
end