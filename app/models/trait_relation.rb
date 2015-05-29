class TraitRelation < ActiveRecord::Base
  belongs_to :trait
  belongs_to :factory

  # if don't exist trait - factory, relation, create. otherwise return nil.
  def self.create_new_trait_relation(new_factory, trait)
    TraitRelation.all.each do |t_r|
       return if t_r.factory == new_factory && t_r.trait.name == trait.name
    end
    TraitRelation.create(factory_id: new_factory.id, trait_id: trait.id)
  end

end
