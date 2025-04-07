require 'net/http'
require 'json'

class PagesController < ApplicationController
  before_action :set_notebook
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  def index
    @pages = @notebook.pages
  end

  def show; 
end

  def new
    @page = @notebook.pages.new
  end

  def edit; end

  def create
    @page = @notebook.pages.new(page_params)
    @page.emoji = fetch_random_emoji(@page.emoji_category)

    if @page.save
      redirect_to [@notebook, @page], notice: "Página creada exitosamente con emoji 🎉"
    else
      flash.now[:alert] = "Error al crear la página."
      render :new
    end
  end

  def update
    if @page.update(page_params)
      redirect_to [@notebook, @page], notice: "Página actualizada correctamente."
    else
      flash.now[:alert] = "Error al actualizar la página."
      render :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to notebook_path(@notebook), notice: "Página eliminada correctamente."
  end

  private

  def set_notebook
    @notebook = Notebook.find(params[:notebook_id])
  end

  def set_page
    @page = @notebook.pages.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :body, :emoji_category)
  end

  def fetch_random_emoji(category)
    url = URI("https://emojihub.yurace.pro/api/random/category/#{category}")
    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      data["htmlCode"]&.first || "❓"
    else
      "❓"
    end
  rescue StandardError => e
    Rails.logger.error "Error al obtener emoji: #{e.message}"
    "❓"
  end
end
