class NotebooksController < ApplicationController
  before_action :set_notebook, only: %i[show edit update destroy]

  # GET /notebooks
  def index
    @notebooks = Notebook.order(created_at: :desc)
  end

  # GET /notebooks/:id
  def show
    # Displays the notebook and its associated pages
  end

  # GET /notebooks/new
  def new
    @notebook = Notebook.new
  end

  # GET /notebooks/:id/edit
  def edit
    respond_to do |format|
      format.html
      format.json { render json: @notebook }
  end
end

  # POST /notebooks
  def create
    @notebook = Notebook.new(notebook_params)
    if @notebook.save
      redirect_to @notebook, notice: '📒 Notebook successfully created.'
    else
      flash.now[:alert] = 'Error creating the notebook.'
      render :new
    end
  end

  # PATCH/PUT /notebooks/:id
  def update
    if @notebook.update(notebook_params)
      redirect_to @notebook, notice: ' Notebook successfully updated.'
    else
      flash.now[:alert] = 'Failed to update the notebook.'
      render :edit
    end
  end

  # DELETE /notebooks/:id
  def destroy
    
    @notebook.destroy
    redirect_to notebooks_path, notice: "Notebook deleted."
  end

  private

  def set_notebook
    
    @notebook = Notebook.find(params[:id])
  end

  def notebook_params
    params.require(:notebook).permit(:name)
  end
end
