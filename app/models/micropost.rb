class Micropost < ApplicationRecord
  #自動生成されたもの
  belongs_to :user

  #Active Storage API(指定のモデルとアップロードされたファイルを関連づける)
  #has_many_attached で１投稿に複数の画像をアップロードすることも出来る
  has_one_attached :image

  #default_scopeでマイクロポストを順序づける/降順（descending）
  default_scope -> { self.order(created_at: :desc) }

  #micropostのuser_idに対する検証
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: {in: %w[image/jpeg image/gif image/png], 
                                    message: "must be a valid image format"},
                    size:         {less_than: 1.megabytes, 
                                    message: "should be less than 1MB"}

  #表示用のリサイズ済みの画像を返す
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
