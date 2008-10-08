Ideas for improvement
=====================

Want to contribute to Theatre? See if any of these features may interest you and improve the way you work with the library. If so, feel free to fork this project on Github and add it!

Theatre-owned namespaces
------------------------

Theatre would register event callbacks within its own Theatre-specific namespace. When responding to these events, it could do something such as report the average runtime for a particular namespace or how long it's been since the Theatre started.

Prioritized namespaces
----------------------

Certain events should be executed as fast as possible. For example, in Adhearsion, maybe `before_call` and `after_call` events should be prioritized over other events.

Handling within the caller's Thread
-----------------------------------
When calling Theatre#trigger, maybe it'd make sense to have some events run within the caller's Thread instead of running it in another Thread. This should probably be split into a separate method called `trigger_syncrhonously` or something.