require 'configliere'

Settings.use :commandline

Settings.define :transform,   :description => "The name of the tranformation to run.", :required => true
Settings.define :class_names, :description => "The output format for class names, one of: 'long', 'medium', or 'short'.", :default => 'medium'

module Clusta
  
  class Runner

    TRANSFORM_ARG_REGEXP  = /--transform=[\w\d_]+/
    TRANSFORM_LIST_REGEXP = /--list-transforms/

    def initialize name, argv
      @name = name
      @argv = argv
    end

    def run_local_by_default!
      @argv.unshift('--run=local') unless @argv.detect { |arg| arg =~ /--run/ }
    end
    
    def ensure_named_transform!
      if transform_arg.nil? || transform_name.nil?

        # Just creating this empty script causes the Settings to get
        # populated with Wukong's usual options.
        begin
          Wukong::Script.new(nil, nil)
          Settings.resolve!
        rescue RuntimeError => e
        end
        
        Settings.dump_help
        exit(1)
      end
    end

    def list_transforms?
      @argv.detect { |arg| arg =~ self.class::TRANSFORM_LIST_REGEXP }
    end

    def transform_arg
      @argv.find_all { |arg| arg =~ self.class::TRANSFORM_ARG_REGEXP }.first
    end

    def transform_name
      transform_arg.split('=').last
    end

    def run!
      begin
        if list_transforms?
          list_transforms!
        else
          run_transform!
        end
      rescue Clusta::Error => e
        $stderr.puts "ERROR: #{e.message}"
        exit(1)
      end
    end

    def run_transform!
      ensure_named_transform!
      run_local_by_default!
      ARGV.replace(@argv)
      Settings.resolve!
      
      transform = Clusta::Transforms.from_name(transform_name)
      script    = Clusta::Transforms.script_for(transform)
      script.run
    end

    def list_transforms!
      puts "Known transforms:"
      puts ''
      Clusta::Transforms.names.sort.each do |transform_name|
        transform = Clusta::Transforms.from_name(transform_name)
        name_suffix = case
                      when Clusta::Transforms.has_mapper?(transform)     && Clusta::Transforms.has_reducer?(transform)     then ''
                      when (! Clusta::Transforms.has_mapper?(transform)) && Clusta::Transforms.has_reducer?(transform)     then ' (reduce-only)'
                      when Clusta::Transforms.has_mapper?(transform)     && (! Clusta::Transforms.has_reducer?(transform)) then ' (map-only)'
                      when (! Clusta::Transforms.has_mapper?(transform)) && (! Clusta::Transforms.has_reducer?(transform)) then ' (nothing)'
                      end
                        
        puts "  #{transform_name}#{name_suffix}"
        if transform.respond_to?(:help)
          puts ''
          puts "    #{transform.help}"
        end
        puts ''
      end
    end
    
  end
  
end
