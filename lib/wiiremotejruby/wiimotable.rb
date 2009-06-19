require 'spinner_dialog'

class GlobalWiimote

  @@wiimote = nil

  def self.wiimote
    @@wiimote
  end

  def self.wiimote= wiimote
    @@wiimote = wiimote
  end

  def self.add_to_mappings wiimote, map 
    listener = Neurogami::WiiRemoteListener.new(wiimote)
    listener.event_map(nil, map ) 
    wiimote.addWiiRemoteListener(listener)
    wiimote
  end

end

module Neurogami

  module Wiimotable
    def wiimote_me event_map, max_attempts = nil
      unless GlobalWiimote.wiimote 
        attempts_so_far = 0
        begin
          attempts_so_far += 1
          transfer[:attempt_number] = attempts_so_far
          signal :set_discovery_mode
          GlobalWiimote.wiimote  =  Wiimote.attach self, event_map
          GlobalWiimote.wiimote.setLEDIlluminated(0, true);
        rescue  Exception => e
          signal :end_discovery_mode
          if max_attempts.nil? || attempts_so_far < max_attempts
            retry
          else
            raise e
          end
        end
      else
        #                GlobalWiimote.wiimote  =  Wiimote.attach self, event_map
        GlobalWiimote.add_to_mappings GlobalWiimote.wiimote, event_map 
      end
    ensure
      signal :end_discovery_mode
      GlobalWiimote.wiimote
    end

    def clean_up_and_exit
      GlobalWiimote.wiimote.setLEDIlluminated(0, false);
      GlobalWiimote.wiimote.disconnect
      java.lang.System.exit(0)
    end
  end



  module WiimotableView

    def set_discovery_mode model, transfer
      begin
        @spinner = SpinnerDialog.new(["Attempt #{transfer[:attempt_number] }", "Press buttons 1+2 together ..."])
        @spinner.visible = true
      rescue  Exception
        warn "Error creating SpinnerDialog: #{$!}"
        raise
      end
    end

    def end_discovery_mode model, transfer
      return unless @spinner
      @spinner.visible = false
      @spinner.hide
      @spinner = nil
    end
  end

end
