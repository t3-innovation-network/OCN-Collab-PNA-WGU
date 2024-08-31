# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require :default, ENV.fetch('RACK_ENV', nil)

require 'dotenv'
Dotenv.load(".env.#{ENV.fetch('RACK_ENV', nil)}") if defined?(Dotenv)

Dir[File.join(__dir__, '..', 'app', '**', '*.rb')].each { require _1 }
