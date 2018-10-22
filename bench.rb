require_relative "config/application"

Rails.application.initialize!

require "benchmark/ips"

Benchmark.ips do |x|
  # x.report("#index") { HomeController.render :index}
  keys = [:a, :b, :c, :d]
  values = ['a', 'b', 'c', 'd']
  hash = {}
  x.report("zip") { keys.zip(values) }
  x.report("manual") do
    keys.map |k| do
      [k values[keys.index(k)]]
    end
  end
  x.compare!
end
