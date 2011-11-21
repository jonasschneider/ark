require "ark"
require "fileutils"
require 'pp'
require "webrat"
require "rack/test"

SANDBOX_DIR = File.expand_path('sandbox', File.dirname(__FILE__))

def put_file(name, contents)
  full_name = SANDBOX_DIR+"/"+name
  FileUtils.mkdir_p File.dirname(full_name)
  
  aFile = File.new(full_name, "w")
  aFile.write(contents)
  aFile.close
end

def get_file(name)
  full_name = SANDBOX_DIR+"/"+name
  File.read(full_name)
end

Webrat.configure do |config|
  config.mode = :rack
  config.application_framework = :sinatra
  config.application_port = 4567
end

RSpec.configure do |config|
  config.before :each do
    FileUtils.rm_rf SANDBOX_DIR
    FileUtils.mkdir SANDBOX_DIR
  end
  
  def app
    Ark::App
  end
  
  config.include(Rack::Test::Methods)
  config.include(Webrat::Methods)
  config.include(Webrat::Matchers)
end