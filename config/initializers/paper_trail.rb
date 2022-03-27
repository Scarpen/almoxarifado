module PaperTrail
  class Version < ::ActiveRecord::Base
    belongs_to :user, foreign_key: :whodunnit
    belongs_to :material, foreign_key: :item_id
  end
end