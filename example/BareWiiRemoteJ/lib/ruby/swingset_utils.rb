module Neurogami
  module SwingSet

    IN_FILE_SYSTEM = :in_file_system
    IN_JAR_FILE = :in_jar_file

    LOCAL_NAME = 'swingset-local'

    # :stopdoc:
    VERSION = '0.4.2'
    LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
    PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
    # :startdoc:

    # Returns the version string for the library.
    #
    def self.version
      VERSION
    end

    # Returns the library path for the module. If any arguments are given,
    # they will be joined to the end of the libray path using
    # <tt>File.join</tt>.
    #
    def self.libpath *args 
      args.empty? ? LIBPATH : ::File.join(LIBPATH, args.flatten)
    end

    # Returns the lpath for the module. If any arguments are given,
    # they will be joined to the end of the path using
    # <tt>File.join</tt>.
    #
    def self.path *args 
      args.empty? ? PATH : ::File.join(PATH, args.flatten)
    end


    # Returns a const value indicating if the currently executing code is being run from the file system or from within a jar file.
    def self.run_location
      if File.expand_path(__FILE__) =~ /\.jar\!/
        IN_JAR_FILE
      else
        IN_FILE_SYSTEM
      end
    end

    # Utility method used to rquire all files ending in .rb that lie in the
    # directory below this file that has the same name as the filename passed
    # in. Optionally, a specific _directory_ name can be passed in such that
    # the _filename_ does not have to be equivalent to the directory.
    #
    def self.require_all_libs_relative_to fname, dir = nil 
      if run_location == IN_FILE_SYSTEM
        dir ||= ::File.basename(fname, '.*')
        search_me = ::File.expand_path( ::File.join(::File.dirname(fname), dir, '**', '*.rb'))
        Dir.glob(search_me).sort.each {|rb| require rb}
      else
        require "swingset/#{LOCAL_NAME}"
      end
    end


    def self.find_mig_jar glob_path
      Dir.glob(glob_path).select { |f| 
        f =~ /(miglayout-)(.+).jar$/}.first
    end

    def self.copy_over_mig path = 'lib/java'
      require 'fileutils'

      java_lib_dir = File.join File.dirname( File.expand_path(__FILE__) ),  'java'
      mig_jar = find_mig_jar "#{java_lib_dir}/*.jar"

      raise "Failed to find MiG layout jar to copy over from '#{java_lib_dir}'!" unless mig_jar 

      if File.exist? "#{path}/#{mig_jar}"
        warn "It seems that the miglayout jar file already exists. Remove it or rename it, and try again."
        exit
      end

      FileUtils.mkdir_p path unless File.exists? path
      warn "************ Have mig jar at #{mig_jar} ************ "
      FileUtils.cp_r mig_jar, path, :verbose =>  true
    end

    def self.copy_over
      copy_over_ruby
      copy_over_mig
    end

    def self.copy_over_ruby path = 'lib/ruby'
      require 'fileutils'

      here = File.dirname(File.expand_path(__FILE__))

      if File.exist?("#{path}/swingset.rb") || File.exist?("#{path}/swingset")
        warn "It seems that the swingset files already exist. Remove or rename them, and try again."
        exit
      end

      FileUtils.mkdir_p path unless File.exists? path
      FileUtils.cp_r "#{here}/swingset",          path + "/#{LOCAL_NAME}",     :verbose =>  true
      FileUtils.cp_r "#{here}/swingset.rb",       path + "/#{LOCAL_NAME}.rb",  :verbose =>  true
      FileUtils.cp_r "#{here}/swingset_utils.rb", path,                        :verbose =>  true
    end

  end  # module Swingset
end


# EOF

if $0 == __FILE__
  java_lib_dir = File.join File.dirname( File.expand_path(__FILE__) ),  'java'
  warn  java_lib_dir
  warn Neurogami::SwingSet.find_mig_jar "#{java_lib_dir}/*.jar"

end
