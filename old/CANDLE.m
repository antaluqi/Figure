classdef CANDLE<indicationBase
    % CANDLE指标类，继承于indicationBase类
    properties
    end
    methods 
        function obj=CANDLE(hMainFigure)% 构造函数
            if nargin ==0
                hMainFigure=[];
            end
            obj=obj@indicationBase(hMainFigure);
            obj.type='CANDLE';
            obj.axesName='CandleAxes';
            obj.propNo=2; % 参数个数2个（数据长度和显示长度）
            obj.DataNo=4; % 数据列数（应该有5列，继承的弊端，可以考虑做相应修改）
        end
        function plot(obj)% 画图

            delete(obj.hthis)
            if obj.show==1
                if isempty(obj.Data)
                    obj.hthis=[];
                %elseif size(obj.Data,2)==obj.DataNo+1
                elseif size(obj.Data,2)==obj.DataNo+2%--------------------------
                    %---------------------------
                    % Candle与其他Line图形共同绘制于一个图层时，更新Candle会发生错误
                    % 所以在Candle绘制的时候临时建立一个图层（位置与CandleAxes相同，并且一定要将两个图层的X轴相连）
                    hCandleAxes=findobj(obj.parent.hfig,'tag',obj.axesName);
                    haxesTemp=axes('parent',obj.parent.hfig,'position',hCandleAxes.Position);
                    linkaxes([hCandleAxes,haxesTemp],'x')
                    %---------------------------
                    axes(haxesTemp);
                    % obj.hthis=candle(obj.Data);
                    candle(obj.Data(:,2),obj.Data(:,3),obj.Data(:,4),obj.Data(:,5)); %---------------------------------
                    hcdl_vl = findobj(gca, 'Type', 'line');%---------------------------------
                    hcdl_bx = findobj(gca, 'Type', 'patch');%---------------------------------
                    obj.hthis=[hcdl_vl(:); hcdl_bx(:)];%---------------------------------
                    ch = get(gca,'children');%---------------------------------
                    set(ch(1),'FaceColor','g');%---------------------------------
                    set(ch(2),'FaceColor','r');%---------------------------------
                    % showTime=[today-obj.propertie(2),today];
                    showTime=[size(obj.Data,1)-obj.propertie(2),size(obj.Data,1)];%---------------------------------
                    haxesTemp.XLim=[showTime(1)-0.5,showTime(2)+0.5];
                    %---------------------------
                    % 将临时图层上绘制的Candle的Parent参数转移至CandleAxes图层并删除临时图层
                    [obj.hthis.Parent]=deal(hCandleAxes);
                    delete(haxesTemp)
                    %---------------------------
                else
                    error('CANDLE参数Data输入有误')
                end
            end
        end
        function calculation(obj)% 计算数据（重载）
            if ~isempty(obj.parent) && ~isempty(obj.parent.DataSource)
                S=obj.parent.DataSource;
               % obj.Data=Comm.table2fts(S.HistoryDaily(today-obj.propertie(1),today,'L'));
                %----------------------------------------------------------
                h=S.HistoryDaily(today-obj.propertie(1),today,'L');
                obj.Data=[datenum(h.Date),h.High,h.Low,h.Close,h.Open,h.Volume];
                %----------------------------------------------------------
            end
        end
        function str=getValueStr(obj,x)
            
           % [~,i]=min(abs(obj.Data.dates-round(x)));
           i=max(min(round(x),size(obj.Data,1)),1);%---------------------------
            if isempty(i)
                str=['日期： '];
                return
            end
            %d=fts2mat(obj.Data(i));
            d=obj.Data(i,:);
            %str=['日期:',datestr(obj.Data.dates(i),'yyyy-mm-dd'),'  开:',sprintf('%8.2f',d(1)),' 高:',sprintf('%8.2f',d(2)),'  低:',sprintf('%8.2f',d(4)),'  收:',sprintf('%8.2f',d(3)),10];
            str=['日期:',datestr(d(1),'yyyy-mm-dd'),'  开:',sprintf('%8.2f',d(5)),' 高:',sprintf('%8.2f',d(2)),'  低:',sprintf('%8.2f',d(3)),'  收:',sprintf('%8.2f',d(4)),10];
        end
        function delete(obj) %？？？？？
            if ~isempty(obj.parent)
               obj.parent=[];
            end
            delete(obj.hthis)
        end
    end
end