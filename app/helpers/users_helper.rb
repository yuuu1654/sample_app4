module UsersHelper
  #全てのビューで利用可能

  #引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user, option = { size: 80 })
    size = option[:size]
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}" #サイズの拡大・縮小をやってくれる
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
