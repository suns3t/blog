class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :article_owner, only: [:edit, :update, :destroy]

  # GET /articles
  # GET /articles.json

  # Change markdown as global var since many function use it.
  $markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  
  def index
    @articles = Article.search(params[:search])
    # Handle when no article is found
    if @articles.empty?
      flash[:notice] = "No article found. Sign in to add more articles."
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = current_user.articles.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = current_user.articles.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      begin
        @article = Article.find(params[:id])
      rescue Exception 
        flash[:notice] = "Article with id=" + params[:id] + " is not found."
        redirect_to root_url
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :body)
    end

    # Check if the current signed in user is the owner of article.
    def article_owner
      unless @article.user_id == current_user.id
        flash[:notice] = 'Access denied as you are not owner of this article.'
        redirect_to root_url
      end
    end
end
