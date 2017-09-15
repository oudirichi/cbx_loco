module CbxLoco
  class Commands
     def self.parse(args)
       options = {}

      parser = OptionParser.new
      parser.banner = "Usage: i18n [options]"

      parser.on("-e", "--extract", "extract all locale files") do
        options[:extract] = true
      end

      parser.on("-i", "--import", "import all locale files") do
        options[:import] = true
      end

      parser.on_tail("-h", "--help", "Prints this help") do
        show_help parser
      end

      begin
        parser.parse! args
      rescue => e
        show_help parser
      end

      if options.empty?
       show_help parser
     end

     options
    end

    private

    def self.show_help(parser)
      puts parser.help
      exit 1
    end
  end
end
