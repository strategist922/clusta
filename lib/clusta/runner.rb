require 'configliere'

Settings.use :commandline

Settings.define :transform,       :description => "The name of the tranformation to run.",                                    :required => false
Settings.define :list_transforms, :description => "List known transformations.",                                              :required => false, :type => :boolean, :default => false
Settings.define :class_names,     :description => "The output format for class names, one of: 'long', 'medium', or 'short'.", :required => true,  :default => 'medium'
Settings.define :serialize,       :description => "The serialization format for data, one of: 'json' or 'tsv'.",              :required => true,  :default => 'tsv'
Settings.define :transforms_path, :description => "A colon-separated list of directories to require transform definitions.",  :required => false, :default => ''
Settings.define :geometry_path,   :description => "A colon-separated list of directories to require geometry definitions.",   :required => false, :default => ''

module Clusta
  
  class Runner

    RUN_ARG_REGEXP = /--run=./
    

    def initialize name, argv
      @name = name
      @argv = argv
    end

    def run!
      begin
        Settings.resolve!
        case
        when Settings[:list_transforms]
          load_transforms!
          list_transforms!
        when Settings[:list_geometry]
          load_geometry!
          list_geometry!
        when Settings[:transform]
          load_transforms!
          load_geometry!
          run_transform!
        when Settings[:map_command] || Settings[:reduce_command]
          run_map_reduce!
        else
          print_help!
        end
      rescue Clusta::Error => e
        $stderr.puts "ERROR: #{e.message}"
        exit(1)
      end
    end

    def load_transforms!
      rb_files_within(:transforms_path) do |path|
        Clusta::Transforms.load_from(path)
      end
    end

    def load_geometry!
      rb_files_within(:geometry_path) do |path|
        Clusta::Geometry.load_from(path)
      end
    end

    def rb_files_within key, &block
      return if Settings[key].nil? || Settings[key].empty?
      Settings[key].split(':').each do |dir|
        expanded = File.expand_path(dir)
        unless File.directory?(expanded)
          $stderr.puts("WARNING: #{expanded} is not a directory")
          next
        end
        Dir[File.join(expanded, '*.rb')].each do |path|
          yield path
        end
      end
    end
    
    def list_transforms!
      puts Clusta::Transforms.listing
    end

    def list_geometry!
      puts Clusta::Geometry.listing
    end
    
    def run_transform!
      transform = Clusta::Transforms.from_name(Settings[:transform])
      ::ARGV.replace(@argv)
      ::ARGV.push('--run=local') unless ARGV.any? { |arg| arg =~ self.class::RUN_ARG_REGEXP }
      script    = Clusta::Transforms.script_for(transform)
      script.run
    end

    def run_map_reduce!
      ::ARGV.replace(@argv)
      ::ARGV.push('--run=local') unless ARGV.any? { |arg| arg =~ self.class::RUN_ARG_REGEXP }
      begin
        s = Wukong::Script.new(nil, nil)
      rescue RuntimeError => e
        raise Error.new(e.message)
      end
      s.run
    end

    def print_help!
      begin
        s = Wukong::Script.new(nil, nil)
      rescue RuntimeError => e
        raise Error.new(e.message)
      end
      s.run
    end
    
  end
end
