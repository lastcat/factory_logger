require "spec_helper"

RSpec.describe TraitRelation, type: :model do
  describe "#create_new_trait_relation" do
    let!(:factory1) { create :factory }
    let!(:trait1) { build :trait }
    let!(:trait2) { create :trait }
    let!(:new_trait1) { Trait.create_new_trait_and_relation(factory1, trait1) }

    it "create new trait relation if it don't exist." do
      expect(TraitRelation.all.size).to eq 1
      TraitRelation.create_new_trait_relation(factory1, trait2)
      expect(TraitRelation.all.size).to eq 2
      expect(factory1.traits.to_a).to eq [new_trait1, trait2]
      TraitRelation.create_new_trait_relation(factory1, trait2)
      expect(TraitRelation.all.size).to eq 2
    end
  end
end
