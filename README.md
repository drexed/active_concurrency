# ActiveConcurrency

ActiveConcurrency that makes it easy to work with thread/process
workers and pools.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_concurrency'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_concurrency

## Table of Contents

* [Usage](#usage)
* [Workers](#worker)
* [Pools](#pools)
* [Schedulers](#schedulers)

## Usage

Before getting started it is best to understand when to use processes vs
threads workers/pools.

Use threads when you need to access an outer shared resource or looking to
run light weight executors. You may find threads harder to debug for
unexpected errors.

Use processes when you don't need to access an outer shared resource.
Processes are also more memory intensive as the load an its
own identical system, but have the added benefit of being easier to debug.

Play around with both until you find the best performance mix of speed and
memory usage. Very rarely will you find any benefit of running both together.
We suggest you start with threads before using processes.

## Workers

Workers are a single unit that contain its own queue to and process data in
a FIFO sequence. You can use a worker without a pool if you need to process
a small amount items.

```ruby
worker = ActiveConcurrency::Processes::Worker.new(name: 'us-east')

worker.schedule { expensive_code }
worker.schedule { expensive_code }
...
worker.shutdown
```

## Pools

Pools are a group of workers that queue data based on a selected scheduling
algorithm. Use a pool to process a large amount of items and spread loads
between many workers.

```ruby
pool = ActiveConcurrency::Threads::Pool.new(size: 10)

pool.schedule { expensive_code }
pool.schedule { expensive_code }
...
pool.shutdown
```

## Schedulers

There are currently three scheduling algorithms to choose that bring
flexibility to your pools.

**Least busy (default)**
The least busy algorithm will schedule the job in the worker with
the smallest sized queue.

```ruby
ActiveConcurrency::Threads::Pool.new(
  scheduler: ActiveConcurrency::Schedulers::LeastBusy
)
```

**Round robin**
The round robin algorithm will schedule the job in the next sequentially available worker queue.

```ruby
ActiveConcurrency::Processes::Pool.new(
  scheduler: ActiveConcurrency::Schedulers::RoundRobin
)
```

**Topic**
The topic algorithm will schedule the job in the selected topic worker queue.
This is similar to background programs or message buses.

```ruby
ActiveConcurrency::Threads::Pool.new(
  scheduler: ActiveConcurrency::Schedulers::Topic,
  topics: %w[topic_1 topic_2 topic_3]
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/drexed/active_concurrency. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveConcurrency project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/drexed/active_concurrency/blob/master/CODE_OF_CONDUCT.md).
