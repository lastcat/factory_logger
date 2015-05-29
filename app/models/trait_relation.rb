class TraitRelation < ActiveRecord::Base
  belongs_to :trait
  belongs_to :factory
end
