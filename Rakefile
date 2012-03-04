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
