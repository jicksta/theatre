Theatre
=======

A library for choreographing a dynamically-shaping pool of hierarchially organized actors. This was originally extracted from the [Adhearsion](http://adhearsion.com) framework by Jay Phillips.

Often in Ruby frameworks it's necessary to expose certain callbacks and have different aspects of the framework publish features for other aspects to consume. In Adhearsion, the framework itself has certain hooks. It's important that these events occur independently of each other.

Example
-------

Below is an example taken from Adhearsion for executing framework-level callbacks. Note: the framework treats this callback synchronously.

    events.framework.asterisk.before_call.each do |event|
      # Pull headers from event and respond to it here.
    end

Below is an example of integration with [Stomp](http://stomp.codehaus.org/), a simple yet robust open-protocol message queue.

    events.stomp.new_call.each do |event|
      
    end

This will filter all events whose name is "new_call"

Pre-filters and Post-filters
----------------------------

A Theatre pre-filter is semantically equivalent to a namespace. Registering a callback with a namespace basically sets a custom destination with in a Theatre for actors to act on incoming events.

Creating more messages

Framework terminology
--------------------

Below are definitions of terms I use in Theatre. See the respective links for more information.

* **[Actor](http://en.wikipedia.org/wiki/Actor_model)**: This refers to concurrent responders to events in a concurrent system.
* **[erlang](http://en.wikipedia.org/wiki/Erlang_unit)**: This should not be confused with the functional programming language by Ericsson named Erlang. An erlang is statistical measure of traffic through a single resource which is in continuous use.

Synchronous vs. Asynchronous
----------------------------

With Theatre, all events are asynchronous with the optional ability to synchronously block until the event is scheduled, handled, and has returned. If you wish to synchronously handle the event, simple call `wait` on the `Invocation` object returned from `handle` and then check the `Invocation#current_state` property for `:success` or `:error`. Optionally the `Invocation#success?` and `Invocation#error?` methods also provide more intuitive access to the finished state. If the event finished with `:success`, you may retrieve the returned value of the event Proc by calling `Invocation#returned_value`. If the event finished with `:error`, you may get the Exception with `Invocation#error`

    invocation = my_theatre.handle "your/namespace/here", ["your", "custom", "payload"]
    invocation.wait
    raise invocation.error if invocation.error?
    log "Actor finished with return value #{invocation.returned_value}"

Thread pools
------------

Theatre maintains statistics about how long blocks take to execute and, over time, will shape its thread pool dynamically to accommodate the load using an algorithm derived from [Agner Krarup Erlang](http://en.wikipedia.org/wiki/Agner_Krarup_Erlang)'s [B](http://en.wikipedia.org/wiki/Erlang-B) and [C](http://en.wikipedia.org/wiki/Erlang-C) formulas.

Ruby 1.8 vs. Ruby 1.9 vs. JRuby
-------------------------------

Theatre was created for Ruby 1.8 because no good Actor system existed on Ruby 1.8 that met Adhearsion's needs (e.g. namespaces, dynamically shaping thread pools based on historical analysis). MRI's implementation of threading is quite poor, slow, and resource intensive. With MRI, all threads will run on a single core of the machine, preventing true processor-level concurrency. If you wish to achieve real processor-level concurrency, use JRuby.

Presently Ruby 1.9 compatibility is not a priority but patches for compatibility will be accepted, as long as they preserve compatibility with both MRI and JRuby.

Theatre Developers
=============

Implementation notes
--------------------

Theatre uses the Ruby standard library class Queue to orchestrate the message passing system.

Notes on AASM
-------------

Theatre uses AASM behind internally to manage finite state machines. The library is somewhat undocumented therefore relevant documentation should be placed here.