# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "middleman-remote-code/version"

Gem::Specification.new do |s|
  s.name = "middleman-remote-code"
  s.version = Middleman::RemoteCode::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Jay Shirley"]
  s.email = ["hello@jayshirley.com"]
  s.homepage = "https://github.com/jshirley/middleman-remote-code"
  s.summary = %q{Fetch remote code examples from referenced external Markdown documents}
  s.description = %q{Fetch remote code examples from referenced external Markdown documents}
  s.license = "MIT"
  s.files = `git ls-files -z`.split("\0")
  s.test_files = `git ls-files -z -- {fixtures,features}/*`.split("\0")
  s.require_paths = ["lib"]
  s.add_runtime_dependency("middleman-core", ["~> 3.2"])
end
