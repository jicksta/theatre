Formulas
========

This is a work-in-progress document covering the mathematical algorithms behind Theatre.

Running average without history
-------------------------------

In our system, we're either given or can calculate for the following information. When I say "number", in this case I mean "a stored time in seconds it took to execute a callback."

    current_average = current average of all numbers in data set
              count = quantity of data items in current_average's data set
    reduced_average = current average adjusted for one more number to be added to the data set
               data = new item for the dataset
        new_average = new average of all numbers in data set, including "data"


      count / (count+1) = current_average / reduced_average
    ∴   reduced_average = (current_average * (count + 1)) / count
    
            new_average = reduced_average + (data / (count + 1))
        

Accounting for variations
-------------------------

Two things can happen which would make the system have an inappropriate number of responders:

* Spikes or sudden drops in traffic
* A singularity input to a callback which causes it to take a uniquely long time to execute

If only a "running average" algorithm is used to track average callback time, the system will respond to variations in throughput less effectively the longer the system runs. The solution is to calculate several running times.

For these reasons, the system should allow the user to specify sampling times and accuracy rates. Some systems may

Erlang B/C calculations
-----------------------

With Agner Erlang's formulas, we calculate the appropriate number of responders to a given throughput of actions. For his formulas, we must know the following information:

* What is the average runtime of each callback?
* How many callbacks do we execute per hour?
* What is an acceptable amount of wait time?
