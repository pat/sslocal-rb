# frozen_string_literal: true

require "puma/plugin/sslocal"

RSpec.describe Puma::Plugin::SSLocal do
  it "responds to initialize without an argument" do
    expect { described_class.new }.to_not raise_error
  end

  it "responds to initialize with an argument" do
    expect { described_class.new double }.to_not raise_error
  end

  it "responds to config" do
    expect { subject.config double }.to_not raise_error
  end

  describe "#start" do
    let(:launcher) { double(:launcher, :config => configuration) }
    let(:configuration) { double(:configuration) }
    let(:user_config) { double }
    let(:file_config) { double }
    let(:default_config) { double }
    let(:rebinder) { double(:rebinder, :call => nil) }

    before :each do
      allow(configuration).to receive(:configure).
        and_yield(user_config, file_config, default_config)

      stub_const("SSLocal::PumaRebinder", rebinder)
    end

    it "rebinds the user configuration" do
      subject.start(launcher)

      expect(rebinder).to have_received(:call).with(user_config)
    end

    it "rebinds the file configuration" do
      subject.start(launcher)

      expect(rebinder).to have_received(:call).with(file_config)
    end

    it "rebinds the default configuration" do
      subject.start(launcher)

      expect(rebinder).to have_received(:call).with(default_config)
    end
  end
end
