# This is relation model between Factory and Assocition(it is alias of factory)
class AssoRelation < ActiveRecord::Base
  belongs_to :factory
  belongs_to :asso

  # Create new assos relation if it don't exisrt
  def self.create_asso_relations(new_factory, assos)
    return if assos.empty?
    assos.each do |asso|
      asso_factory = Factory.same_factory(asso.name, asso.traits)
      unless REDIS.add("asso_relations", { factory: new_factory.name, asso: asso.name }.to_json)
        AssoRelation.create(factory_id: new_factory.id, asso_id: asso_factory.id)
      end
    end
  end
end
