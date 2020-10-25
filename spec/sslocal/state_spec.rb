# frozen_string_literal: true

require "sslocal/state"

RSpec.describe SSLocal::State do
  subject { described_class.new "test" }

  before :each do
    allow(File).to receive(:exist?).and_return(false)
  end

  describe "#enabled?" do
    it "returns true if both files exist" do
      allow(File).to receive(:exist?).with(
        File.expand_path("config/certificates/test.key")
      ).and_return(true)

      allow(File).to receive(:exist?).with(
        File.expand_path("config/certificates/test.crt")
      ).and_return(true)

      expect(subject).to be_enabled
    end

    it "returns false if only the key file exists" do
      allow(File).to receive(:exist?).with(
        File.expand_path("config/certificates/test.key")
      ).and_return(true)

      allow(File).to receive(:exist?).with(
        File.expand_path("config/certificates/test.crt")
      ).and_return(false)

      expect(subject).to_not be_enabled
    end

    it "returns false if only the cert file exists" do
      allow(File).to receive(:exist?).with(
        File.expand_path("config/certificates/test.key")
      ).and_return(false)

      allow(File).to receive(:exist?).with(
        File.expand_path("config/certificates/test.crt")
      ).and_return(true)

      expect(subject).to_not be_enabled
    end

    it "returns false if neither file exists" do
      allow(File).to receive(:exist?).with(
        File.expand_path("config/certificates/test.key")
      ).and_return(false)

      allow(File).to receive(:exist?).with(
        File.expand_path("config/certificates/test.crt")
      ).and_return(false)

      expect(subject).to_not be_enabled
    end
  end
end
