module CbxLoco
  class commands
     def self.parse(args)
       options = {}

       parser = OptionParser.new do |opts|
         opts.banner = "Usage: i18n [options]"

         opts.on('extract', 'extract all locale files') do
           options[:extract] = true
         end

         opts.on('import', 'import all locale files') do
           options[:import] = true
         end

         opts.on_tail("-h", "--help", "Prints this help") do
           puts opts.help
           exit
         end

         if options.empty?
           puts opts.help
           exit
         end
       end

       parser.parse! args
    end
  end
end
