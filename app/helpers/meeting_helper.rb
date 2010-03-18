module MeetingHelper
  
  def minutes_in_intervals_of minutes=5
    (0..59).collect do |m| 
      if ((m%minutes)==0)
        if m > 9
          m.to_s
        else
          "0#{m}"
        end
      end
    end.compact
  end

end
