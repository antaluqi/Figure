classdef indProp<handle
    properties
        indName
        propName
        propValue
        hfig
        indObj
        parent
        hPropTitle
        hEdit
        hBottomOK
        hBottomCancle
    end
    events
    end
    methods
        function obj=indProp(hMainFigure,indName,propName)
            obj.parent=hMainFigure;
            indNameList=Comm.indFileName;
            if ischar(indName) && ismember(indName,indNameList)
                obj.indName=indName;
            else
                error('indName输入错误或没有相关指标')
            end
            if isempty(propName)
                obj.propName=[];
            elseif ~isempty(propName) && all(cellfun(@(x) ischar(x),propName))
                obj.propName=propName;
            else
                error('propName输入错误')
            end
            obj.Initialization     % 界面初始化
            set(obj.hBottomOK,'Callback',{@obj.OKButtonDownFcn})
            set(obj.hBottomCancle,'Callback',{@obj.CancleButtonDownFcn})
            set(obj.hfig,'WindowKeyPressFcn',{@obj.WindowKeyPressFcn})
        end
        function set.propValue(obj,value)
             obj.propValue=value;
            if ~isempty(value) && length(value)==length(obj.propName) && all(~isnan(value))
                set(obj.hPropTitle,'ForegroundColor','black');  
                if isempty(obj.indObj)
                    obj.indObj=eval([obj.indName,'(obj.parent,[',strjoin(arrayfun(@(x) num2str(x),obj.propValue,'UniformOutput',0),','),'])']);
                else
                    obj.indObj.propertie=obj.propValue;
                end
                disp(['运行',obj.indName])
                delete(obj)
            else
                set(obj.hPropTitle(~isnan(value)),'ForegroundColor','black');
                set(obj.hPropTitle(isnan(value)),'ForegroundColor','r');
            end
            
        end
        function delete(obj)
            delete(obj.hfig)
            disp('indProp被删除')
        end
    end
    methods (Access = 'private')
        function Initialization(obj)
            if ~isempty(obj.propName)
                MFPos=obj.parent.hfig.Position; % 主画面位置
                wight=MFPos(3)*0.4;
                high=MFPos(4)*0.4;
                X=MFPos(1)+MFPos(3)*0.3;
                Y=MFPos(2)+MFPos(4)*0.3;
                FigureSize=[X,Y,wight,high];
                obj.hfig=figure('Position',FigureSize,'MenuBar','none','ToolBar','none'); % 建立空白Figure界面
                Title= uicontrol('Style','text','parent',obj.hfig,'Units','normal','position',[0.3,0.85,0.4,0.1],'string',['请输入',obj.indName,'指标参数'],'fontsize',12,'FontWeight','bold');% 标题
                obj.hBottomOK=uicontrol('Style','pushbutton','parent',obj.hfig,'Units','normal','position',[0.2,0.15,0.2,0.1],'String','确定');
                obj.hBottomCancle=uicontrol('Style','pushbutton','parent',obj.hfig,'Units','normal','position',[0.6,0.15,0.2,0.1],'String','取消');
                
                startY=Title.Position(2);
                dotY=(Title.Position(2)-obj.hBottomOK.Position(2)-obj.hBottomOK.Position(4))/(length(obj.propName)*2+1);
                for i=1:length(obj.propName)
                    Y=startY-dotY*(i*2);
                    obj.hPropTitle(i)=uicontrol('Style','text','parent',obj.hfig,'Units','normal','position',[0.1,Y,0.2,min(dotY,0.1)],'string',[obj.propName{i},':'],'fontsize',12,'FontWeight','bold');
                    obj.hEdit(i)=uicontrol('Style','edit','parent',obj.hfig,'Units','normal','position',[0.4,Y,0.4,min(dotY,0.1)]);
                end
            end
        end
        function OKButtonDownFcn(obj,hObject,event)
            obj.propValue=cellfun(@(x) str2double(x),cellstr(get(obj.hEdit,'String')));
        end
        function CancleButtonDownFcn(obj,hObject,event)
            delete(obj)
        end
        function WindowKeyPressFcn(obj,hObject,event)
            switch get(obj.hfig,'CurrentKey')
                case 'return'
                    uicontrol(obj.hBottomOK)
                    obj.OKButtonDownFcn
            end
        end
    end
end