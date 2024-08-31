# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require File.join(__dir__, '..', 'config', 'application')

FIXTURES_PATH = Pathname.new(File.join(__dir__, 'fixtures'))
