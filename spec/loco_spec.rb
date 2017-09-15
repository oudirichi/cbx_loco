# require "spec_helper"
# require_relative "../../lib/tasks/i18n/i18n.rb"
#
# def rand_str
#   ("a".."z").to_a.sample(16).join
# end
#
# describe CbxLoco::Loco do
#   before(:all) do
#     @fake_i18n_files = [
#       {
#         format: :yaml,
#         id: "test_server",
#         name: "test_cbx"
#       },
#       {
#         format: :yaml,
#         id: "test_server",
#         name: "test_devise"
#       },
#       {
#         format: :gettext,
#         id: "test_client",
#         name: "test_front_end"
#       }
#     ]
#     @pot_header = "msgid \"\"\nmsgstr \"\"\n\"Content-Type: text/plain; charset=UTF-8\\n\"\n\"Content-Transfer-Encoding: 8bit\\n\"\n\n"
#     @fake_translations = {
#       "test_server" => "en:\n  cbx:\n    some_asset:\n    some_other_asset:",
#       "test_client" => @pot_header + "msgid \"Some asset\"\nmsgstr \"\"\n\nmsgid \"Some other asset\"\nmsgstr \"\"\n"
#     }
#     @fake_api_key = "abcd1234"
#     @fake_api_url = "http://example.com/api/"
#
#     @str_response = rand_str
#     @str_json = "{\"test\": \"#{@str_response}\"}"
#   end
#
#   before(:each) do
#     stub_const("I18n::I18N_FILES", @fake_i18n_files)
#     stub_const("I18n::Loco::API_KEY", @fake_api_key)
#     stub_const("I18n::Loco::API_URL", @fake_api_url)
#     suppress_console_output
#   end
#
#   describe "get" do
#     before(:each) do
#       allow(RestClient).to receive(:get).and_return(double(body: @str_json))
#     end
#
#     it "should call RestClient.get" do
#       I18n::Loco.get("test")
#       expect(RestClient).to have_received(:get)
#     end
#
#     it "should build the request URL" do
#       random_str = rand_str
#       I18n::Loco.get(random_str)
#       expect(RestClient).to have_received(:get).with("#{@fake_api_url}#{random_str}", anything)
#     end
#
#     it "should build the request parameters" do
#       cur_datetime = Time.parse "2016-12-25"
#       allow(Time).to receive(:now).and_return(cur_datetime)
#       random_sym = rand_str.to_sym
#       random_str = rand_str
#       I18n::Loco.get("test", random_sym => random_str)
#       expect(RestClient).to have_received(:get).with(anything, params: { key: @fake_api_key, random_sym => random_str, ts: cur_datetime })
#     end
#
#     it "should prevent overriding the API key" do
#       cur_datetime = Time.parse "2016-12-25"
#       allow(Time).to receive(:now).and_return(cur_datetime)
#       random_str = rand_str
#       I18n::Loco.get("test", key: random_str)
#       expect(RestClient).to have_received(:get).with(anything, params: { key: @fake_api_key, ts: cur_datetime })
#     end
#
#     context "with json undefined or true" do
#       it "should parse the response body" do
#         expect(I18n::Loco.get("test")).to eq "test" => @str_response
#         expect(I18n::Loco.get("test", {}, true)).to eq "test" => @str_response
#       end
#     end
#
#     context "with json false" do
#       it "should not parse the response body" do
#         expect(I18n::Loco.get("test", {}, false)).to eq @str_json
#       end
#     end
#   end
#
#   describe "post" do
#     before(:each) do
#       allow(RestClient).to receive(:post).and_return(double(body: @str_json))
#     end
#
#     it "should call RestClient.post" do
#       I18n::Loco.post("test")
#       expect(RestClient).to have_received(:post)
#     end
#
#     it "should build the request URL" do
#       random_str = rand_str
#       I18n::Loco.post(random_str)
#       expect(RestClient).to have_received(:post).with("#{@fake_api_url}#{random_str}?key=#{@fake_api_key}", anything)
#     end
#
#     it "should use the untouched request parameters" do
#       random_sym = rand_str.to_sym
#       random_str = rand_str
#       I18n::Loco.post("test", random_sym => random_str)
#       expect(RestClient).to have_received(:post).with(anything, random_sym => random_str)
#     end
#   end
#
#   describe "extract" do
#     before(:all) do
#       @fake_i18n_files.each do |i18n_file|
#         fmt = I18n::FILE_FORMATS[i18n_file[:format]]
#         case i18n_file[:format]
#         when :gettext
#           file_path = I18n.file_path fmt[:path], [i18n_file[:name], fmt[:src_ext]].join(".")
#         when :yaml
#           language = I18n::LANGUAGES.first
#           file_path = I18n.file_path fmt[:path], [i18n_file[:name], language, fmt[:src_ext]].join(".")
#         end
#
#         f = File.new file_path, "w:UTF-8"
#         f.write @fake_translations[i18n_file[:id]].force_encoding("UTF-8")
#         f.close
#       end
#     end
#
#     before(:each) do
#       get_response = [
#         { "id" => "cbx.some_other_asset", "name" => "cbx.some_other_asset", "tags" => ["testserver-testcbx"] },
#         { "id" => "some-other-asset", "name" => "Some other asset", "tags" => ["testclient-testfrontend"] }
#       ]
#       allow(I18n::Loco).to receive(:get).and_return(get_response)
#       allow(I18n::Loco).to receive(:post).and_return("id" => "test", "tags" => [])
#       allow(I18n::Loco).to receive(:`)
#       allow(File).to receive(:unlink)
#     end
#
#     after(:all) do
#       @fake_i18n_files.each do |i18n_file|
#         fmt = I18n::FILE_FORMATS[i18n_file[:format]]
#         case i18n_file[:format]
#         when :gettext
#           file_path = I18n.file_path fmt[:path], [i18n_file[:name], fmt[:src_ext]].join(".")
#         when :yaml
#           language = I18n::LANGUAGES.first
#           file_path = I18n.file_path fmt[:path], [i18n_file[:name], language, fmt[:src_ext]].join(".")
#         end
#
#         File.unlink file_path if File.file? file_path
#       end
#     end
#
#     it "should delete old files" do
#       I18n::Loco.extract
#       expect(File).to have_received(:unlink).once
#     end
#
#     it "should extract server assets" do
#       I18n::Loco.extract
#       expect(I18n::Loco).to have_received(:`).with("i18n-tasks add-missing")
#     end
#
#     it "should extract client assets" do
#       I18n::Loco.extract
#       expect(I18n::Loco).to have_received(:`).with("./node_modules/grunt-cli/bin/grunt nggettext_extract")
#     end
#
#     it "should extract assets with tags" do
#       expected_value = {
#         "Some asset" => { tags: %w[testclient-testfrontend] },
#         "Some other asset" => { tags: %w[testclient-testfrontend] },
#         "cbx.some_asset" => { tags: %w[testserver-testcbx testserver-testdevise], id: "cbx.some_asset" },
#         "cbx.some_other_asset" => { tags: %w[testserver-testcbx testserver-testdevise], id: "cbx.some_other_asset" }
#       }
#       I18n::Loco.extract
#       expect(I18n::Loco.instance_variable_get(:@assets)).to eq expected_value
#     end
#
#     it "should get the list of existing assets on Loco" do
#       I18n::Loco.extract
#       expect(I18n::Loco).to have_received(:get).with("assets.json")
#     end
#
#     it "should upload non-existing assets to Loco" do
#       I18n::Loco.extract
#       expect(I18n::Loco).to have_received(:post).with("assets.json", anything).twice
#     end
#
#     it "should upload non-existing asset tags to Loco" do
#       I18n::Loco.extract
#       expect(I18n::Loco).to have_received(:post).with(%r[assets/.*/tags\.json], anything).exactly(4).times
#     end
#
#     context "with missing API_KEY" do
#       before(:each) do
#         stub_const("I18n::Loco::API_KEY", nil)
#       end
#
#       it "should not do anything" do
#         expect(I18n::Loco).to_not have_received(:get)
#         expect(I18n::Loco).to_not have_received(:post)
#         expect(I18n::Loco).to_not have_received(:`)
#         expect(File).to_not have_received(:unlink)
#       end
#     end
#   end
#
#   describe "import" do
#     before(:each) do
#       allow(I18n::Loco).to receive(:get).and_return(@str_response)
#       allow(I18n::Loco).to receive(:`)
#     end
#
#     after(:all) do
#       @fake_i18n_files.each do |i18n_file|
#         fmt = I18n::FILE_FORMATS[i18n_file[:format]]
#         I18n::LANGUAGES.each do |language|
#           case i18n_file[:format]
#           when :gettext
#             file_path = I18n.file_path fmt[:path], language, [i18n_file[:name], fmt[:dst_ext]].join(".")
#           when :yaml
#             file_path = I18n.file_path fmt[:path], [i18n_file[:name], language, fmt[:dst_ext]].join(".")
#           end
#           File.unlink file_path if File.file? file_path
#         end
#       end
#     end
#
#     it "should call API for each language file" do
#       @fake_i18n_files.each do |i18n_file|
#         I18n::LANGUAGES.each do |language|
#           fmt = I18n::FILE_FORMATS[i18n_file[:format]]
#           api_ext = fmt[:api_ext]
#           tag = I18n.asset_tag i18n_file[:id], i18n_file[:name]
#
#           api_params = { filter: tag, order: :id }
#           case i18n_file[:format]
#           when :gettext
#             api_params[:index] = "name"
#           when :yaml
#             api_params[:format] = "rails"
#           end
#
#           expect(I18n::Loco).to receive(:get).with("export/locale/#{language}.#{api_ext}", api_params, false)
#         end
#       end
#
#       I18n::Loco.import
#     end
#
#     it "should write API return in language files" do
#       I18n::Loco.import
#
#       @fake_i18n_files.each do |i18n_file|
#         fmt = I18n::FILE_FORMATS[i18n_file[:format]]
#         I18n::LANGUAGES.each do |language|
#           case i18n_file[:format]
#           when :gettext
#             file_path = I18n.file_path fmt[:path], language, [i18n_file[:name], fmt[:dst_ext]].join(".")
#           when :yaml
#             file_path = I18n.file_path fmt[:path], [i18n_file[:name], language, fmt[:dst_ext]].join(".")
#           end
#           expect(File.read(file_path)).to eq @str_response
#         end
#       end
#     end
#
#     it "should call grunt nggettext_compile" do
#       I18n::Loco.import
#       expect(I18n::Loco).to have_received(:`).with("./node_modules/grunt-cli/bin/grunt nggettext_compile")
#     end
#
#     context "with missing API_KEY" do
#       before(:each) do
#         stub_const("I18n::Loco::API_KEY", nil)
#       end
#
#       it "should not do anything" do
#         expect(I18n::Loco).to_not have_received(:get)
#         expect(I18n::Loco).to_not have_received(:`)
#       end
#     end
#   end
# end
