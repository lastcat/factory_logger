require 'spec_helper'

RSpec.describe FactoryLog, type: :model do
  describe 'test' do
    it { expect(1 + 1).to eq 2 }
  end

  describe 'can use factory_girl?' do
    let(:fl1) { create(:factory_log) }
    it { expect(fl1).to eq fl1 }
  end
end
