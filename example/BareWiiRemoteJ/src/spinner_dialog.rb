require 'resource_loader'

class SpinnerDialog < javax.swing.JDialog
  def initialize(messages, parent=nil, modal=nil)
    unless parent.nil? && modal.nil?
      super
    else
      super()
    end
    @messages = messages
    initialize_components
  end

  def initialize_components
    content_pane.layout = nil
    self.always_on_top = true
    #self.undecorated = true
    self.set_size 220, 185
    position_to_center
    @loading_labels = []

    @messages.each do |msg|
      @loading_labels << javax.swing.JLabel.new
      add @loading_labels.last
      @loading_labels.last.text = msg 
    end

    @image_label = javax.swing.JLabel.new
    begin 
      @image_label.icon = javax.swing.ImageIcon.new load_resource('images/spinner3.gif')
    rescue Exception
      warn "Error loading icon image: #{$!}"
      # raise
    end
    add @image_label

    #center the image
    @image_label.set_bounds self.width / 2 - 26, self.height / 2 - 50 ,32,32
    label_base = self.height / 3 
    @loading_labels.each_with_index do |label, i|
      label.set_bounds  10 , label_base += 24*1 , 200, 16
    end
  end

  def position_to_center
    screen_size = java.awt.Toolkit.default_toolkit.screen_size
    self.set_location((screen_size.width - width) / 2, (screen_size.height - height) /2 )
  end


end
