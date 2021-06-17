class Post < ApplicationRecord
  belongs_to :category
  belongs_to :user

  validates :title, presence: true, uniqueness: true
  validates :content, presence: true
  validates :img_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true
end
