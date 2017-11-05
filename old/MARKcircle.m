classdef MARKcircle<indicationBase
    properties
    end
    methods
        function obj=MARKcircle(hMainFigure)
            if nargin ==0
                hMainFigure=[];
            end
            obj=obj@indicationBase(hMainFigure);
            obj.type='MARKcircle';
            obj.propNo=[3,5];
            obj.DataNo=5;
        end
        function plot(obj)
            delete(obj.hthis)
            if obj.show==1
                if isempty(obj.Data)
                    obj.hthis=[];
                elseif size(obj.Data,2)==obj.DataNo
                    %------------------------------
                    haxes=obj.Data{1};
                    x=obj.Data{2};
                    weigth=obj.Data{3};
                    y=obj.Data{4};
                    high=obj.Data{5};
                    obj.hthis=imrect(haxes,[x,weigth,y,high]);
                    obj.parent.notify('limChange');%---------------------------
                    setColor(obj.hthis,'r')
                    %------------------------------
                else
                    error([obj.type,'参数Data输入有误'])
                end
            end
        end
        function calculation(obj)
            if ~isempty(obj.parent) && ~isempty(obj.parent.indObjArr)
                %-------------------------------------------
                axesName=obj.propertie{1};
                startDay=datenum(obj.propertie{2});
                endDay=datenum(obj.propertie{3});
                haxes=findobj(obj.parent.hfig,'tag',axesName);
                if isempty(haxes)
                    error(['未找到名为',axesName,'的axes.'])
                end
                %-------------------------------------------
                ind=obj.parent.indObjArr;
                indCandle=ind(strcmp({ind.type},'CANDLE'));
                if length(obj.propertie)==5
                    yLow=obj.propertie{4};
                    yHigh=obj.propertie{5};
                    obj.Data={haxes,startDay,yLow,endDay-startDay,yHigh-yLow};
                    return
                end
                if ~isempty(indCandle)
                 %  Dates=indCandle.Data.dates;
                    Dates=indCandle.Data(:,1);%----------------------------
                    if ~ismember(startDay,Dates) || ~ismember(endDay,Dates)
                        obj.Data=[];
                        warning([datestr(startDay,'yyyy-mm-dd'),'或',datestr(endDay,'yyyy-mm-dd'),'不在Candle数据中'])
                        return
                    end
                    fullData=indCandle.Data;
                   % yLow=min(fts2mat(fullData.Low([datestr(startDay),'::',datestr(endDay)])));
                   % yHigh=max(fts2mat(fullData.High([datestr(startDay),'::',datestr(endDay)])));
                   
                   yLow=min(indCandle.Data((Dates>=startDay & Dates<=endDay),3));%-------------------------
                   yHigh=max(indCandle.Data((Dates>=startDay & Dates<=endDay),2));%-------------------------
                   iStart=find(Dates==startDay);%-------------------------
                   iEnd=find(Dates==endDay);%-------------------------
                   leaveDot=diff(haxes.YLim)*0.05;
                    %obj.Data={haxes,startDay-0.5,yLow-leaveDot,endDay-startDay+1,yHigh-yLow+2*leaveDot};
                    obj.Data={haxes,iStart-0.5,yLow-leaveDot,iEnd-iStart+1,yHigh-yLow+2*leaveDot};
                else
                    error('Candle数据为空，请输入完整的MARK点坐标')
                end
            else
            end
        end
        function reload(obj)
            %----------------------------
            try
                delete(obj.parent.customizeObjArr.hthis)
                obj.parent.customizeObjArr=[];
                obj.parent.hResultTable.hmark=[];
            end
            %----------------------------
        end
    end
    methods(Access = 'protected')
        function set_hthis(obj,value)
            if ~isempty(value)
                if ~isempty(obj.indArrClass)
                    arrayfun(@(x) set(x,'UserData',obj.indArrClass),value,'UniformOutput',0);
                else
                    arrayfun(@(x) set(x,'UserData',obj),value,'UniformOutput',0);
                end
            end
            
        end
        function set_parent(obj,value)
            if ~isempty(value)
                validateattributes(value, {'MainFigure'}, {'scalar'});
                obj.listenerList=[obj.listenerList,value.addlistener('DataSourceChange',@obj.update)];
                value.customizeObjArr=[value.customizeObjArr,obj];%=============================
            end
        end        
        function varaout=set_beSelected(obj,value)
            varaout=[];
        end
        function value=get_beSelected(obj)
            value=0;
        end
    end
end