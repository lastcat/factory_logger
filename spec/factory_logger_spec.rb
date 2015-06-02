require "spec_helper"
describe FactoryLogger do
  describe "is configurable" do
    FactoryLogger.configure do |config|
      config.redis_host = "http://regis_host_url"
      config.redis_port = 4649
    end
    let(:client) { Redis::Client.new(host: FactoryLogger.config.redis_host || "localhost", port: FactoryLogger.config.redis_port || 6379) }
    it "configured" do
      expect(FactoryLogger.config.redis_host).to eq ("http://regis_host_url")
      expect(FactoryLogger.config.redis_port).to eq 4649
    end

    it "config reflected" do
      expect(client.host).to eq "http://regis_host_url"
      expect(client.port).to eq 4649
    end
  end
end
