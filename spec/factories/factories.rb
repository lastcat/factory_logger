FactoryGirl.define do
  factory :factory do
    sequence(:name) { |n| "Factory#{n}" }
    after(:create) do |factory|
      REDIS.sadd("factory_names", factory.name)
    end
  end
end
