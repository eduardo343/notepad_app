require 'net/http'
require 'json'

class PagesController < ApplicationController
  before_action :set_notebook
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  def index
    @pages = @notebook.pages
  end

  def show
    render "notebooks/show"
  end

  def new
    @page = @notebook.pages.new
  end

  def edit
    respond_to do |format|
      format.html 
      format.json { render json: @page } 
  end
end
  def create
    @page = @notebook.pages.new(page_params)
    @page.emoji = fetch_random_emoji(@page.emoji_category)

    if @page.save
      redirect_to [@notebook, @page], notice: "Page create with emoji 🎉"
    else
      flash.now[:alert] = "Error creating page."
      render :new
    end
  end

  def update
    if @page.update(page_params)
      redirect_to [@notebook, @page], notice: "Page updated correctly."
    else
      flash.now[:alert] = "Error refreshing the page."
      render :edit
    end
  end

  def destroy
  @page.destroy
  redirect_to notebook_pages_path(@notebook), notice: "Page deleted successfully."
  end

  private

  def set_notebook
    @notebook = Notebook.find(params[:notebook_id])
  end

  def set_page
    @page = @notebook.pages.find_by(id: params[:id])
    unless @page
      redirect_to notebook_path(@notebook), alert: "Page not found." and return
    end
  end

  def page_params
    params.require(:page).permit(:title, :body, :emoji_category)
  end

  def fetch_random_emoji(category)
    url = URI("https://emojihub.yurace.pro/api/random/category/#{category}")
    response = Net::HTTP.get_response(url)
  
    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      unicode = data["unicode"]&.first # Obtiene el código Unicode
      return [unicode.delete_prefix("U+").to_i(16)].pack("U*") if unicode # Convierte a emoji
    end
  
    "❓" # Emoji por defecto si falla
  rescue StandardError => e
    Rails.logger.error "Error al obtener emoji: #{e.message}"
    "❓"
  end

end