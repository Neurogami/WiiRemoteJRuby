class Java::WiiremotejEvent::WRButtonEvent

  def details= h
    @details = h
  end

  def details
    @details || {}
  end
end

module Neurogami

  class Wiimote

    def self.attach owner, map = {}
      @owner = owner

      warn "Finding remote .." 

      remote = nil

      begin
        remote = WiiRemoteJ::WiiRemoteJ.findRemote
        warn "remote: #{remote.pretty_inspect}"
      rescue Exception
        warn "Error calling findRemote: #{$!}"
        raise
      end

      unless remote
        sleep 2
        raise "Wiimote class could not attache to Wiimote!"
      end


      listener = WiiRemoteListener.new(remote)
      listener.event_map(owner, map ) 
      remote.addWiiRemoteListener(listener)
      remote.accelerometerEnabled = true

      # Need this if you want to track IR events
      #remote.setIRSensorEnabled(true, WiiRemoteJEvent::WRIREvent.FULL, WiiRemoteJ::IRSensitivitySettings::WII_LEVEL_4)
      #  remote.enableContinuous

      # This works, giving both IR and pitch, roll info
      remote.setIRSensorEnabled(true, WiiRemoteJEvent::WRIREvent.BASIC, WiiRemoteJ::IRSensitivitySettings::WII_LEVEL_3)

      # But this only gives IR data; pitch  stuff ends up NaN or zero
      #remote.setIRSensorEnabled(true, WiiRemoteJEvent::WRIREvent.FULL, WiiRemoteJ::IRSensitivitySettings::WII_LEVEL_3)

#      remote.setIRSensorEnabled(true, WiiRemoteJEvent::WRIREvent.EXTENDED, WiiRemoteJ::IRSensitivitySettings::WII_LEVEL_3)
     # remote.enableContinuous
      remote.setLEDIlluminated(0, true);

      remote
    end
  end


  def add_to_mappings map 
    STDERR.puts( ":DEBUG #{__FILE__}:#{__LINE__}" ) if ENV['JAMES_SCA_JDEV_MACHINE'] # JGBDEBUG 
    listener = WiiRemoteListener.new(self)
    listener.event_map(nil, map ) 
    self.addWiiRemoteListener(listener)
    # remote.accelerometerEnabled = true
    self
  end

  class WiiRemoteListener
    @@button_masks = {}

    def initialize remote
      @remote = remote
      @accelerometer_source = true #//true = wii remote, false = nunchuk
      warn "   Created WiiRemoteListener"
      STDERR.puts( ":DEBUG #{__FILE__}:#{__LINE__}" ) if ENV['JAMES_SCA_JDEV_MACHINE'] # JGBDEBUG 
    end

    def event_map owner, map={}
      @owner = owner
      @maps ||= []
      @maps <<   map
    end

    def accelerometer_source
      @accelerometer_source
    end

    def combined_input_received evt
    end

    # So: There are several different buttons tha can be pressed
    # The wiimote jar thing does not offer a way to simply *ask* for
    # the button value.  Instead, you have to play 20 questions.
    #
    # 
    def button_input_received event
      dispatch_on_button event
    end

    def maps_contain key
      @maps.each do |map|
        return true if map[key]
      end
      false
    end

    def maps_handle_event event_key, event
      @maps.each do |map|
        map[event_key].call event
      end
    end

    def acceleration_input_received event
      return unless maps_contain :motion_sensing_event
      maps_handle_event :motion_sensing_event, event
    end

    # 
    def IRInputReceived  event
      return unless maps_contain :ir_sensing_event
      maps_handle_event :ir_sensing_event, event

    end


    def method_missing m, *args
      m =  "  WiiRemoteListener mm: #{m}, #{args.inspect}"
      STDERR.puts( ":DEBUG #{__FILE__}:#{__LINE__}\n#{}" ) if ENV['JAMES_SCA_JDEV_MACHINE'] # JGBDEBUG 
    end


    # Here's the thing:
    #  A user can be doing any number of things with buttons, including
    #  pressing multiple buttons, holding buttons down, releasing buttons.
    #
    #  We might want to loop over the mapping and only see if we have
    #  a matching event.
    #  For example, 
    #   :wiimote_button_b maps to the B button pressed.
    #   :wiimote_button_b_wiimote_button_a would map to both A  + B pressed.
    #  We still get lots of combos:
    #   :wiimote_button_b_only
    #
    #   There's also 'is' and 'was' ... ?
    #
    #   and 'released'
    #
    #     :wiimote_button_b_was_released
    #
    #  We need some formal syntax so we can create code:
    #
    #  :wiimote_button_<x>_<action>
    #
    #  isAnyPressed(int buttonMask)
    #          Returns true if any of the given buttons are pressed; otherwise false.
    # boolean 	isOnlyPressed(int buttonMask)
    #          Returns true if all of the given buttons are pressed and no others are; otherwise false.
    # boolean 	isPressed(int buttonMask)
    #          Returns true if all of the given buttons are pressed; otherwise false.
    # boolean 	wasOnlyPressed(int buttonMask)
    #          Returns true if all of the given buttons were pressed and no others are; otherwise false.
    # boolean 	wasPressed(int buttonMask)
    #          Returns true if all of the given buttons were pressed; otherwise false.
    # boolean 	wasReleased(int buttonMask)
    #          Returns true if one of the given buttons wa
    #
    # We need to figure out, for each mapping, the button mask, and then the action to
    # look for.
    #  Given - 
    #       { :buttons => :two, :action => :only_pressed }   => lambda {|e| exit_button_action_performed e },
    #      { :buttons => [:two, :b], :action => :released }   => lambda {|e| release_example e },
    #   
    ##
    def dispatch_on_button event

      @maps.each do |map|

        map[:buttons].each do |m|
          mask = buttons_to_mask(m[:buttons])
          action = m[:action]
          # Can we do some dynaimic invokation here?
          event.details = {:buttons => m[:buttons] , :action => action };
          case action
          when :any_pressed
            m[:handler].call(event)  if event.isAnyPressed(mask)
          when :is_only_pressed
            m[:handler].call(event)  if event.isOnlyPressed(mask)
          when :pressed
            m[:handler].call(event)  if event.isPressed(mask)
          when :was_only_pressed
            m[:handler].call(event) if event.wasOnlyPressed(mask)
          when :was_pressed
            m[:handler].call(event)  if event.wasPressed(mask)
          when :was_released
            m[:handler].call(event)  if event.wasReleased(mask)
          end

        end
      end

    end


    def buttons_to_mask buttons
      if buttons.is_a?(Array)
        mask = 0
        buttons.each do |button| 
          @@button_masks[button] ||= eval "WiiRemoteJEvent::WRButtonEvent::#{button.to_s.upcase}"
          mask  =+ @@button_masks[button]  
        end
        mask
      else
        @@button_masks[buttons] ||= eval "WiiRemoteJEvent::WRButtonEvent::#{buttons.to_s.upcase}"
        @@button_masks[buttons]
      end
    end
  end
end

