require 'spec_helper'
RSpec.describe FactoryLog, type: :model do
  describe '#log_set' do
    let!(:factoryAs) { create_list(:factory_log, 10) }
    let!(:factoryBs) { create_list(:factory_log, 10, :factoryB) }

    it 'return FactoyAs' do
      expect(FactoryLog.log_set("factoryA")).to eq factoryAs
    end
  end

  describe '#log_set_with_trait' do
    let!(:factoryAs) { create_list(:factory_log, 10) }
    let!(:factoryAs_with_trait) { create_list(:factory_log, 10, :have_trait) }
    let!(:sample) { factoryAs_with_trait.first }

    it 'return objects have trait' do
      expect(FactoryLog.log_set_with_trait(sample.name + sample.traits)).to eq factoryAs_with_trait
    end
  end

  describe '#candidates' do
    let!(:factoryAs) { create(:factory_log) }
    let!(:factoryAs_with_trait) { create(:factory_log, :have_trait) }
    let!(:factoryBs) { create(:factory_log, :factoryB) }

    it 'return all candidates' do
      expect(FactoryLog.candidates()).to eq [
                                              (factoryAs.name + factoryAs.traits),
                                              (factoryAs_with_trait.name + factoryAs_with_trait.traits),
                                              (factoryBs.name + factoryBs.traits)
                                            ]
    end
  end

  describe '#sum_time' do
    let!(:factoryAs) { create_list(:factory_log, 10) }
    let!(:sample) { factoryAs.first }
    it 'return total time factoyAs' do
      expect(FactoryLog.sum_time(sample.name + sample.traits)).to eq 20.0
    end
  end

  describe '#average_time' do
    let!(:factoryAs) { create_list(:factory_log, 10) }
    let!(:factoryAs_short) { create_list(:factory_log, 7, time: 0.5) }
    let!(:factoryAs_long) { create_list(:factory_log, 3, time: 5.0) }
    let(:sample) { factoryAs.first }

    it 'return average time factoryAs' do
      expect(FactoryLog.average_time(sample.name + sample.traits)).to eq ((2.0 * 10) + (0.5 * 7) + (5.0 * 3)) / (10 + 7 + 3)
    end
  end

  describe 'time_ranking' do
    let!(:factoryAs) { create_list(:factory_log, 10) }
    let!(:factoryAs_with_traits) { create_list(:factory_log, 1, :have_trait) }
    let!(:factoryBs) { create_list(:factory_log, 3, :factoryB) }

    let!(:a_sample) { factoryAs.first }
    let!(:a_with_traits_sample) { factoryAs_with_traits.first }
    let!(:b_sample) { factoryBs.first }

    let!(:a_ranking_data) {
                            {
                              name: (a_sample.name + a_sample.traits),
                              total_time: 2.0 * 10,
                              count: 10,
                              average_time: 2.0
                            }
                          }
    let!(:a_with_traits_ranking_data) {
                                        {
                                          name: (a_with_traits_sample.name + a_with_traits_sample.traits),
                                          total_time: 2.0,
                                          count: 1,
                                          average_time: 2.0
                                        }
                                      }
    let!(:b_ranking_data) {
                            {
                              name: (b_sample.name + b_sample.traits),
                              total_time: 10.0 * 3,
                              count: 3,
                              average_time: 10.0
                            }
                          }

    it 'ranking about time they took (total)' do
      expect(FactoryLog.time_ranking).to eq [
                                              b_ranking_data,
                                              a_ranking_data,
                                              a_with_traits_ranking_data
                                            ]
    end
  end
end
