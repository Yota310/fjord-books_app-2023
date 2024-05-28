# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = Book.order(id: 'DESC').page(params[:page])
  end

  def show
    @comment = Comment.new
    @comments = @book.comments # 表示している本のidを持つコメントを表示
  end

  def new
    @book = Book.new
  end

  def edit; end

  def create
    @book = Book.new(book_params)

    if @book.save
      redirect_to book_url(@book), notice: t('controllers.common.notice_create', name: Book.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      redirect_to book_url(@book), notice: t('controllers.common.notice_update', name: Book.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    redirect_to books_url, notice: t('controllers.common.notice_destroy', name: Book.model_name.human)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def book_params
    params.require(:book).permit(:title, :memo, :author, :picture)
  end
end
