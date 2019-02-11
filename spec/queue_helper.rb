module QueueHelper

  def update_result_hash(hash, operation, value, break_i: nil)
    hash.each_with_index do |(k, _), i|
      if operation == '='
        hash.store(k, value)
      else
        hash[k].send(operation, value)
      end

      break if i == break_i
    end
  end

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
