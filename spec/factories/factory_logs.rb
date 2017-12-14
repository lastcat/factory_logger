FactoryBot.define do
  factory :factory_log do
    name "factoryA"
    traits "[]"
    assos "[]"
    parent_id 0
    time 2.0

    trait :have_trait do
      traits "[:trait]"
      time 2.0
      parent_id 0
    end

    trait :factoryB do
      name "factoryB"
      traits "[]"
      assos "[]"
      time 10.0
      parent_id 0
    end
  end
end
