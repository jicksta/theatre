require 'rubygems'
require 'theatre'

theatre = Theatre::Theatre.new

theatre.namespace_manager.register_namespace_name "printer"
theatre.register_callback_at_namespace("printer", lambda {
  events.printer.each do |event|
    p event
  end
}

theatre.start!

theatre.trigger("framework", 123)
theatre.gracefully_stop!
theatre.join

puts "Shutting down"