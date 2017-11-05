classdef MA<indicationBase
    % MA指标类，继承于indicationBase类
    properties
    end
    methods 
        function obj=MA(hMainFigure)
            if nargin ==0
                hMainFigure=[];
            end
            obj=obj@indicationBase(hMainFigure);
            obj.type='MA';
            obj.axesName='CandleAxes';
            obj.propNo=1;     % 指标个数1个
            obj.DataNo=1;     % 数据列数1列
            obj.pField={'MA'};% 数据列表头名前缀
            
        end
        function plot(obj)
            delete(obj.hthis)
            if obj.show==1
                if isempty(obj.Data)
                    obj.hthis=[];
                elseif size(obj.Data,2)==obj.DataNo+1
                    haxes=findobj(obj.parent.hfig,'tag',obj.axesName);
                   % obj.hthis=plot(obj.Data(:,1),obj.Data(:,2),'parent',haxes);
                     obj.hthis=plot(obj.Data(:,2),'parent',haxes);
                else
                    error('MA参数Data输入有误')
                end
            end
        end
        function str=getValueStr(obj,x)
           % [~,i]=min(abs(obj.Data(:,1)-round(x)));
           i=max(min(round(x),size(obj.Data,1)),1);%---------------------------
            if isempty(i)
                str=['MA(',pStr,'):'];
                return
            end
            pStr=strjoin(arrayfun(@(x) num2str(x),obj.propertie,'UniformOutput',0),'_'); % 参数字符化，如[15,2]变为'15_2'
            str=['MA[',pStr,']:',sprintf('%8.2f',obj.Data(i,2)),32];
        end
    end
    methods(Access = 'protected')
    end
end