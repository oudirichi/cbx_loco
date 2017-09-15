# require 'active_support'

module CbxLoco


  # LANGUAGES = %w[en fr].freeze
  #
  # FILE_FORMATS = {
  #   gettext: {
  #     api_ext: "po",
  #     delete: true,
  #     dst_ext: "po",
  #     src_ext: "pot",
  #     path: "locale"
  #   },
  #   yaml: {
  #     api_ext: "yml",
  #     delete: false,
  #     dst_ext: "yml",
  #     src_ext: "yml",
  #     path: "config/locales"
  #   }
  # }.freeze
  #
  # I18N_FILES = [
  #   {
  #     format: :yaml,
  #     id: "server",
  #     name: "cbx"
  #   },
  #   {
  #     format: :yaml,
  #     id: "server",
  #     name: "devise"
  #   },
  #   {
  #     format: :gettext,
  #     id: "client",
  #     name: "front_end"
  #   }
  # ].freeze

  def self.asset_tag(*args)
    args.join("-").gsub(/[^a-z,-]/i, "")
  end

  def self.flatten_hash(data_hash, parent = [])
    data_hash.flat_map do |key, value|
      case value
      when Hash then flatten_hash value, parent + [key]
      else (parent + [key]).join(".")
      end
    end
  end

  def self.file_path(*args)
    Rails.root.join(*args).to_s
  end

  class Loco
    # API_URL = "https://localise.biz:443/api/".freeze
    # API_KEY = ENV["I18N_API_KEY"]

    def self.get(api_path, params = {}, json = true)
      params = params.merge(key: API_KEY, ts: Time.now.getutc)
      res = RestClient.get API_URL + api_path, params: params

      json ? JSON.parse(res.body) : res.body
    end

    def self.post(api_path, params = {})
      res = RestClient.post API_URL + api_path + "?key=#{API_KEY}", params

      JSON.parse res.body
    end

    def self.valid_api_key?
      valid = API_KEY.present?
      puts "MISSING I18N API KEY. ABORTING.".colorize(:red).bold unless valid
      valid
    end

    def self.extract
      return unless valid_api_key?

      puts "\n" + "Extract i18n assets".colorize(:green).bold

      print "Removing old files... "
      I18N_FILES.each do |i18n_file|
        fmt = FILE_FORMATS[i18n_file[:format]]

        next unless fmt[:delete]

        path = fmt[:path]
        src_ext = fmt[:src_ext]
        file_path = I18n.file_path path, [i18n_file[:name], src_ext].join(".")
        File.unlink file_path if File.file?(file_path)
      end
      puts "Done!".colorize(:green)

      print "Extracting server assets... "
      `i18n-tasks add-missing`
      puts "Done!".colorize(:green)

      print "Extracting client assets... "
      `./node_modules/grunt-cli/bin/grunt nggettext_extract`
      puts "Done!".colorize(:green)

      @assets = {}
      I18N_FILES.each do |i18n_file|
        fmt = FILE_FORMATS[i18n_file[:format]]
        path = fmt[:path]
        src_ext = fmt[:src_ext]

        case i18n_file[:format]
        when :gettext
          file_path = I18n.file_path path, [i18n_file[:name], src_ext].join(".")
          translations = GetPomo::PoFile.parse File.read(file_path)
          msgids = translations.reject { |t| t.msgid.blank? }.map(&:msgid)
        when :yaml
          language = LANGUAGES.first
          file_path = I18n.file_path path, [i18n_file[:name], language, src_ext].join(".")
          translations = YAML.load_file file_path
          msgids = I18n.flatten_hash(translations[language])
        end

        msgids.each do |msgid|
          if msgid.is_a? Array
            # we have a plural (get text only)
            singular = msgid[0]
            plural = msgid[1]

            # add the singular
            @assets[singular] = { tags: [] } if @assets[singular].nil?
            @assets[singular][:tags] << I18n.asset_tag(i18n_file[:id], i18n_file[:name])

            # add the plural
            @assets[plural] = { tags: [] } if @assets[plural].nil?
            @assets[plural][:singular_id] = singular
            @assets[plural][:tags] << I18n.asset_tag(i18n_file[:id], i18n_file[:name])
          else
            @assets[msgid] = { tags: [] } if @assets[msgid].nil?
            @assets[msgid][:id] = msgid if i18n_file[:format] == :yaml
            @assets[msgid][:tags] << I18n.asset_tag(i18n_file[:id], i18n_file[:name])
          end
        end
      end

      puts "\n" + "Upload i18n assets to Loco".colorize(:green).bold
      begin
        print "Grabbing the list of existing assets... "
        res = get "assets.json"
        existing_assets = {}
        res.each do |asset|
          existing_assets[asset["name"]] = { id: asset["id"], tags: asset["tags"] }
        end
        res = nil
        puts "Done!".colorize(:green)

        @assets.each do |asset_name, asset|
          existing_asset = existing_assets[asset_name]

          if existing_asset.nil?
            print_asset_name = asset_name.length > 50 ? asset_name[0..46] + "[...]" : asset_name
            print "Uploading asset: \"#{print_asset_name}\"... "

            asset_hash = { name: asset_name, type: "text" }

            if !asset[:singular_id].blank?
              singular_id = existing_assets[asset[:singular_id]][:id]
              res = post "assets/#{singular_id}/plurals.json", asset_hash
            else
              asset_hash[:id] = asset_name if asset[:id]
              res = post "assets.json", asset_hash
            end

            existing_asset = { id: res["id"], tags: res["tags"] }
            existing_assets[asset_name] = existing_asset
            puts "Done!".colorize(:green)
          end

          new_tags = asset[:tags] - existing_asset[:tags]
          new_tags.each do |tag|
            print_asset_id = existing_asset[:id].length > 30 ? existing_asset[:id][0..26] + "[...]" : existing_asset[:id]
            print "Uploading tag \"#{tag}\" for asset: \"#{print_asset_id}\"... "
            post "assets/#{URI.escape(existing_asset[:id])}/tags.json", name: tag
            puts "Done!".colorize(:green)
          end
        end

        puts "\n" + "All done!".colorize(:green).bold
      rescue => e
        res = JSON.parse e.response
        puts "\n" + "\nUpload to online service failed: #{e.message}: #{res["error"]}".colorize(:red).bold
      end
    end

    def self.import
      return unless valid_api_key?

      puts "\n" + "Import i18n assets from Loco".colorize(:green).bold
      begin
        I18N_FILES.each do |i18n_file|
          LANGUAGES.each do |language|
            fmt = FILE_FORMATS[i18n_file[:format]]
            path = fmt[:path]
            dst_ext = fmt[:dst_ext]
            api_ext = fmt[:api_ext]
            tag = I18n.asset_tag i18n_file[:id], i18n_file[:name]

            print "Importing \"#{language}\" #{tag} assets... "

            api_params = { filter: tag, order: :id }
            case i18n_file[:format]
            when :gettext
              api_params[:index] = "name"
              file_path = I18n.file_path path, language, [i18n_file[:name], dst_ext].join(".")
            when :yaml
              api_params[:format] = "rails"
              file_path = I18n.file_path path, [i18n_file[:name], language, dst_ext].join(".")
            end

            translations = get "export/locale/#{language}.#{api_ext}", api_params, false

            f = File.new file_path, "w:UTF-8"
            f.write translations.force_encoding("UTF-8")
            f.close

            puts "Done!".colorize(:green)
          end
        end

        puts "\n" + "Compile i18n assets".colorize(:green).bold

        print "Compiling client assets... "
        `./node_modules/grunt-cli/bin/grunt nggettext_compile`
        puts "Done!".colorize(:green)

        puts "\n" + "All done!".colorize(:green).bold
      rescue => e
        translations = {}
        GetPomo::PoFile.parse(e.response).each do |t|
          translations[t.msgid] = t.msgstr unless t.msgid.blank?
        end
        puts "\n" + "\nDownload from online service failed: #{translations["status"]}: #{translations["error"]}".colorize(:red).bold
      end
    end
  end
end
