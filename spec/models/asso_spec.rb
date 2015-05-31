require "spec_helper"
RSpec.describe Asso, type: :model do

  describe "#create_new_asso_and_relation" do
    let!(:factory1) { create :factory }
    let!(:asso1) { create :asso, name: "asso1", factory_id: factory1.id }
    let!(:parent1) { create :factory, name: "parent1" }
    let!(:asso_relation1) { create(:asso_relation, asso_id: asso1.id, factory_id: parent1.id) }
    it "same asso don't exist case" do
      expect { Asso.create_new_asso_and_relation({ name: "asso2", factory_name: factory1.name, traits: [] }, parent1) }.to change { Asso.all.size }.from(1).to(2)
    end
    it "having same factory asso exist case" do
      expect { Asso.create_new_asso_and_relation({ name: "asso1", factory_name: factory1.name, traits: [] }, parent1) }.not_to change { Asso.all.size }
    end
  end

  describe "#same_asso" do
    let!(:factory1) { create :factory }
    let!(:factory2) { create :factory }
    let!(:asso1) { create :asso, name: "asso1", factory_id: factory1.id }
    let!(:parent1) { create :factory, name: "parent1" }
    let!(:parent2) { create :factory, name: "parent2" }
    let!(:asso_relation1) { create(:asso_relation, asso_id: asso1.id, factory_id: parent1.id) }
    context "same asso exist case" do
      it "same factory asso exist case" do
        expect(Asso.same_asso_exist?("asso1", factory1, parent1)).to eq true
      end
      it "asso_name defferent case" do
        expect(Asso.same_asso_exist?("asso2", factory1, parent1)).to eq false
      end
      it "deffenrent factory case" do
        expect(Asso.same_asso_exist?("asso1", factory2, parent1)).to eq false
      end
      it "deffenrent parent factory case" do
        expect(Asso.same_asso_exist?("asso1", factory1, parent2)).to eq false
      end
    end
  end
end
