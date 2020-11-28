class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255},
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  # 反対側のユーザ(:follow)から見た関係性
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  has_many :favorites
  # favolitesテーブルのmicropost_idを通して
  # お気に入り登録している投稿
  has_many :likes, through: :favorites, source: :micropost
  
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    # 自分がフォローしている人たちのuser_idと自分のuser_idの投稿を取得する
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  # 中間テーブルを参照
  def like(micropost)
    # favoliteモデルから既にあるインスタンスを取得するか、フォロー関係を作る
    # (micropostのidがインスタンスのmicropost_idと同じもの)
    favorite = favorites.find_or_create_by(micropost_id: micropost.id)
  end
  
  # 中間テーブルを参照
  def unlike(micropost)
    favorite = favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end
  
  # 中間テーブルを経由した相手のテーブルを参照
  def like?(micropost)
    # ある投稿が、自分のお気に入りに含まれているか？の確認
    self.likes.include?(micropost)
  end
end
