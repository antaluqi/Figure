classdef indiArr<handle & matlab.mixin.Heterogeneous
    properties
        type
        parent
        axesName
        indObj
        propertie
        show
        hthis
        Data
        beSelected
    end
    properties (Access = 'protected')
    end
    methods
        function obj=indiArr(type,propertie,parent)
            eval(['obj.indObj=',type,';']);
            obj.type=type;
            obj.parent=parent;
            obj.show=1;
            obj.propertie=propertie;
            obj.beSelected=0;
        end

        %---------------------------------set
        function set.parent(obj,value)
            set_parent(obj,value)
            obj.parent=value;            
        end
        function set.axesName(obj,value)
            set_axesName(obj,value);
            obj.axesName=value;
        end
        function set.indObj(obj,value)
            obj.indObj=value;
            set_indObj(obj,value)
            
        end
        function set.propertie(obj,value)
            set_propertie(obj,value);
            obj.propertie=value;
        end
        function set.show(obj,value)
           set_show(obj,value);
           obj.show=value;
        end
        function set.hthis(obj,value)
              set_hthis(obj,value);
              obj.hthis=value;
        end
        function set.Data(obj,value)
          set_Data(obj,value);
          obj.Data=value;
        end
        function set.beSelected(obj,value)
          set_beSelected(obj,value);
          obj.beSelected=value;
        end
        %---------------------------------get
        function value=get.parent(obj)
            value=obj.get_parent;
        end
        function value=get.axesName(obj)
           value=get_axesName(obj);
        end
        function value=get.propertie(obj)
            value=obj.get_propertie;
        end
        function value=get.show(obj)
            value=obj.get_show;
        end
        function value=get.hthis(obj)
            value=obj.get_hthis;
        end
        function value=get.Data(obj)
            value=obj.get_Data;
        end
        function value=get.beSelected(obj)
            value=obj.get_beSelected;
        end
        %---------------------------------
        function str=getValueStr(obj,x)
            IndObj=[obj.indObj];
           str=strjoin(arrayfun(@(Indobj) Indobj.getValueStr(x),IndObj,'UniformOutput',0));
          %    str=arrayfun(@(indobj) indobj.getValueStr(x),indObj,'UniformOutput',0);
        end
        function delete(obj)
            delete(obj.indObj);
            disp([obj.type,'被删除'])
        end
    end
    methods(Access = 'protected')
                %----------------------------------set
        function set_parent(obj,value)
            if ~isempty(obj.indObj)
                obj.indObj.parent=value;
                value.indObjArr=[value.indObjArr,obj];
            end
        end
        function set_axesName(obj,value)
            if ~isempty(obj.axesName)
                obj.indObj.axesName=value;
            end           
        end
        function set_indObj(obj,value)
            validateattributes(value, {'indicationBase'}, {'scalar'});
            value.indArrClass=obj;
            value.parent=obj.parent;
            value.propertie=obj.propertie;
            value.show=obj.show;        
        end
        function set_propertie(obj,value)
            if ~isempty(obj.indObj)
                obj.indObj.propertie=value;
            end            
        end
        function set_show(obj,value)
            if all(ismember(value,[0,1]))
                if ~isempty(obj.indObj)
                    [obj.indObj.show]=deal(value);
                end
            else
                error('show的输入必须为0或1')
            end        
        end
        function set_hthis(obj,value)  
        end
        function set_Data(obj,value)
        end
        function set_beSelected(obj,value)
            if ~isempty(obj.indObj)
                obj.indObj.beSelected=value;
            end
        end
        %----------------------------------get
        function value=get_parent(obj)
            if ~isempty(obj.indObj)
                value=obj.indObj.parent;
            else
                value=[];
            end
        end
        function value=get_axesName(obj)
            if ~isempty(obj.indObj.axesName)
                value=obj.indObj.axesName;
            else
                value=[];
            end
        end
        function value=get_propertie(obj)
            if ~isempty(obj.indObj)
                value=obj.indObj.propertie;
            else
                value=[];
            end            
        end
        function value=get_show(obj)
            if ~isempty(obj.indObj)
                value=obj.indObj.show;
            else
                value=[];
            end
        end
        function value=get_hthis(obj)
            if ~isempty(obj.indObj)
                value=obj.indObj.hthis;
            else
                value=[];
            end            
        end
        function value=get_Data(obj)
             if ~isempty(obj.indObj)
                value=obj.indObj.Data;
            else
                value=[];
            end             
        end
        function value=get_beSelected(obj)
            if ~isempty(obj.indObj)
                value=obj.indObj.beSelected;
            else
                value=0;
            end
        end
    end
    methods(Abstract)

    end



end