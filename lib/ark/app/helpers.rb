module Ark::AppHelpers
  def timeago(time, options = {})
    start_date = options.delete(:start_date) || Time.new
    date_format = options.delete(:date_format) || :default
    delta_minutes = (start_date.to_i - time.to_i).floor / 60
    if delta_minutes.abs <= (8724*60)       
      distance = distance_of_time_in_words(delta_minutes)       
      if delta_minutes < 0
        return "#{distance} from now"
      else
        return "#{distance} ago"
      end
    else
      return "on #{DateTime.now.to_formatted_s(date_format)}"
    end
  end
  
  def distance_of_time_in_words(minutes)
    case
    when minutes < 1
     "less than a minute"
    when minutes < 50
     "#{minutes} minute#{minutes==1?'':'s'}"
    when minutes < 90
     "about one hour"
    when minutes < 1080
     "#{(minutes / 60).round} hours"
    when minutes < 1440
     "one day"
    when minutes < 2880
     "about one day"
    else
     "#{(minutes / 1440).round} days"
    end
  end
  
  def format_bytes(num)
    Format.filesize(num)
  end
end

class Format
  FILESIZE_UNITS = %w[ bytes kilobytes megabytes gigabytes ]
  
  def self.filesize(bytes, precision = 1)
    new(bytes).to_s(precision)
  end
  
  def initialize(bytes)
    @bytes = bytes.to_f
  end
  
  def units
    FILESIZE_UNITS.inject("bytes") do |method,current|
      1.send(current) <= @bytes ? current : method
    end
  end
  
  def humanized_units
    bytes == 1 ? units.to_s.sub(/s$/, '') : units.to_s
  end
  
  def bytes
    @bytes / 1.send(units)
  end
  
  def to_s(precision = 1)
    precision = 0 if units == "bytes"
    "%.#{precision}f %s" % [ bytes, humanized_units ]
  end
end

class Numeric
  def bytes
    self
  end
  alias_method :byte, :bytes
  alias_method :b, :bytes
  
  def kilobytes
    self * 1024
  end
  alias_method :kilobyte, :kilobytes
  alias_method :kb, :kilobytes
  
  def megabytes
    self * 1024.kilobytes
  end
  alias_method :megabyte, :megabytes
  alias_method :mb, :megabytes
  
  def gigabytes
    self * 1024.megabytes
  end
  alias_method :gigabyte, :gigabytes
  alias_method :gb, :gigabytes
end