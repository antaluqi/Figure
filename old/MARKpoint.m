classdef MARKpoint<indicationBase
    
    properties
    end
    methods
        function obj=MARKpoint(hMainFigure)
            if nargin ==0
                hMainFigure=[];
            end
            obj=obj@indicationBase(hMainFigure);
            obj.type='MARKpoint';
            obj.propNo=[2,3];
            obj.DataNo=3;
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
                    y=obj.Data{3};
                    obj.hthis=impoint(haxes,[x,y]);
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
                x=datenum(obj.propertie{2});
                haxes=findobj(obj.parent.hfig,'tag',axesName);
                if isempty(haxes)
                   error(['未找到名为',axesName,'的axes.'])
                end
                %-------------------------------------------
                ind=obj.parent.indObjArr;
                indCandle=ind(strcmp({ind.type},'CANDLE'));
                if length(obj.propertie)==3
                    y=obj.propertie{3};
                    obj.Data={haxes,x,y};
                    return
                end
                if ~isempty(indCandle) 
                 %  Dates=indCandle.Data.dates;
                    Dates=indCandle.Data(:,1);%----------------------------
                   if ~ismember(x,Dates)
                       obj.Data=[];
                       warning([datestr(x,'yyyy-mm-dd'),'不在Candle数据中'])
                       return
                   end
                 %  y=fts2mat(indCandle.Data.Low(datestr(x)));
                   y=indCandle.Data(Dates==x,3);%-------------------------
                   leaveDot=diff(haxes.YLim)*0.05;
                   y=y-leaveDot;
                   obj.Data={haxes,find(Dates==x),y};
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