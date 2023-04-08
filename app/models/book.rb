class Book < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :view_counts, dependent: :destroy
  belongs_to :user

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  scope :latest, -> {order(created_at: :desc)}
  scope :rate_count, -> {order(rate: :desc)}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  scope :most_favorite, -> { left_joins(:favorites).select(:id, "COUNT(favorites.id) AS favorites_count").group(:id) }

  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end
end
