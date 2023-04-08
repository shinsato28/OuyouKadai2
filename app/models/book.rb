class Book < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :view_counts, dependent: :destroy
  has_many  :tag_relationships, dependent: :destroy
  has_many  :tags, through: :tag_relationships
  belongs_to :user

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  scope :latest, -> {order(created_at: :desc)}
  scope :rate_count, -> {order(rate: :desc)}
  scope :most_favorite, -> { left_joins(:favorites).select(:id, "COUNT(favorites.id) AS favorites_count").group(:id) }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def save_tags(savebook_tags)
    savebook_tags.each do |new_name|
    book_tag = Tag.find_or_create_by(name: new_name)
    self.tags << book_tag
    end
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
end
