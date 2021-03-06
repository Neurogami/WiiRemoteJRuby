# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{wiiremotejruby}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Britt / Neurogami"]
  s.date = %q{2009-06-18}
  s.default_executable = %q{wiiremotejruby}
  s.description = %q{}
  s.email = %q{james@neurogami.com}
  s.executables = ["wiiremotejruby"]
  s.extra_rdoc_files = ["History.txt", "bin/wiiremotejruby"]
  s.files = ["History.txt", "README.md", "Rakefile", "bin/wiiremotejruby", "lib/wiiremotejruby.rb", "lib/wiiremotejruby/wii_remote.rb", "lib/wiiremotejruby/wiimotable.rb", "lib/wiiremotejruby_utils.rb"]
  s.homepage = %q{http://github.com/Neurogami/wiiremotejruby/tree/master}
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ }
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Nicer Ruby wrapper using the WiiRemoteJ library.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bones>, [">= 2.5.0"])
    else
      s.add_dependency(%q<bones>, [">= 2.5.0"])
    end
  else
    s.add_dependency(%q<bones>, [">= 2.5.0"])
  end
end
