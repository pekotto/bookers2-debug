class BooksController < ApplicationController
  before_action :ensure_correct_book, only: [:edit, :update]

  def show
  	@book = Book.find(params[:id])
    @new_book = Book.new
    @user = @book.user
  end

  def index
    @book = Book.new
    @books = Book.all
  end

  def create
  	@book = Book.new(book_params)
    @book.user_id = current_user.id #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
  	if @book.save #入力されたデータをdbに保存する。
  		redirect_to @book, notice: "successfully created book!"#保存された場合の移動先を指定。
  	else
  		@books = Book.all
      flash[:danger] = @book.errors.full_messages
  		render 'index'
  	end
  end

  def edit
  	@book = Book.find(params[:id])
      if current_user.id != @book.user_id
      redirect_to books_path
      end
  end

  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		redirect_to @book, notice: "successfully updated book!"
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
  		render "edit"
  	end
  end

  def destroy
  	@book = Book.find(params[:id])
  	@book.destoy
  	redirect_to books_path, notice: "successfully delete book!"
  end

  private

  def book_params
  	params.require(:book).permit(:title, :body)
  end

  def ensure_correct_book
    @book = Book.find(params[:id])
    if current_user.id != @book.user_id
      redirect_to books_path
    end
  end

end
