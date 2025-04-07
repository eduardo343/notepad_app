class Page < ApplicationRecord
  belongs_to :notebook

  validates :title, presence: true
  validates :body, presence: true
  validates :emoji_category, presence: true
end
