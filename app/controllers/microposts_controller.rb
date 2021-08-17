class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image]) #アップロードされた画像を@micropostオブジェクトにアタッチする
    #投稿が保存されるかどうかで処理を分岐させる
    if @micropost.save
      flash[:success] = "Micropost 作りやした！"
      redirect_to root_path
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
      #render 'ファイル名/ビュー名'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost消しときやした！"
    #redirect_to request.referrer || root_path
    redirect_back(fallback_location: root_path)
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end

    def correct_user
      #自分の投稿したマイクロポストの集合の中に、消したいマイクロポストのidが入っているかどうか(nilが返ってくる場合もありうる)
      #find_byはnilも返す
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_path if @micropost.nil?
    end
end
