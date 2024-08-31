# frozen_string_literal: true

desc 'Starts a Pry session'
task :console do
  ARGV.clear
  Pry.start
end
