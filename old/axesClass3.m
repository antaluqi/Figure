classdef axesClass3<handle
  properties
      parent 
      area double
      axesList
      axesText
  end 
  properties(Access=private)
      CandleAxesAreaY double
  end
  methods
      function obj=axesClass3(MainFigureObj)
          obj.parent=MainFigureObj;
          obj.area=[0.04,0.96;0.2,0.95];% axes所占据的范围，x[0.04,0.96],y[0.2,0.95]
          obj.CandleAxesAreaY=3; % CandleAxes与其他axes的Y的比值
          obj.axesText=containers.Map;
          haxes=axes('Tag','CandleAxes','pos',[obj.area(:,1)',obj.area(:,2)'-obj.area(:,1)'],'parent',obj.parent.hfig,'nextplot','add','xtick',[],'FontSize',7);
         %------------------------------
          CandleText=myText(obj.parent);
          CandleText.position=[haxes.Position(1),haxes.Position(2)+haxes.Position(4)-0.005];
          CandleText.str='CandleAxes';
          obj.axesText('CandleAxes')=CandleText;
          %------------------------------
          
      end
      function add(obj)
          i=length(obj.axesList);
          if i==0
             axes('Tag','CandleAxes','pos',[obj.area(:,1)',obj.area(:,2)'-obj.area(:,1)'],'parent',obj.parent.hfig,'nextplot','add','xtick',[],'FontSize',7);
             return
          end 
          if i>0
              CandleAxes=findobj(obj.parent.hfig,'type','axes','tag','CandleAxes');
              indAxes=findobj(obj.parent.hfig,'type','axes','-not','tag','CandleAxes');
              if isempty(CandleAxes)
                  error('缺少主画布CandleAxes')
              end
              XStart=obj.area(1,1);
              XEnd=obj.area(1,2);
              YStart=obj.area(2,1);
              YEnd=obj.area(2,2);
              dot=(YEnd-YStart)/(i+obj.CandleAxesAreaY);
              CandleAxes.Position=[XStart,YEnd-dot*obj.CandleAxesAreaY,XEnd-XStart,dot*obj.CandleAxesAreaY];
              for j=1:i-1
                  indAxes(j).Position=[XStart,YEnd-dot*(j+obj.CandleAxesAreaY),XEnd-XStart,dot];
                  %------------------------------------
                  indText=obj.axesText(indAxes(j).Tag);
                  obj.axesText(indAxes(j).Tag)=indText;
                  indText.position=[indAxes(j).Position(1),indAxes(j).Position(2)+indAxes(j).Position(4)-0.005];
                  %------------------------------------
              end
              
              if isempty(indAxes)
                  tag='IndicatorsAxes1';
              else
                  nameList={indAxes.Tag};
                  for n=1:10
                      if ~any(ismember(nameList,['IndicatorsAxes',num2str(n)]))
                          tag=['IndicatorsAxes',num2str(n)];
                          break
                      end
                  end
              end
              haxes=axes('Tag',tag,'pos',[XStart,YStart,XEnd-XStart,dot],'parent',obj.parent.hfig,'nextplot','add','xtick',[],'FontSize',7);
              %--------------------------------
              indText=myText(obj.parent);
              indText.position=[haxes.Position(1),haxes.Position(2)+haxes.Position(4)-0.005];
              indText.str=tag;
              obj.axesText(tag)=indText;
             % obj.showText(tag)={};
              %--------------------------------
              if i>0
                  XLim=CandleAxes.XLim;
                  linkaxes(obj.axesList,'x');
                  CandleAxes.XLim=XLim;
              end
          end
          
      end
      function remove(obj,tag)
          i=length(obj.axesList);
          if i==0
              return
          end
          tagAxes=findobj(obj.parent.hfig,'type','axes','tag',tag);
          if isempty(tagAxes)
             error(['没有找到名为',tag,'的画布'])
          end
          delete(tagAxes)
          %---------------------------
          delete(obj.axesText(tag));
          %delete(obj.showText(tag));
          obj.axesText.remove(tag);
          
          %---------------------------
          i=max(i-1,0);
          CandleAxes=findobj(obj.parent.hfig,'type','axes','tag','CandleAxes');
          indAxes=findobj(obj.parent.hfig,'type','axes','-not','tag','CandleAxes');
          if i==0
              return
          end
          XStart=obj.area(1,1);
          XEnd=obj.area(1,2);
          YStart=obj.area(2,1);
          YEnd=obj.area(2,2);
          dot=(YEnd-YStart)/(i-1+obj.CandleAxesAreaY);
          CandleAxes.Position=[XStart,YEnd-dot*obj.CandleAxesAreaY,XEnd-XStart,dot*obj.CandleAxesAreaY];
          for j=1:i-1
              indAxes(j).Position=[XStart,YEnd-dot*(j+obj.CandleAxesAreaY),XEnd-XStart,dot];
              %------------------------------------
              indText=obj.axesText(indAxes(j).Tag);
              indText.position=[indAxes(j).Position(1),indAxes(j).Position(2)+indAxes(j).Position(4)-0.005];
              %------------------------------------
          end
          
      end
      function value=get.axesList(obj)
          if isempty(obj.parent) || isempty(obj.parent.hfig)||~ishandle(obj.parent.hfig)
              value=[];
              return
          end
          value=findobj(obj.parent.hfig,'type','axes');
      end
  end
end