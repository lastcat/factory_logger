class Trait < ActiveRecord::Base
  has_many :trait_relations

  def self.create_new_trait_and_relation(new_factory, trait)
    new_trait = Trait.create(name: trait)
    new_trait_relation = new_factory.trait_relations.build
    new_trait_relation.trait = new_trait
    new_trait_relation.save
    new_trait
  end
end
