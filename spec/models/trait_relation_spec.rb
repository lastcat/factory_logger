require "spec_helper"

RSpec.describe TraitRelation, type: :model do

  describe ".same_trait_exist?" do
    let!(:factory) { create :factory }
    let!(:trait) { create :trait }
    let!(:trait_relation) { create :trait_relation, factory_id: factory.id, trait_id: trait.id }
    context "exist case" do
      it do
        expect(TraitRelation.same_relation_exist?(factory, trait)).to eq true
      end
    end
    context "don't exist case" do
      let!(:another_trait) { create :trait }
      it do
        expect(TraitRelation.same_relation_exist?(factory, another_trait)).to eq false
      end
    end
  end
  describe ".create_new_trait_relation" do
    context "create new trait relation if it don't exist." do
      let!(:factory1) { create :factory }
      let!(:trait1) { create :trait }
      it "" do
        TraitRelation.create_new_trait_relation(factory1, trait1)
        expect(factory1.traits.to_a).to eq [trait1]
      end
    end
    context "don't create already relation exist." do
      let!(:factory1) { create :factory }
      let!(:trait1) { create :trait }
      it "" do
        TraitRelation.create_new_trait_relation(factory1, trait1)
        expect{ TraitRelation.create_new_trait_relation(factory1, trait1) }.not_to change { TraitRelation.all.size }
      end
    end
  end
end
