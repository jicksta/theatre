THEATRE_FILES = %w[
  MIT-LICENSE
  README.markdown
  Rakefile
  TODO.markdown
  algorithms.markdown
  benchmark/growing_usage.rb
  lib/theatre.rb
  lib/theatre/dsl/callback_definition_loader.rb
  lib/theatre/guid.rb
  lib/theatre/invocation.rb
  lib/theatre/namespace.rb
  lib/theatre/namespace_manager.rb
  lib/theatre/version.rb
  theatre.gemspec
]

Gem::Specification.new do |s|
  s.name    = "theatre"
  s.version = "0.8.0"
  
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :require_rubygems_version=
  
  s.authors = ["Jay Phillips"]
  s.date = "2008-08-21"
  
  s.description = "A library for choreographing a dynamic pool of hierarchially organized actors on Ruby v1.8"
  s.summary     = "A library for choreographing a dynamic pool of hierarchially organized actors on Ruby v1.8"
  
  s.email = "Jay -at- Codemecca.com"
  
  s.files = THEATRE_FILES
  
  s.has_rdoc = false
  
  s.rubyforge_project = "theatre"
  s.homepage          = "http://github.com/jicksta/theatre"
  
  s.require_paths    = ["lib"]
  s.rubygems_version = "1.2.0"
  
end
