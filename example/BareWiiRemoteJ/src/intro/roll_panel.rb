require 'swingset'
include  Neurogami::SwingSet::Core

class RollPanel < Panel

  def initialize
    #   super # You will need this if you decide to 'self'
    #   otherwise you get "RuntimeError - Java wrapper with no contents:" 
    @rads = 0.0
  end

  def angle_radians= rads
    warn "@rads  = #{@rads}; angle_radians = #{rads}"
    @rads = rads * -1
    repaint
  end

  # Note: When calling Java stuff from JRuby you can usually 
  # use Ruby-stlye naming conventions.
  # For example, 
  #    setFoo(n);
  #  can be called using
  #    foo = n
  #  
  #  or 
  #     calcSomeValue(x); 
  #  can be used as 
  #     calc_some_value x
  #
  # But paintComponent seems to only get called when you
  # override it using the Java name 
  def paintComponent g
    g.color = java::awt::Color::BLACK
    centerX =  getWidth/2
    centerY = getHeight/2
    endX = centerX - getWidth * Math.sin(@rads)
    endY = centerY - getHeight * Math.cos(@rads)
    g.drawLine centerX, centerY, endX, endY
  end

end

