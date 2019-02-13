module JobHelpers

  FILE_PATH ||= 'spec/support/test.txt'

  def fib(n)
    n < 2 ? n : fib(n - 1) + fib(n - 2)
  end

  def schedule_pool_jobs(size, args: [], file: false)
    truncate_file if file

    size.times do |n|
      pool.schedule(*args) do
        result = fib(n)
        file ? write_file(result) : (results[n] = result)
      end
    end
  end

  def schedule_worker_jobs(size, args: [], file: false)
    truncate_file if file

    size.times do |n|
      worker.schedule(*args) do
        result = fib(n)
        file ? write_file(result) : (results << result)
      end
    end
  end

  def update_worker_pool(hash, operation, value, break_i: nil)
    hash.each_with_index do |(k, _), i|
      value = hash[k].send(operation, value) if operation != '='
      hash[k] = value

      break if i == break_i
    end
  end

end
