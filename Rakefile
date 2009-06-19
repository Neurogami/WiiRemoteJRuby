# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'wiiremotejruby_utils'

task :default do
  puts "There is no default task."
end

PROJ.name = 'wiiremotejruby'
PROJ.authors = 'James Britt / Neurogami'
PROJ.email = 'james@neurogami.com'
PROJ.url = 'http://github.com/Neurogami/wiiremotejruby/tree/master'
PROJ.version = Neurogami::WiiRemoteJRuby::VERSION
#PROJ.rubyforge.name = 'wiiremotejruby'
PROJ.readme_file = 'README.md'
PROJ.summary = "Nicer Ruby wrapper using the WiiRemoteJ library."
PROJ.spec.opts << '--color'

# EOF
