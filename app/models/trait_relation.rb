# This is relation model between Factory and Trait
class TraitRelation < ActiveRecord::Base
  belongs_to :trait
  belongs_to :factory

  # if don't exist trait - factory, relation, create. otherwise return nil.
  def self.create_new_trait_relation(new_factory, trait)
    # TODO: more faster
    #TraitRelation.each do |t_r|
    #  return if t_r.factory == new_factory && t_r.trait.name == trait.name
    #end
    return if TraitRelation.any? { |t_r| t_r.factory == new_factory && t_r.trait.name == trait.name }
    TraitRelation.create(factory_id: new_factory.id, trait_id: trait.id)
  end
end
