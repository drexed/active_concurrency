module QueueHelper

  def enqueue_jobs(number_of_jobs)
    number_of_jobs.times do |n|
      worker << -> { results.push("job_#{n}") }
    end
  end

  def enqueue_pool_jobs(number_of_pools)
    number_of_pools.times do |n|
      pool << -> { results[n] = fib(n) }
    end
  end

  def fib(n)
    n < 2 ? n : fib(n - 1) + fib(n - 2)
  end

end
