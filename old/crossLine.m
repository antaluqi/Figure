classdef crossLine<handle
    properties
       parent MainFigure
       Data   double
       hthis
       textInfo myText
    end
    properties (Access = private)
        callbackObj
        left
        right
        top
        bottom
        fz
    end
    properties(Dependent)
        x double
        y double
    end
    
    methods
        function obj=crossLine(MainFigureObj)
            obj.parent=MainFigureObj;
            obj.callbackObj=obj.parent.callbackObj;
        end
        function set.Data(obj,value)
            if length(value)~=2
               error('crossLine坐标数据输入有误')
            end
            obj.Data=value;
            obj.plot;
        end
        function plot(obj)
            [obj.fz,obj.bottom,obj.top,obj.left,obj.right]=obj.callbackObj.geiFigureSize;
            if isempty(obj.Data) || ~(obj.x>obj.left && obj.x<obj.right && obj.y>obj.bottom && obj.y<obj.top)
                delete(obj.hthis)
                htext=[obj.textInfo.hthis];
                [htext.Visible]=deal('off');% 有可能不对
                return
            end
            if  isempty(obj.hthis) || all(~ishandle(obj.hthis))
                l=annotation(obj.parent.hfig,'line',[obj.left,obj.right],[obj.y,obj.y],'tag','crossLine_level');    %水平线
                v=annotation(obj.parent.hfig,'line',[obj.x,obj.x],[obj.bottom,obj.top],'tag','crossLine_vertical'); %垂直线
                obj.hthis=[l,v];
            end
            if  isempty(obj.textInfo)
               obj.textInfo=[myText(obj.parent),myText(obj.parent)];
            end
            l=obj.hthis(1);
            v=obj.hthis(2);
            l.X=[obj.left,obj.right];
            l.Y=[obj.y,obj.y];
            v.X=[obj.x,obj.x];
            v.Y=[obj.bottom,obj.top];
            
            htext=[obj.textInfo.hthis];
            [htext.Visible]=deal('on');
            obj.textInfo(1).str='lValue';
            obj.textInfo(2).str='vDate';
            obj.textInfo(1).position=[obj.right,obj.y];
            obj.textInfo(2).position=[obj.x,obj.top];
        end
        function value=get.x(obj)
            value=max(min(obj.Data(1)/obj.fz(3),obj.right),obj.left);
        end
        function value=get.y(obj)
            value=max(min(obj.Data(2)/obj.fz(4),obj.top),obj.bottom);
        end
    end
    methods (Access = 'private')
    end
end


