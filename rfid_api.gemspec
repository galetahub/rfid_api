# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rfid_api/version"

Gem::Specification.new do |s|
  s.name        = "rfid_api"
  s.version     = RfidApi::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Igor Galeta"]
  s.email       = ["galeta.igor@gmail.com"]
  s.homepage    = "https://github.com/galetahub/rfid_api"
  s.summary     = %q{Simple client for RFID API}
  s.description = %q{Simple client to work with RFID API}

  s.rubyforge_project = "rfid_api"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["README.rdoc"]
  
  s.add_dependency("json", "~> 1.6.1")
  s.add_dependency("httparty", "~> 0.8.1")
  s.add_dependency("activesupport", ">= 0")
  s.add_dependency("activemodel", ">= 0")
end
