require 'bundler'
Bundler.require(:development)

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = %w(--format pretty --order random)
end

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names']
end

task default: [:spec, :features]

begin
  require 'github_changelog_generator/task'
  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    require 'tugboat/version'
    version = Tugboat::VERSION
    config.user = 'petems'
    config.project = 'tugboat'
    config.future_release = "v#{version}"
    config.header = "# Change log\n\nAll notable changes to this project will be documented in this file."
    config.exclude_labels = %w{duplicate question invalid wontfix}
  end
rescue LoadError
end
