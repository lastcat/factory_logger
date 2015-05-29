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
      Factory.create_new_trait_and_relation(factoryA_with_trait, "A's_trait")
      expect(Factory.same_factory("factoryC",[])).to eq nil
      expect(Factory.same_factory("factoryA", ["hoge_trait"])).to eq nil
      expect(Factory.same_factory("factoryA", ["A's_trait"])).to eq factoryA_with_trait
    end
  end

  describe "#create_new_trait_and_relation" do
    let!(:new_factory) { create :factory }

    it "create traits and trait_relations record" do
      (1..3).each do |n|
        Factory.create_new_trait_and_relation(new_factory, "trait#{n}")
      end
      expect((1..3).map{|n| "trait#{n}"}).to eq new_factory.traits.map(&:name)
    end
  end

  describe "#create_new_trait_relation" do
    let!(:factory1) { create :factory }
    let!(:trait1) { build :trait }
    let!(:trait2) { create :trait }
    let!(:new_trait1) { Factory.create_new_trait_and_relation(factory1, trait1) }

    it "create new trait relation if it don't exist." do
      expect(TraitRelation.all.size).to eq 1
      Factory.create_new_trait_relation(factory1, trait2)
      expect(TraitRelation.all.size).to eq 2
      expect(factory1.traits.to_a).to eq [new_trait1, trait2]
      Factory.create_new_trait_relation(factory1, trait2)
      expect(TraitRelation.all.size).to eq 2
    end
  end

  describe "#create_asso_relations" do
    let!(:factory1) { create :factory }
    let!(:factory2) { create :factory }
    let!(:factory3) { create :factory }

    it "create asso relations record if it don't exist" do
      AssoRelation.create(factory_id: factory1.id, asso_id: factory2.id)
      Factory.create_asso_relations(factory1, [factory2, factory3])
      expect(factory1.assos).to eq [factory2, factory3]
    end
  end

  describe "#create_unique_factory" do
    let!(:asso_of_factory1) { create :factory, name: "asso_of_factory1" }
    let!(:factory1) { create :factory, name: "factory1" }
    let!(:factory1_with_trait) { create :factory, name: "factory1"}
    let!(:trait1_of_factory1) { build :trait, name: "trait1_of_factory1" }
    #let(:already_exist_factory) { build :factory, name: "factory1" }

    it "create new factory pattern and don't create if it already exist." do
      Factory.create_asso_relations(factory1, [asso_of_factory1])
      Factory.create_new_trait_and_relation(factory1_with_trait, trait1_of_factory1)

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
