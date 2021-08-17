class RelationshipsController < ApplicationController
	before_action :logged_in_user

	#POST => /relationships
	def create
		@user = User.find(params[:followed_id])
		current_user.follow(@user) #@つけ忘れたらエラーになる(フォローボタンが反応しなかった)
		#Ajaxリクエストに応答できるようにする
		# => 窓口を二つつくる
		respond_to do |format|
			format.html { redirect_to @user }
			format.js #デフォルト => app/views/relationships/create.js.erb
		end
	end

	#POST => /relationships/:id
	def destroy
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow(@user)
		#Ajaxリクエストに応答できるようにする
		respond_to do |format|
			format.html { redirect_to @user }
			format.js #デフォルト => app/views/relationships/destroy.js.erb
		end
	end

end
