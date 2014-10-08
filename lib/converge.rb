require 'logger'

require "hydrogen"

require "converge/db"
require "converge/model"
require "converge/version"

module Converge
  module_function
  def logger
    return @logger if @logger

    @logger = Logger.new(STDOUT)
    @logger.formatter = proc { |severity, datetime, progname, msg| 
      "[#{datetime}, #{severity}] #{msg}\n"
    }
    @logger
  end

  def logger=(logger)
    @logger = logger
  end

  def env
    @_env ||= ActiveSupport::StringInquirer.new(ENV["QUASAR_ENV"] || ENV["RAILS_ENV"] || "development")
  end

  def env=(environment)
    @_env = ActiveSupport::StringInquirer.new(environment)
  end
end
