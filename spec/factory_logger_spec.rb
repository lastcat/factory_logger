require 'spec_helper'
describe FactoryLogger do
  describe "is configurable" do
    FactoryLogger.configure do |config|
      config.something = "something config"
    end
    it 'configured' do
      expect(FactoryLogger.config.something).to eq ("something config")
    end
  end

  describe ".descendants and .ancestors" do
    let!(:top) { create :factory_log, name: "top", parent_id: nil }
    let!(:child1) { create :factory_log, name: "child1", parent_id: top.id }
    let!(:child2) { create :factory_log, name: "child2", parent_id: top.id }
    let!(:child3) { create :factory_log, name: "child3", parent_id: top.id }
    let!(:grand_son1_1) { create :factory_log, name: "grand_son1_1", parent_id: child1.id }
    let!(:grand_son1_2) { create :factory_log, name: "grand_son1_2", parent_id: child1.id }
    let!(:grand_son2_1) { create :factory_log, name: "grand_son2_1", parent_id: child2.id }

    it "have descendants" do
      expect(top.descendants).to eq [
                                      [child1, [ [grand_son1_1], [grand_son1_2] ] ],
                                      [child2, [ [grand_son2_1] ] ],
                                      [child3]
                                    ]
    end
    it "have ancestors" do
      expect(grand_son1_1.ancestors).to eq [child1, top]
    end
  end
end
