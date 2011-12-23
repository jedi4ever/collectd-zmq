require 'rubygems'
require 'collectd'

Collectd.add_server(interval=2, addr="127.0.0.1", port=2345)
Stats = Collectd.my_process(:woo_data)
Stats.with_full_proc_stats
sleep 20
