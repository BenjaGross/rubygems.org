## Benchmarking
  + Benchmark: test of speed of given piece of code
  + What would you want to Benchmark
    + Algorithms
    + Hot Paths - commonly used controller routs e.g.
    + Allocations - memory usage
    + Background jobs

  - Benchmark/ips - gem for Benchmarking

  + Good benchmarking have:
  + Do not depend benchmarks on external services - should only include your own code
  + Low variability
  + Long-lived - can be used whenever that code is touched
  + Inspired by bad production metrics - should only be based on what is seen in production
  + examples (rubybench.org, sentry-raven gem, dalli gem)

  - Pitfalls
  + letting microbenchmarks drive decisions
    + Instead benchmark things like user creation action
  + not paying attention to overhead
  + not paying attention to garbage collection (gc.disable in benchmark)
  + JRuby compiler warmup
+ Kalibera - gem that gives some good statistics for benchmarking


## Profiling
+ Profiling: Accounting of substeps required to complete a task
  + looks at each iteration and says what amount of time is spent on each part of the task
  + WRK - tool to
  ! This is integration level performance testing

- Should work like production since speed issues are in production  
  + Settings should look as production like as possible
  + Production like data in database
    + bring production data down while dropping user data/emails/credit cards/ overwrite stuff
    + If those are not options get a truly good seed file

+ Most performance work is in DB active record and sql optimization


+ Threads: cpu work that can be done at once
+ Connections: opten connections
  - Higher numbers higher demand

G.I.L/G.V.L - Global VM Lock
  Number of threads with access to the ruby vm
  Only one thread can use ruby vm at one time
ruby virtual machine - converts code into instructions to run

Most web servers work on process model/ 1 socket
  + Worker processes all listening to that socket
  + Puma processes sign up to listen to that socket
  + requests stack in socket if no puma processes are ready

  + only one thread in a process can use the vm at one time but multiple other threads can do other things like i/o which allows for context switching

  + When a thread is waiting for I/O response it frees up the GVM and another thread can use ruby code there

  + The more IO an application is doing the more it will benefit from more threads.

  + Most puma applications need at most 5 threads
  + Background jobs use more threads than rails servers: Sidekiq uses a default of 10
    + More threads use more memory

(Truffle Ruby)[https://github.com/oracle/truffleruby]
* forking process model

## How many servers for a given load
  + Server right-sizing
  + Little's Law
    ! WIP = (latency * throughput)
    - Ideal number is 10 - 25 %
    throughput = requests per minute and latency is time
    - In terms of processes
    - Capacity Management
    - Relationship w/ latency and throughput
    - Amount of work currently in the system
    - (puma) to find the processes per server multiply the number of cores by 1.25 and start there (unicorn) multiply by about 4
  When you change scale:
    + As you add more instances you increase the likelihood that a request will be routed to a non busy process.
    + reduce amount of time a request sits in request queueing

  An application with predictable trends(spikes/dips) in usage is more scalable than other

  + Get to the point where adding additional processes does not decrease request queue time (across entire infosctructure)
  + For this look at 24 hour cycles and this data. With drastic spikes on days you would look for autoscaling
    + Often scaled based on response time, though you actually want to scale in response to how many requests are in request queuing/how many requests are in socket. that number is harder to get


## Profiling all costs overhead
  - makes what you profile slower just by the act of doing it
  - Benchmarking should exist separate from that

  Workflow:
    - Scour metrics
    - Establish Benchmark
    - Dig in with a profiler (find answer to why thing is slow)
    - Iterate on a solution - go back to benchmark and test
  - Must be iterated, hard to see past the bottle neck of a single performance issue

  ### Profiler modes
    - cpu time - clock cycles gHz does not count IO
      - use cpu profilers to eliminate IO (don't care about db or http calls)
      - not accurate on OSx
    - wall - computer clock to measure time (stopwatch time)
    - process - like process time but only for time spent on the actual process you are looking for (usually don't work)

  Types of profilers - Statistical Profiling vs Tracing
    - Aggregates stack traces together to get time
    - RubyProf - only tracing ruby profile
      - Take a stackframe every time trace instruction runs on vm (listens to vm to see when these happen)
    - statistical profilers just take profile at the given time increment: makes statistical inference of what all frames are
    - Should use multiple times since they are different each time
     - stacprof - gperftools - rbspy (gems for doing so)

    Tracing profilers are high overhead and high precision
      - cannot be run in production
    Statistical are low overhead low precision
      - can be run in production (something like new relic runs these under the hood)

  Profiler reading -
    looking for time spent in self - (in the method itself and blocks)
    child - would be a method called by another method

  Call-stack printer

  - Memory!
  - disable garbage collection while profiling since it changes things and prevents profiling acurate
    - store objects in memory? uses something called:
     + Object space: a list of every ruby object
      - List of "r values" 40 byte c structures with info about a string, contains pointer to the object
      - organized into pages of 400 r values.
      Object space looked at with:
      - ObjectSpace and objspace.so (in standard ruby library)
      - gc_tracer
      - derailed_benchmarks
      - memory_profiler
        - wraps as a block and tells every object that was allocated in that block

    + Bloat
    + Leaks
    + Allocation

  # Garbage collection
  - when does it happen? When we run out of empty r values in object space in an attempt to free up space
  - Hit off-objectspace limits ("malloc")
  - To return memory back to the OS we need large heaps of memory
  - objects can't be moved around in memory because c extensions need these pointers
  - Heap fragmentation looks like a leak because it is a similar long slow growth
  - The more threads we have the more memory fragmentation we have - due to a bug in the malloc c library
    - on fragmenting app curve is logarithmic
    - on leak the curve is constant and generally happens quite quickly

  GC.stat - tells you statistics about how often/much garbage collection has run

  OINK - checks memory usage before and after controller actions - helps diagnose memory problems


# Front end
  - Dom content loaded: fires when html parser reaches the end of the file


JEMalloc - ruby memory allocator, better set of strategies for multithreaded allocations than regular malloc
