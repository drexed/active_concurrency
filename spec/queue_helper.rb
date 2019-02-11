module QueueHelper

  def schedule_jobs(size)
    size.times do |n|
      worker.schedule { results.push("job_#{n}") }
    end
  end

  def schedule_pool_jobs(size)
    size.times do |n|
      pool.schedule { results[n] = fib(n) }
    end
  end

  def fib(n)
    n < 2 ? n : fib(n - 1) + fib(n - 2)
  end

end
