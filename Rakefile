# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
#  Bones.setup
rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'

end

ensure_in_path 'lib'
require 'wiiremotejruby_utils'
task :default do
  puts "There is no default task."
end



Bones {

  name  'WiiRemoteJRuby'
 authors  'James Britt'
 email  'james@neurogami.com'
 url  'http:// neurogami.com/code'
 version  Neurogami::WiiRemoteJRuby::VERSION

}
# EOF
