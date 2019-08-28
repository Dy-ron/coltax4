class BanksController < ApplicationController
  before_action :set_bank, only: [:show, :edit, :update, :destroy]

  # GET /banks
  # GET /banks.json
  def index
    @banks = Bank.all
  end


  # GET /banks/new
  def index
    @banks = Bank.all

    @movements = Movement.all

    # Bancos /All
    @ad_bd = Movement.where(mov_type: 'B¹', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_bd = Movement.where(mov_type: 'B¹', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_bd = Movement.where(mov_type: 'B¹', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_bd = Movement.where(mov_type: 'B¹', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year)).sum(:price)

    @ad_br = Movement.where(mov_type: 'B²', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_br = Movement.where(mov_type: 'B²', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_br = Movement.where(mov_type: 'B²', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_br = Movement.where(mov_type: 'B²', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year)).sum(:price)

    @ad_bc = Movement.where(mov_type: 'B³', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_bc = Movement.where(mov_type: 'B³', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_bc = Movement.where(mov_type: 'B³', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_bc = Movement.where(mov_type: 'B³', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year)).sum(:price)

    @ad_bo = Movement.where(mov_type: 'B°', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_bo = Movement.where(mov_type: 'B°', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_bo = Movement.where(mov_type: 'B°', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_bo = Movement.where(mov_type: 'B°', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year)).sum(:price)

    @ad_nb = @ad_bd - (@ad_br + @ad_bc+ @ad_bo)
    @aw_nb = @aw_bd - (@aw_br + @aw_bc+ @aw_bo)
    @am_nb = @am_bd - (@am_br + @am_bc+ @am_bo)
    @ay_nb = @ay_bd - (@ay_br + @ay_bc+ @ay_bo)
    @nn_n  = 0


  end




  # GET /banks/1
  # GET /banks/1.json
  def show
  end

  # GET /banks/new
  def new
    @bank = Bank.new

    @user_name = current_user.nil? ? '' : User.where(id: current_user.id).email

    if @bank.puc.eql? "110101"
       @puc_name = "Caja"
    end
  end

  # GET /banks/1/edit
  def edit
  end

  # POST /banks
  # POST /banks.json
  def create
    @bank = Bank.new(bank_params)

    respond_to do |format|
      if @bank.save
        format.html { redirect_to @bank, notice: 'Bank was successfully created.' }
        format.json { render :show, status: :created, location: @bank }
      else
        format.html { render :new }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /banks/1
  # PATCH/PUT /banks/1.json
  def update
    respond_to do |format|
      if @bank.update(bank_params)
        format.html { redirect_to @bank, notice: 'Bank was successfully updated.' }
        format.json { render :show, status: :ok, location: @bank }
      else
        format.html { render :edit }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /banks/1
  # DELETE /banks/1.json
  def destroy
    @bank.destroy
    respond_to do |format|
      format.html { redirect_to banks_url, notice: 'Bank was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank
      @bank = Bank.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bank_params
      params.require(:bank).permit(:puc, :tran_type, :detail, :trans_value, :balance, :bank_id, :bank, :users_id, :verified)
    end
end
