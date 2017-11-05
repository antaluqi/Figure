classdef MA<indicationBase
    % MAָ���࣬�̳���indicationBase��
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
            obj.propNo=1;     % ָ�����1��
            obj.DataNo=1;     % ��������1��
            obj.pField={'MA'};% �����б�ͷ��ǰ׺
            
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
                    error('MA����Data��������')
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
            pStr=strjoin(arrayfun(@(x) num2str(x),obj.propertie,'UniformOutput',0),'_'); % �����ַ�������[15,2]��Ϊ'15_2'
            str=['MA[',pStr,']:',sprintf('%8.2f',obj.Data(i,2)),32];
        end
    end
    methods(Access = 'protected')
    end
end