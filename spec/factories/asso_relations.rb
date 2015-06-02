FactoryGirl.define do
  factory :asso_relation do
    factory_id 1
    asso_id 1
    after(:create) do |asso_relation|
      REDIS.sadd("assos", { asso_name: Asso.find(asso_relation.asso_id)[:name], factory_id: Asso.find(asso_relation.asso_id)[:factory_id], parent_factory_id: asso_relation.factory_id }.to_json)
    end
  end
end
