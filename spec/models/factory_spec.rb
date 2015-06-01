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

  describe "#same_factory_overwrite" do
    let!(:same_factory) { create :factory, name: "same_factory" }
    let!(:trait1) { create :trait, name: "trait1" }
    let!(:trait_relation1) { TraitRelation.create(factory_id: same_factory.id, trait_id: trait1.id) }

    context "have asso case" do
      let!(:assos) { [{ name: "asso1", traits: ["trait2"], factory_name: "same_factory" }] }
      it "same factory have no asso" do
        expect { Factory.same_factory_overwrite(assos, same_factory) }.to change{ same_factory.assos.size }.from(0).to(1)
      end
      context "same factory have assos" do
        let!(:factory_of_asso) { create :factory, name: "factory_of_asso1" }
        let!(:asso1) { create :asso, name: "asso1", factory_id: factory_of_asso.id }
        let!(:asso_relation1) { create :asso_relation, factory_id: same_factory.id, asso_id: asso1.id }
        it do
          expect { Factory.same_factory_overwrite(assos, same_factory) }.not_to change{ same_factory.assos.size }
        end
      end
    end

    context "have no asso case" do
      let!(:assos) { [] }
      it "same factory have no asso" do
        expect { Factory.same_factory_overwrite(assos, same_factory) }.not_to change{ same_factory.assos.size }
      end
      context "same factory have assos" do
        let!(:factory_of_asso) { create :factory, name: "factory_of_asso1" }
        let!(:asso1) { create :asso, name: "asso1", factory_id: factory_of_asso.id }
        let!(:asso_relation1) { create :asso_relation, factory_id: same_factory.id, asso_id: asso1.id }
        it do
          expect { Factory.same_factory_overwrite(assos, same_factory) }.not_to change{ same_factory.assos.size }
        end
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

  describe ".depth" do
    let!(:factory1) { create :factory }
    let!(:factory2) { create :factory }
    let!(:factory3) { create :factory }
    let!(:asso1) { create :asso, name: "asso1", factory: factory2 }
    let!(:asso_relation1) { AssoRelation.create(factory_id: factory1.id, asso_id: asso1.id) }
    let!(:asso2) { create :asso, name: "asso2", factory: factory2 }
    let!(:asso_relation2) { AssoRelation.create(factory_id: factory1.id, asso_id: asso2.id) }
    let!(:asso3) { create :asso, name: "asso3", factory: factory3 }
    let!(:asso_relation3) { AssoRelation.create(factory_id: factory2.id, asso_id: asso3.id) }

    it do
      expect(factory1.depth).to eq 3
    end
  end
end
