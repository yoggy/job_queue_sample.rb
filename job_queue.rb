#!/bin/ruby
#
# job_queue.rb - JobQueue class
#
# github:
#     https://github.com/yoggy/job_queue_sample.rb
#
# license:
#     Copyright (c) 2017 yoggy <yoggy0@gmail.com>
#     Released under the MIT license
#     http://opensource.org/licenses/mit-license.php;
#
require 'thread'

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

