require 'diffy'
require 'open3'

module Clusta
  module TransformsSpecHelper

    def transforming seg, options={}
      Transformer.new(seg, options)
    end
    
    def have_output seg
      HaveOutput.new(*seg)
    end

    class Transformer

      attr_accessor :seg, :output, :error

      def initialize seg, options={}
        self.seg  = seg
        self.path = File.join(CLUSTA_SPEC_DATA_DIR, seg)
        @options  = options
      end

      def path= path
        raise SpecError.new("Spec data path #{path} does not exist.") unless File.exist?(path)
        @path = path
      end

      def clusta_bin
        File.join(CLUSTA_BIN_DIR, 'clusta')
      end

      def transform_name
        @options[:with] or raise SpecError.new("Must supply a transformation name with the :with option.")
      end

      def args
        @options[:args] || ''
      end

      def command
        "#{clusta_bin} --run=local --transform=#{transform_name} #{args} #{@path} -"
      end

      def output
        return @output if @output
        run
        @output
      end

      def error
        return @formatted_error if @formatted_error
        run
        @formatted_error = format_error(@error)
      end

      def format_error raw
        raw.split("\n").map do |line|
          "STDERR:  " + line
        end.join("\n")
      end

      def run
        Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
          @output  = stdout.read
          @error   = stderr.read
          @exit    = wait_thr.value
        end
      end

      def error?
        return true unless @exit
        @exit.to_i != 0
      end
      
    end

    class HaveOutput

      def initialize seg
        @seg      = seg
        self.path = File.join(CLUSTA_SPEC_DATA_DIR, seg)
      end

      def verbose?
        ENV["VERBOSE"]
      end

      def path= path
        raise SpecError.new("Spec data path #{path} does not exist.") unless File.exist?(path)
        @path = path
      end
      
      def expected
        @expected ||= File.read(@path)
      end

      def matches? transformer
        @transformer = transformer
        @transformer.output == expected
      end

      def diff
        @diff ||= Diffy::Diff.new(expected, @transformer.output)
      end

      def failure_message
        "expected #{@transformer.seg} to match #{@seg}:\n\n#{diff}".tap do |m|
          m << "\n\n#{@transformer.error}" if verbose? || @transformer.error?
        end
      end

      def negative_failure_message
        "expected #{@transformer.seg} to be different than #{@seg}.".tap do |m|
          m << "\n\n#{@transformer.error}" if verbose? || @transformer.error?
        end
      end

    end
    
  end
end

