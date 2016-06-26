class Article < ActiveRecord::Base

	# ensure that title and body is present
    validates :title, presence: true
    validates :body, presence: true

	belongs_to :user
	has_many :comments, dependent: :destroy # Destroy all comments once that article is destroyed.

	# Simple search function
    def self.search(search)
        if search
            # Lowercase the search term first
            search.downcase!
            where("title LIKE ?", "%#{search}%").order(created_at: :desc)
        else

          # Order article in descending order
          all().order(created_at: :desc)
        end
    end
end
