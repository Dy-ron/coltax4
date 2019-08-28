class PucsController < ApplicationController
  before_action :set_puc, only: [:show, :edit, :update, :destroy]

  # GET /pucs
  # GET /pucs.json
  def index
    @pucs = Puc.all
  end

  # GET /pucs/1
  # GET /pucs/1.json
  def show
  end

  # GET /pucs/new
  def new
    @puc = Puc.new
  end

  # GET /pucs/1/edit
  def edit
  end

  # POST /pucs
  # POST /pucs.json
  def create
    @puc = Puc.new(puc_params)

    respond_to do |format|
      if @puc.save
        format.html { redirect_to @puc, notice: 'Puc was successfully created.' }
        format.json { render :show, status: :created, location: @puc }
      else
        format.html { render :new }
        format.json { render json: @puc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pucs/1
  # PATCH/PUT /pucs/1.json
  def update
    respond_to do |format|
      if @puc.update(puc_params)
        format.html { redirect_to @puc, notice: 'Puc was successfully updated.' }
        format.json { render :show, status: :ok, location: @puc }
      else
        format.html { render :edit }
        format.json { render json: @puc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pucs/1
  # DELETE /pucs/1.json
  def destroy
    @puc.destroy
    respond_to do |format|
      format.html { redirect_to pucs_url, notice: 'Puc was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_puc
      @puc = Puc.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def puc_params
      params.require(:puc).permit(:code, :name, :puc_type, :detail, :puc_class, :category)
    end
end
