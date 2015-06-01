# This is Factroy pattern(indentified factory_name and having traits) class.
class Factory < ActiveRecord::Base
  has_many :trait_relations
  has_many :traits, through: :trait_relations
  has_many :asso_relations
  has_many :assos, through: :asso_relations

  # Create unique factory pattern.
  # Arguments is expected, hash like this,
  # name: factory_name
  # traits: trait_name(String) array
  # assos: array of hash { name:association_name, traits: trait(string) array, factory_name: factory_name }
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
      assos.each do |asso|
        Asso.create_new_asso_and_relation(asso, new_factory)
      end
    else
      same_factory = same_factory(name, traits)
      return same_factory_overwrite(assos, same_factory) if same_factory
      new_factory = Factory.create(name: name)
      traits.each do |trait|
        if Trait.any? { |tr| tr.name == trait && tr.trait_relations.first.factory.name == name }
          TraitRelation.create_new_trait_relation(new_factory, trait)
        else
          Trait.create_new_trait_and_relation(new_factory, trait)
        end
        assos.each do |asso|
          Asso.create_new_asso_and_relation(asso, new_factory)
        end
      end
    end
    new_factory
  end

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

  # Return same factory. If if it is no asoociarion, overwrite new assos.
  def self.same_factory_overwrite(assos, same_factory)
    if assos == same_factory.assos
      return same_factory
    elsif !assos.empty? && same_factory.assos.empty?
      assos.each do |asso|
        Asso.create_new_asso_and_relation(asso, same_factory)
      end
    end
    return same_factory.reload
  end
end
