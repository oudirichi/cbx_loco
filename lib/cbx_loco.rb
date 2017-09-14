require "cbx_loco/version"

module CbxLoco
  mattr_accessor :file_formats, default: {}
  mattr_accessor :languages, default: []
  mattr_accessor :i18n_files, default: []
  mattr_accessor :api_key, default: nil

  def self.setup
    yield self
  end

  def self.extract
    self.i18n_files
  end

  def self.run(command)
    p command
    p api_key

    if command[:extract]

    end

    if command[:import]

    end
  end
end
