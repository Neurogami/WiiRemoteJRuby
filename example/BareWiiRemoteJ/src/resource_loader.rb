class Object
  def load_resource(path)
    begin 
      com.neurogami.ResourceLoader.new.get_resource(path)
    rescue Exception
      STDERR.puts "Error calling com.neurogami.ResourceLoader.new.get_resource('#{path}') #{$!}"
      raise
    end 
  end
end
