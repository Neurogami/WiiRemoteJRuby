## The current date is: Tue 03/26/2013  : 17:52:01.19
module Neurogami
  module SwingSet
    module MiG
      module ClassMethods

        HERE = File.expand_path(File.dirname __FILE__ )

        def in_jar?
          warn ". . . . SwingSet#in_jar? has HERE = '#{HERE}' . . . . "
          HERE =~ /(^jar:)|(^file)/ 
        end


        def jar_dir
          raise "Do not call 'jsr_dir' if you are not in a jar!" unless in_jar?
          java_import 'org.monkeybars.rawr.Path'
          File.dirname(org.monkeybars.rawr::Path.new.get_jar_path)
        end

        def mig_jar glob_path = File.expand_path("#{HERE}/../../java/*.jar")
          # See  http://stackoverflow.com/questions/9730660/get-jruby-jar-path 
          if in_jar?
            java_import 'org.monkeybars.rawr.Path'
            glob_path  = "#{jar_dir}/lib/java/*" 
          end

          if glob_path =~ /jar!/
            warn ". . . . SwingSet#mig_jar is adjusting path '#{glob_path}' . . . . "
            glob_path = glob_path.split( 'jar!/').last
          end

          _  = Dir.glob(glob_path).select { |f| f =~ /(miglayout-)(.+).jar$/}.first
          raise "Failed to locate MiG jar!" unless _
          _
        end

        def mig_layout
          require mig_jar  
        end

      end

      def self.included(base)
        base.extend(MiG::ClassMethods)
      end

      def mig_layout layout_spec
        Java::net::miginfocom::swing::MigLayout.new layout_spec
      end

    end

    module Core
      module SwingConstants
       %w{
        BOTTOM
        CENTER
        EAST
        HORIZONTAL
        LEADING
        LEFT
        NEXT
        NORTH
        NORTH_EAST
        NORTH_WEST
        PREVIOUS
        RIGHT
        SOUTH
        SOUTH_EAST
        SOUTH_WEST
        TOP
        TRAILING
        VERTICAL
        WEST}.each do  |konst|
         class_eval "#{konst} = Java::javax::swing::SwingConstants::#{konst}"
        end
      end

      class Dimension
        def self.[](width, height)
          java::awt::Dimension.new width, height
        end
      end

      class ImageIcon
        def self.load  image_path 
          javax.swing.ImageIcon.new load_resource image_path
        end
      end

      class GroupLayout
        def self.get content_pane
          org.jdesktop.layout.GroupLayout.new content_pane 
        end
      end

      class Button < Java::javax::swing::JButton
        def initialize
          super
          yield self if block_given?
        end
      end

      class MenuBar < Java::javax.swing.JMenuBar
        def initialize
          super
          yield self if block_given?
        end
      end

      class MenuItem  < Java::javax.swing.JMenuItem
        def initialize
          super
          yield self if block_given?
        end
      end

      class Menu  < Java::javax.swing.JMenu
        def initialize
          super
          yield self if block_given?
        end
      end

      class Font < Java::java.awt.Font
      end

      # A label  wrapper
      # See http://xxxxxxxx to understand Swing labels
      class Label < Java::javax::swing::JLabel

        @@default_font = java::awt.Font.new "Lucida Grande", 0, 12

        def self.default_font= default_font
          @@default_font = default_font
        end

        def self.default_font
          @@default_font 
        end

        # This cause some stupid Java cast error nonsense
        #def initialize text=nil
        #  super
        #  self.text = text.to_s
        #  self.font = Label.default_font
        #  yield self if block_given?
        #end

        def minimum_dimensions width, height
          self.minimum_size = java::awt::Dimension.new width, height
        end

        def prefered_dimensions width, height
          self.prefered_size = java::awt::Dimension.new width, height
        end
      end


      class TextField < Java::javax.swing.JTextField

        @@default_font = java::awt.Font.new "Lucida Grande", 0, 12

        def self.default_font= default_font
          @@default_font = default_font
        end

        def self.default_font
          @@default_font 
        end

        def initialize text = nil
          super
          self.text = text.to_s
          self.font = Label.default_font

          yield self if block_given?
        end

        def minimum_dimensions width, height
          self.minimum_size = java::awt::Dimension.new width, height
        end

        def prefered_dimensions width, height
          self.preferred_size =  java::awt::Dimension.new width, height
          self.setPreferredSize  java::awt::Dimension.new width, height
        end

      end

      class LayeredPane < javax::swing.JLayeredPane
        def background_color red, blue, green
          self.background = java::awt::Color.new red.to_i, blue.to_i, green.to_i
        end

        def size width, height
          self.preferred_size =  java::awt::Dimension.new width, height
        end

        def add_ordered_components *components
          components.each do |c|
            self.add c
          end

          components.each do |c|
            self.moveToFront c
          end
        end
      end

      class Panel < javax::swing.JPanel
        def background_color red, blue, green
          self.background = java::awt::Color.new red.to_i, blue.to_i, green.to_i
        end

        def size width, height
          self.preferred_size =  java::awt::Dimension.new  width, height
        end
      end

      class Frame  < Java::javax::swing::JFrame
        attr_accessor :minimum_height, :minimum_width

        def initialize *args
          super
        end

        def define_minimum_size width, height
          self.minimum_size = java::awt::Dimension.new width, height 
        end

        def minimum_height= height
          define_minimum_size  @minimum_width.to_i, @minimum_height = height.to_i
        end

        def minimum_width= width
          define_minimum_size  @minimum_width = width.to_i, @minimum_height.to_i
        end
      end
    end
  end
end

