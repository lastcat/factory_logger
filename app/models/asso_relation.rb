class AssoRelation < ActiveRecord::Base
  belongs_to :factory
  belongs_to :asso, foreign_key: "asso_id", class_name: 'Factory'
end
