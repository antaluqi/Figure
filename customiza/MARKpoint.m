classdef MARKpoint<customizaBass
    %---------------------------
    % 标记点
    % p=MARKpoint(f)
    % p.propertie={'CandleAxes','2016-09-07'};
    % p.propertie={haxes,'2016-09-07'};
    % p.propertie={haxes,101,15.6};
    %---------------------------
    properties
        propertie % 参数
    end
    methods
        function obj=MARKpoint(hMainFigure)  % 构造函数
            if nargin ==0
                hMainFigure=[];
            end
            obj=obj@customizaBass(hMainFigure); % 调用父类构造函数
            obj.type='MARKpoint';               % 名称
        end
        function calculation(obj)            %（重载）计算
            if ~isempty(obj.parent) && ~isempty(obj.parent.indObjArr)
                % 在参数中取得作用画布
                if all(ishandle(obj.propertie{1})) && strcmp(obj.propertie{1}.Tag,'axes') % 在参数(1)如果是画布句柄，则为当前画布句柄
                    haxes=obj.propertie{1};
                elseif ischar(obj.propertie{1})                 % 如果是字符则通过画布名称找到画布句柄 
                    axesName=obj.propertie{1};   
                    haxes=findobj(obj.parent.hfig,'tag',axesName);
                else
                    error('Mark对象propertie参数第一个错误，应为axes句柄或axes名称')
                end  
                % 在参数中取得日期数据
                x=datenum(obj.propertie{2});                     
                % 指定画布必须存在
                if isempty(haxes)       
                   error(['未找到名为',axesName,'的axes.'])
                end
                % 如果参数为3个，则后面两个为实际坐标传输给Data，返回函数
                if length(obj.propertie)==3
                    y=obj.propertie{3};
                    obj.Data={haxes,x,y};
                    return
                end
                % 否则开始计算Y坐标
                % 找到CANDLE指标对象
                ind=obj.parent.indObjArr;
                indCandle=ind(strcmp({ind.type},'CANDLE'));                
                if ~isempty(indCandle)  % CANDLE指标对象必须存在
                   Dates=indCandle.Data(:,1); % 在CANDLE指标对象的Data中取得日期列
                   if ~ismember(x,Dates)      % 如果输入的日期不在当前CANDLE指标的日期序列中，则返回空的Data(不做图)
                       obj.Data=[];
                       warning([datestr(x,'yyyy-mm-dd'),'不在Candle数据中'])
                       return
                   end
                   % 如果输入日期存在于前CANDLE指标的日期序列中，则继续计算Y值
                   y=indCandle.Data(Dates==x,3);     % 取得当日的最低价
                   leaveDot=diff(haxes.YLim)*0.05;   % 偏移量（根据画布坐标调整）
                   y=y-leaveDot;                     % 得到实际的Y值
                   obj.Data={haxes,find(Dates==x),y};% 组合成数据（x值也要转换为实际的横坐标值）
                else
                    error('Candle数据为空，请输入完整的MARK点坐标')
                end
            else
            end
        end
        function plot(obj)                   %（重载）画图 
            delete(obj.hthis)     % 删除之前可能存在的句柄
            if isempty(obj.Data)  % 数据不能为空
                obj.hthis=[];
            else
                haxes=obj.Data{1};             % 取得画布句柄
                x=obj.Data{2};                 % X坐标
                y=obj.Data{3};                 % Y坐标
                obj.hthis=impoint(haxes,[x,y]);% 作图
                obj.parent.notify('limChange');% 发现在作图当中有可能会改变坐标范围，所以发布变化通知
                setColor(obj.hthis,'r')        % 颜色
            end 

        end
        function set.propertie(obj,value)    %  参数（相对于父类增加的参数）
            obj.propertie=value;
            set_propertie(obj,value);
        end
    end
    methods(Access = 'protected')
        function set_hthis(obj,value)             %（重载）设置句柄（句柄上不用绑定点击响应函数） 
        end       
        function set_propertie(obj,value)         % 设置参数，激活calculation计算
            obj.calculation;
        end        
        function set_beDestroied(obj,value)       %（重载）设置是否被销毁（增加了在resultTable中注销hmark）
            if value==1
                try
                    obj.parent.customizeObjArr([obj.parent.customizeObjArr.beDestroied]==1)=[];
                catch
                    disp('set_beDestroied在删除customizeObjArr中的对象时有错误发生')
                end
                try
                    obj.parent.hResultTable.hmark=[];
                catch
                    disp('set_beDestroied在删除customizeObjArr中的对象时有错误发生')
                end                
            end
        end        
        function value=get_beSelected(obj)        % (重载) 不能被选中
            value=0;
        end
    end
    methods (Static)
        function propSet(parent)
            disp(['运行',mfilename,'参数设定'])
        end
    end    
end