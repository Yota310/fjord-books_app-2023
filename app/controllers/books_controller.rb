# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = Book.order(id: 'ASC').page(params[:page])
  end

  def show
    @user = current_user
    @comment = Comment.new
    @comments = @book.comments # 表示している本のidを持つコメントを表示
    set_comment_users
  end

  def new
    @book = Book.new
    @user = current_user
  end

  def edit; end

  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to book_url(@book), notice: t('controllers.common.notice_create', name: Book.model_name.human) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to book_url(@book), notice: t('controllers.common.notice_update', name: Book.model_name.human) }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url, notice: t('controllers.common.notice_destroy', name: Book.model_name.human) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def book_params
    params.require(:book).permit(:title, :memo, :author, :picture, :user_id)
  end

  def set_comment_users
    @users = @comments.map do |comment|
      User.where("id = #{comment.user_id}")[0]
    end
  end
end
