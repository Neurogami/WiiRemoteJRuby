require 'wiimotable'


class IntroController < ApplicationController
  set_model 'IntroModel'
  set_view  'IntroView'


  include Neurogami::Wiimotable # Add this to stock Monkeybars controller code

  #   There seems to be something about MB models where
  #  they are not persistent.  Need to review the MB code and docs
  #  on this.  
  #

  def default_button_action_performed
    transfer[:pitch_text] = "In-line Swing classes from Ruby rulez!"
    signal :set_pitch_text
  end


  def about_menu_action_performed
    AboutController.instance.show
  end


  def exit_menu_action_performed
    close 
  end 

  # You need to define the handlers that are invoked via the mappings

  def exit_button_action_performed event
    sleep 2
    java.lang.System.exit 0
  end

  def motion_sensing_event_action_performed e    # WRAccelerationEvent
    model.acceleration_event = e
    transfer[:pitch_text] = "Pitch: #{e.pitch}"
    signal :set_pitch_text

    #  warn e.yaw # Does this even exist?  Not in WiiRemoteJ

    transfer[:roll_text] = "Roll: #{e.roll}"
    signal :set_roll_text
  end

  def some_action_for_b e
    warn "do_send_note #{e}"
  end

  def stuff_to_do_when_b_released e
    warn "send_note_off #{e}"
  end


  def load

    mappings = {
      :buttons => [
        { :buttons => :home,  :action => :was_released, :handler  => lambda {|e| exit_button_action_performed e } },
        { :buttons => :b,     :action => :was_pressed,  :handler  => lambda {|e| some_action_for_b e } },
        { :buttons => :b,     :action => :was_released, :handler  => lambda {|e| stuff_to_do_when_b_released e } },
        { :buttons => :up,    :action => :was_released, :handler  => lambda {|e| do_up e } },
        { :buttons => :down,  :action => :was_released, :handler  => lambda {|e| do_down e } },

    ],
    :motion_sensing_event => lambda{|e|  motion_sensing_event_action_performed e },
    #      :ir_sensing_event     => lambda{|e|  move_pitch_pointer e  }
    }



    # Neurogami::WiimoteEventListener code doesn't know anything about these lambdas, so it
    # makes the assumption that they accept a single argument: the source event.
    # You are free to ignore this argument in the lambda, but you have to account
    # for it being part of the invocation or you'll get an error.
    #

    # You do not have to map all possible Wii events, just those you care about.

    # Now create a Wiimote event listner, passing in the mappings,
    # and the number of times to prompt the user to connect before giving up.
    # If you omit this number, the application will prompt the user forever.
    wiimote_me  mappings, 3


  end



end
