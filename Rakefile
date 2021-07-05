require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "opalgems"

RSpec::Core::RakeTask.new(:spec)

desc "Parse opalgems.rb to create/update Git submodules in a gems/ subdirectory"
task :submodules do
  Opalgems.prepare_submodules
end

desc "Run Minitest over all default gems with Opal"
task :minitest do
  raise NotImplementedError
end

Rake::Task[:build].prerequisites << :submodules

task :default => :spec
