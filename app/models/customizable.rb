class Customizable < ApplicationRecord
  has_many :customizable_options, dependent: :destroy
end
