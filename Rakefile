# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

begin
  require 'vlad'
  Vlad.load(:app => :passenger)
rescue LoadError => e
  puts e.message
  puts e.backtrace
end

task :deploy => ["vlad:setup", "vlad:update", "vlad:migrate", "vlad:start_app"] do
end