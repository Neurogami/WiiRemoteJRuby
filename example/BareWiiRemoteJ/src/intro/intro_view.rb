require 'wiimotable'
require 'intro_ui' 

# This is our Monkeybars View code
class IntroView < ApplicationView
  set_java_class IntroFrame  # Defined in intro_ui.rb

  # Signals are a way to have the controller pass requests to the view.
  # To understand Moneybars signals, see:
  #     http://www.monkeybars.org/understanding-signals
  define_signal :name => :set_pitch_text, :handler => :handle_pitch_text
  define_signal :name => :set_roll_text,  :handler => :handle_roll_text
  define_signal :name => :set_roll_rads,  :handler => :handle_roll_rads
  define_signal :name => :set_pitch_rads, :handler => :handle_pitch_rads

  Thread.abort_on_exception = true

  include Neurogami::WiimotableView

  define_signal :name => :set_discovery_mode,   :handler => :set_discovery_mode 
  define_signal :name => :end_discovery_mode,   :handler => :end_discovery_mode 
  define_signal :name => :update_pitch_marker,  :handler => :update_pitch_marker 

  ####### 


  # @load@ is called when the UI is opened.  You can think of it as a subsitute for 'initialize',
  # which, in the parent code, is already used for high-lelve preperations and should not
  # be replaced without a good understanding of how it works.
  #
  # To understand the Monkeybars View lifecycle, see:
  #    http://www.monkeybars.org/understanding-views
  def load
    # Helper method defined in application_view ro all views can use it
     set_frame_icon 'images/mb_default_icon_16x16.png'
    move_to_center # Built in to each Monkeybars View class.
    # Set up some basics content for our UI ...
    pitch_label.text = "Pitch: 0 "
    roll_label.text = "Roll: 0 "
  end

  # This is the method invoked when the view receives the set_new_text signal
  # is received.  All such signal handlers need to accept model and transfer objects.
  #
  # To understand Moneybars signals, see:
  #     http://www.monkeybars.org/understanding-signals
  def handle_pitch_text model, transfer
    pitch_label.text = transfer[:pitch_text]
  end

  def handle_roll_text model, transfer
    roll_label.text = transfer[:roll_text]
  end


  def handle_roll_rads model, transfer
    warn "roll_panel is  #{roll_panel.inspect}" 
    roll_panel.angle_radians = transfer[:roll_rads]
  end

  def handle_pitch_rads model, transfer
    warn "pitch_panel is  #{pitch_panel.inspect}" 
    pitch_panel.angle_radians = transfer[:pitch_rads]
  end

  private

  def set_frame_icon file
    #  This is not working yet   @main_view_component.icon_image = Java::javax::swing::ImageIcon.new(Java::org::monkeybars.rawr.Main.get_resource(file)).image
  rescue Exception => e
    # The weird thing is that this simply breaks the app.
    warn  "Error loading frame icon: #{e.message} "
    warn "Perhaps you do not have the image file '#{file}' in the proper location?"
  end



end
