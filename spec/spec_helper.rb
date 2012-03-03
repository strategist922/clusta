require 'rspec'

CLUSTA_ROOT_DIR      = File.expand_path( '../', File.dirname(__FILE__)) unless defined?(CLUSTA_ROOT_DIR)
CLUSTA_LIB_DIR       = File.join(CLUSTA_ROOT_DIR, 'lib')   unless defined?(CLUSTA_LIB_DIR)
CLUSTA_SPEC_DIR      = File.join(CLUSTA_ROOT_DIR, 'spec')  unless defined?(CLUSTA_SPEC_DIR)
CLUSTA_SPEC_DATA_DIR = File.join(CLUSTA_SPEC_DIR, 'data')  unless defined?(CLUSTA_SPEC_DATA_DIR)

$:.unshift << CLUSTA_LIB_DIR unless $:.include?(CLUSTA_LIB_DIR)
require 'clusta'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |path| require path }

RSpec.configure do |config|
  config.mock_with :rspec
end
