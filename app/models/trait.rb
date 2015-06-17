# This is Trait model identified by namae and related factory.
class Trait < ActiveRecord::Base
  has_many :trait_relations
  has_many :factories, through: :trait_relations

  def self.create_new_trait_and_relation(new_factory, trait)
    new_trait = Trait.create(name: trait)
    REDIS.sadd("traits", { name: trait, factory_name: new_factory.name }.to_json)
    new_trait_relation = new_factory.trait_relations.build
    new_trait_relation.trait = new_trait
    new_trait_relation.save
    new_trait
  end

  # TODO: write test
  def self.create_new_traits_and_relations(factory, traits_names)
    traits_names.each do |trait|
      Trait.create_new_trait_and_relation(new_factory, trait)
    end
  end

  # TODO: write test
  # Create and register only not connected traits to factory.
  def self.add_new_traits_and_relations(factory, trait_names)
    trait_names.each do |trait|
      if Factory.same_trait_exist?(trait, factory.name)
        existing_trait = Trait.where(name: trait).select { |tr| tr.factories.first.name == factory.name }.first
        TraitRelation.create_new_trait_relation(factory, existing_trait)
      else
        Trait.create_new_trait_and_relation(factory, trait)
      end
    end
  end
end
