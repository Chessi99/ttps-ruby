class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: %i[ show edit update destroy export ]
  before_action :validate_global, only: %i[ edit update destroy ]

  # GET /books or /books.json
  def index
    @books = current_user.books
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  def export
    @book.export
    return redirect_to book_notes_path(@book)
  end

  def export_all
    current_user.export_all_books
    return redirect_to books_path
  end
  # POST /books or /books.json
  def create
    @book = Book.new(title: book_params[:title], user: current_user)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      #if @book.update(book_params)
      if @book.update(title: book_params[:title], user: current_user)
      format.html { redirect_to @book, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      # @book = Book.find(params[:id])
      @book = current_user.get_book(params[:id])
    end

    def validate_global
      if @book.is_global?
        raise ActiveRecord::RecordNotFound 
      end
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title)
    end

end
