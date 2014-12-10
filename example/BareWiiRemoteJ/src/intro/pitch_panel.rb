require 'swingset'
include  Neurogami::SwingSet::Core


class PitchPanel < Panel

  HEIGHT_OFFSET = 1 # 

  def initialize
    #   super # You will need this if you decide to 'self'
    #   otherwise you get "RuntimeError - Java wrapper with no contents:" 
    @rads = 0.0
  end

  def normalized_value  
    _ = if @rads.nan?
          0.0
        else
          @rads * -1
        end
# Facing down is neg, up positive, but we want this reversed
#    _.translate -Math::PI, Math::PI, 0, getHeight-HEIGHT_OFFSET 
    _.translate -1.5, 1.5, 0, getHeight
  end

  def angle_radians= rads
    @rads = rads * -1
    repaint
    #warn "===================== @rads  = #{@rads}; angle_radians = #{rads} #{getWidth}:#{getHeight} ==================== "
  end

  # Note: When calling Java stuff from JRuby you can usually 
  # use Ruby-stlye naming conventions.
  # For example, 
  #    setFoo(n) 
  #  can be called using
  #    foo = n
  #  
  #  or 
  #     calcSomeValue 
  #  can be used as 
  #     calc_some_value
  #
  # But paintComponent seems to only get called when you
  # override it using the Java name
  def paintComponent g

#     warn "******************************* paintComponent PitchPanel  #{@rads} => #{normalized_value} [#{getHeight}] ******************************"
    g.color = java::awt::Color::GREEN

    # drawLine takes x1, y1, x2, y2 
    g.drawLine 0, 0, getWidth, 0  
    g.color = java::awt::Color::RED
    g.drawLine 0, getHeight-HEIGHT_OFFSET , getWidth, getHeight-HEIGHT_OFFSET 
    g.color = java::awt::Color::BLACK
    g.drawLine 0, normalized_value, getWidth, normalized_value   
    g.dispose  # Is this needed?
  end

end


