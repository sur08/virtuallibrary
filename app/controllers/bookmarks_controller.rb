class BookmarksController < ApplicationController
  before_action :check_signin
  before_action :set_bookmark, only: [:show, :edit, :update, :destroy]
  before_action :set_book, only: [:create]

  # GET /bookmarks
  # GET /bookmarks.json
  def index
    @bookmarks = current_user.bookmarks.all
  end

  # POST /bookmarks
  # POST /bookmarks.json
  def create
    @bookmark = @book.bookmarks.new(user_id: current_user.id)

    respond_to do |format|
      if @bookmark.save
        format.html {
          redirect_to @book,
          notice: t('.successfully_added', book: @book.name)
        }
        format.json { render :show, status: :created, location: @bookmark }
      else
        format.html { render :new }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/1
  # DELETE /bookmarks/1.json
  def destroy
    @book = @bookmark.book
    @bookmark.destroy
    respond_to do |format|
      format.html {
        redirect_to bookmarks_path,
        notice: t('.successfully_removed', book: @book.name)
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def check_signin
      if !user_signed_in?
        respond_to do |format|
          format.html{
            redirect_to new_user_session_path, notice: t('signin_message')
          }
        end
      end
    end

    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end

    def set_book
      @book = Book.find(params[:book_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bookmark_params
      params.require(:bookmark).permit(:user_id, :book_id)
    end
end
