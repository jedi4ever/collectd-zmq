class CollectdPacket
  def initialize(packet)
    @io = StringIO.new(packet)
    require 'pp'
    #1pp packet
    pp packet
    parse
  end

  def parse
    until @io.eof?
      read_part
    end
  end

  def read_part
    type=@io.read(2).unpack('n').first
    length=@io.read(2).unpack('n').first
    case type
    when 0x0000
      puts "Hostname: #{read_string(length-4)}"
    when 1
      puts "Time: #{read_numeric(length-4)}"
    when 0x0008
      puts "Time high resolution"
    when 2
      puts "Plugin: #{read_string(length-4)}"
    when 3
      puts "Plugin Instance: #{read_string(length-4)}"
    when 4
      puts "Type: #{read_string(length-4)}"
    when 5
      puts "Type instance: #{read_string(length-4)}"
    when 6
      read_value(length-4)
    when 7
      puts "Interval: #{read_numeric(length-4)}"
    when 9
      puts "Interval high: #{read_numeric(length-4)}"
    when 0x100
      puts "Message Notification: #{read_string(length-4)}"
    when 0x101
      puts "Severity: #{read_numeric(length-4)}"
    else
      puts "Part of unkown type" 
    end

    puts "#{type} - #{length}"
    #puts value
  end

  def read_string(length)
    value=@io.read(length)
    value.unpack("A#{length}")
  end

  def read_value(length)
    nr=@io.read(2).unpack('n')
    puts "#{nr} values"

    # 8 bit field
    # COUNTER → 0
    # GAUGE → 1
    # DERIVE → 2
    # ABSOLUTE → 3
    data_type=@io.read(1).unpack('C').first.to_i
    puts "#{data_type} data_type"

    # Valye - 64 bit field
    case data_type
    when 0
      # Counter network (big endian) unsigned integer
      value=read_uint
    when 1
      # Gauge x86 (little endian) double
      value=read_double
    when 2
      # Derive (network big endian) signed integer
      value=read_int
    when 3
      # Absolute
      value=read_uint
    end

  end

  def read_uint
    value=@io.read(2)
    i=value.unpack("n")
    puts "i:#{i}"
    @io.read(2)
  end

  def read_int
    value=@io.read(4)
    value.unpack("s")
  end

  def read_double
    value=@io.read(4)
    value.unpack("d")
  end

  def read_numeric(length)
    value=@io.read(length)
    value.unpack("N#{length}")
  end

end
