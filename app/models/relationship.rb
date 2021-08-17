class Relationship < ApplicationRecord
	#リレーションシップ/フォロワーに対してbelongs_toの関連付けを追加する
	belongs_to :follower, class_name: "User"
	belongs_to :followed, class_name: "User"

	#Relationshipモデルに対してバリデーションを追加する
	validates :follower_id, presence: true
	validates :followed_id, presence: true
end
