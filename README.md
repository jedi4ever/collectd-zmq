_NOTE:_ not yet fully functional, almost there with parsing the value parts

### What is this project about:

There is not one monitoring project to rule them all:

Ganglia, Graphite, Collectd, Opentsdb, ... they all have their specific unique functionality and their associate unique storage.

Instead of trying to create one central storage, we want to send the different metric information, to each monitoring solution for their optimized function.

This project's code will:

- listen into the collectd protocol 

From there, other subscribers can pull the information into graphite, collectd, opentsdb etc..

We have deliberately chosen not to go for peer to peer communication, but for a bus/queue oriented system.

It currently doesn't do more than put things on the queue, the next step is to write subscribers for the other monitoring systems.

And maybe , just maybe,  this will evolve into a swiss-army knife of monitoring/metrics conversion ....

### Requirements:
#### Centos

    # yum install libxml2-devel
    # yum install libxslt-devel
    # yum install zeromq-devel
    # yum install uuid-devel
    # yum install json-c-devel

### Configuring collectd clients

<http://collectd.org/wiki/index.php/Networking_introduction#Multiple_servers>

    <Plugin "network">
      Server "127.0.0.1" "2345"
    </Plugin>

### Running it:

    collectd-zmq - A collectd UDP receiver that pushes things to a 0mq Pub/Sub

    Usage: collectd-zmq [-p port] [-P file] [-d] [-k]
           collectd-zmq --help

        -p, --port PORT           Specify port
                                  (default: 2345)
        -P, --pid FILE            save PID in FILE when using -d option.
                                  (default: /var/run/collectd-zmq.pid)
        -d, --daemon              Daemonize mode
        -k, --kill [PORT]         Kill specified running daemons - leave blank to kill all.
        -u, --user USER           User to run as
        -G, --group GROUP         Group to run as
            --zmq-port [PORT]     tcp port of the zmq publisher, 7777 default
            --zmq-host [HOST]     hostname/ip address of the zmq publisher
        -v, --verbose             more verbose output
        -t, --test-zmq            Starts a test zmq subscriber
        -?, --help                Display this usage information.

### Message examples

### Some inspiration:

- [The collectd binary protocol](http://collectd.org/wiki/index.php/Binary_protocol)
- [Astro's ruby-collect Gem| Packet specification](https://github.com/astro/ruby-collectd/blob/master/lib/collectd/pkt.rb)
