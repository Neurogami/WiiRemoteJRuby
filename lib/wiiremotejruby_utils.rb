require 'fileutils'

module Neurogami
  module WiiRemoteJRuby

    # :stopdoc:
    VERSION = '0.2.0'
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
    def self.libpath( *args )
      args.empty? ? LIBPATH : ::File.join(LIBPATH, args.flatten)
    end

    # Returns the lpath for the module. If any arguments are given,
    # they will be joined to the end of the path using
    # <tt>File.join</tt>.
    #
    def self.path( *args )
      args.empty? ? PATH : ::File.join(PATH, args.flatten)
    end

    # Utility method used to rquire all files ending in .rb that lie in the
    # directory below this file that has the same name as the filename passed
    # in. Optionally, a specific _directory_ name can be passed in such that
    # the _filename_ does not have to be equivalent to the directory.
    #
    def self.require_all_libs_relative_to( fname, dir = nil )
      dir ||= ::File.basename(fname, '.*')
      search_me = ::File.expand_path(
                                     ::File.join(::File.dirname(fname), dir, '**', '*.rb'))
                                     Dir.glob(search_me).sort.each {|rb| require rb}
    end


    def self.copy_over base_path = 'lib/ruby/', end_dir = 'wiiremotejruby'
      full_path = base_path + end_dir
      require 'fileutils'
      files =  %w{wiimotable.rb wii_remote.rb }
      here = File.dirname(File.expand_path(__FILE__))

      FileUtils.mkdir_p(base_path) unless File.exist?(base_path)
      FileUtils.mkdir_p(full_path ) unless File.exist?(full_path )

      files.each do |file|
        if File.exist? "#{full_path }/#{file}"
          warn "It seems that the wiiremotejruby files already exist. Remove or rename them, and try again."
          exit
        end
        FileUtils.cp_r "#{here}/wiiremotejruby/#{file}", full_path , :verbose =>  true
      end
    end

  end 
end

