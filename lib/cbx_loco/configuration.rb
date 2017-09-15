module CbxLoco
  class Configuration
    attr_accessor :file_formats #, default: {}
    attr_accessor :languages #, default: []
    attr_accessor :i18n_files #, default: []
    attr_accessor :api_key #, default: nil
    attr_accessor :api_url #, default: "https://localise.biz:443/api/".freeze
  end
end
