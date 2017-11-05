classdef CallBack<handle

    properties
        parent MainFigure
        mousePos double
        moveNameList cell
        keypressNameList cell
        buttondownNameList cell
        pixelPos
    end
    properties(Dependent)
        haxes             % 当前鼠标所在画布句柄
        coordinate double % 鼠标在当前画布上的坐标    
        normPos double    % 鼠标在figure上的归一化坐标
    end
    properties (Access = private)
        crossLineObj crossLine
        indTextObj myText     

        left
        right
        top
        bottom
        fz
    end
    events
        limChange
    end
    methods
        function obj=CallBack(MainFigureObj)
            obj.parent=MainFigureObj;
        end
        function add(obj,type,name) %#ok<INUSL>
            NameList=eval(['obj.',type,'NameList;']);
            if any(ismember(name,NameList))
                namei=ismember(name,NameList);
                warning([type,'NameList已经包含了',name{namei}])
                if isempty(name(~namei))
                    return
                else
                    name=name(~namei);
                end
            end
            eval(['obj.',type,'NameList=[obj.',type,'NameList,name];'])
        end
        function remove(obj,type,name)
            name=cellstr(name);
            switch type
                case 'move'
                    if ~ismember(name,obj.moveNameList)
                        warning(['moveNameList没有包含',name{1}])
                        return
                    end
                    List=obj.moveNameList;
                    obj.moveNameList=List(~ismember(List,name));
                    %------------------------------可能要修改
                    for i=1:length(name)
                        eval(['delete([obj.',name{i},'Obj.hthis]);'])
                    end
                    %------------------------------
                otherwise
                   warning(['没有',type,'类型的CallBack定义'])
            end           
        end
        function replace(obj,type,name) %#ok<INUSD,INUSL>
            eval(['obj.',type,'NameList=cellstr(name);'])
        end
        function WindowButtonMotionFcn(obj)
            if ~isempty(obj.parent) && ~isempty(obj.moveNameList)
                obj.mousePos=get(obj.parent.hfig,'currentpoint');
                obj.setFigureSize;
                %--------------------------------------------------
                axesList=findobj(obj.parent.hfig,'type','axes');
                axesPos=cell2mat({axesList.Position}');
                PosX=[axesPos(1,1),axesPos(1,1)+axesPos(1,3)];
                xlim=cell2mat({axesList(1).XLim}');
                x=max(min(obj.mousePos(1)/obj.fz(3),obj.right),obj.left);
                obj.pixelPos=(xlim(1)-xlim(2)).*(x-PosX(1))./(PosX(1)-PosX(2))+xlim(1);
                %--------------------------------------------------
                cellfun(@eval,strcat('obj.',obj.moveNameList));
            end
        end
        function WindowButtonDownFcn(obj)
            if ~isempty(obj.parent) && ~isempty(obj.buttondownNameList)
                cellfun(@eval,strcat('obj.',obj.buttondownNameList));
            end
        end
        function WindowKeyPressFcn(obj)
            if ~isempty(obj.parent) && ~isempty(obj.keypressNameList)
                cellfun(@eval,strcat('obj.',obj.keypressNameList));
            end
        end
        function [fz,bottom,top,left,right]=geiFigureSize(obj)
            fz=obj.fz;
            bottom=obj.bottom;
            top=obj.top;
            right=obj.right;
            left=obj.left;
        end
        %------------------------------------ get
        function value=get.coordinate(obj) 
           if isempty(obj.parent)
               value=[];
               return
           end
           value=obj.parent.pixel2coord(obj.mousePos);
        end
        function value=get.haxes(obj)
           if isempty(obj.parent)
               value=[];
               return
           end
           value=obj.parent.pixel2axes(obj.mousePos);
        end 
        function value=get.normPos(obj)
           if isempty(obj.parent)
               value=[];
               return
           end
           value=obj.parent.pixel2norm(obj.mousePos);
        end
        
    end
    methods (Access = 'private')
        function setFigureSize(obj)
              obj.fz=get(obj.parent.hfig,'pos');
              hAxes=findobj(obj.parent.hfig,'type','axes');
              posAxes=[hAxes.Position];
              obj.left=max(posAxes(1:4:end));
              obj.right=min(posAxes(1:4:end)+posAxes(3:4:end));
              obj.bottom=min(posAxes(2:4:end));
              obj.top=max(posAxes(2:4:end)+posAxes(4:4:end));            
        end
        %--------------------------move
        function crossLine(obj)
            if isempty(obj.crossLineObj)
                obj.crossLineObj=crossLine(obj.parent);
            end
            obj.crossLineObj.Data=obj.mousePos;
        end
        function indText(obj)
          axNa=unique({obj.parent.indObjArr.axesName});
          d=cellfun(@(x) obj.parent.indObjArr(strcmp({obj.parent.indObjArr.axesName},x)),axNa,'UniformOutput',0);
          strcell=cellfun(@(x) x.getValueStr(obj.pixelPos),d,'UniformOutput',0);
          myTextObj=cellfun(@(x) obj.parent.axesObj.axesText(x),axNa,'UniformOutput',0);
          myText=[myTextObj{:}];
          [myText.str]=deal(strcell{:});
          obj.indTextObj=myText; % 不合理
          %--------------------------------
        end
        function fibonacci(obj)
            FibonacciObjAll=obj.parent.customizeObjArr(strcmp('Fibonacci',{obj.parent.customizeObjArr.type}));
            FibonacciObj=FibonacciObjAll([FibonacciObjAll.propertie]~=2);
            FibonacciObj.indObj.Data=obj.mousePos;
        end
        function rate(obj)
            RateObjAll=obj.parent.customizeObjArr(strcmp('Rate',{obj.parent.customizeObjArr.type}));
            RateObj=RateObjAll([RateObjAll.propertie]~=2);
            RateObj.indObj.Data=obj.mousePos;            
        end
        function line(obj)
            lineObjAll=obj.parent.customizeObjArr(strcmp('Line',{obj.parent.customizeObjArr.type}));
            lineObj=lineObjAll([lineObjAll.propertie]~=2);
            lineObj.indObj.Data=obj.mousePos;
        end
        %--------------------------keypress
        function normal(obj)
           axesObjend=obj.parent.axesObj.axesList(end);
           XLim=axesObjend.XLim;
           switch get(obj.parent.hfig,'CurrentKey')
               case 'uparrow'
                   if XLim(1)+1<XLim(2)-1
                      axesObjend.XLim=[XLim(1)+1,XLim(2)-1];
                      obj.notify('limChange');
                   end
               case 'downarrow'
                   axesObjend.XLim=[XLim(1)-1,XLim(2)+1];   
                   obj.notify('limChange');
               case 'leftarrow'
                   axesObjend.XLim=[XLim(1)-1,XLim(2)-1]; 
                   obj.notify('limChange');
               case 'rightarrow'
                   axesObjend.XLim=[XLim(1)+1,XLim(2)+1]; 
                   obj.notify('limChange');
               case 'delete'
                   if ~isempty(obj.parent.indObjArr)
                       isSelected=logical([obj.parent.indObjArr.beSelected]);
                       delete(obj.parent.indObjArr(isSelected));
                       obj.parent.indObjArr(isSelected)=[];
                   end
                   if ~isempty(obj.parent.customizeObjArr)
                       isSelected=logical([obj.parent.customizeObjArr.beSelected]);
                       delete(obj.parent.customizeObjArr(isSelected));
                   end
                   
           end            
        end
        %--------------------------buttondown
        function linepress(obj)
            lineObjAll=obj.parent.customizeObjArr(strcmp('Line',{obj.parent.customizeObjArr.type}));
            lineObj=lineObjAll([lineObjAll.propertie]~=2);
            if lineObj.indObj.propertie<2 && strcmp(get(gcf,'SelectionType'),'normal') 
                lineObj.indObj.propertie=lineObj.indObj.propertie+1;
            end
        end
    end
    
end

