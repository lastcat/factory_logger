# Association model indentified asso_name, factory, prent_factory.
class Asso < ActiveRecord::Base
  belongs_to :factory
  has_many :asso_relations
  has_many :parent_factories, through: :asso_relations, source: "factory"

  # Create new asso.If same asso exist, return nil.
  def self.create_new_asso_and_relation(asso_hash, parent_factory)
    # asso_hash is
    # name: associarion_name
    # traits: String array of trait name
    # factory_name: name of asso's factory
    factory = Factory.create_unique_factory(name: asso_hash[:factory_name], traits: asso_hash[:traits], assos: [])
    return if same_asso_exist?(asso_hash[:name], factory, parent_factory)
    new_asso = Asso.create(name: asso_hash[:name], factory_id: factory.id)
    AssoRelation.create(factory_id: parent_factory.id, asso_id: new_asso.id)
  end

  # Judging whether same asso exist.
  def self.same_asso_exist?(asso_name, factory, parent_factory)
    # TODO: more faster
    Asso.any? do |as|
      as.factory == factory && as.name == asso_name && as.parent_factories.include?(parent_factory)
    end
  end
end
