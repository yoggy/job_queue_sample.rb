job_queue_sample.rb
====

```ruby
class JobQueue
  def initialize()
    @m = Mutex.new
    @c = ConditionVariable.new
    @q = Queue.new
  end

  def push(job)
    @m.synchronize do
      @q.push(job)
      @c.signal
    end
  end

  def shift()
    @m.synchronize do
      @c.wait(@m) if @q.size == 0
      job = @q.shift
      return job
    end
  end

  def size
    @m.synchronize do
      return @q.size
    end
  end
end
```

```
$ ./main.rb
D, [2017-09-10T18:17:00.900136 #9260] DEBUG -- : sender_thread0 : push job=thread 0
D, [2017-09-10T18:17:00.900763 #9260] DEBUG -- : sender_thread3 : push job=thread 3
D, [2017-09-10T18:17:00.999368 #9260] DEBUG -- : sender_thread1 : push job=thread 1
D, [2017-09-10T18:17:01.100560 #9260] DEBUG -- : sender_thread1 : push job=thread 1
D, [2017-09-10T18:17:01.399521 #9260] DEBUG -- : sender_thread2 : push job=thread 2
D, [2017-09-10T18:17:01.499734 #9260] DEBUG -- : sender_thread4 : push job=thread 4
D, [2017-09-10T18:17:01.500700 #9260] DEBUG -- : sender_thread0 : push job=thread 0
D, [2017-09-10T18:17:01.600862 #9260] DEBUG -- : sender_thread0 : push job=thread 0
D, [2017-09-10T18:17:01.701888 #9260] DEBUG -- : sender_thread1 : push job=thread 1
D, [2017-09-10T18:17:01.702115 #9260] DEBUG -- : sender_thread3 : push job=thread 3
D, [2017-09-10T18:17:01.702330 #9260] DEBUG -- : sender_thread1 : push job=thread 1
D, [2017-09-10T18:17:01.799890 #9260] DEBUG -- : reciever_thread : shift job=thread 0
D, [2017-09-10T18:17:01.800052 #9260] DEBUG -- : sender_thread2 : push job=thread 2
D, [2017-09-10T18:17:01.800205 #9260] DEBUG -- : reciever_thread : shift job=thread 3
D, [2017-09-10T18:17:01.800347 #9260] DEBUG -- : reciever_thread : shift job=thread 1
D, [2017-09-10T18:17:01.800405 #9260] DEBUG -- : reciever_thread : shift job=thread 1
D, [2017-09-10T18:17:01.800463 #9260] DEBUG -- : reciever_thread : shift job=thread 2
D, [2017-09-10T18:17:01.800519 #9260] DEBUG -- : reciever_thread : shift job=thread 4
D, [2017-09-10T18:17:01.800576 #9260] DEBUG -- : reciever_thread : shift job=thread 0
D, [2017-09-10T18:17:01.800636 #9260] DEBUG -- : reciever_thread : shift job=thread 0
D, [2017-09-10T18:17:01.800702 #9260] DEBUG -- : reciever_thread : shift job=thread 1
D, [2017-09-10T18:17:01.800758 #9260] DEBUG -- : reciever_thread : shift job=thread 3
D, [2017-09-10T18:17:01.800817 #9260] DEBUG -- : reciever_thread : shift job=thread 1
D, [2017-09-10T18:17:01.800915 #9260] DEBUG -- : reciever_thread : shift job=thread 2
D, [2017-09-10T18:17:01.801894 #9260] DEBUG -- : sender_thread0 : push job=thread 0
```

References
----
* Guarded suspension - Wikipedia
  * https://en.wikipedia.org/wiki/Guarded_suspension

* class ConditionVariable (Ruby 1.8.7)
  * https://docs.ruby-lang.org/ja/1.8.7/class/ConditionVariable.html

* class Thread::Queue (Ruby 2.4.0)
  * https://docs.ruby-lang.org/ja/latest/class/Thread=3a=3aQueue.html

Copyright and license
----
Copyright (c) 2017 yoggy

Released under the [MIT license](LICENSE.txt)
