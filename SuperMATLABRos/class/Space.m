classdef Space < MapChip
  methods
    function obj = Space(x,y)
      obj@MapChip(x,y)
      obj.name_ = 'space';
      obj.rigit_ = 0;
      obj.death_ = 0;
      obj.imdata_ = [];
    end
    function imSet(obj)
    end
    function imDelete(obj)
    end
  end
end