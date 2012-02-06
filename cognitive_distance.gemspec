# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cognitive_distance/version"

Gem::Specification.new do |s|
  s.name        = "cognitive_distance"
  s.version     = CognitiveDistance::VERSION
  s.authors     = ["Ian D. Eccles"]
  s.email       = ["ian.eccles@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A measure of locality}
  s.description = %q{A tool for measuring locality of Ruby source}

  s.rubyforge_project = "cognitive_distance"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rake'
end

