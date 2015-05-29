FactoryGirl.define do
  factory :factory do
    sequence(:name) { |n| "Factory#{n}" }
  end

end
