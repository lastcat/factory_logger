require "pry-byebug"
# This is factory pattern(indentified factory_name and having traits) class.
class Factory < ActiveRecord::Base
  has_many :trait_relations
  has_many :traits, through: :trait_relations
  has_many :asso_relations
  has_many :assos, through: :asso_relations

  # Create a unique factory pattern.
  # Arguments is expected, hash like this,
  # name: factory_name
  # traits: trait_name(String) array
  # assos: array of hash { name:association_name, traits: trait(string) array, factory_name: factory_name }
  # I wrote factory_inspector gem (https://github.com/lastcat/factory_inspector). Please use it.
  def self.create_unique_factory(inspected_factory)
    # TODO: パラメータのnilカバー
    factory_name = inspected_factory[:name]
    traits = inspected_factory[:traits]
    assos = inspected_factory[:assos]

    if is_first_look_factory?
      new_factory = Factory.create(name: factory_name)
      Trait.create_new_traits_and_relations(new_factory, traits)
      Asso.create_new_assos_and_relations(new_factory, assos)
    else
      same_factory = search_same_factory(factory_name, traits)
      # We can get factory's assos only when it executed as "subject" (not as "asso" of other factory!).
      # So, We must overwrite it's asso and asso_relation in case the factory registered when it executed as other factory's asso before.
      return overwrite_same_factory_asso(assos, Factory.find(same_factory["id"])) unless same_factory.nil?

      new_factory = Factory.create(name: factory_name)
      Trait.add_new_traits_and_relations(new_factory, traits)
      Asso.create_new_assos_and_relations(new_factory, assos)
    end
    # Register concat factory and traits for uniqueness inspection @#search_same_factory
    REDIS.sadd("factory_with_traits", {
                                        factory_name: new_factory.name,
                                        traits: new_factory.traits.map(&:name).to_s,
                                        id: new_factory.id
                                      }.to_json)
    new_factory
  end

  # Return max depth of association
  def depth
    return 1 if assos.empty?
    assos.map do |asso|
      asso.factory.depth
    end.max + 1
  end

  # Return factory's familty array. index equal to depth.
  # TODO: 非自明なので分割するなりコメントなりもうちょっと書く
  def family
    queue = []
    queue.unshift(self)
    results = []
    generation = 0
    while (!queue.empty?)
      count = queue.inject(0) { |sum, factory| sum + factory.assos.size }
      break if count == 0
      results[generation] = []
      while (count > 0)
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
    name + "," + traits.map(&:name).join(",").to_s
  end

  private
  
    # Return same name and same traits having factory.
    # TODO: improve algorithm
    def self.search_same_factory(name, trait_names)
      trait_names = trait_names.to_s
      # This is maybe too slow
      REDIS.smembers("factory_with_traits").find do |fwt|
        factory_hash = JSON.parse(fwt)
        return factory_hash if factory_hash["factory_name"] == name && factory_hash["traits"] == trait_names
      end
    end

    # Return same factory. If if it is no asoociarion, overwrite new assos.
    def self.overwrite_same_factory_asso(assos, same_factory)
      if assos == same_factory.assos
        return same_factory
      elsif !assos.empty? && same_factory.assos.empty?
        Asso.create_new_assos_and_relations(same_factory, assos)
      end
      same_factory.reload
    end

    def self.is_first_look_factory?
      REDIS.sadd("factory_names", name).nil?
    end
end
