Dir.glob(File.expand_path(File.dirname(__FILE__) + "/**/*").gsub('%20', ' ')).each do |directory|
  $:.push(directory) unless directory =~ /\.\w+$/
end


#===============================================================================
# This pulls in the requisite libraries needed for
# Monkeybars to operate.

require 'resolver'

def monkeybars_jar path
  Dir.glob(path).select { |f| f =~ /(monkeybars-)(.+).jar$/}.first
end

case Monkeybars::Resolver.run_location
when Monkeybars::Resolver::IN_FILE_SYSTEM
  here = File.expand_path File.dirname(__FILE__)
  _mbj = monkeybars_jar( here + '/../lib/java/*.jar' )
  raise "Failed to locate a monkeybars jar!" unless _mbj 
  add_to_classpath _mbj 
  require _mbj 
end

require 'monkeybars'
require 'application_controller'
require 'application_view'

# End of Monkeybars requires
#===============================================================================


# Add your own application-wide libraries below.  To include jars, append to
# $CLASSPATH, or use add_to_classpath, for example:
# 
# $CLASSPATH << File.expand_path(File.dirname(__FILE__) + "/../lib/java/swing-layout-1.0.3.jar")
#
# is equivalent to
#
# add_to_classpath "../lib/java/swing-layout-1.0.3.jar"
#
# There is also a helper for adding to your load path and avoiding issues with file: being
# appended to the load path (useful for JRuby libs that need your jar directory on
# the load path).
#
# add_to_load_path "../lib/java"
#

case Monkeybars::Resolver.run_location
when Monkeybars::Resolver::IN_FILE_SYSTEM
  # Files to be added only when running from the file system go here
  add_to_classpath monkeybars_jar( '../lib/java/' )
when Monkeybars::Resolver::IN_JAR_FILE
  # Files to be added only when run from inside a jar file
end

if Config::CONFIG["target_os"] =~ /linux|darwin/
  add_to_classpath '../lib/java/bluecove-gpl-2.1.0.jar'
  add_to_classpath '../lib/java/bluecove-2.1.0.jar'
end

add_to_classpath "../lib/java/WiiRemoteJ.jar"

#### Copied over from a working version

module WiiRemoteJ
  include_package  'wiiremotej'
end

module WiiRemoteJEvent
  include_package 'wiiremotej.event'
end

include WiiRemoteJ
include WiiRemoteJEvent

case Monkeybars::Resolver.run_location
when Monkeybars::Resolver::IN_FILE_SYSTEM
  add_to_classpath "../package/classes"
  # Files to be added only when running from the file system go here
when Monkeybars::Resolver::IN_JAR_FILE
  # Files to be added only when run from inside a jar file
  add_to_classpath "bluecove-2.1.0.jar"
  add_to_classpath "WiiRemoteJ.jar"
end



