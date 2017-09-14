require "cbx_loco/version"

module CbxLoco
  def self.setup
    yield self
  end
end
