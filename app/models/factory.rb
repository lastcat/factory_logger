class Factory < ActiveRecord::Base
  has_many :traits
  has_many :asso_relations
  has_many :assos, through: :asso_relations
end
