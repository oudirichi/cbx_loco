require "cbx_loco/version"
require 'cbx_loco/configuration'
require 'cbx_loco/loco'
require 'cbx_loco/commands'


module CbxLoco
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    config = configuration
    yield(config)
  end

  def self.run(command)
    p command
    p api_key

    if command[:extract]
      Loco.extract
    end

    if command[:import]
      Loco.import
    end
  end
end
