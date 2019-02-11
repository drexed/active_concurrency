module QueueHelper

  def update_result_hash(hash, operation, value, break_i: nil)
    hash.each_with_index do |(k, _), i|
      hash[k] = (operation == '=' ? value : hash[k].send(operation, value))

      break if i == break_i
    end
  end

  def schedule_jobs(size, *args)
    size.times do |n|
      worker.schedule(*args) { results << fib(n) }
    end
  end

  def schedule_pool_jobs(size, *args)
    size.times do |n|
      pool.schedule(*args) { results[n] = fib(n) }
    end
  end

  def fib(n)
    n < 2 ? n : fib(n - 1) + fib(n - 2)
  end

end
