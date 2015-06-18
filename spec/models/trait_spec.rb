require "spec_helper"

RSpec.describe Trait, type: :model do
  describe "#create_new_trait_and_relation" do
    let!(:new_factory) { create :factory }

    it "create traits and trait_relations record" do
      (1..3).each do |n|
        Trait.create_new_trait_and_relation(new_factory, "trait#{n}")
      end
      expect((1..3).map{|n| "trait#{n}"}).to eq new_factory.traits.map(&:name)
    end
  end

  describe "#same_trait_exist?" do
    it "same trait found case" do
      REDIS.sadd("traits", { name: "trait1", factory_name: "factory1" }.to_json)
      REDIS.sadd("traits", { name: "trait2", factory_name: "factory1" }.to_json)
      expect(Trait.same_trait_exist?("trait1", "factory1")).to eq true
    end
    it "same trait couldn't found case" do
      REDIS.sadd("traits", { name: "trait1", factory_name: "factory1" }.to_json)
      REDIS.sadd("traits", { name: "trait2", factory_name: "factory1" }.to_json)
      expect(Trait.same_trait_exist?("trait3", "factory1")).to eq false
    end
  end
end
