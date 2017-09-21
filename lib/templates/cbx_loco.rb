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

  # config.on :after_import do
  #   puts "do something awesome after import!"
  # end
  #
  # config.on :before_extract do
  #   puts "do something else during extract!"
  # end
end
