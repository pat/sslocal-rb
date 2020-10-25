# frozen_string_literal: true

require "sslocal/puma_rebinder"

RSpec.describe SSLocal::PumaRebinder do
  let(:dsl) do
    double(:dsl, :clear_binds! => nil, :ssl_bind => nil, :bind => nil)
  end
  let(:binds) { ["tcp://0.0.0.0:3000"] }
  let(:state) do
    double(:state, :enabled? => true, :key_path => "my.key",
      :cert_path => "my.crt")
  end

  subject { described_class }

  before :each do
    allow(dsl).to receive(:get).with(:binds).and_return(binds)
    allow(dsl).to receive(:get).with(:environment).and_return("test")

    allow(SSLocal::State).to receive(:new).and_return(state)
  end

  it "does nothing if there are no binds" do
    allow(dsl).to receive(:get).with(:binds).and_return(nil)

    subject.call dsl

    expect(dsl).to_not have_received(:clear_binds!)
  end

  it "loads the state for the supplied environment" do
    subject.call dsl

    expect(SSLocal::State).to have_received(:new).with("test")
  end

  it "does nothing if the state is disabled" do
    allow(state).to receive(:enabled?).and_return(false)

    subject.call dsl

    expect(dsl).to_not have_received(:clear_binds!)
  end

  it "replaces TCP bindings with SSL" do
    subject.call dsl

    expect(dsl).to have_received(:ssl_bind).with(
      "0.0.0.0", "3000", :key => "my.key", :cert => "my.crt"
    )
  end

  it "does not modify unix bindings" do
    allow(dsl).to receive(:get).with(:binds).and_return(["unix:///path.socket"])

    subject.call dsl

    expect(dsl).to have_received(:bind).with("unix:///path.socket")
  end

  it "uses 0.0.0.0 if the binding does not specify a host" do
    allow(dsl).to receive(:get).with(:binds).and_return(["tcp://:4000"])

    subject.call dsl

    expect(dsl).to have_received(:ssl_bind).with(
      "0.0.0.0", "4000", :key => "my.key", :cert => "my.crt"
    )
  end

  it "does not modify any bindings if there's an unknown TCP format" do
    allow(dsl).to receive(:get).with(:binds).and_return(["tcp://foo"])

    subject.call dsl

    expect(dsl).to have_received(:bind).with("tcp://foo")
  end
end
