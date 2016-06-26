class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :user

  # ensure that comment is presence
  validates :text, presence:  true, allow_blank: false
end
