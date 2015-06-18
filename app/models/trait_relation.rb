# This is relation model between Factory and Trait
class TraitRelation < ActiveRecord::Base
  belongs_to :trait
  belongs_to :factory

  # if don't exist trait - factory, relation, create. otherwise return nil.
  def self.create_new_trait_relation(new_factory, trait)
    TraitRelation.create(factory_id: new_factory.id, trait_id: trait.id) unless same_relation_exist?(new_factory, trait)
  end

  private
    def self.same_relation_exist?(factory, trait)
      !(REDIS.sadd("trait_relations", { factory: factory.id, trait: trait.id }.to_json))
    end
end
