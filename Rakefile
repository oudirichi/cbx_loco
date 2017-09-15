require "bundler/gem_tasks"
require 'rake/testtask'
#
# Rake::TestTask.new(:spec) do |test|
#   test.libs      << 'lib' << 'spec'
#   test.pattern   = FileList['spec/**/*_spec.rb']
#   test.verbose   = true
# end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

task :default => :spec
