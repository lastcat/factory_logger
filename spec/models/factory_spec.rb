require "spec_helper"

RSpec.describe Factory, type: :model do

  # TODO: 各ケース適当に分割する
  # TODO: そもそもメソッド別クラスにしてテストも分ける
  describe "#same_factory" do
    let!(:factoryA) { create :factory, name: "factoryA" }
    let!(:factoryA_with_trait) { create :factory, name: "factoryA" }
    let!(:factoryB) { create :factory }
    let!(:factoryC) { build :factory }

    it "return same_factory (if exist), or nil (don't exist)" do
      Trait.create_new_trait_and_relation(factoryA_with_trait, "A's_trait")
      expect(Factory.same_factory("factoryC",[])).to eq nil
      expect(Factory.same_factory("factoryA", ["hoge_trait"])).to eq nil
      expect(Factory.same_factory("factoryA", ["A's_trait"])).to eq factoryA_with_trait
    end
  end

  describe "#create_unique_factory" do
    let!(:asso_of_factory1) { create :factory, name: "asso_of_factory1" }
    let!(:factory1) { create :factory, name: "factory1" }
    let!(:factory1_with_trait) { create :factory, name: "factory1"}
    let!(:trait1_of_factory1) { build :trait, name: "trait1_of_factory1" }
    #let(:already_exist_factory) { build :factory, name: "factory1" }

    it "create new factory pattern and don't create if it already exist." do
      AssoRelation.create_asso_relations(factory1, [asso_of_factory1])
      Trait.create_new_trait_and_relation(factory1_with_trait, trait1_of_factory1)

      before_size = Factory.all.size
      Factory.create_unique_factory(name: "factory1", traits: [], assos: [])
      after_size = Factory.all.size
      expect(after_size).to eq before_size
      Factory.create_unique_factory(name: "factory1", traits: ["trait2_of_factory1"], assos:[])
      after_after_size = Factory.all.size
      expect(after_after_size).to eq after_size + 1
      expect(Trait.all.any? { |trait| trait.name == "trait2_of_factory1" && trait.trait_relations.first.factory.name == "factory1" }).to eq true
    end
  end
end
