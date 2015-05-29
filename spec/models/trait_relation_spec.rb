require "spec_helper"

RSpec.describe TraitRelation, type: :model do
  describe "#create_new_trait_relation" do
    context "create new trait relation if it don't exist." do
      let!(:factory1) { create :factory }
      let!(:trait1) { create :trait }
      it "" do
        TraitRelation.create_new_trait_relation(factory1, trait1)
        expect(factory1.traits).to eq [trait1]
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
