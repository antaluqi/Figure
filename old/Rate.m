classdef Rate<indicationBase
    properties
        textInfo myText
    end
    properties (Access = private)
        Temp
        rightClick
        coordinate
        haxes
    end
    methods
        function obj=Rate(hMainFigure)
            if nargin ==0
                hMainFigure=[];
            end
            obj=obj@indicationBase(hMainFigure);
            obj.type='Rate';
            obj.propNo=1;
            obj.DataNo=[1,2];   
            obj.rightClick=0;
        end
        function calculation(obj)
             if ~isempty(obj.parent)
                switch obj.propertie
                    case 0
                        obj.Temp=obj.parent.callbackObj.moveNameList;
                        obj.parent.callbackObj.replace('move','rate')
                    case 1
                        obj.parent.callbackObj.replace('move','rate')
                    case 2
                        %-------------------------------------------------
                        normX=cell2mat({obj.hthis.X}');
                        normY=cell2mat({obj.hthis.Y}');
                        pointStart=[normX(:,1),normY(:,1)];
                        pointEnd=[normX(:,2),normY(:,2)];
                        coordStart=obj.parent.norm2coord(pointStart);
                        coordEnd=obj.parent.norm2coord(pointEnd);
                        obj.coordinate=[coordStart;coordEnd];
                end
            end           
        end
        function plot(obj)
            if isempty(obj.parent) || isempty(obj.Data)
                return
            end
            [fz,bottom,top,left,right]=obj.parent.callbackObj.geiFigureSize;
            y=max(min(obj.Data(2)/fz(4),top),bottom); 
            if isempty(obj.hthis)
                obj.hthis=annotation(obj.parent.hfig,'line',[left,right],[y,y],'tag','RateLine_Start');    %水平线
                obj.textInfo=[myText(obj.parent),myText(obj.parent),myText(obj.parent),myText(obj.parent)];
            end        
            obj.hthis(1).X=[left,right];
            obj.hthis(1).Y=[y,y];
            if obj.propertie==0 
                obj.textInfo(1).str='0%:lValue';
            else
                End=obj.parent.norm2coord([0.5,y]);
                Start=obj.parent.norm2coord([0.5,obj.hthis(2).Y(1)]);
                str=[num2str(100*(End(2)-Start(2))/Start(2)),'%:lValue'];
                obj.textInfo(1).str=str;
            end   
            obj.textInfo(1).position=[right-0.1,y];
            if length(obj.hthis)==2
                obj.haxes=obj.parent.norm2axes([obj.hthis(1).X(2),obj.hthis(1).Y(2)]);%--------------
            end
        end
        function replot(obj,scr,data)
            if ~isempty(obj.hthis) && all(ishandle(obj.hthis)) && length(obj.hthis)==2 && ~isempty(obj.coordinate)
                normPos=obj.parent.coord2norm(obj.coordinate,obj.haxes.Tag);
                normPosStart=normPos(1:2,:);
                y=normPosStart(:,2);
                [obj.hthis.Y]=deal([y(1),y(1)],[y(2),y(2)]);
                textBox=[obj.textInfo.hthis];
                for i=1:length(textBox)
                    textBox(i).Position(2)=y(i);
                end
            end
        end
        function reload(obj)
            %----------------------------
            try
                delete(obj.parent.customizeObjArr.hthis)
                delete(obj.parent.customizeObjArr.indObj.textInfo)
                obj.parent.customizeObjArr=[];
            end
            %----------------------------
        end     
        function delete(obj)
            delete@indicationBase(obj);
            delete(obj.textInfo);
        end        
    end
    methods(Access = 'protected')
         function ButtonDownFcn2(obj,hObject,event)
            if strcmp(get(gcf,'SelectionType'),'alt') && obj.rightClick==1;
                    obj.propertie=0;
                    delete(obj.hthis);
                    obj.hthis=[];
                    obj.rightClick=0;   
                    return
            end
            if obj.propertie==0
                hthisStart=obj.hthis(1);
                obj.hthis(2)=annotation(obj.parent.hfig,'line',hthisStart.X,hthisStart.Y,'tag','Fibonacci_end');    %结束水平线
                obj.textInfo(2).str='0%:lValue';%---------------------
                obj.textInfo(2).position=[hthisStart.X(2)-0.1,hthisStart.Y(1)];%---------------
                obj.propertie=1;                
            elseif obj.propertie==1
                obj.parent.callbackObj.replace('move','indText');
                set(obj.hthis,'ButtonDownFcn',{@obj.ButtonDownFcn3});
                obj.propertie=2;
                obj.rightClick=0;                
            end
         end
         function ButtonDownFcn3(obj,hObject,event)
            if strcmp(get(gcf,'SelectionType'),'alt') 
                if obj.rightClick==0
                    obj.propertie=1;
                    set(obj.hthis(1),'ButtonDownFcn',{@obj.ButtonDownFcn2});
                    obj.rightClick=1;
                end
            else
               ButtonDownFcn(obj,hObject,event);  
            end
            

         end  
         function set_hthis(obj,value)
            if obj.propertie==0 && length(value)>=1 && ishandle(value(1))
                set(value(1),'ButtonDownFcn',{@obj.ButtonDownFcn2});
            elseif obj.propertie==2 && length(value)>=1 && ishandle(value(1))
                set(value,'ButtonDownFcn',{@obj.ButtonDownFcn});
            end
         end
         function set_parent(obj,value)
            if ~isempty(value)
                validateattributes(value, {'MainFigure'}, {'scalar'});
                obj.listenerList=[obj.listenerList,value.addlistener('DataSourceChange',@obj.update)];
                obj.listenerList=[obj.listenerList,addlistener(value.callbackObj,'limChange',@obj.replot)];
            end
        end        
    end
    
end