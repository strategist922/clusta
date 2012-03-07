Dir[File.join(File.dirname(__FILE__), '**/*.rb')].each do |path|
  require Clusta.require_path path
end
