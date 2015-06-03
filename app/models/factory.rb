require "pry-byebug"
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
    is_first = REDIS.sadd("factory_names", name)
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
      return same_factory_overwrite(assos, Factory.find(same_factory["id"])) if same_factory
      new_factory = Factory.create(name: name)
      traits.each do |trait|
        if Factory.same_trait_exist?(trait, name)
          existing_trait = Trait.where(name: trait).select { |tr| tr.factories.first.name == name }.first
          TraitRelation.create_new_trait_relation(new_factory, existing_trait)
        else
          Trait.create_new_trait_and_relation(new_factory, trait)
        end
        assos.each do |asso|
          Asso.create_new_asso_and_relation(asso, new_factory)
        end
      end
    end
    REDIS.sadd("factory_with_traits", { factory_name: new_factory.name, traits: new_factory.traits.map(&:name).to_s, id: new_factory.id }.to_json)
    new_factory
  end

  # Return same name and same traits having factory.
  def self.same_factory(name, trait_names)
    trait_names = trait_names.to_s
    result = REDIS.smembers("factory_with_traits").find do |fwt|
      factory_hash = JSON.parse(fwt)
      factory_hash["factory_name"] == name && factory_hash["traits"] == trait_names
    end
    JSON.parse(result) if result
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
    same_factory.reload
  end

  # Return whether same name and parent factory trait exist.
  def self.same_trait_exist?(trait, factory_name)
    !REDIS.sadd("traits", { name: trait, factory_name: factory_name }.to_json)
  end

  # Return max depth of association
  def depth
    return 1 if assos.empty?
    assos.map do |asso|
      asso.factory.depth
    end.max + 1
  end

  # Return factory's familty array. index equal to depth.
  def family
    queue = []
    queue.unshift(self)
    results = []
    generation = 0
    while(!queue.empty?)
      count = queue.inject(0) { |sum, factory| sum + factory.assos.size }
      break if count == 0
      results[generation] = []
      while(count > 0)
        queue.pop.assos.each do |asso|
          factory = asso.factory
          results[generation].push(factory)
          queue.unshift(factory)
          count -= 1
        end
      end
      generation += 1
    end
    results
  end

  def to_s
    name + ":" + traits.map(&:name).join(",").to_s
  end
end
