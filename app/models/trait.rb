# This is Trait model identified by namae and related factory.
class Trait < ActiveRecord::Base
  has_many :trait_relations
  has_many :factories, through: :trait_relations

  def self.create_new_trait_and_relation(new_factory, trait)
    new_trait = Trait.create(name: trait)
    REDIS.sadd("traits", { name: trait, factory_name: new_factory.name }.to_json)
    TraitRelation.create_new_trait_relation(new_factory, new_trait)
  end

  # TODO: write test
  def self.create_new_traits_and_relations(factory, traits_names)
    traits_names.each do |trait|
      create_new_trait_and_relation(new_factory, trait)
    end
  end

  # TODO: write test
  # Create and register only not connected traits to factory.
  def self.add_new_traits_and_relations(factory, trait_names)
    trait_names.each do |trait|
      if same_trait_exist?(trait, factory.name)
        TraitRelation.create_new_trait_relation(factory, seach_existing_trait(trait, factory.name))
      else
        create_new_trait_and_relation(factory, trait)
      end
    end
  end

  private
  
    # TODO: write test
    def self.seach_existing_trait(trait_name, factory_name)
      where(name: trait_name).find { |tr| tr.factories.first.name == factory_name }
    end

    # Return whether same name and parent factory trait exist.
    def self.same_trait_exist?(trait, factory_name)
      !REDIS.sadd("traits", { name: trait, factory_name: factory_name }.to_json)
    end
end
