CbxLoco.setup do |config|
  config.LANGUAGES = %w[en fr].freeze

  config.FILE_FORMATS = {
    yaml: {
      api_ext: "yml",
      delete: false,
      dst_ext: "yml",
      src_ext: "yml",
      path: "config/locales"
    }
  }.freeze

  config.I18N_FILES = [
    {
      format: :yaml,
      id: "server",
      name: "devise"
    }
  ].freeze
end
