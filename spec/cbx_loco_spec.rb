require "test_helper"

describe CbxLoco do
  describe ".configure" do
    let(:any_api_key) { "ANY API KEY" }

    before do
      CbxLoco.configure do |c|
        c.api_key = any_api_key
      end
    end

    it "should set values" do
      expect(CbxLoco.configuration.api_key).to eq any_api_key
    end
  end
end
