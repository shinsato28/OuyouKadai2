class TagsController < ApplicationController
  before_action :authenticate_user!

  def tag_search
    @range = params[:range]
    @tag = params[:tag]
    @books = Book.looks(params[:tag_search], params[:tag])
  end
end
