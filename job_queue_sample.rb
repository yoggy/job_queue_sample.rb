#!/bin/ruby
#
# job_queue_sample.rb
#
# see also... https://docs.ruby-lang.org/ja/1.8.7/class/ConditionVariable.html
#
require 'thread'
require 'logger'

Thread.abort_on_exception = true

$log = Logger.new(STDOUT)

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

threads = []
job_queue = JobQueue.new

# job sender thread
5.times do |n|
  threads << Thread.start do
    loop do
      sleep(rand(10)/10.0)
      job = "thread #{n}"
      $log.debug "sender_thread#{n} : push job=#{job}"
      job_queue.push job
    end
  end
end

# job reciever thread
t = Thread.start do
  loop do
    sleep 1 if job_queue.size == 0 
    job = job_queue.shift
    $log.debug "reciever_thread : shift job=#{job}"
  end
end

threads.each do |t|
  t.join
end
