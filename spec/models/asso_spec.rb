require "spec_helper"
RSpec.describe Asso, type: :model do

  describe "#create_new_asso_and_relation" do
    let!(:factory1) { create :factory }
    let!(:asso1) { create :asso, name: "asso1", factory_id: factory1.id }
    let!(:parent1) { create :factory, name: "parent1" }
    let!(:asso_relation1) { create(:asso_relation, asso_id: asso1.id, factory_id: parent1.id) }
    it "same asso don't exist case" do
      REDIS.sadd("factory_names", factory1.name)
      REDIS.sadd("factory_names", parent1.name)
      REDIS.sadd("factory_with_traits", { factory_name: factory1.name, traits: factory1.traits.map(&:name).to_s, id: factory1.id }.to_json)
      REDIS.sadd("factory_with_traits", { factory_name: parent1.name, traits: parent1.traits.map(&:name).to_s, id: parent1.id }.to_json)
      expect { Asso.create_new_asso_and_relation({ name: "asso2", factory_name: factory1.name, traits: [] }, parent1) }.to change { Asso.all.size }.from(1).to(2)
    end
    it "having same factory asso exist case" do
      REDIS.sadd("factory_names", factory1.name)
      REDIS.sadd("factory_names", parent1.name)
      REDIS.sadd("factory_with_traits", { factory_name: factory1.name, traits: factory1.traits.map(&:name).to_s, id: factory1.id }.to_json)
      REDIS.sadd("factory_with_traits", { factory_name: parent1.name, traits: parent1.traits.map(&:name).to_s, id: parent1.id }.to_json)
      expect { Asso.create_new_asso_and_relation({ name: "asso1", factory_name: factory1.name, traits: [] }, parent1) }.not_to change { Asso.all.size }
    end
  end
end
