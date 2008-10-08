# Adds messages to the Theatre with growing intensity

require File.dirname(__FILE__) + "/../lib/theatre.rb"

theatre = Theatre.new

# TODO: Register namespaces here


# As the current time diverges from the start time, enqueue more messages per second
start_time  = Time.now

# This is a function of the number of seconds that have passed since starting. For example, at 10 seconds into the demo,
# we'll be pushing in 13 messages per second. At 100 seconds (1 minute, 40 seconds), we'll be doing 130 messages per second.
growth_rate = 1.3

# We need to keep a running count of how long it takes to actually dispatch a payload into the theatre.
trigger_count = 0
average_time = 0

loop do
  
  seconds_since_start = (Time.now - start_time).to_i
  times_per_second = (time_since_start * growth_rate).to_i

  times_per_second.times do
  
    before_handling = Time.now
    theatre.trigger "/my/special/namespace", :payload
    after_handling = Time.now
    
    trigger_times.push after_handling - before_handling
    
    # Update the running average
    #   count / (count+1) = current_average / reduced_average
    # ∴   reduced_average = (current_average * (count + 1)) / count
    # 
    #         new_average = reduced_average + (data / (count + 1))
    
    trigger_count / (trigger_count + 1)

    sleep average_time
  
  end
  
end