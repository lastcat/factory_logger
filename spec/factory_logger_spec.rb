require 'spec_helper'
describe FactoryLogger do
  describe "is configurable" do
    FactoryLogger.configure do |config|
      config.something = "something config"
    end
    it 'configured' do
      expect(FactoryLogger.config.something).to eq ("something config")
    end
  end
end
