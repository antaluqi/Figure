classdef Line<indicationBase
    properties
        textInfo myText

    end
    properties (Access = private)
        moveTemp
        windowsbuttondownTemp
        rightClick
        coordinate
        haxes
    end
    methods
        function obj=Line(hMainFigure)
            if nargin ==0
                hMainFigure=[];
            end
            obj=obj@indicationBase(hMainFigure);
            obj.type='Rate';
            obj.propNo=1;
            obj.DataNo=[1,2];
            obj.rightClick=0;
            obj.windowsbuttondownTemp={};
        end
        function calculation(obj)
             if ~isempty(obj.parent)
                 switch obj.propertie
                     case 0
                         if isempty(obj.moveTemp)
                             obj.moveTemp=obj.parent.callbackObj.moveNameList;
                         end
                         obj.parent.callbackObj.replace('move','line')
                          if isempty(obj.moveTemp)
                             obj.windowsbuttondownTemp=obj.parent.callbackObj.buttondownNameList;
                         end                        
                         obj.parent.callbackObj.replace('buttondown','linepress')
                     case 1
                         obj.parent.callbackObj.replace('move','line')              
                         obj.parent.callbackObj.replace('buttondown','linepress')
                         if isempty(obj.hthis)
                             normPos=obj.parent.pixel2norm(obj.Data);
                             obj.hthis=annotation(obj.parent.hfig,'line',[normPos(1),normPos(1)],[normPos(2),normPos(2)],'tag','Line_Start');    %Ë®Æ½Ïß
                             obj.textInfo(2).position=obj.textInfo(1).position;
                             obj.textInfo(2).str=obj.textInfo(1).str;
                         end
                          obj.rightClick=1;
                         obj.plot;
                     case 2
                         obj.parent.callbackObj.replace('move',obj.moveTemp);
                         obj.parent.callbackObj.replace('buttondown',obj.windowsbuttondownTemp);
                         obj.moveTemp={};
                         obj.windowsbuttondownTemp={};
                         obj.rightClick=0;
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
            try
                obj.textInfo(1).str='lValue';
                obj.textInfo(1).position=obj.parent.pixel2norm(obj.Data);
            catch
                obj.textInfo=[myText(obj.parent),myText(obj.parent)];
                obj.textInfo(1).str='lValue';   
                obj.textInfo(1).position=obj.parent.pixel2norm(obj.Data);           
            end
            
            if ~isempty(obj.hthis) && ishandle(obj.hthis)
                normPos=obj.parent.pixel2norm(obj.Data);
                obj.hthis.X(2)=normPos(1);
                obj.hthis.Y(2)=normPos(2);
            end
            
            
        end
        function replot(obj,scr,data)
            if ~isempty(obj.hthis) && all(ishandle(obj.hthis)) && ~isempty(obj.coordinate)          
                normPos=obj.parent.coord2norm(obj.coordinate,obj.haxes.Tag);
                [obj.hthis.X]=deal(normPos(:,1));
                [obj.hthis.Y]=deal(normPos(:,2));
                textBox=[obj.textInfo.hthis];
                for i=1:length(textBox)
                    textBox(i).Position(1:2)=normPos(i,:);
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
         function ButtonDownFcn3(obj,hObject,event)
            if strcmp(get(gcf,'SelectionType'),'alt') 
                if obj.rightClick==0
                    obj.moveTemp=obj.parent.callbackObj.moveNameList;
                    obj.windowsbuttondownTemp=obj.parent.callbackObj.buttondownNameList;                   
                    obj.propertie=1;
                    obj.rightClick=1;
                elseif obj.rightClick==1 
                    delete(obj.hthis)
                    obj.hthis=[];
                    delete(obj.textInfo)
                    obj.propertie=0;
                    obj.rightClick=0;
                end
            else
               ButtonDownFcn(obj,hObject,event);  
            end

         end         
        function set_hthis(obj,value)
            if ~isempty(value)
                set(value,'ButtonDownFcn',{@obj.ButtonDownFcn3});
                obj.haxes=obj.parent.norm2axes([value.X(1),value.Y(1)]);
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