require "spec_helper"

RSpec.describe Factory, type: :model do

  describe "#same_factory" do
    context "no same factory case" do
      let!(:factoryA) { create :factory, name: "factoryA" }
      it { expect(Factory.same_factory("factoryC",[])).to eq nil }
    end

    context "no same trait having case" do
      let!(:factoryA) { create :factory, name: "factoryA" }
      let!(:factoryA_with_trait) { create :factory, name: "factoryA" }
      it do
        Trait.create_new_trait_and_relation(factoryA_with_trait, "A's_trait")
        expect(Factory.same_factory("factoryA", ["hoge_trait"])).to eq nil
      end
    end

    context "same factory exist case." do
      let!(:factoryA) { create :factory, name: "factoryA" }
      let!(:factoryA_with_trait) { create :factory, name: "factoryA" }
      it do
        Trait.create_new_trait_and_relation(factoryA_with_trait, "A's_trait")
        expect(Factory.same_factory("factoryA", ["A's_trait"])).to eq factoryA_with_trait
      end
    end
  end

  describe "#create_unique_factory" do

    context "already same factory exist case" do
      let!(:factory1) { create :factory, name: "factory1" }
      it "don't create new factory" do
        expect{ Factory.create_unique_factory(name: "factory1", traits: [], assos: []) }.not_to change { Factory.all }
      end
    end

    context "same factory dont't exist case" do
      let!(:factory1) { create :factory, name: "factory1" }
      it "create new factory" do
        expect{ Factory.create_unique_factory(name: "factory1", traits: ["trait2_of_factory1"], assos:[]) }.to change { Factory.all.size }.from(1).to(2)
      end

      it "create trait" do
        Factory.create_unique_factory(name: "factory1", traits: ["trait2_of_factory1"], assos:[])
        expect(Trait.all.any? { |trait| trait.name == "trait2_of_factory1" && trait.trait_relations.first.factory.name == "factory1" }).to eq true
      end
    end
  end
end
