classdef MainFigure < handle

    properties
        hfig % ��ǰFigure������
        axesList % �����б�
        hCrossLine %ʮ���߶���
        hCandle % K��ͼ���
        hResultTable % �����
        Data; % ����
        DataSource % ����Դ
        indObjArr % ָ���������
        CrossLineSwitch % ʮ�ֹ�꿪�أ�0 or 1��
    end
    events
        CrossLineEvant % ʮ�ֹ�꿪���¼�
        MainFigureDataUpdateEvant % �����桰Data�����Ա仯�¼�
    end
    methods
        function obj=MainFigure
            obj.Initialization % �����ʼ��
            obj.loadData;
            obj.CrossLineSwitch=0;
            obj.indObjArr=[];
            set(obj.hfig,'WindowKeyPressFcn',{@obj.WindowKeyPressFcn});
        end
        function plot(obj,n)
           haxes=findobj(obj.hfig,'tag','CandleAxes');
           axes(haxes);
           if ishandle(obj.hCandle)
              delete(obj.hCandle);
           end
           
           if ~isempty(obj.hResultTable) &&  ~isempty(obj.hResultTable.hmark)
              delete(obj.hResultTable.hmark);
              obj.hResultTable.hmark=[];
           end       
           
          if isa(n,'double') & all(size(n)==1) & ~isempty(obj.data)
             obj.hCandle=candle(obj.data(1:n));
          elseif isa(n,'fints')
             obj.hCandle=candle(n);
          end
        end
        function set.hfig(obj,value)
            validateattributes(value, {'matlab.ui.Figure'}, {'scalar'});
            obj.hfig=value;
        end
        function set.Data(obj,value)
            validateattributes(value, {'info001'}, {'scalar'});
            value.addlistener('DataUpdataEvent',@obj.update);
            obj.Data=value;
            value.parent=obj;
            obj.update;
            obj.notify('MainFigureDataUpdateEvant');
        end
        function set.DataSource(obj,value)
            if ~isempty(value)
                validateattributes(value, {'Stock'}, {'scalar'});
            end
            obj.DataSource=value;
            infoData=info001;
            infoData.fullData=value.HistoryDaily(today-720,today,'L');
            infoData.showTime=[infoData.fullData.dates(end-50),infoData.fullData.dates(end)];
            obj.Data=infoData;
        end
        function set.CrossLineSwitch(obj,value)
           if value==1 || value==0
               msg=msgClass(value);
               obj.notify('CrossLineEvant',msg);
               obj.CrossLineSwitch=value;
           end
        end
        function update(obj,scr,data)
            obj.CandleAxesUpdata;
        end
        function loadData(obj)
            %--------------------------------------------------- ԭʼ����
%             load('sh600118.mat','sh600118');
%             a=info001;
%              
%             a.fullData=sh600118;
%             a.showTime=[a.fullData.dates(1),a.fullData.dates(50)];
%             % a.filterTime=[a.fullData.dates(1:50)];   
%             a.filterTime=[a.fullData.dates(1:50),a.fullData.dates(3:52)];
%             obj.Data=a; 
              obj.DataSource=Stock('zgwx');
        end
    end
    methods (Access = 'private')
        function Initialization(obj)  % �����ʼ������
            %-------------------------------------------------��������
            ScreenSize=get(0,'ScreenSize'); % ȡ����Ļ�ߴ�(����)
            FigureSize=[ScreenSize(3)/5,ScreenSize(4)/4,ScreenSize(3)/1.5,ScreenSize(4)/1.5];%������Ļ��С��������С
            obj.hfig=figure('Position',FigureSize); % �����հ�Figure���棬�˵�ȫ������
            % CandleAxes��������ʼ��������λ���趨��ΧΪ[0,1]֮�䣬���½�Ϊ����
            CandleAxes=axes('Tag','CandleAxes','pos',[0.04,0.4,0.92,0.55],'parent',obj.hfig,'nextplot','add','xtick',[],'FontSize',7);
            % IndicatorsAxes��������ʼָ�껭����
            IndicatorsAxes=axes('Tag','IndicatorsAxes','pos',[0.04,0.2,0.92,0.2],'parent',obj.hfig,'nextplot','add','FontSize',7);
            obj.axesList=[CandleAxes,IndicatorsAxes];
            % ������������x������
            linkaxes([CandleAxes,IndicatorsAxes],'x')
            % ResultTable����б�
            obj.hResultTable=resultTable(obj);
        
            %--------------------------------------------------- ���ֶ���
            crossLineObj=crossLine(obj.hfig);
            obj.hCrossLine=crossLineObj;
            obj.addlistener('CrossLineEvant',@crossLineObj.switchListener);
        end
        function WindowKeyPressFcn(obj,hObject,event)
           switch get(obj.hfig,'CurrentKey')
               case 'uparrow'
                   XLim=obj.axesList(1).XLim;
                   if XLim(1)+1<XLim(2)-1
                      obj.axesList(1).XLim=[XLim(1)+1,XLim(2)-1];
                   end
               case 'downarrow'
                   XLim=obj.axesList(1).XLim;
                   obj.axesList(1).XLim=[XLim(1)-1,XLim(2)+1];                  
               case 'leftarrow'
                    XLim=obj.axesList(1).XLim;
                   obj.axesList(1).XLim=[XLim(1)-1,XLim(2)-1];                     
               case 'rightarrow'
                   XLim=obj.axesList(1).XLim;
                   obj.axesList(1).XLim=[XLim(1)+1,XLim(2)+1];  
               case 'delete'
                   isSelected=logical([obj.indObjArr.beSelected]);
                   delete(obj.indObjArr(isSelected));
                   obj.indObjArr(isSelected)=[];
           end
        end
        function CandleAxesUpdata(obj)
            value=obj.Data;
            if ~isempty(value)
                if isempty(value.fullData)
                    delete(obj.hCandle);
                    obj.hCandle=[];
                elseif ~isempty(value.fullData) && isempty(value.showTime)
                    obj.plot(value.fullData);
                elseif ~isempty(value.fullData) && ~isempty(value.showTime)
                    obj.plot(value.fullData);
                    obj.axesList(1).XLim=[value.showTime(1)-0.5,value.showTime(2)+0.5];
                end
            else
                delete(obj.hCandle);
                obj.hCandle=[];
            end
        end
    end
end

