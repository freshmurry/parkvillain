class PhotosController < ApplicationController

  def create
    @space = Space.find(params[:space_id])

    if params[:images]
        params[:images].each do |img|
        @space.photos.create(image: img)
      end

      @photos = @space.photos
      redirect_back(fallback_location: request.referer, notice: "Saved...")
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @space = @photo.space

    @photo.destroy
    @photos = Photo.where(space_id: @space.id)

    respond_to :js
  end
end
