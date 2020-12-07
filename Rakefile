require "bundler/gem_tasks"
require "rake/testtask"

task default: :test
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.warning = false
end

require 'rake/extensiontask'

Rake::ExtensionTask.new('libmf') do |ext|
  ext.lib_dir = 'lib/libmf'
end

task :benchmark do
  require "benchmark/ips"
  require "libmf"

  data = []
  File.foreach("vendor/demo/real_matrix.tr.txt") do |line|
    row = line.chomp.split(" ")
    data << [row[0].to_i, row[1].to_i, row[2].to_f]
  end
  model = Libmf::Model.new(quiet: true)

  Benchmark.ips do |x|
    x.report("fit") { model.fit(data) }
  end
end
