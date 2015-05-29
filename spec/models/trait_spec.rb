require "spec_helper"

RSpec.describe Trait, type: :model do
  describe "#create_new_trait_and_relation" do
    let!(:new_factory) { create :factory }

    it "create traits and trait_relations record" do
      (1..3).each do |n|
        Trait.create_new_trait_and_relation(new_factory, "trait#{n}")
      end
      expect((1..3).map{|n| "trait#{n}"}).to eq new_factory.traits.map(&:name)
    end
  end
end
