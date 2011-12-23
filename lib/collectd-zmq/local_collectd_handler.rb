require 'uuid'
require 'collectd'
require 'json'
require 'collectd-zmq/collectd_packet'

Thread.abort_on_exception = true

# Passing params to an EM Connection
#  http://stackoverflow.com/questions/3985092/one-question-with-eventmachine

class LocalCollectdHandler < EM::Connection
  attr_accessor :zmq_push_socket
  attr_accessor :verbose

  def receive_data packet

    data=CollectdPacket.new(packet)

    # Check if it was a valid data request
    unless data.nil?
      # We currently assume this goes fast
      # send Topic, Body
      # Using the correct helper methods - https://github.com/andrewvc/em-zeromq/blob/master/lib/em-zeromq/connection.rb

      message=Hash.new
      message['id'] = UUID.new.generate
      message['timestamp'] = Time.now.to_i
      message['context'] = "METRIC"
      message['source'] = "COLLECTD"
      message['payload'] = data

      zmq_push_socket.send_msg('gmond', message.to_json)
    end


    # If not, we might need to defer the block
    # # http://www.igvita.com/2008/05/27/ruby-eventmachine-the-speed-demon/
    # # Callback block to execute once the parsing is finished
    # operation = proc do
    # end
    #
    # callback = proc do |res|
    # end
    # # Let the thread pool (20 Ruby Threads handle request)
    # EM.defer(operation,callback)

  end

end
