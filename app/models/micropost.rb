class Micropost < ApplicationRecord
  belongs_to :user
  has_many :favorites
  # favolitesテーブルのuser_idを通して
  # ある投稿をお気に入り登録しているユーザをすべて取得
  has_many :favorite_users, through: :favorites, source: :user
  
  validates :content, presence: true, length: { maximum: 255 }
end
