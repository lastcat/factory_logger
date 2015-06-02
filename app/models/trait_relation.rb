# This is relation model between Factory and Trait
class TraitRelation < ActiveRecord::Base
  belongs_to :trait
  belongs_to :factory

  # if don't exist trait - factory, relation, create. otherwise return nil.
  def self.create_new_trait_relation(new_factory, trait)
    return unless REDIS.sadd("trait_relations", { factory: new_factory.name, trait: trait.name }.to_json)
    TraitRelation.create(factory_id: new_factory.id, trait_id: trait.id)
  end
end
