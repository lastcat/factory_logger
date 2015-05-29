class Factory < ActiveRecord::Base
  has_many :trait_relations
  has_many :traits, through: :trait_relations
  has_many :asso_relations
  has_many :assos, through: :asso_relations

  # Create unique factory pattern.
  # Arguments is expected, hash like this,
  # name: factory_name
  # traits: trait_name(String) array
  # assos: assoiacion_name(Strings) arary
  # I wrote factroy_inspector gem (https://github.com/lastcat/factory_inspector). Please use it.
  def self.create_unique_factory(inspected_factory)
    # TODO: パラメータのnilカバー
    name = inspected_factory[:name]
    traits = inspected_factory[:traits]
    assos = inspected_factory[:assos]
    is_first = true unless Factory.pluck(:name).include?(name)
    if is_first
      new_factory = Factory.create(name: name)
      traits.each do |trait|
        Trait.create_new_trait_and_relation(new_factory, trait)
      end
      AssoRelation.create_asso_relations(new_factory, assos)
    else
      return if same_factory(name, traits)
      new_factory = Factory.create(name: name)
      traits.each do |trait|
        unless Trait.any? { |tr| tr.name == trait && tr.trait_relations.first.factory.name == name }
          Trait.create_new_trait_and_relation(new_factory, trait)
        else
          TraitRelation.create_new_trait_relation(new_factory, trait)
        end
        AssoRelation.create_asso_relations(new_factory, assos)
      end
    end
  end

  private

  # Return same name and same traits having factory.
  def self.same_factory(name, trait_names)
    Factory.all.find do |factory|
      if factory.traits.nil?
        factory_traits = []
      else
        factory_traits = factory.traits.map(&:name)
      end
      factory.name == name && factory_traits == trait_names
    end
  end

end
