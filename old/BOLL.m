classdef BOLL<indicationBase
    % BOLLָ���࣬�̳���indicationBase��
    properties
    end
    methods 
        function obj=BOLL(hMainFigure)
            if nargin ==0
                hMainFigure=[];
            end
            obj=obj@indicationBase(hMainFigure);
            obj.type='BOLL';
            obj.axesName='CandleAxes';
            obj.propNo=2;     % ָ�����1��
            obj.DataNo=3;     % ��������1��
            obj.pField={'BOllMid','BOllUp','BOllDown'};% �����б�ͷ��ǰ׺
        end
        function plot(obj)
            delete(obj.hthis)
            if obj.show==1
                if isempty(obj.Data)
                    obj.hthis=[];
                elseif size(obj.Data,2)==obj.DataNo+1
                    haxes=findobj(obj.parent.hfig,'tag',obj.axesName);
                   % obj.hthis=plot(obj.Data(:,1),obj.Data(:,2:end),'parent',haxes);
                     obj.hthis=plot(obj.Data(:,2:end),'parent',haxes);
                else
                    error('BOLL����Data��������')
                end
            end
        end
        function str=getValueStr(obj,x)
           % [~,i]=min(abs(obj.Data(:,1)-round(x)));
           i=max(min(round(x),size(obj.Data,1)),1);%---------------------------
            if isempty(i)
                str=['BOLL(',pStr,'):'];
                return
            end
            pStr=strjoin(arrayfun(@(x) num2str(x),obj.propertie,'UniformOutput',0),','); % �����ַ�������[15,2]��Ϊ'15_2'
            str=['BOLL[',pStr,'] ( Up:',sprintf('%8.2f',obj.Data(i,2)),',  Mid:',sprintf('%8.2f',obj.Data(i,3)),',  Down:',sprintf('%8.2f',obj.Data(i,4)),')   '];
        end
    end
end