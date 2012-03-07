require 'wukong'

module Clusta

  def self.underscore string
    string.gsub(/([A-Z])/, '_\1').downcase[1..-1]
  end

  def self.classify string
    string.split('_').map(&:capitalize).join
  end

  def self.require_name path
    File.basename(path).gsub(/\.rb$/, '')
  end

  def self.require_path path
    File.join(File.dirname(path), File.basename(path).gsub(/\.rb$/, ''))
  end
  
  Error                     = Class.new(StandardError)
  DirectednessMismatchError = Class.new(Error)
  AmbiguousArgumentsError   = Class.new(Error)
  NotImplementedError       = Class.new(Error)

  autoload :Geometry,      'clusta/geometry'
  autoload :Transforms,    'clusta/transforms'
  autoload :Runner,        'clusta/runner'
  autoload :Schema,        'clusta/schema'
  autoload :Serialization, 'clusta/serialization'
end
