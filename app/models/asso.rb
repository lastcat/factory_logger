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

    asso_name = asso_hash[:name]
    factory = Factory.create_unique_factory(
                                              name: asso_hash[:factory_name],
                                              traits: asso_hash[:traits],
                                              assos: []
                                           )
    return if same_asso_exist?(asso_name, factory.id, parent_factory.id)
    new_asso = Asso.create(name: asso_hash[:name], factory_id: factory.id)
    AssoRelation.create(factory_id: parent_factory.id, asso_id: new_asso.id)
  end

  # TODO: write test
  def self.create_new_assos_and_relations(new_factory, asso_names)
    asso_names.each do |asso|
      Asso.create_new_asso_and_relation(asso, new_factory)
    end
  end

  private
  
    # TODO: write test
    def self.same_asso_exist?(asso_name, factory_id, parent_factory_id)
      !(REDIS.sadd("assos", {
                              asso_name: asso_name,
                              factory_id: factory_id,
                              parent_factory_id: parent_factory_id
                            }.to_json))
    end
end
