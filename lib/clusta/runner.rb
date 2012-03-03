module Clusta
  
  class Runner

    def initialize args
      self.args = args
    end

    def run!
      Settings.resolve!
    end
    
  end
  
end
