class Trait < ActiveRecord::Base
  belongs_to :factory
  has_many :assos
end
