class GuidesController < ApplicationController
  def index
    @guides = Guide.published
  end

  def show
    @guide = Guide.published.find_by!(slug: params[:slug])
  end
end
