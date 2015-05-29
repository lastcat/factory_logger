class Factory < ActiveRecord::Base
  has_many :trait_relations
  has_many :traits, through: :trait_relations
  has_many :asso_relations
  has_many :assos, through: :asso_relations

  def self.create_unique_factory(inspected_factory)
    # それぞれパラメータのnilカバー
    # それぞれが文字列配列であることを期待している
    name = inspected_factory[:name]
    traits = inspected_factory[:traits]
    assos = inspected_factory[:assos]
    is_first = true unless Factory.pluck(:name).include?(name)
    if is_first
      new_factory = Factory.create(name: name)
      traits.each do |trait|
        create_new_trait_and_relation(new_factory, trait)
      end
      create_asso_relations(new_factory, assos)
    else
      return if same_factory(name, traits)
      new_factory = Factory.create(name: name)
      traits.each do |trait|
        unless Trait.any? { |tr| tr.name == trait && tr.trait_relations.first.factory.name == name }
          create_new_trait_and_relation(new_factory, trait)
        else
          create_new_trait_relation(new_factory, trait)
        end
        create_asso_relations(new_factory, assos)
      end
    end
  end

  private

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

  # Traitのメソッドであるべきな気がしなくもない
  def self.create_new_trait_and_relation(new_factory, trait)
    new_trait = Trait.create(name: trait)
    new_trait_relation = new_factory.trait_relations.build
    new_trait_relation.trait = new_trait
    new_trait_relation.save
    new_trait
  end
  #これは明らかにTRのクラスメソッドでしょ
  def self.create_new_trait_relation(new_factory, trait)
    TraitRelation.all.each do |t_r|
       return if t_r.factory == new_factory && t_r.trait.name == trait.name
    end
    TraitRelation.create(factory_id: new_factory.id, trait_id: trait.id)
  end

  # 同上
  def self.create_asso_relations(new_factory, assos)
    return if assos.empty?
    assos.each do |asso|
      asso_factory = Factory.same_factory(asso.name, asso.traits)
      unless AssoRelation.any? { |a_r| a_r.factory == new_factory && a_r.asso == asso }
        AssoRelation.create(factory_id: new_factory.id, asso_id: asso_factory.id)
      end
    end
  end

end
