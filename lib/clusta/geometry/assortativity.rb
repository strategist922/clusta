module Clusta

  module Geometry

    class AssortativityCount < Element

      field :source_degree_value, :type => :int
      field :target_degree_value, :type => :int
      field :count,               :type => :int
      
    end
    
  end
end
