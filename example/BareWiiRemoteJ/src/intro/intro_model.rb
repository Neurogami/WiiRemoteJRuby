require 'utils'


class IntroModel

  # From -Math::PI to Math::PI
  def pitch
    @acceleration_event ?  @acceleration_event.pitch : 0.0
  end

  
  def normalized_pitch min, max
    _ = if pitch < 0.0 ||  pitch.nan?
       0.0
        else
      pitch
    end
    _.translate -Math::PI, Math::PI, max, min
  end

  #  the roll of the remote, in radians from 0 to 2PI. 
  #  However, sometimes the value is -1.5707963267948966 
  #  And always that special number. 
  def roll
    @acceleration_event ?  @acceleration_event.roll : 0.0
  end

# Account for the odd occurence of the negative value, which might be
  # some weird represnetation of NaN or something.
  def normalized_roll  min, max
    _ = if roll < 0.0
         Math::PI # Default to flat, no roll
        else
      roll
    end
    _.translate 0, 2*Math::PI, min, max
  end


  def acceleration_event= e
    @acceleration_event = e # AccelerationEvent
    if e.roll < 0.0 
      warn "* * * * * @acceleration_event roll is #{e.roll} * * * * "
    end
  end


end
