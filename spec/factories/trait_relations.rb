FactoryBot.define do
  factory :trait_relation do
    factory_id 0
    trait_id 0
    after(:create) do |trait_relation|
      REDIS.sadd("traits", { name: trait_relation.trait.name, factory_name: trait_relation.factory.name }.to_json)
      REDIS.sadd("trait_relations", { factory: trait_relation.factory.id, trait: trait_relation.trait.id }.to_json)
    end
  end
end
