require "test_helper"

describe CbxLoco::Commands do

  describe "#parse" do
    context "call with import" do
      it "should return import command" do
        command = CbxLoco::Commands.parse ["--import"]
        expect(command[:import]).to be true
      end

      it "should not output help" do
        expect { CbxLoco::Commands.parse ["--import"] }.to_not output.to_stdout
      end
    end

    context "call with extract" do
      it "should return extract command" do
        command = CbxLoco::Commands.parse ["--extract"]
        expect(command[:extract]).to be true
      end

      it "should not output help" do
        expect { CbxLoco::Commands.parse ["--extract"] }.to_not output.to_stdout
      end
    end

    context "call with any command" do
      it "should print help" do
        expect { CbxLoco::Commands.parse ["any_method"] }.to output.to_stdout
      end
    end

    context "call with nothing" do
      it "should print help" do
        expect { CbxLoco::Commands.parse [] }.to output.to_stdout
      end

      it "should exit" do
        begin
          CbxLoco::Commands.parse []
        rescue SystemExit => e
          expect(e.status).to eq 1
        end
      end
    end
  end
end
