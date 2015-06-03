require 'spec_helper'
RSpec.describe FactoryLog, type: :model do
  describe "time ranking" do
    let!(:inspected_factory1) { { name: "factory1", traits: [], assos: [] } }
    let!(:inspected_factory2) { { name: "factory1", traits: ["trait_a"], assos: [] } }
    let!(:factory1) { Factory.create_unique_factory(inspected_factory1) }
    let!(:factory2) { Factory.create_unique_factory(inspected_factory2) }
    it do
      FactoryLog.logging(inspected_factory1, 1.0)
      FactoryLog.logging(inspected_factory1, 1.1)
      FactoryLog.logging(inspected_factory1, 1.0)
      FactoryLog.logging(inspected_factory2, 2.1)
      expect(FactoryLog.ranking).to eq [
                                         {
                                            factory: factory1.to_s,
                                            total_time: 1.0 + 1.1 + 1.0,
                                            count: 3,
                                            average_time: (1.0 + 1.1 + 1.0) / 3,
                                            factory_id: factory1.id
                                         },
                                         {
                                            factory: factory2.to_s,
                                            total_time: 2.1,
                                            count: 1,
                                            average_time: 2.1,
                                            factory_id: factory2.id
                                         }
                                       ]
    end
  end
end
