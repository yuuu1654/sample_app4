class User < ApplicationRecord

  #ユーザーがマイクロポストを複数所有する関連付け(手動で行う)
  #micropostは所有者（user）と一緒に破棄される事を保証
  # => "#{モデル名}s"
  has_many :microposts, dependent: :destroy


  #能動的関係に対して1対多(has_many)の関連付けを実装する
  #デフォルト => ActiveRelationship モデル（クラス）を探しに行く
  # クラスは => Relationship
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: "followed_id",
                                  dependent: :destroy

  #Userモデルにfollowingの関連付けを追加する
  # :sourceパラメーター => following配列の元はfollowed_idの集合である」ということを明示的にRailsに伝え
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: {maximum: 50}
  

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true  #beforeセーブで小文字で保存するようにしているから！
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true



  #渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                            BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  #永続sessionの為にユーザーをDBに記憶する(new_tokenを発行してdigest化してDBに保存する)
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end



  #渡されたトークンがダイジェストと一致したらtrueを返す
  #authenticated?メソッドの抽象化(動的ディスパッチ)
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end



  #ユーザーのログイン情報を破棄する
  def forget
    self.update_attribute(:remember_digest, nil)
  end

  #アカウントを有効にする
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  #有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  #パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  #パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  #パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    #< 記号を「〜より早い時刻」と読んでください
    #「少ない」と読んでしまうと混乱するので注意！
    self.reset_sent_at < 2.hours.ago
  end

  #ユーザーのステータスフィードを返す
  def feed
    #① Micropost.where("user_id = ? OR user_id IN (?)", self.id, following_ids)
    #② Micropost.where("user_id IN (:following_ids) OR user_id = :user_id", following_ids: following_ids, user_id: self.id)
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: self.id)
  end

  #ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  #ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  #現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  private

    #メールアドレスを全て小文字にする
    def downcase_email
      self.email = email.downcase
    end

    #有効化トークンとダイジェストを作成及び代入する
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
