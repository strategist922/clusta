root = File.expand_path('../', __FILE__)

lib  = File.join(root, 'lib')
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name         = 'clusta'
  s.version      = File.read(File.join(root, 'VERSION')).strip
  s.platform     = Gem::Platform::RUBY
  s.authors      = ['Dhruv Bansal']
  s.email        = ['dhruv@infochimps.com']
  s.homepage     = 'http://github.com/dhruvbansal/clusta'
  s.summary      = "Scalable network algorithms library built in Ruby using Wukong."
  s.description  =  "Clusta is a Ruby library that implements network algorithms using Wukong.  This means you can use and extend these algorithms on your laptop and seamlessly lift them into a Hadoop cluster when you're ready."
  s.files        = Dir["{bin,lib,spec}/**/*"] + %w[LICENSE README.rdoc VERSION]
  s.executables  = ['clusta']
  s.require_path = 'lib'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'diffy'
  
  s.add_dependency 'wukong'
end
