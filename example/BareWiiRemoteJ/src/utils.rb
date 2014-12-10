
class Numeric
  def scale_between from_min, from_max, to_min, to_max
    ((to_max - to_min) * (self - from_min)) / (from_max - from_min) + to_min
  end

  def translate left_min, left_max, right_min, right_max
    # Figure out how 'wide' each range is
    left_span = left_max - left_min
    right_span = right_max - right_min

    # Convert the left range into a 0-1 range (float)
    value_scaled = (self - left_min).to_f / left_span.to_f

    # Convert the 0-1 range into a value in the right range.
    right_min + value_scaled * right_span
  end

end

