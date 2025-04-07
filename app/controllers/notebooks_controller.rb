class NotebooksController < ApplicationController
    before_action :set_notebook, only: %i[show edit update destroy]
  
    # GET /notebooks
    def index
      @notebooks = Notebook.order(created_at: :desc)
    end
  
    # GET /notebooks/:id
    def show
      # Muestra el notebook y sus páginas asociadas
    end
  
    # GET /notebooks/new
    def new
      @notebook = Notebook.new
    end
  
    # GET /notebooks/:id/edit
    def edit; end
  
    # POST /notebooks
    def create
      @notebook = Notebook.new(notebook_params)
      if @notebook.save
        redirect_to @notebook, notice: '📒 Notebook creado exitosamente.'
      else
        flash.now[:alert] = 'Error al crear el notebook.'
        render :new
      end
    end
  
    # PATCH/PUT /notebooks/:id
    def update
      if @notebook.update(notebook_params)
        redirect_to @notebook, notice: '✅ Notebook actualizado correctamente.'
      else
        flash.now[:alert] = 'No se pudo actualizar el notebook.'
        render :edit
      end
    end
  
    # DELETE /notebooks/:id
    def destroy
      @notebook.destroy
      redirect_to notebooks_url, notice: '🗑️ Notebook eliminado correctamente.'
    end
  
    private
  
    def set_notebook
      @notebook = Notebook.find(params[:id])
    end
  
    def notebook_params
      params.require(:notebook).permit(:name)
    end
  end
  