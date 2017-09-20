require "spec_helper"

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

  describe ".run" do
    context "called with import" do
      it "should call import from LocoAdapter" do
        params = { import: true }
        allow(CbxLoco::LocoAdapter).to receive(:import)
        CbxLoco.run params
        expect(CbxLoco::LocoAdapter).to have_received(:import)
      end
    end

    context "called with extract" do
      it "should call extract from LocoAdapter" do
        params = { extract: true }
        allow(CbxLoco::LocoAdapter).to receive(:extract)
        CbxLoco.run params
        expect(CbxLoco::LocoAdapter).to have_received(:extract)
      end
    end
  end
end
