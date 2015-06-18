# This is relation model between Factory and Assocition(it is alias of factory)
class AssoRelation < ActiveRecord::Base
  belongs_to :factory
  belongs_to :asso

  # Create new assos relation if it don't exisrt
  # TODO: 分割。重複チェックの部分分割できる
  def self.create_asso_relations(new_factory, assos)
    return if assos.empty?
    assos.each do |asso|
      asso_factory = Factory.same_factory(asso.name, asso.traits)
      AssoRelation.create(
                            factory_id: new_factory.id,
                            asso_id: asso_factory.id
                          ) unless same_asso_relation_exist?(new_factory, asso.name)
    end
  end

  private
  
    #TODO :write test
    def self.same_asso_relation_exist?(factory, asso_name)
      !(REDIS.sadd("asso_relations", { factory_id: factory.id, asso: asso_name }.to_json))
    end
end
