classdef customizeObjArr<indiArr
    properties
    end
    properties (Access = 'private')
    end
    methods
        function obj=customizeObjArr(type,propertie,parent)
            if nargin ==0
                error('��������ָ������type')
            elseif nargin ==1
                propertie=[];
                parent=[];
            elseif nargin ==2
                parent=[];
            elseif nargin ==3
            else
                error('indiArr������Ŀ����')
            end            
             obj=obj@indiArr(type,propertie,parent);
        end
    end
    methods(Access = 'protected')
        function set_parent(obj,value)
            if ~isempty(obj.indObj)
                obj.indObj.parent=value;
                value.customizeObjArr=[value.customizeObjArr,obj];
            end
        end
    end
end