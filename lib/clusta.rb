module Clusta
  Error                     = Class.new(StandardError)
  DirectednessMismatchError = Class.new(Error)

  autoload :Geometry,   'clusta/geometry'
  autoload :Transforms, 'clusta/transforms'
  
end
