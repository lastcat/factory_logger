require "spec_helper"

RSpec.describe AssoRelation, type: :model do
  describe "#create_asso_relations" do
    let!(:factory1) { create :factory }
    let!(:factory2) { create :factory }
    let!(:factory3) { create :factory }

    it "create asso relations record if it don't exist" do
      AssoRelation.create(factory_id: factory1.id, asso_id: factory2.id)
      AssoRelation.create_asso_relations(factory1, [factory2, factory3])
      expect(factory1.assos).to eq [factory2, factory3]
    end
  end
end
