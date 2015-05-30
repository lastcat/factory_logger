FactoryGirl.define do
  factory :trait do
    sequence(:name) { |n| "Trait_#{n}" }
  end

end
