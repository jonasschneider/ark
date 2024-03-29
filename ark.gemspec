# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ark/version"

Gem::Specification.new do |s|
  s.name        = "ark"
  s.version     = Ark::VERSION
  s.authors     = ["Jonas Schneider"]
  s.email       = ["mail@jonasschneider.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "ark"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "watchr"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  s.add_development_dependency "webrat"
  s.add_development_dependency "rack-test"
  
  s.add_runtime_dependency "awesome_print"
  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "sinatra"
  s.add_runtime_dependency "haml"
end
