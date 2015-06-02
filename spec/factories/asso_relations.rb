FactoryGirl.define do
  factory :asso_relation do
    factory_id 1
    asso_id 1
    after(:create) do |asso_relation|
      asso =  Asso.find(asso_relation.asso_id)
      REDIS.sadd("assos", { asso_name: asso[:name], factory_id: asso[:factory_id], parent_factory_id: asso_relation.factory_id }.to_json)
    end
  end
end
