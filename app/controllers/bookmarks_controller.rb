class BookmarksController < ApplicationController
  def new
    @list = List.find(params[:list_id])
    @bookmark = Bookmark.new
    @movies = Movie.all.order(:title)
  end

def create
  @list = List.find(params[:list_id])
  @bookmark = @list.bookmarks.build(bookmark_params)
  @movies = Movie.all.order(:title) # Nécessaire pour réafficher la liste déroulante

  if @bookmark.save
    redirect_to @list, notice: 'Film ajouté avec succès!'
  else
    # On récupère les bookmarks existants pour la liste
    @bookmarks = @list.bookmarks
    render 'lists/show', status: :unprocessable_entity
  end
end

 def destroy
  @bookmark = Bookmark.find(params[:id])
  @list = @bookmark.list
  @bookmark.destroy
  redirect_to @list, notice: "Film retiré de la liste"
end

  private

  def bookmark_params
    params.require(:bookmark).permit(:movie_id, :comment)
  end
end
