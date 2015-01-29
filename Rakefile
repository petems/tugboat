require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :features do
  Cucumber::Rake::Task.new(:run) do |t|
    t.cucumber_opts = %w(--format pretty --order random)
  end
end