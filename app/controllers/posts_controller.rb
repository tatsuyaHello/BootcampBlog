class PostsController < ApplicationController
  before_action :post_find, {only: [:show, :edit, :destroy, :update]}
  before_action :user_find, {only: [:show, :edit, :destroy, :update]}
  before_action :set_ranking_data

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
     REDIS.zincrby "posts/daily/#{Date.today.to_s}", 1, "#{@post.id}"
  end

  def set_ranking_data
    #@ids = REDIS.zrevrange "posts/daily/#{Date.today.to_s}", 0, 4, withscores: true


   #2件のランキングデータを取得
   ids = REDIS.zrevrangebyscore"posts/daily/#{Date.today.to_s}", "+inf", 0, limit: [0, 2], withscore: true

   @ranking_posts = Post.where(id: ids)

   @ranking_posts = ids.map{ |id| Post.find(id) }


    #2件未満の場合、公開日時順で値を取得
   if @ranking_posts.count < 2
     adding_posts = Post.order( created_at: :DESC, updated_at: :DESC).where.not(id: ids).limit(2 - @ranking_posts.count)
     @ranking_posts.concat(adding_posts)
   end
 end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create(edit_params)
    @post.save
    redirect_to root_path
  end

  def edit
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  def update
    @post.update(edit_params)
    redirect_to "/posts/#{@post.id}"
  end

  private
  def edit_params
    params.require(:post).permit(:title, :content, :user_id).merge(:user_id => current_user.id)
  end

  def post_find
    @post = Post.find(params[:id])
  end

  def user_find
    @user = User.find(@post.user_id)
  end
end
