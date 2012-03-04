$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

desc "Build clusta"
task :build do
  system "gem build clusta.gemspec"
end

version = File.read(File.expand_path('../VERSION', __FILE__)).strip
desc "Release clusta-#{version}"
task :release => :build do
  system "gem push clusta-#{version}.gem"
end

desc "Build tags."
task :tags do
  files   = Dir["**/*.rb"]
  command =  "etags -e --language-force=ruby Rakefile #{files.join(' ')}"
  puts command
  system(command)
end
