#!/usr/bin/ruby
#
# job_queue_sample.rb - How to use JobQueue class
#
# github:
#     https://github.com/yoggy/job_queue_sample.rb
#
# license:
#     Copyright (c) 2017 yoggy <yoggy0@gmail.com>
#     Released under the MIT license
#     http://opensource.org/licenses/mit-license.php;
#
require 'logger'
require_relative 'job_queue'

Thread.abort_on_exception = true

$log = Logger.new(STDOUT)
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
