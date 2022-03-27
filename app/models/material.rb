class Material < ApplicationRecord

	has_paper_trail

	validates :name, uniqueness: true

end
