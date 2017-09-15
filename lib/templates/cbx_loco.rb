CbxLoco.configure do |config|
  config.api_key = ENV["YOUR_API_KEY"]
  config.languages = %w[en fr].freeze

  config.file_formats = {
    yaml: {
      api_ext: "yml",
      delete: false,
      dst_ext: "yml",
      src_ext: "yml",
      path: "config/locales"
    }
  }.freeze

  config.i18n_files = [
    {
      format: :yaml,
      id: "server",
      name: "devise"
    }
  ].freeze
end
