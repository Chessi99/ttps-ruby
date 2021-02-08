class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: %i[ show edit update destroy export ]

  # GET /books/:id/notes or /notes.json
  def index
    @notes = current_user.get_book(params[:book_id]).notes
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  def export
    @note.export
    return redirect_to book_note_path(@note.book_id,@note.id)
  end

  # POST /notes or /notes.json
  def create
    # current_user.get_book(params[:book_id])
    @note = Note.new(title: note_params[:title],content: note_params[:content], book: current_user.get_book(params[:book_id]))

    respond_to do |format|
      if @note.save
        return redirect_to action: 'index', book_id: @note.book_id
        # format.html { redirect_to @note, notice: "Note was successfully created." }
        # format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    respond_to do |format|
      if @note.update(title: note_params[:title],content: note_params[:content], book: current_user.get_book(params[:book_id]))
        return redirect_to action: 'index', book_id: @note.book_id
        #format.html { redirect_to @note, notice: "Note was successfully updated." }
        #format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    book_id = @note.book_id 
    @note.destroy
    respond_to do |format|
      return redirect_to action: 'index', book_id: book_id
      #format.html { redirect_to notes_url, notice: "Note was successfully destroyed." }
      #format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = current_user.get_book(params[:book_id]).notes.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :content, :book_id)
    end
end
