
class MovementsController < ApplicationController
  before_action :authenticate_user!, only: [:home_admin]
  before_action :set_movement, only: [:show, :edit, :update, :destroy]

  # GET /movements
  # GET /movements.json
  def index
    @movements = Movement.where(mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day))

    # Resumen general actual
    @act_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)
    @act_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)
    @act_ev = @act_eg.nonzero? ? @act_in/@act_eg : 0
    @act_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)

    @act_an = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)
    @act_dt = Movement.where(mov_type: 'A°', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)

    @act_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)
    @act_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)
    @act_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)
    @act_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)
    @act_tn = @act_so + @act_to + @act_tx + @act_tm

    @act_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)
    @act_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)
    @act_oo = @act_pj + @act_an+@act_dt + @act_so+@act_to+@act_tx+@act_tm + @act_tr+@act_vr
    @act_na = @act_in - (@act_eg + @act_oo)

    # Financiera - Cuotas, inter_mora, seguro_crédito
    @act_fn = Movement.where(mov_type: 'Fª', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)
    @act_fi = Movement.where(mov_type: 'F°', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)
    @act_sg = Movement.where(mov_type: 'F×', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)
    @act_nf = @act_na - (@act_fn + @act_fi + @act_sg)

    # Contabilidad personal general
    @act_cd = Movement.where(mov_type: 'D', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year )).sum(:price)
    @act_cc = Movement.where(mov_type: 'C', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year )).sum(:price)

    @act_im = Movement.where(mov_type: 'M', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year )).sum(:price)
    @act_lg = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year )).sum(:price)
    @act_ot = Movement.where(mov_type: 'O', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year )).sum(:price)

    @act_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)
    @act_ps = Movement.where(mov_type: 'P', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)
    @act_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year )).sum(:price)
    @act_vs = @act_im + @act_lg + @act_ot + @act_hm + @act_ps + @act_ss
    @act_nc = (@act_nf + @act_cd) - (@act_cc + @act_vs)

    # Finanzas2 - Créditos(Préstamos2), pagos, intereses
    @act_fp = Movement.where(mov_type: 'F¹', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year )).sum(:price)
    @act_fg = Movement.where(mov_type: 'F²', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year )).sum(:price)
    @act_fr = Movement.where(mov_type: 'F³', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year )).sum(:price)
    @act_fz = (@act_nc + @act_fp) - (@act_fg + @act_fr)

    # Bancos - Estado Operaciones en [Contab]
    @act_bd = Movement.where(mov_type: 'Bd', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year )).sum(:price)
    @act_bc = Movement.where(mov_type: 'Bc', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year )).sum(:price)
    @act_bk = Movement.where(mov_type: 'ß',  mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year )).sum(:price)
    @act_tb = (@act_fz + @act_bc) - (@act_bd + @act_bk)
    # Nota: se invierten bd(consig_bank=ret_caja) y bc(ret_bank=reinteg_caja)


    # ----------------------------------------------
    # Estado Actual - // Día / Sem / Mes / Año //
    # ----------------------------------------------
    @ad_in = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_in = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_in = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @am_iv = @am_in/30
    @a17a_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_eg = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_eg = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_eg = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @am_ev = @am_eg.nonzero? ? @am_in/@am_eg : 0
    @a17a_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_pj = Movement.where(mov_type: 'J', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_pj = Movement.where(mov_type: 'J', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_pj = Movement.where(mov_type: 'J', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_pj=Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_pj=Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_pj=Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_pj=Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_pj=Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    # Andaluz / Datos / Seguridad Social
    @ad_an = Movement.where(mov_type: 'Aª', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_an = Movement.where(mov_type: 'Aª', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_an = Movement.where(mov_type: 'Aª', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @a17a_an=Movement.where(mov_type: 'Aª', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_an=Movement.where(mov_type: 'Aª', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_an=Movement.where(mov_type: 'Aª', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_an=Movement.where(mov_type: 'Aª', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_an=Movement.where(mov_type: 'Aª', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)
    @ay_an = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @ay_av = @ay_an.nonzero? ? (@ay_in/@ay_an)/1000 : 0

    @ad_dt = Movement.where(mov_type: 'A°', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_dt = Movement.where(mov_type: 'A°', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_dt = Movement.where(mov_type: 'A°', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @a17a_dt=Movement.where(mov_type: 'A°', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_dt=Movement.where(mov_type: 'A°', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_dt=Movement.where(mov_type: 'A°', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_dt=Movement.where(mov_type: 'A°', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_dt=Movement.where(mov_type: 'A°', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)
    @ay_dt = Movement.where(mov_type: 'A°', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @ay_dv = @ay_dt.nonzero? ? (@ay_in/@ay_dt)/1000 : 0
    # Neto¹
    @ad_ea = @ad_in -(@ad_eg + @ad_pj + @ad_an+@ad_dt)
    @aw_ea = @aw_in -(@aw_eg + @aw_pj + @aw_an+@aw_dt)
    @am_ea = @am_in -(@am_eg + @am_pj + @am_an+@am_dt)
    @ay_ea = @ay_in -(@ay_eg + @ay_pj + @ay_an+@ay_dt)
    @ay_ev = @ay_in.nonzero? ? (@ay_in)/(@ay_eg + @ay_pj + @ay_an + @ay_dt) : 0
    @a17a_ea= @a17a_in-(@a17a_eg+@a17a_pj + @a17a_an+@a17a_dt)
    @a18a_ea= @a18a_in-(@a18a_eg+@a18a_pj + @a18a_an+@a18a_dt)
    @a18b_ea= @a18b_in-(@a18b_eg+@a18b_pj + @a18b_an+@a18b_dt)
    @a19a_ea= @a19a_in-(@a19a_eg+@a19a_pj + @a19a_an+@a19a_dt)
    @a19b_ea= @a19b_in-(@a19b_eg+@a19b_pj + @a19b_an+@a19b_dt)


    # Legales anuales / Soat, Taxímetro, Ténico_Mecánica
    @ad_so = Movement.where(mov_type: 'S°', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_so = Movement.where(mov_type: 'S°', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_so = Movement.where(mov_type: 'S°', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_so=Movement.where(mov_type: 'S°', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_so=Movement.where(mov_type: 'S°', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_so=Movement.where(mov_type: 'S°', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_so=Movement.where(mov_type: 'S°', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_so=Movement.where(mov_type: 'S°', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_to = Movement.where(mov_type: 'T°', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_to = Movement.where(mov_type: 'T°', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_to = Movement.where(mov_type: 'T°', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_to=Movement.where(mov_type: 'T°', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_to=Movement.where(mov_type: 'T°', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_to=Movement.where(mov_type: 'T°', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_to=Movement.where(mov_type: 'T°', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_to=Movement.where(mov_type: 'T°', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_tx = Movement.where(mov_type: 'T×', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_tx = Movement.where(mov_type: 'T×', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_tx = Movement.where(mov_type: 'T×', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_tx=Movement.where(mov_type: 'T×', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_tx=Movement.where(mov_type: 'T×', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_tx=Movement.where(mov_type: 'T×', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_tx=Movement.where(mov_type: 'T×', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_tx=Movement.where(mov_type: 'T×', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_tm = Movement.where(mov_type: 'T™', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_tm = Movement.where(mov_type: 'T™', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_tm = Movement.where(mov_type: 'T™', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @ad_nx = (@ad_so+@ad_to+@ad_tx+@ad_tm)
    @a17a_tm=Movement.where(mov_type: 'T™', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_tm=Movement.where(mov_type: 'T™', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_tm=Movement.where(mov_type: 'T™', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_tm=Movement.where(mov_type: 'T™', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_tm=Movement.where(mov_type: 'T™', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    # Gastos Varios Operación
    @ad_tr = Movement.where(mov_type: 'T', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_tr = Movement.where(mov_type: 'T', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_tr = Movement.where(mov_type: 'T', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @a17a_tr=Movement.where(mov_type: 'T', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_tr=Movement.where(mov_type: 'T', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_tr=Movement.where(mov_type: 'T', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_tr=Movement.where(mov_type: 'T', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_tr=Movement.where(mov_type: 'T', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)
    @ay_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @ay_tv = @ay_tr.nonzero? ? (@ay_in/@ay_tr)/1000 : 0

    @ad_vr = Movement.where(mov_type: 'V', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_vr = Movement.where(mov_type: 'V', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_vr = Movement.where(mov_type: 'V', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @a17a_vr=Movement.where(mov_type: 'V', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_vr=Movement.where(mov_type: 'V', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_vr=Movement.where(mov_type: 'V', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_vr=Movement.where(mov_type: 'V', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_vr=Movement.where(mov_type: 'V', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)
    @ay_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @ay_vv = @ay_vr.nonzero? ? (@ay_in/@ay_vr)/1000 : 0
    # Neto² actual Operación
    @ad_na = @ad_ea - (@ad_so+@ad_to+@ad_tx+@ad_tm+@ad_tr+@ad_vr)
    @aw_na = @aw_ea - (@aw_so+@aw_to+@aw_tx+@aw_tm+@aw_tr+@aw_vr)
    @am_na = @am_ea - (@am_so+@am_to+@am_tx+@am_tm+@am_tr+@am_vr)
    @ay_na = @ay_ea - (@ay_so+@ay_to+@ay_tx+@ay_tm+@ay_tr+@ay_vr)
    @nn_n  = 0
    @am_av = @am_eg.nonzero? ? @am_in/@am_eg : 0

    @a17a_na= @a17a_ea-(@a17a_so+@a17a_to+@a17a_tx+@a17a_tm + @a17a_tr+@a17a_vr)
    @a18a_na= @a18a_ea-(@a18a_so+@a18a_to+@a18a_tx+@a18a_tm + @a18a_tr+@a18a_vr)
    @a18b_na= @a18b_ea-(@a18b_so+@a18b_to+@a18b_tx+@a18b_tm + @a18b_tr+@a18b_vr)
    @a19a_na= @a19a_ea-(@a19a_so+@a19a_to+@a19a_tx+@a19a_tm + @a19a_tr+@a19a_vr)
    @a19b_na= @a19b_ea-(@a19b_so+@a19b_to+@a19b_tx+@a19b_tm + @a19b_tr+@a19b_vr)

    # Financiera
    @ad_fn = Movement.where(mov_type: 'Fª', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_fn = Movement.where(mov_type: 'Fª', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_fn = Movement.where(mov_type: 'Fª', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_fn = Movement.where(mov_type: 'Fª', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_fn=Movement.where(mov_type: 'Fª', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_fn=Movement.where(mov_type: 'Fª', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_fn=Movement.where(mov_type: 'Fª', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_fn=Movement.where(mov_type: 'Fª', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_fn=Movement.where(mov_type: 'Fª', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_ir = Movement.where(mov_type: 'F°', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_ir = Movement.where(mov_type: 'F°', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_ir = Movement.where(mov_type: 'F°', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_ir = Movement.where(mov_type: 'F°', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_ir=Movement.where(mov_type: 'F°', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_ir=Movement.where(mov_type: 'F°', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_ir=Movement.where(mov_type: 'F°', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_ir=Movement.where(mov_type: 'F°', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_ir=Movement.where(mov_type: 'F°', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_sg = Movement.where(mov_type: 'F×', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_sg = Movement.where(mov_type: 'F×', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_sg = Movement.where(mov_type: 'F×', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_sg = Movement.where(mov_type: 'F×', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_sg=Movement.where(mov_type: 'F×', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_sg=Movement.where(mov_type: 'F×', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_sg=Movement.where(mov_type: 'F×', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_sg=Movement.where(mov_type: 'F×', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_sg=Movement.where(mov_type: 'F×', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)
    # Neto³ = Operación - Financiera
    @ad_nf = @ad_na - (@ad_fn + @ad_ir + @ad_sg)
    @aw_nf = @aw_na - (@aw_fn + @aw_ir + @aw_sg)
    @am_nf = @am_na - (@am_fn + @am_ir + @am_sg)
    @ay_nf = @ay_na - (@ay_fn + @ay_ir + @ay_sg)

    @a17a_nf= @a17a_na-(@a17a_fn+@a17a_ir+@a17a_sg)
    @a18a_nf= @a18a_na-(@a18a_fn+@a18a_ir+@a18a_sg)
    @a18b_nf= @a18b_na-(@a18b_fn+@a18b_ir+@a18b_sg)
    @a19a_nf= @a19a_na-(@a19a_fn+@a19a_ir+@a19a_sg)
    @a19b_nf= @a19b_na-(@a19b_fn+@a19b_ir+@a19b_sg)


    # Contab personal general
    @ad_cd = Movement.where(mov_type: 'D', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_cd = Movement.where(mov_type: 'D', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_cd = Movement.where(mov_type: 'D', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_cd = Movement.where(mov_type: 'D', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_cd=Movement.where(mov_type: 'D', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_cd=Movement.where(mov_type: 'D', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_cd=Movement.where(mov_type: 'D', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_cd=Movement.where(mov_type: 'D', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_cd=Movement.where(mov_type: 'D', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_cc = Movement.where(mov_type: 'C', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_cc = Movement.where(mov_type: 'C', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_cc = Movement.where(mov_type: 'C', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_cc = Movement.where(mov_type: 'C', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_cc=Movement.where(mov_type: 'C', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_cc=Movement.where(mov_type: 'C', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_cc=Movement.where(mov_type: 'C', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_cc=Movement.where(mov_type: 'C', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_cc=Movement.where(mov_type: 'C', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    # Finanzas2 / Préstamos2, pagos, intereses
    @ad_fd = Movement.where(mov_type: 'F¹', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_fd = Movement.where(mov_type: 'F¹', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_fd = Movement.where(mov_type: 'F¹', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_fd = Movement.where(mov_type: 'F¹', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_fd=Movement.where(mov_type: 'F¹', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_fd=Movement.where(mov_type: 'F¹', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_fd=Movement.where(mov_type: 'F¹', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_fd=Movement.where(mov_type: 'F¹', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_fd=Movement.where(mov_type: 'F¹', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_fc = Movement.where(mov_type: 'F²', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_fc = Movement.where(mov_type: 'F²', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_fc = Movement.where(mov_type: 'F²', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_fc = Movement.where(mov_type: 'F²', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_fc=Movement.where(mov_type: 'F²', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_fc=Movement.where(mov_type: 'F²', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_fc=Movement.where(mov_type: 'F²', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_fc=Movement.where(mov_type: 'F²', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_fc=Movement.where(mov_type: 'F²', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_fi = Movement.where(mov_type: 'F³', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_fi = Movement.where(mov_type: 'F³', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_fi = Movement.where(mov_type: 'F³', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_fi = Movement.where(mov_type: 'F³', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_fi=Movement.where(mov_type: 'F³', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_fi=Movement.where(mov_type: 'F³', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_fi=Movement.where(mov_type: 'F³', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_fi=Movement.where(mov_type: 'F³', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_fi=Movement.where(mov_type: 'F³', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    # Contab varios
    @ad_im = Movement.where(mov_type: 'M', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_im = Movement.where(mov_type: 'M', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_im = Movement.where(mov_type: 'M', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_im = Movement.where(mov_type: 'M', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_im=Movement.where(mov_type: 'M', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_im=Movement.where(mov_type: 'M', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_im=Movement.where(mov_type: 'M', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_im=Movement.where(mov_type: 'M', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_im=Movement.where(mov_type: 'M', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_lg = Movement.where(mov_type: 'L', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_lg = Movement.where(mov_type: 'L', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_lg = Movement.where(mov_type: 'L', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_lg = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_lg=Movement.where(mov_type: 'L', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_lg=Movement.where(mov_type: 'L', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_lg=Movement.where(mov_type: 'L', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_lg=Movement.where(mov_type: 'L', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_lg=Movement.where(mov_type: 'L', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_ot = Movement.where(mov_type: 'O', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_ot = Movement.where(mov_type: 'O', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_ot = Movement.where(mov_type: 'O', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_ot = Movement.where(mov_type: 'O', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_ot=Movement.where(mov_type: 'O', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_ot=Movement.where(mov_type: 'O', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_ot=Movement.where(mov_type: 'O', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_ot=Movement.where(mov_type: 'O', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_ot=Movement.where(mov_type: 'O', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    # Personal
    @ad_hm = Movement.where(mov_type: 'H', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_hm = Movement.where(mov_type: 'H', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_hm = Movement.where(mov_type: 'H', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_hm=Movement.where(mov_type: 'H', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_hm=Movement.where(mov_type: 'H', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_hm=Movement.where(mov_type: 'H', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_hm=Movement.where(mov_type: 'H', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_hm=Movement.where(mov_type: 'H', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_ps = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_ps = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_ps = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_ps = Movement.where(mov_type: 'P', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_ps=Movement.where(mov_type: 'P', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_ps=Movement.where(mov_type: 'P', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_ps=Movement.where(mov_type: 'P', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_ps=Movement.where(mov_type: 'P', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_ps=Movement.where(mov_type: 'P', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_ss = Movement.where(mov_type: 'S', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_ss = Movement.where(mov_type: 'S', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_ss = Movement.where(mov_type: 'S', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_ss=Movement.where(mov_type: 'S', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_ss=Movement.where(mov_type: 'S', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_ss=Movement.where(mov_type: 'S', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_ss=Movement.where(mov_type: 'S', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_ss=Movement.where(mov_type: 'S', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)
    # Subtotales Contab
    @ad_nc = (@ad_cd - @ad_cc) + (@ad_fd - (@ad_fc + @ad_fi)) - (@ad_im + @ad_lg + @ad_ot + @ad_hm + @ad_ps + @ad_ss)
    @aw_nc = (@aw_cd - @aw_cc) + (@aw_fd - (@aw_fc + @aw_fi)) - (@aw_im + @aw_lg + @aw_ot + @aw_hm + @aw_ps + @aw_ss)
    @am_nc = (@am_cd - @am_cc) + (@am_fd - (@am_fc + @am_fi)) - (@am_im + @am_lg + @am_ot + @am_hm + @am_ps + @am_ss)
    @ay_nc = (@ay_cd - @ay_cc) + (@ay_fd - (@ay_fc + @ay_fi)) - (@ay_im + @ay_lg + @ay_ot + @ay_hm + @ay_ps + @ay_ss)

    @a17a_nc = (@a17a_cd-@a17a_cc) + (@a17a_fd - (@a17a_fc + @a17a_fi)) - (@a17a_im + @a17a_lg + @a17a_ot + @a17a_hm + @a17a_ps + @a17a_ss)
    @a18a_nc = (@a18a_cd-@a18a_cc) + (@a18a_fd - (@a18a_fc + @a18a_fi)) - (@a18a_im + @a18a_lg + @a18a_ot + @a18a_hm + @a18a_ps + @a18a_ss)
    @a18b_nc = (@a18b_cd-@a18b_cc) + (@a18b_fd - (@a18b_fc + @a18b_fi)) - (@a18b_im + @a18b_lg + @a18b_ot + @a18b_hm + @a18b_ps + @a18b_ss)
    @a19a_nc = (@a19a_cd-@a19a_cc) + (@a19a_fd - (@a19a_fc + @a19a_fi)) - (@a19a_im + @a19a_lg + @a19a_ot + @a19a_hm + @a19a_ps + @a19a_ss)
    @a19b_nc = (@a19b_cd-@a19b_cc) + (@a19b_fd - (@a19b_fc + @a19b_fi)) - (@a19b_im + @a19b_lg + @a19b_ot + @a19b_hm + @a19b_ps + @a19b_ss)

    # Total Operación_Financiera + Contab
    @ad_tc = @ad_nf + @ad_nc
    @aw_tc = @aw_nf + @aw_nc
    @am_tc = @am_nf + @am_nc
    @ay_tc = @ay_nf + @ay_nc

    @a17a_tc = @a17a_nf + @a17a_nc
    @a18a_tc = @a18a_nf + @a18a_nc
    @a18b_tc = @a18b_nf + @a18b_nc
    @a19a_tc = @a19a_nf + @a19a_nc
    @a19b_tc = @a19b_nf + @a19b_nc


    # Diario / Semana actual
    if Time.zone.now.sunday?
      then
      # Si es Domingo... ¡muestre el movimiento!
      @wdm = Time.zone.now.beginning_of_week
      @wdm_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_nt = @wdm_in - (@wdm_eg + @wdm_pj)
      @wdm_ev = @wdm_eg.nonzero? ? @wdm_in/@wdm_eg : 0

      @wdm_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)

      @wdm_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_nx = (@wdm_so+@wdm_to+@wdm_tx+@wdm_tm)

      @wdm_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
    else
      # Si ya no es Domingo... ¡muestre los datos!
      @adm = Time.zone.now.beginning_of_week
      @adm_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price) or 0
      @adm_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_ev = @adm_eg.nonzero? ? @adm_in/@adm_eg : 0

      @adm_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)

      @adm_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_nx = (@adm_so+@adm_to+@adm_tx+@adm_tm)

      @adm_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
    end

    if Time.zone.now.monday?
      then
      # Si es lunes... ¡muestre elmovimiento!
      @wln = Time.zone.now.beginning_of_week
      @wln_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_ev = @wln_eg.nonzero? ? @wln_in/@wln_eg : 0

      @wln_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week).sum(:price)

      @wln_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_nx = (@wln_so+@wln_to+@wln_tx+@wln_tm)

      @wln_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week).sum(:price)
    else
      # Si ya no es Lunes... ¡muestre los datos!
      @aln = Time.zone.now.beginning_of_week
      @aln_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_ev = @aln_eg.nonzero? ? @aln_in/@aln_eg : 0

      @aln_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week).sum(:price)

      @aln_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_nx = (@aln_so+@aln_to+@aln_tx+@aln_tm)

      @aln_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week).sum(:price)
    end

    if Time.zone.now.tuesday?
      then
      @wma = Time.zone.now.beginning_of_week + 1.day
      @wma_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_ev = @wma_eg.nonzero? ? @wma_in/@wma_eg : 0

      @wma_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)

      @wma_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_nx = (@wma_so+@wma_to+@wma_tx+@wma_tm)

      @wma_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
    else
      @ama = Time.zone.now.beginning_of_week + 1.day
      @ama_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_ev = @ama_eg.nonzero? ? @ama_in/@ama_eg : 0

      @ama_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)

      @ama_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_nx = (@ama_so+@ama_to+@ama_tx+@ama_tm)

      @ama_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
    end

    if Time.zone.now.wednesday?
      then
      @wmi = Time.zone.now.beginning_of_week + 2.day
      @wmi_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_ev = @wmi_eg.nonzero? ? @wmi_in/@wmi_eg : 0

      @wmi_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)

      @wmi_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_nx = (@wmi_so+@wmi_to+@wmi_tx+@wmi_tm)

      @wmi_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
    else
      @ami = Time.zone.now.beginning_of_week + 2.day
      @ami_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_ev = @ami_eg.nonzero? ? @ami_in/@ami_eg : 0

      @ami_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)

      @ami_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_nx = (@ami_so+@ami_to+@ami_tx+@ami_tm)

      @ami_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
    end

    if Time.zone.now.thursday?
      then
      @wju = Time.zone.now.beginning_of_week + 3.day
      @wju_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_ev = @wju_eg.nonzero? ? @wju_in/@wju_eg : 0

      @wju_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)

      @wju_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_nx = (@wju_so+@wju_to+@wju_tx+@wju_tm)

      @wju_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
    else
      @aju = Time.zone.now.beginning_of_week + 3.day
      @aju_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_ev = @aju_eg.nonzero? ? @aju_in/@aju_eg : 0

      @aju_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)

      @aju_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_nx = (@aju_so+@aju_to+@aju_tx+@aju_tm)

      @aju_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
    end

    if Time.zone.now.friday?
      then
      @wvi = Time.zone.now.beginning_of_week + 4.day
      @wvi_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_ev = @wvi_eg.nonzero? ? @wvi_in/@wvi_eg : 0

      @wvi_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)

      @wvi_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_nx = (@wvi_so+@wvi_to+@wvi_tx+@wvi_tm)

      @wvi_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
    else
      @avi = Time.zone.now.beginning_of_week + 4.day
      @avi_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_ev = @avi_eg.nonzero? ? @avi_in/@avi_eg : 0

      @avi_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)

      @avi_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_nx = (@avi_so+@avi_to+@avi_tx+@avi_tm)

      @avi_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
    end

    if Time.zone.now.saturday?
      then
      @wsa = Time.zone.now.beginning_of_week + 5.day
      @wsa_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_ev = @wsa_eg.nonzero? ? @wsa_in/@wsa_eg : 0

      @wsa_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)

      @wsa_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_nx = (@wsa_so+@wsa_to+@wsa_tx+@wsa_tm)

      @wsa_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
    else
      @asa = Time.zone.now.beginning_of_week + 5.day
      @asa_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_ev = @asa_eg.nonzero? ? @asa_in/@asa_eg : 0

      @asa_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)

      @asa_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_nx = (@asa_so+@asa_to+@asa_tx+@asa_tm)

      @asa_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
    end

    # Total week mov: ing, eg, op
    @wmv_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_ev = @wmv_eg.nonzero? ? @wmv_in/@wmv_eg : 0

    @wmv_an = Movement.where(mov_type: 'Aª',mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_dt = Movement.where(mov_type: 'A°',mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)

    @wmv_so = Movement.where(mov_type: 'S°',mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_to = Movement.where(mov_type: 'T°',mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_tx = Movement.where(mov_type: 'T×',mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_tm = Movement.where(mov_type: 'T™',mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_nx = (@wmv_so+@wmv_to+@wmv_tx+@wmv_tm)

    @wmv_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)


    @dom = Time.zone.now.beginning_of_week - 1.day
    @dia = Time.zone.now.saturday?
    @sab = Time.zone.now.end_of_week - 1.day


    # 2019 Diciembre // STW313 //


    # 2019 Septbre // STW313 //
    @a19sp_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  9, 1)..Date.new(2019,  9,30) )).sum(:price)
    @a19sp_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  9, 1)..Date.new(2019,  9,30) )).sum(:price)
    @a19sp_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  9, 1)..Date.new(2019,  9,30) )).sum(:price)
    @a19sp_ov = @a19sp_in-(@a19sp_eg+@a19sp_pj)
    @a19sp_an = Movement.where(mov_type: 'Aª',mov_date: (Date.new(2019,  9, 1)..Date.new(2019,  9,30) )).sum(:price)
    @a19sp_dt = Movement.where(mov_type: 'A°',mov_date: (Date.new(2019,  9, 1)..Date.new(2019,  9,30) )).sum(:price)
    # 2019 Agosto // STW313 //
    @a19ag_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  8, 1)..Date.new(2019,  8,31) )).sum(:price)
    @a19ag_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  8, 1)..Date.new(2019,  8,31) )).sum(:price)
    @a19ag_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  8, 1)..Date.new(2019,  8,31) )).sum(:price)
    @a19ag_ov = @a19ag_in-(@a19ag_eg+@a19ag_pj)
    @a19ag_an = Movement.where(mov_type: 'Aª',mov_date: (Date.new(2019,  8, 1)..Date.new(2019,  8,31) )).sum(:price)
    @a19ag_dt = Movement.where(mov_type: 'A°',mov_date: (Date.new(2019,  8, 1)..Date.new(2019,  8,31) )).sum(:price)
    # 2019 Julio // STW313 //
    @a19jl_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  7, 1)..Date.new(2019,  7,31) )).sum(:price)
    @a19jl_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  7, 1)..Date.new(2019,  7,31) )).sum(:price)
    @a19jl_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  7, 1)..Date.new(2019,  7,31) )).sum(:price)
    @a19jl_ov = @a19jl_in-(@a19jl_eg+@a19jl_pj)
    @a19jl_an = Movement.where(mov_type: 'Aª',mov_date: (Date.new(2019,  7, 1)..Date.new(2019,  7,31) )).sum(:price)
    @a19jl_dt = Movement.where(mov_type: 'A°',mov_date: (Date.new(2019,  7, 1)..Date.new(2019,  7,31) )).sum(:price)

    # 2019 Junio // STW313 //
    @a19jn_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  6, 1)..Date.new(2019,  6,30) )).sum(:price)
    @a19jn_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  6, 1)..Date.new(2019,  6,30) )).sum(:price)
    @a19jn_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  6, 1)..Date.new(2019,  6,30) )).sum(:price)
    @a19jn_ov = @a19jn_in-(@a19jn_eg+@a19jn_pj)
    @a19jn_an = Movement.where(mov_type: 'Aª',mov_date: (Date.new(2019,  6, 1)..Date.new(2019,  6,30) )).sum(:price)
    @a19jn_dt = Movement.where(mov_type: 'A°',mov_date: (Date.new(2019,  6, 1)..Date.new(2019,  6,30) )).sum(:price)
    # 2019 Mayo // STW313 //
    @a19my_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  5, 1)..Date.new(2019,  5,31) )).sum(:price)
    @a19my_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  5, 1)..Date.new(2019,  5,31) )).sum(:price)
    @a19my_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  5, 1)..Date.new(2019,  5,31) )).sum(:price)
    @a19my_ov = @a19my_in-(@a19my_eg+@a19my_pj)
    @a19my_an = Movement.where(mov_type: 'Aª',mov_date: (Date.new(2019,  5, 1)..Date.new(2019,  5,31) )).sum(:price)
    @a19my_dt = Movement.where(mov_type: 'A°',mov_date: (Date.new(2019,  5, 1)..Date.new(2019,  5,31) )).sum(:price)
    # 2019 Abril // STW313 //
    @a19ab_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  4, 1)..Date.new(2019,  4,30) )).sum(:price)
    @a19ab_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  4, 1)..Date.new(2019,  4,30) )).sum(:price)
    @a19ab_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  4, 1)..Date.new(2019,  4,30) )).sum(:price)
    @a19ab_ov = @a19ab_in-(@a19ab_eg+@a19ab_pj)
    @a19ab_an = Movement.where(mov_type: 'Aª',mov_date: (Date.new(2019,  4, 1)..Date.new(2019,  4,30) )).sum(:price)
    @a19ab_dt = Movement.where(mov_type: 'A°',mov_date: (Date.new(2019,  4, 1)..Date.new(2019,  4,30) )).sum(:price)
    # 2019 Marzo // STW313 //
    @a19mz_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  3, 1)..Date.new(2019,  3,31) )).sum(:price)
    @a19mz_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  3, 1)..Date.new(2019,  3,31) )).sum(:price)
    @a19mz_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  3, 1)..Date.new(2019,  3,31) )).sum(:price)
    @a19mz_ov = @a19mz_in-(@a19mz_eg+@a19mz_pj)
    @a19mz_an = Movement.where(mov_type: 'Aª',mov_date: (Date.new(2019,  3, 1)..Date.new(2019,  3,31) )).sum(:price)
    @a19mz_dt = Movement.where(mov_type: 'A°',mov_date: (Date.new(2019,  3, 1)..Date.new(2019,  3,31) )).sum(:price)
    # 2019 Febrero // STW313 //
    @a19fb_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    @a19fb_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    @a19fb_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    @a19fb_ov = @a19fb_in-(@a19fb_eg+@a19fb_pj)
    @a19fb_an = Movement.where(mov_type: 'Aª',mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    @a19fb_dt = Movement.where(mov_type: 'A°',mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    # 2019 Enero // STW313 //
    @a19en_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)
    @a19en_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)
    @a19en_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)
    @a19en_ov = @a19en_in-(@a19en_eg+@a19en_pj)
    @a19en_an = Movement.where(mov_type: 'Aª',mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)
    @a19en_dt = Movement.where(mov_type: 'A°',mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)

    # 2019 _ Costos Fijos legales /Mintrans
    # SOAT _ Estado meses
    @a19sp_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2019,  9, 1)..Date.new(2019,  9,30) )).sum(:price)
    @a19ag_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2019,  8, 1)..Date.new(2019,  8,31) )).sum(:price)
    @a19jl_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2019,  7, 1)..Date.new(2019,  7,31) )).sum(:price)
    @a19jn_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2019,  6, 1)..Date.new(2019,  6,30) )).sum(:price)
    @a19my_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2019,  5, 1)..Date.new(2019,  5,31) )).sum(:price)
    @a19ab_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2019,  4, 1)..Date.new(2019,  4,30) )).sum(:price)
    @a19mz_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2019,  3, 1)..Date.new(2019,  3,31) )).sum(:price)
    @a19fb_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    @a19en_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)
    # Tarj_Operac _ Estado meses
    @a19sp_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2019,  9, 1)..Date.new(2019,  9,30) )).sum(:price)
    @a19ag_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2019,  8, 1)..Date.new(2019,  8,31) )).sum(:price)
    @a19jl_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2019,  7, 1)..Date.new(2019,  7,31) )).sum(:price)
    @a19jn_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2019,  6, 1)..Date.new(2019,  6,30) )).sum(:price)
    @a19my_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2019,  5, 1)..Date.new(2019,  5,31) )).sum(:price)
    @a19ab_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2019,  4, 1)..Date.new(2019,  4,30) )).sum(:price)
    @a19mz_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2019,  3, 1)..Date.new(2019,  3,31) )).sum(:price)
    @a19fb_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    @a19en_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)
    # Taxim _ Estado meses
    @a19sp_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2019,  9, 1)..Date.new(2019,  9,30) )).sum(:price)
    @a19ag_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2019,  8, 1)..Date.new(2019,  8,31) )).sum(:price)
    @a19jl_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2019,  7, 1)..Date.new(2019,  7,31) )).sum(:price)
    @a19jn_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2019,  6, 1)..Date.new(2019,  6,30) )).sum(:price)
    @a19my_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2019,  5, 1)..Date.new(2019,  5,31) )).sum(:price)
    @a19ab_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2019,  4, 1)..Date.new(2019,  4,30) )).sum(:price)
    @a19mz_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2019,  3, 1)..Date.new(2019,  3,31) )).sum(:price)
    @a19fb_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    @a19en_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)
    # Téc_Méc _ Estado meses
    @a19sp_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2019,  9, 1)..Date.new(2019,  9,30) )).sum(:price)
    @a19ag_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2019,  8, 1)..Date.new(2019,  8,31) )).sum(:price)
    @a19jl_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2019,  7, 1)..Date.new(2019,  7,31) )).sum(:price)
    @a19jn_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2019,  6, 1)..Date.new(2019,  6,30) )).sum(:price)
    @a19my_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2019,  5, 1)..Date.new(2019,  5,31) )).sum(:price)
    @a19ab_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2019,  4, 1)..Date.new(2019,  4,30) )).sum(:price)
    @a19mz_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2019,  3, 1)..Date.new(2019,  3,31) )).sum(:price)
    @a19fb_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    @a19en_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)
    # 2019 subtts Mintrans
    @a19sp_nx = @a19sp_so + @a19sp_to + @a19sp_tx + @a19sp_tm
    @a19ag_nx = @a19ag_so + @a19ag_to + @a19ag_tx + @a19ag_tm
    @a19jl_nx = @a19jl_so + @a19jl_to + @a19jl_tx + @a19jl_tm

    @a19jn_nx = @a19jn_so + @a19jn_to + @a19jn_tx + @a19jn_tm
    @a19my_nx = @a19my_so + @a19my_to + @a19my_tx + @a19my_tm
    @a19ab_nx = @a19ab_so + @a19ab_to + @a19ab_tx + @a19ab_tm
    @a19mz_nx = @a19mz_so + @a19mz_to + @a19mz_tx + @a19mz_tm
    @a19fb_nx = @a19fb_so + @a19fb_to + @a19fb_tx + @a19fb_tm
    @a19en_nx = @a19en_so + @a19en_to + @a19en_tx + @a19en_tm

    @a19sp_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2019,  9, 1)..Date.new(2019,  9,30) )).sum(:price)
    @a19ag_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2019,  8, 1)..Date.new(2019,  8,31) )).sum(:price)
    @a19jl_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2019,  7, 1)..Date.new(2019,  7,31) )).sum(:price)
    @a19jn_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2019,  6, 1)..Date.new(2019,  6,30) )).sum(:price)
    @a19my_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2019,  5, 1)..Date.new(2019,  5,31) )).sum(:price)
    @a19ab_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2019,  4, 1)..Date.new(2019,  4,30) )).sum(:price)
    @a19mz_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2019,  3, 1)..Date.new(2019,  3,31) )).sum(:price)
    @a19fb_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    @a19en_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)
    # 2019 varios _ estado meses
    @a19sp_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2019,  9, 1)..Date.new(2019,  9,30) )).sum(:price)
    @a19ag_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2019,  8, 1)..Date.new(2019,  8,31) )).sum(:price)
    @a19jl_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2019,  7, 1)..Date.new(2019,  7,31) )).sum(:price)
    @a19jn_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2019,  6, 1)..Date.new(2019,  6,30) )).sum(:price)
    @a19my_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2019,  5, 1)..Date.new(2019,  5,31) )).sum(:price)
    @a19ab_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2019,  4, 1)..Date.new(2019,  4,30) )).sum(:price)
    @a19mz_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2019,  3, 1)..Date.new(2019,  3,31) )).sum(:price)
    @a19fb_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    @a19en_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)
    # Neto mes
    @a19sp_nt = @a19sp_in-( (@a19sp_eg+@a19sp_pj) + @a19sp_nx + @a19sp_tr+@a19sp_vr )
    @a19ag_nt = @a19ag_in-( (@a19ag_eg+@a19ag_pj) + @a19ag_nx + @a19ag_tr+@a19ag_vr )
    @a19jl_nt = @a19jl_in-( (@a19jl_eg+@a19jl_pj) + @a19jl_nx + @a19jl_tr+@a19jl_vr )

    @a19jn_nt = @a19jn_in-( (@a19jn_eg+@a19jn_pj) + @a19jn_nx + @a19jn_tr+@a19jn_vr )
    @a19my_nt = @a19my_in-( (@a19my_eg+@a19my_pj) + @a19my_nx + @a19my_tr+@a19my_vr )
    @a19ab_nt = @a19ab_in-( (@a19ab_eg+@a19ab_pj) + @a19ab_nx + @a19ab_tr+@a19ab_vr )
    @a19mz_nt = @a19mz_in-( (@a19mz_eg+@a19mz_pj) + @a19mz_nx + @a19mz_tr+@a19mz_vr )
    @a19fb_nt = @a19fb_in-( (@a19fb_eg+@a19fb_pj) + @a19fb_nx + @a19fb_tr+@a19fb_vr )
    @a19en_nt = @a19en_in-( (@a19en_eg+@a19en_pj) + @a19en_nx + @a19en_tr+@a19en_vr )

    @a19sp_ev = @a19sp_eg.nonzero? ? @a19sp_in/@a19sp_eg : 0
    @a19ag_ev = @a19ag_eg.nonzero? ? @a19ag_in/@a19ag_eg : 0
    @a19jl_ev = @a19jl_eg.nonzero? ? @a19jl_in/@a19jl_eg : 0

    @a19jn_ev = @a19jn_eg.nonzero? ? @a19jn_in/@a19jn_eg : 0
    @a19my_ev = @a19my_eg.nonzero? ? @a19my_in/@a19my_eg : 0
    @a19ab_ev = @a19ab_eg.nonzero? ? @a19ab_in/@a19ab_eg : 0
    @a19mz_ev = @a19mz_eg.nonzero? ? @a19mz_in/@a19mz_eg : 0
    @a19fb_ev = @a19fb_eg.nonzero? ? @a19fb_in/@a19fb_eg : 0
    @a19en_ev = @a19en_eg.nonzero? ? @a19en_in/@a19en_eg : 0

    # Totales 2019
    @a19tt_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  1, 1)..Date.new(2019, 12,31) )).sum(:price)
    @a19tt_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  1, 1)..Date.new(2019, 12,31) )).sum(:price)
    @a19tt_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  1, 1)..Date.new(2019, 12,31) )).sum(:price)
    @a19tt_an = Movement.where(mov_type: 'Aª',mov_date: (Date.new(2019,  1, 1)..Date.new(2019, 12,31) )).sum(:price)
    @a19tt_dt = Movement.where(mov_type: 'A°',mov_date: (Date.new(2019,  1, 1)..Date.new(2019, 12,31) )).sum(:price)
    # MNT - Totales generales
    @a19tt_so = Movement.where(mov_type: 'S°',mov_date: (Date.new(2019,  1, 1)..Date.new(2019, 12,31) )).sum(:price)
    @a19tt_to = Movement.where(mov_type: 'T°',mov_date: (Date.new(2019,  1, 1)..Date.new(2019, 12,31) )).sum(:price)
    @a19tt_tx = Movement.where(mov_type: 'T×',mov_date: (Date.new(2019,  1, 1)..Date.new(2019, 12,31) )).sum(:price)
    @a19tt_tm = Movement.where(mov_type: 'T™',mov_date: (Date.new(2019,  1, 1)..Date.new(2019, 12,31) )).sum(:price)
    @a19tt_nx = (@a19tt_so+@a19tt_to+@a19tt_tx+@a19tt_tm)
    @a19tt_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2019,  1, 1)..Date.new(2019, 12,31) )).sum(:price)
    @a19tt_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2019,  1, 1)..Date.new(2019, 12,31) )).sum(:price)
    # Total Ing, Egr, Oper /General
    @a19tt_nt = @a19tt_in - ( (@a19tt_eg+@a19tt_pj) + @a19tt_an+@a19tt_dt + @a19tt_nx + @a19tt_tr+@a19tt_vr )
    @a19tt_ev = @a19tt_eg.nonzero? ? @a19tt_in/@a19tt_eg : 0

    # ------------------------------------
    # 2018 Julio - Diciembre // STW313 //
    @a18dc_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)
    @a18dc_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)
    @a18dc_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)
    @a18dc_an= Movement.where(mov_type: 'Aª',mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)
    @a18dc_dt= Movement.where(mov_type: 'A°',mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)

    @a18nv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)
    @a18nv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)
    @a18nv_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)
    @a18nv_an= Movement.where(mov_type: 'Aª',mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)
    @a18nv_dt= Movement.where(mov_type: 'A°',mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)

    @a18oc_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)
    @a18oc_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)
    @a18oc_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)
    @a18oc_an= Movement.where(mov_type: 'Aª',mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)
    @a18oc_dt= Movement.where(mov_type: 'A°',mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)

    @a18sp_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)
    @a18sp_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)
    @a18sp_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)
    @a18sp_an= Movement.where(mov_type: 'Aª',mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)
    @a18sp_dt= Movement.where(mov_type: 'A°',mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)

    @a18ag_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)
    @a18ag_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)
    @a18ag_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)
    @a18ag_an= Movement.where(mov_type: 'Aª',mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)
    @a18ag_dt= Movement.where(mov_type: 'A°',mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)

    @a18jl_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)
    @a18jl_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)
    @a18jl_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)
    @a18jl_an= Movement.where(mov_type: 'Aª',mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)
    @a18jl_dt= Movement.where(mov_type: 'A°',mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)

    # 2018 Enero - Junio // STW313 //
    @a18jn_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)
    @a18jn_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)
    @a18jn_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)
    @a18jn_an= Movement.where(mov_type: 'Aª',mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)
    @a18jn_dt= Movement.where(mov_type: 'A°',mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)

    @a18my_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)
    @a18my_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)
    @a18my_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)
    @a18my_an= Movement.where(mov_type: 'Aª',mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)
    @a18my_dt= Movement.where(mov_type: 'A°',mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)

    @a18ab_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)
    @a18ab_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)
    @a18ab_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)
    @a18ab_an= Movement.where(mov_type: 'Aª',mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)
    @a18ab_dt= Movement.where(mov_type: 'A°',mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)

    @a18mz_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)
    @a18mz_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)
    @a18mz_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)
    @a18mz_an= Movement.where(mov_type: 'Aª',mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)
    @a18mz_dt= Movement.where(mov_type: 'A°',mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)

    @a18fb_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)
    @a18fb_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)
    @a18fb_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)
    @a18fb_an= Movement.where(mov_type: 'Aª',mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)
    @a18fb_dt= Movement.where(mov_type: 'A°',mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)

    @a18en_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)
    @a18en_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)
    @a18en_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)
    @a18en_an= Movement.where(mov_type: 'Aª',mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)
    @a18en_dt= Movement.where(mov_type: 'A°',mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)

    # 2018 _ Costos Fijos legales /Mintrans
    # SOAT _ Estado meses
    @a18dc_so= Movement.where(mov_type: 'S°', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)
    @a18nv_so= Movement.where(mov_type: 'S°', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)
    @a18oc_so= Movement.where(mov_type: 'S°', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)
    @a18sp_so= Movement.where(mov_type: 'S°', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)
    @a18ag_so= Movement.where(mov_type: 'S°', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)
    @a18jl_so= Movement.where(mov_type: 'S°', mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)
    @a18jn_so= Movement.where(mov_type: 'S°', mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)
    @a18my_so= Movement.where(mov_type: 'S°', mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)
    @a18ab_so= Movement.where(mov_type: 'S°', mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)
    @a18mz_so= Movement.where(mov_type: 'S°', mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)
    @a18fb_so= Movement.where(mov_type: 'S°', mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)
    @a18en_so= Movement.where(mov_type: 'S°', mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)

    # Tarjeta_Operac _ Estado meses
    @a18dc_to= Movement.where(mov_type: 'T°', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)
    @a18nv_to= Movement.where(mov_type: 'T°', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)
    @a18oc_to= Movement.where(mov_type: 'T°', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)
    @a18sp_to= Movement.where(mov_type: 'T°', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)
    @a18ag_to= Movement.where(mov_type: 'T°', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)
    @a18jl_to= Movement.where(mov_type: 'T°', mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)
    @a18jn_to= Movement.where(mov_type: 'T°', mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)
    @a18my_to= Movement.where(mov_type: 'T°', mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)
    @a18ab_to= Movement.where(mov_type: 'T°', mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)
    @a18mz_to= Movement.where(mov_type: 'T°', mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)
    @a18fb_to= Movement.where(mov_type: 'T°', mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)
    @a18en_to= Movement.where(mov_type: 'T°', mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)

    # Taxímetro _ Estado meses
    @a18dc_tx= Movement.where(mov_type: 'T×', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)
    @a18nv_tx= Movement.where(mov_type: 'T×', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)
    @a18oc_tx= Movement.where(mov_type: 'T×', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)
    @a18sp_tx= Movement.where(mov_type: 'T×', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)
    @a18ag_tx= Movement.where(mov_type: 'T×', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)
    @a18jl_tx= Movement.where(mov_type: 'T×', mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)
    @a18jn_tx= Movement.where(mov_type: 'T×', mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)
    @a18my_tx= Movement.where(mov_type: 'T×', mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)
    @a18ab_tx= Movement.where(mov_type: 'T×', mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)
    @a18mz_tx= Movement.where(mov_type: 'T×', mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)
    @a18fb_tx= Movement.where(mov_type: 'T×', mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)
    @a18en_tx= Movement.where(mov_type: 'T×', mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)

    # Técn_Méc _ Estado meses
    @a18dc_tm= Movement.where(mov_type: 'T™', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)
    @a18nv_tm= Movement.where(mov_type: 'T™', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)
    @a18oc_tm= Movement.where(mov_type: 'T™', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)
    @a18sp_tm= Movement.where(mov_type: 'T™', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)
    @a18ag_tm= Movement.where(mov_type: 'T™', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)
    @a18jl_tm= Movement.where(mov_type: 'T™', mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)
    @a18jn_tm= Movement.where(mov_type: 'T™', mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)
    @a18my_tm= Movement.where(mov_type: 'T™', mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)
    @a18ab_tm= Movement.where(mov_type: 'T™', mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)
    @a18mz_tm= Movement.where(mov_type: 'T™', mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)
    @a18fb_tm= Movement.where(mov_type: 'T™', mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)
    @a18en_tm= Movement.where(mov_type: 'T™', mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)
    # 2018 subtts Mintrans
    @a18dc_nx= @a18dc_so + @a18dc_to + @a18dc_tx + @a18dc_tm
    @a18nv_nx= @a18nv_so + @a18nv_to + @a18nv_tx + @a18nv_tm
    @a18oc_nx= @a18oc_so + @a18oc_to + @a18oc_tx + @a18oc_tm
    @a18sp_nx= @a18sp_so + @a18sp_to + @a18sp_tx + @a18sp_tm
    @a18ag_nx= @a18ag_so + @a18ag_to + @a18ag_tx + @a18ag_tm
    @a18jl_nx= @a18jl_so + @a18jl_to + @a18jl_tx + @a18jl_tm
    @a18jn_nx= @a18jn_so + @a18jn_to + @a18jn_tx + @a18jn_tm
    @a18my_nx= @a18my_so + @a18my_to + @a18my_tx + @a18my_tm
    @a18ab_nx= @a18ab_so + @a18ab_to + @a18ab_tx + @a18ab_tm
    @a18mz_nx= @a18mz_so + @a18mz_to + @a18mz_tx + @a18mz_tm
    @a18fb_nx= @a18fb_so + @a18fb_to + @a18fb_tx + @a18fb_tm
    @a18en_nx= @a18en_so + @a18en_to + @a18en_tx + @a18en_tm

    # taller _ estado meses
    @a18dc_tr= Movement.where(mov_type: 'T', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)
    @a18nv_tr= Movement.where(mov_type: 'T', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)
    @a18oc_tr= Movement.where(mov_type: 'T', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)
    @a18sp_tr= Movement.where(mov_type: 'T', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)
    @a18ag_tr= Movement.where(mov_type: 'T', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)
    @a18jl_tr= Movement.where(mov_type: 'T', mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)
    @a18jn_tr= Movement.where(mov_type: 'T', mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)
    @a18my_tr= Movement.where(mov_type: 'T', mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)
    @a18ab_tr= Movement.where(mov_type: 'T', mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)
    @a18mz_tr= Movement.where(mov_type: 'T', mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)
    @a18fb_tr= Movement.where(mov_type: 'T', mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)
    @a18en_tr= Movement.where(mov_type: 'T', mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)
    # 2018 varios _ estado meses
    @a18dc_vr= Movement.where(mov_type: 'V', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)
    @a18nv_vr= Movement.where(mov_type: 'V', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)
    @a18oc_vr= Movement.where(mov_type: 'V', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)
    @a18sp_vr= Movement.where(mov_type: 'V', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)
    @a18ag_vr= Movement.where(mov_type: 'V', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)
    @a18jl_vr= Movement.where(mov_type: 'V', mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)
    @a18jn_vr= Movement.where(mov_type: 'V', mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)
    @a18my_vr= Movement.where(mov_type: 'V', mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)
    @a18ab_vr= Movement.where(mov_type: 'V', mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)
    @a18mz_vr= Movement.where(mov_type: 'V', mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)
    @a18fb_vr= Movement.where(mov_type: 'V', mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)
    @a18en_vr= Movement.where(mov_type: 'V', mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)



    # 2017 Diciembre // STW313 //
    @a17dc_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a17dc_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a17dc_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    # Andaluz _ Estado meses
    @a17dc_an= Movement.where(mov_type: 'Aª', mov_date:(Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    # Datos móviles _ Estado meses
    @a17dc_dt= Movement.where(mov_type: 'A°',mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)

    # 2017 _ Costos Fijos legales /Mintrans
    @a17dc_so= Movement.where(mov_type: 'S°', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a17dc_to= Movement.where(mov_type: 'T°', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a17dc_tx= Movement.where(mov_type: 'T×', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a17dc_tm= Movement.where(mov_type: 'T™', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    # 2017 subtts Mintrans
    @a17dc_nx= @a17dc_so + @a17dc_to + @a17dc_tx + @a17dc_tm
    # 2017
    @a17dc_tr= Movement.where(mov_type: 'T', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a17dc_vr= Movement.where(mov_type: 'V', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)

    # Total Ing, Egr, Oper /General
    @tt3_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year)).sum(:price)
    @tt3_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year)).sum(:price)
    @tt3_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year)).sum(:price)

    @tt3_an = Movement.where(mov_type: 'Aª',mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year)).sum(:price)
    @tt3_dt = Movement.where(mov_type: 'A°',mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year)).sum(:price)
    # MNT - Totales generales
    @tt3_so = Movement.where(mov_type: 'S°',mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year)).sum(:price)
    @tt3_to = Movement.where(mov_type: 'T°',mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year)).sum(:price)
    @tt3_tx = Movement.where(mov_type: 'T×',mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year)).sum(:price)
    @tt3_tm = Movement.where(mov_type: 'T™',mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_year)).sum(:price)
    @tt3_nx = (@tt3_so+@tt3_to+@tt3_tx+@tt3_tm)

    @tt3_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year)).sum(:price)
    @tt3_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year)).sum(:price)

    # flash[:success] = "Diario Actualizado"
  end


  def see_all
    @movements = Movement.all
    @nn_n  = 0

    # Diario / Semana actual
    if Time.zone.now.sunday?
      then
      @wdm = Time.zone.now.beginning_of_week-1.day
      @wdm_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
    else
      @adm = Time.zone.now.beginning_of_week-1.day
      @adm_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price) or 0
      @adm_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
    end

    if Time.zone.now.monday?
      then
      @wln = Time.zone.now.beginning_of_week
      @wln_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week).sum(:price)
    else
      # Si ya no es Lunes... ¡muestre los datos!
      @aln = Time.zone.now.beginning_of_week
      @aln_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week).sum(:price)
    end

    if Time.zone.now.tuesday?
      then
      @wma = Time.zone.now.beginning_of_week + 1.day
      @wma_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
    else
      @ama = Time.zone.now.beginning_of_week + 1.day
      @ama_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
    end

    if Time.zone.now.wednesday?
      then
      @wmi = Time.zone.now.beginning_of_week + 2.day
      @wmi_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
    else
      @ami = Time.zone.now.beginning_of_week + 2.day
      @ami_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
    end

    if Time.zone.now.thursday?
      then
      @wju = Time.zone.now.beginning_of_week + 3.day
      @wju_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
    else
      @aju = Time.zone.now.beginning_of_week + 3.day
      @aju_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
    end

    if Time.zone.now.friday?
      then
      @wvi = Time.zone.now.beginning_of_week + 4.day
      @wvi_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
    else
      @avi = Time.zone.now.beginning_of_week + 4.day
      @avi_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
    end

    if Time.zone.now.saturday?
      then
      @wsa = Time.zone.now.beginning_of_week + 5.day
      @wsa_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
    else
      @asa = Time.zone.now.beginning_of_week + 5.day
      @asa_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
    end

    # Total week mov: ing, eg, op
    @wmv_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)

    @dom = Time.zone.now.beginning_of_week - 1.day
    @dia = Time.zone.now.saturday?
    @sab = Time.zone.now.end_of_week - 1.day


    # flash[:success] = "Operaciones generales" L546
  end


  def see_weeks
    @movements = Movement.where(mov_date: (Time.zone.now.beginning_of_week-1.day..Time.zone.now.end_of_week-1.day))

    # def dweek
    if Time.zone.now.sunday?
      then
        @date_wdm = Time.zone.now.sunday?
        @wdm_in  = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
        @wdm_eg  = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
        @wdm_pj  = Movement.where(mov_type: 'J', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
      else
        @wdm_in = 0
        @wdm_eg = 0
        @wdm_pj = 0
    end

    if Time.zone.now.monday?
      then
        @date_wln = Time.zone.now.monday?
        @wln_in  = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
        @wln_eg  = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
        @wln_pj  = Movement.where(mov_type: 'J', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
      else
        @wln_in = 0
        @wln_eg = 0
        @wln_pj= 0
    end

    if Time.zone.now.tuesday?
      then
        @date_wma = Time.zone.now.tuesday?
        @wma_in  = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
        @wma_eg  = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
        @wma_pj  = Movement.where(mov_type: 'J', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
      else
        @wma_in = 0
        @wma_eg = 0
        @wma_pj = 0
    end

    if Time.zone.now.wednesday?
      then
        @date_wmi = Time.zone.now.wednesday?
        @wmi_in  = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
        @wmi_eg  = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
        @wmi_pj  = Movement.where(mov_type: 'J', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
      else
        @wmi_in = 0
        @wmi_eg = 0
        @wmi_pj = 0
    end

    if Time.zone.now.thursday?
      then
        @date_wju = Time.zone.now.thursday?
        @wju_in  = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
        @wju_eg  = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
        @wju_pj  = Movement.where(mov_type: 'J', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
      else
        @wju_in = 0
        @wju_eg = 0
        @wju_pj = 0
    end

    if Time.zone.now.friday?
      then
        @date_wvi = Time.zone.now.friday?
        @wvi_in  = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
        @wvi_eg  = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
        @wvi_pj  = Movement.where(mov_type: 'J', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
      else
        @wvi_in = 0
        @wvi_eg = 0
        @wvi_pj = 0
    end

    if Time.zone.now.saturday?
      then
        @date_wsa = Time.zone.now.saturday?
        @wsa_in  = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
        @wsa_eg  = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
        @wsa_pj  = Movement.where(mov_type: 'J', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
      else
        @wsa_in = 0
        @wsa_eg = 0
        @wsa_pj = 0
    end

    @wmv_in  = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_week-1.day..Time.zone.now.end_of_week-1.day)).sum(:price)
    @wmv_eg  = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_week-1.day..Time.zone.now.end_of_week-1.day)).sum(:price)
    @wmv_pj  = Movement.where(mov_type: 'J', mov_date: (Time.zone.now.beginning_of_week-1.day..Time.zone.now.end_of_week-1.day)).sum(:price)

    # end
    flash[:success] = "Diario semana actual"

    # def dweek before



    # A19-08 / W36
    @a19_36dm_da = Date.new(2019, 9, 1).sunday?
    @a19_36dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 9, 1)..Date.new(2019, 9, 1) )).sum(:price)
    @a19_36dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 9, 1)..Date.new(2019, 9, 1) )).sum(:price)
    @a19_36dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 9, 1)..Date.new(2019, 9, 1) )).sum(:price)

    @a19_36ln_da = Date.new(2019, 9, 2).monday?
    @a19_36ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 9, 2)..Date.new(2019, 9, 25) )).sum(:price)
    @a19_36ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 9, 2)..Date.new(2019, 9, 25) )).sum(:price)
    @a19_36ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 9, 2)..Date.new(2019, 9, 25) )).sum(:price)

    @a19_36ma_da = Date.new(2019, 9, 3).tuesday?
    @a19_36ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 9, 3)..Date.new(2019, 9, 3) )).sum(:price)
    @a19_36ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 9, 3)..Date.new(2019, 9, 3) )).sum(:price)
    @a19_36ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 9, 3)..Date.new(2019, 9, 3) )).sum(:price)

    @a19_36mi_da = Date.new(2019, 9, 4).wednesday?
    @a19_36mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 9, 4)..Date.new(2019, 9, 4) )).sum(:price)
    @a19_36mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 9, 4)..Date.new(2019, 9, 4) )).sum(:price)
    @a19_36mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 9, 4)..Date.new(2019, 9, 4) )).sum(:price)

    @a19_36ju_da = Date.new(2019, 9, 5).thursday?
    @a19_36ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 9, 5)..Date.new(2019, 9, 5) )).sum(:price)
    @a19_36ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 9, 5)..Date.new(2019, 9, 5) )).sum(:price)
    @a19_36ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 9, 5)..Date.new(2019, 9, 5) )).sum(:price)

    @a19_36vi_da = Date.new(2019, 9, 6).friday?
    @a19_36vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 9, 6)..Date.new(2019, 9, 6) )).sum(:price)
    @a19_36vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 9, 6)..Date.new(2019, 9, 6) )).sum(:price)
    @a19_36vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 9, 6)..Date.new(2019, 9, 6) )).sum(:price)

    @a19_36sa_da = Date.new(2019, 9, 7).saturday?
    @a19_36sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 9, 7)..Date.new(2019, 9, 7) )).sum(:price)
    @a19_36sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 9, 7)..Date.new(2019, 9, 7) )).sum(:price)
    @a19_36sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 9, 7)..Date.new(2019, 9, 7) )).sum(:price)
    # A19-08 / W36
    @a19_36mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 9, 1)..Date.new(2019, 9, 7) )).sum(:price)
    @a19_36mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 9, 1)..Date.new(2019, 9, 7) )).sum(:price)
    @a19_36mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 9, 1)..Date.new(2019, 9, 7) )).sum(:price)

    # A19-08 / W35
    @a19_35dm_da = Date.new(2019, 8,25).sunday?
    @a19_35dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,25)..Date.new(2019, 8,25) )).sum(:price)
    @a19_35dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,25)..Date.new(2019, 8,25) )).sum(:price)
    @a19_35dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,25)..Date.new(2019, 8,25) )).sum(:price)

    @a19_35ln_da = Date.new(2019, 8,26).monday?
    @a19_35ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,26)..Date.new(2019, 8,26) )).sum(:price)
    @a19_35ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,26)..Date.new(2019, 8,26) )).sum(:price)
    @a19_35ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,26)..Date.new(2019, 8,26) )).sum(:price)

    @a19_35ma_da = Date.new(2019, 8,27).tuesday?
    @a19_35ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,27)..Date.new(2019, 8,27) )).sum(:price)
    @a19_35ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,27)..Date.new(2019, 8,27) )).sum(:price)
    @a19_35ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,27)..Date.new(2019, 8,27) )).sum(:price)

    @a19_35mi_da = Date.new(2019, 8,28).wednesday?
    @a19_35mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,28)..Date.new(2019, 8,28) )).sum(:price)
    @a19_35mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,28)..Date.new(2019, 8,28) )).sum(:price)
    @a19_35mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,28)..Date.new(2019, 8,28) )).sum(:price)

    @a19_35ju_da = Date.new(2019, 8,29).thursday?
    @a19_35ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,29)..Date.new(2019, 8,29) )).sum(:price)
    @a19_35ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,29)..Date.new(2019, 8,29) )).sum(:price)
    @a19_35ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,29)..Date.new(2019, 8,29) )).sum(:price)

    @a19_35vi_da = Date.new(2019, 8,30).friday?
    @a19_35vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,30)..Date.new(2019, 8,30) )).sum(:price)
    @a19_35vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,30)..Date.new(2019, 8,30) )).sum(:price)
    @a19_35vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,30)..Date.new(2019, 8,30) )).sum(:price)

    @a19_35sa_da = Date.new(2019, 8,31).saturday?
    @a19_35sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,31)..Date.new(2019, 8,31) )).sum(:price)
    @a19_35sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,31)..Date.new(2019, 8,31) )).sum(:price)
    @a19_35sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,31)..Date.new(2019, 8,31) )).sum(:price)
    # A19-08 / W35
    @a19_35mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,25)..Date.new(2019, 8,31) )).sum(:price)
    @a19_35mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,25)..Date.new(2019, 8,31) )).sum(:price)
    @a19_35mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,25)..Date.new(2019, 8,31) )).sum(:price)

    # A19-08 / W34
    @a19_34dm_da = Date.new(2019, 8,18).sunday?
    @a19_34dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,18)..Date.new(2019, 8,18) )).sum(:price)
    @a19_34dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,18)..Date.new(2019, 8,18) )).sum(:price)
    @a19_34dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,18)..Date.new(2019, 8,18) )).sum(:price)

    @a19_34ln_da = Date.new(2019, 8,19).monday?
    @a19_34ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,19)..Date.new(2019, 8,19) )).sum(:price)
    @a19_34ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,19)..Date.new(2019, 8,19) )).sum(:price)
    @a19_34ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,19)..Date.new(2019, 8,19) )).sum(:price)

    @a19_34ma_da = Date.new(2019, 8,20).tuesday?
    @a19_34ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,20)..Date.new(2019, 8,20) )).sum(:price)
    @a19_34ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,20)..Date.new(2019, 8,20) )).sum(:price)
    @a19_34ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,20)..Date.new(2019, 8,20) )).sum(:price)

    @a19_34mi_da = Date.new(2019, 8,21).wednesday?
    @a19_34mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,21)..Date.new(2019, 8,21) )).sum(:price)
    @a19_34mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,21)..Date.new(2019, 8,21) )).sum(:price)
    @a19_34mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,21)..Date.new(2019, 8,21) )).sum(:price)

    @a19_34ju_da = Date.new(2019, 8,22).thursday?
    @a19_34ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,22)..Date.new(2019, 8,22) )).sum(:price)
    @a19_34ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,22)..Date.new(2019, 8,22) )).sum(:price)
    @a19_34ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,22)..Date.new(2019, 8,22) )).sum(:price)

    @a19_34vi_da = Date.new(2019, 8,23).friday?
    @a19_34vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,23)..Date.new(2019, 8,23) )).sum(:price)
    @a19_34vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,23)..Date.new(2019, 8,23) )).sum(:price)
    @a19_34vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,23)..Date.new(2019, 8,23) )).sum(:price)

    @a19_34sa_da = Date.new(2019, 8,24).saturday?
    @a19_34sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,24)..Date.new(2019, 8,24) )).sum(:price)
    @a19_34sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,24)..Date.new(2019, 8,24) )).sum(:price)
    @a19_34sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,24)..Date.new(2019, 8,24) )).sum(:price)
    # A19-08 / W34
    @a19_34mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,18)..Date.new(2019, 8,24) )).sum(:price)
    @a19_34mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,18)..Date.new(2019, 8,24) )).sum(:price)
    @a19_34mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,18)..Date.new(2019, 8,24) )).sum(:price)

    # A19-08 / W33
    @a19_33dm_da = Date.new(2019, 8,11).sunday?
    @a19_33dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,11)..Date.new(2019, 8,11) )).sum(:price)
    @a19_33dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,11)..Date.new(2019, 8,11) )).sum(:price)
    @a19_33dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,11)..Date.new(2019, 8,11) )).sum(:price)

    @a19_33ln_da = Date.new(2019, 8,12).monday?
    @a19_33ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,12)..Date.new(2019, 8,12) )).sum(:price)
    @a19_33ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,12)..Date.new(2019, 8,12) )).sum(:price)
    @a19_33ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,12)..Date.new(2019, 8,12) )).sum(:price)

    @a19_33ma_da = Date.new(2019, 8,13).tuesday?
    @a19_33ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,13)..Date.new(2019, 8,13) )).sum(:price)
    @a19_33ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,13)..Date.new(2019, 8,13) )).sum(:price)
    @a19_33ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,13)..Date.new(2019, 8,13) )).sum(:price)

    @a19_33mi_da = Date.new(2019, 8,14).wednesday?
    @a19_33mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,14)..Date.new(2019, 8,14) )).sum(:price)
    @a19_33mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,14)..Date.new(2019, 8,14) )).sum(:price)
    @a19_33mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,14)..Date.new(2019, 8,14) )).sum(:price)

    @a19_33ju_da = Date.new(2019, 8,15).thursday?
    @a19_33ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,15)..Date.new(2019, 8,15) )).sum(:price)
    @a19_33ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,15)..Date.new(2019, 8,15) )).sum(:price)
    @a19_33ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,15)..Date.new(2019, 8,15) )).sum(:price)

    @a19_33vi_da = Date.new(2019, 8,16).friday?
    @a19_33vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,16)..Date.new(2019, 8,16) )).sum(:price)
    @a19_33vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,16)..Date.new(2019, 8,16) )).sum(:price)
    @a19_33vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,16)..Date.new(2019, 8,16) )).sum(:price)

    @a19_33sa_da = Date.new(2019, 8,17).saturday?
    @a19_33sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,17)..Date.new(2019, 8,17) )).sum(:price)
    @a19_33sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,17)..Date.new(2019, 8,17) )).sum(:price)
    @a19_33sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,17)..Date.new(2019, 8,17) )).sum(:price)
    # A19-08 / W33
    @a19_33mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,11)..Date.new(2019, 8,17) )).sum(:price)
    @a19_33mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,11)..Date.new(2019, 8,17) )).sum(:price)
    @a19_33mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,11)..Date.new(2019, 8,17) )).sum(:price)

    # A19-08 / W32
    @a19_32dm_da = Date.new(2019, 8, 4).sunday?
    @a19_32dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8, 4)..Date.new(2019, 8, 4) )).sum(:price)
    @a19_32dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8, 4)..Date.new(2019, 8, 4) )).sum(:price)
    @a19_32dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8, 4)..Date.new(2019, 8, 4) )).sum(:price)

    @a19_32ln_da = Date.new(2019, 8, 5).monday?
    @a19_32ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8, 5)..Date.new(2019, 8, 5) )).sum(:price)
    @a19_32ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8, 5)..Date.new(2019, 8, 5) )).sum(:price)
    @a19_32ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8, 5)..Date.new(2019, 8, 5) )).sum(:price)

    @a19_32ma_da = Date.new(2019, 8, 6).tuesday?
    @a19_32ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8, 6)..Date.new(2019, 8, 6) )).sum(:price)
    @a19_32ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8, 6)..Date.new(2019, 8, 6) )).sum(:price)
    @a19_32ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8, 6)..Date.new(2019, 8, 6) )).sum(:price)

    @a19_32mi_da = Date.new(2019, 8, 7).wednesday?
    @a19_32mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8, 7)..Date.new(2019, 8, 7) )).sum(:price)
    @a19_32mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8, 7)..Date.new(2019, 8, 7) )).sum(:price)
    @a19_32mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8, 7)..Date.new(2019, 8, 7) )).sum(:price)

    @a19_32ju_da = Date.new(2019, 8, 8).thursday?
    @a19_32ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8, 8)..Date.new(2019, 8, 8) )).sum(:price)
    @a19_32ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8, 8)..Date.new(2019, 8, 8) )).sum(:price)
    @a19_32ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8, 8)..Date.new(2019, 8, 8) )).sum(:price)

    @a19_32vi_da = Date.new(2019, 8, 9).friday?
    @a19_32vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8, 9)..Date.new(2019, 8, 9) )).sum(:price)
    @a19_32vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8, 9)..Date.new(2019, 8, 9) )).sum(:price)
    @a19_32vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8, 9)..Date.new(2019, 8, 9) )).sum(:price)

    @a19_32sa_da = Date.new(2019, 8,10).saturday?
    @a19_32sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,10)..Date.new(2019, 8,10) )).sum(:price)
    @a19_32sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,10)..Date.new(2019, 8,10) )).sum(:price)
    @a19_32sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,10)..Date.new(2019, 8,10) )).sum(:price)
    # A19-08 / W32
    @a19_32mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8, 4)..Date.new(2019, 8,10) )).sum(:price)
    @a19_32mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8, 4)..Date.new(2019, 8,10) )).sum(:price)
    @a19_32mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8, 4)..Date.new(2019, 8,10) )).sum(:price)

    # A19-08 / W31
    @a19_31ju_da = Date.new(2019, 8, 1).thursday?
    @a19_31ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8, 1)..Date.new(2019, 8, 1) )).sum(:price)
    @a19_31ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8, 1)..Date.new(2019, 8, 1) )).sum(:price)
    @a19_31ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8, 1)..Date.new(2019, 8, 1) )).sum(:price)

    @a19_31vi_da = Date.new(2019, 8, 2).friday?
    @a19_31vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8, 2)..Date.new(2019, 8, 2) )).sum(:price)
    @a19_31vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8, 2)..Date.new(2019, 8, 2) )).sum(:price)
    @a19_31vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8, 2)..Date.new(2019, 8, 2) )).sum(:price)

    @a19_31sa_da = Date.new(2019, 8, 3).saturday?
    @a19_31sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8, 3)..Date.new(2019, 8, 3) )).sum(:price)
    @a19_31sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8, 3)..Date.new(2019, 8, 3) )).sum(:price)
    @a19_31sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8, 3)..Date.new(2019, 8, 3) )).sum(:price)
    # N° Subt A19-08 / W31
    @a19_31mv_08in= Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8, 1)..Date.new(2019, 8, 3) )).sum(:price)
    @a19_31mv_08eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8, 1)..Date.new(2019, 8, 3) )).sum(:price)
    @a19_31mv_08pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8, 1)..Date.new(2019, 8, 3) )).sum(:price)
    # A19-08 / W31
    @a19_31mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,28)..Date.new(2019, 8, 3) )).sum(:price)
    @a19_31mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,28)..Date.new(2019, 8, 3) )).sum(:price)
    @a19_31mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,28)..Date.new(2019, 8, 3) )).sum(:price)

    # A19-07 / W31
    @a19_31dm_da = Date.new(2019, 7,28).sunday?
    @a19_31dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,28)..Date.new(2019, 7,28) )).sum(:price)
    @a19_31dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,28)..Date.new(2019, 7,28) )).sum(:price)
    @a19_31dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,28)..Date.new(2019, 7,28) )).sum(:price)

    @a19_31ln_da = Date.new(2019, 7,29).monday?
    @a19_31ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,29)..Date.new(2019, 7,29) )).sum(:price)
    @a19_31ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,29)..Date.new(2019, 7,29) )).sum(:price)
    @a19_31ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,29)..Date.new(2019, 7,29) )).sum(:price)

    @a19_31ma_da = Date.new(2019, 7,30).tuesday?
    @a19_31ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,30)..Date.new(2019, 7,30) )).sum(:price)
    @a19_31ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,30)..Date.new(2019, 7,30) )).sum(:price)
    @a19_31ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,30)..Date.new(2019, 7,30) )).sum(:price)

    @a19_31mi_da = Date.new(2019, 7,31).wednesday?
    @a19_31mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,31)..Date.new(2019, 7,31) )).sum(:price)
    @a19_31mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,31)..Date.new(2019, 7,31) )).sum(:price)
    @a19_31mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,31)..Date.new(2019, 7,31) )).sum(:price)
    # A19-07 / W31
    @a19_31mv_07in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,28)..Date.new(2019, 7,31) )).sum(:price)
    @a19_31mv_07eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,28)..Date.new(2019, 7,31) )).sum(:price)
    @a19_31mv_07pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,28)..Date.new(2019, 7,31) )).sum(:price)

    # A19-07 / W30
    @a19_30dm_da = Date.new(2019, 7,21).sunday?
    @a19_30dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,21)..Date.new(2019, 7,21) )).sum(:price)
    @a19_30dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,21)..Date.new(2019, 7,21) )).sum(:price)
    @a19_30dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,21)..Date.new(2019, 7,21) )).sum(:price)

    @a19_30ln_da = Date.new(2019, 7,22).monday?
    @a19_30ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,22)..Date.new(2019, 7,22) )).sum(:price)
    @a19_30ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,22)..Date.new(2019, 7,22) )).sum(:price)
    @a19_30ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,22)..Date.new(2019, 7,22) )).sum(:price)

    @a19_30ma_da = Date.new(2019, 7,23).tuesday?
    @a19_30ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,23)..Date.new(2019, 7,23) )).sum(:price)
    @a19_30ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,23)..Date.new(2019, 7,23) )).sum(:price)
    @a19_30ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,23)..Date.new(2019, 7,23) )).sum(:price)

    @a19_30mi_da = Date.new(2019, 7,24).wednesday?
    @a19_30mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,24)..Date.new(2019, 7,24) )).sum(:price)
    @a19_30mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,24)..Date.new(2019, 7,24) )).sum(:price)
    @a19_30mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,24)..Date.new(2019, 7,24) )).sum(:price)

    @a19_30ju_da = Date.new(2019, 7,25).thursday?
    @a19_30ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,25)..Date.new(2019, 7,25) )).sum(:price)
    @a19_30ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,25)..Date.new(2019, 7,25) )).sum(:price)
    @a19_30ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,25)..Date.new(2019, 7,25) )).sum(:price)

    @a19_30vi_da = Date.new(2019, 7,26).friday?
    @a19_30vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,26)..Date.new(2019, 7,26) )).sum(:price)
    @a19_30vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,26)..Date.new(2019, 7,26) )).sum(:price)
    @a19_30vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,26)..Date.new(2019, 7,26) )).sum(:price)

    @a19_30sa_da = Date.new(2019, 7,27).saturday?
    @a19_30sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,27)..Date.new(2019, 7,27) )).sum(:price)
    @a19_30sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,27)..Date.new(2019, 7,27) )).sum(:price)
    @a19_30sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,27)..Date.new(2019, 7,27) )).sum(:price)
    # A19-07 / W30
    @a19_30mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,21)..Date.new(2019, 7,27) )).sum(:price)
    @a19_30mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,21)..Date.new(2019, 7,27) )).sum(:price)
    @a19_30mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,21)..Date.new(2019, 7,27) )).sum(:price)

    # A19-07 / W29
    @a19_29dm_da = Date.new(2019, 7,14).sunday?
    @a19_29dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,14)..Date.new(2019, 7,14) )).sum(:price)
    @a19_29dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,14)..Date.new(2019, 7,14) )).sum(:price)
    @a19_29dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,14)..Date.new(2019, 7,14) )).sum(:price)

    @a19_29ln_da = Date.new(2019, 7,15).monday?
    @a19_29ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,15)..Date.new(2019, 7,15) )).sum(:price)
    @a19_29ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,15)..Date.new(2019, 7,15) )).sum(:price)
    @a19_29ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,15)..Date.new(2019, 7,15) )).sum(:price)

    @a19_29ma_da = Date.new(2019, 7,16).tuesday?
    @a19_29ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,16)..Date.new(2019, 7,16) )).sum(:price)
    @a19_29ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,16)..Date.new(2019, 7,16) )).sum(:price)
    @a19_29ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,16)..Date.new(2019, 7,16) )).sum(:price)

    @a19_29mi_da = Date.new(2019, 7,17).wednesday?
    @a19_29mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,17)..Date.new(2019, 7,17) )).sum(:price)
    @a19_29mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,17)..Date.new(2019, 7,17) )).sum(:price)
    @a19_29mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,17)..Date.new(2019, 7,17) )).sum(:price)

    @a19_29ju_da = Date.new(2019, 7,18).thursday?
    @a19_29ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,18)..Date.new(2019, 7,18) )).sum(:price)
    @a19_29ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,18)..Date.new(2019, 7,18) )).sum(:price)
    @a19_29ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,18)..Date.new(2019, 7,18) )).sum(:price)

    @a19_29vi_da = Date.new(2019, 7,19).friday?
    @a19_29vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,19)..Date.new(2019, 7,19) )).sum(:price)
    @a19_29vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,19)..Date.new(2019, 7,19) )).sum(:price)
    @a19_29vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,19)..Date.new(2019, 7,19) )).sum(:price)

    @a19_29sa_da = Date.new(2019, 7,20).saturday?
    @a19_29sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,20)..Date.new(2019, 7,20) )).sum(:price)
    @a19_29sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,20)..Date.new(2019, 7,20) )).sum(:price)
    @a19_29sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,20)..Date.new(2019, 7,20) )).sum(:price)
    # A19-07 / W29
    @a19_29mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,14)..Date.new(2019, 7,20) )).sum(:price)
    @a19_29mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,14)..Date.new(2019, 7,20) )).sum(:price)
    @a19_29mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,14)..Date.new(2019, 7,20) )).sum(:price)

    # A19-07 / W28
    @a19_28dm_da = Date.new(2019, 7, 7).sunday?
    @a19_28dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7, 7)..Date.new(2019, 7, 7) )).sum(:price)
    @a19_28dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7, 7)..Date.new(2019, 7, 7) )).sum(:price)
    @a19_28dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7, 7)..Date.new(2019, 7, 7) )).sum(:price)

    @a19_28ln_da = Date.new(2019, 7, 8).monday?
    @a19_28ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7, 8)..Date.new(2019, 7, 8) )).sum(:price)
    @a19_28ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7, 8)..Date.new(2019, 7, 8) )).sum(:price)
    @a19_28ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7, 8)..Date.new(2019, 7, 8) )).sum(:price)

    @a19_28ma_da = Date.new(2019, 7, 9).tuesday?
    @a19_28ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7, 9)..Date.new(2019, 7, 9) )).sum(:price)
    @a19_28ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7, 9)..Date.new(2019, 7, 9) )).sum(:price)
    @a19_28ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7, 9)..Date.new(2019, 7, 9) )).sum(:price)

    @a19_28mi_da = Date.new(2019, 7,10).wednesday?
    @a19_28mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,10)..Date.new(2019, 7,10) )).sum(:price)
    @a19_28mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,10)..Date.new(2019, 7,10) )).sum(:price)
    @a19_28mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,10)..Date.new(2019, 7,10) )).sum(:price)

    @a19_28ju_da = Date.new(2019, 7,11).thursday?
    @a19_28ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,11)..Date.new(2019, 7,11) )).sum(:price)
    @a19_28ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,11)..Date.new(2019, 7,11) )).sum(:price)
    @a19_28ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,11)..Date.new(2019, 7,11) )).sum(:price)

    @a19_28vi_da = Date.new(2019, 7,12).friday?
    @a19_28vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,12)..Date.new(2019, 7,12) )).sum(:price)
    @a19_28vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,12)..Date.new(2019, 7,12) )).sum(:price)
    @a19_28vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,12)..Date.new(2019, 7,12) )).sum(:price)

    @a19_28sa_da = Date.new(2019, 7,13).saturday?
    @a19_28sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,13)..Date.new(2019, 7,13) )).sum(:price)
    @a19_28sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,13)..Date.new(2019, 7,13) )).sum(:price)
    @a19_28sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,13)..Date.new(2019, 7,13) )).sum(:price)
    # A19-07 / W28
    @a19_28mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7, 7)..Date.new(2019, 7,13) )).sum(:price)
    @a19_28mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7, 7)..Date.new(2019, 7,13) )).sum(:price)
    @a19_28mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7, 7)..Date.new(2019, 7,13) )).sum(:price)

    # A19-07 / W27
    @a19_27ln_da = Date.new(2019, 7, 1).monday?
    @a19_27ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7, 1)..Date.new(2019, 7, 1) )).sum(:price)
    @a19_27ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7, 1)..Date.new(2019, 7, 1) )).sum(:price)
    @a19_27ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7, 1)..Date.new(2019, 7, 1) )).sum(:price)

    @a19_27ma_da = Date.new(2019, 7, 2).tuesday?
    @a19_27ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7, 2)..Date.new(2019, 7, 2) )).sum(:price)
    @a19_27ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7, 2)..Date.new(2019, 7, 2) )).sum(:price)
    @a19_27ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7, 2)..Date.new(2019, 7, 2) )).sum(:price)

    @a19_27mi_da = Date.new(2019, 7, 3).wednesday?
    @a19_27mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7, 3)..Date.new(2019, 7, 3) )).sum(:price)
    @a19_27mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7, 3)..Date.new(2019, 7, 3) )).sum(:price)
    @a19_27mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7, 3)..Date.new(2019, 7, 3) )).sum(:price)

    @a19_27ju_da = Date.new(2019, 7, 4).thursday?
    @a19_27ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7, 4)..Date.new(2019, 7, 4) )).sum(:price)
    @a19_27ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7, 4)..Date.new(2019, 7, 4) )).sum(:price)
    @a19_27ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7, 4)..Date.new(2019, 7, 4) )).sum(:price)

    @a19_27vi_da = Date.new(2019, 7, 5).friday?
    @a19_27vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7, 5)..Date.new(2019, 7, 5) )).sum(:price)
    @a19_27vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7, 5)..Date.new(2019, 7, 5) )).sum(:price)
    @a19_27vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7, 5)..Date.new(2019, 7, 5) )).sum(:price)

    @a19_27sa_da = Date.new(2019, 7, 6).saturday?
    @a19_27sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7, 6)..Date.new(2019, 7, 6) )).sum(:price)
    @a19_27sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7, 6)..Date.new(2019, 7, 6) )).sum(:price)
    @a19_27sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7, 6)..Date.new(2019, 7, 6) )).sum(:price)
    # N° Subt A19-07 / W27
    @a19_27_07mv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7, 1)..Date.new(2019, 7, 6) )).sum(:price)
    @a19_27_07mv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7, 1)..Date.new(2019, 7, 6) )).sum(:price)
    @a19_27_07mv_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7, 1)..Date.new(2019, 7, 6) )).sum(:price)
    # A19-07 / W27
    @a19_27mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,30)..Date.new(2019, 7, 6) )).sum(:price)
    @a19_27mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,30)..Date.new(2019, 7, 6) )).sum(:price)
    @a19_27mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,30)..Date.new(2019, 7, 6) )).sum(:price)

    # ***  Junio 2019  ***
    # A19-06 / W27
    @a19_27dm_da = Date.new(2019, 6,30).sunday?
    @a19_27dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,30)..Date.new(2019, 6,30) )).sum(:price)
    @a19_27dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,30)..Date.new(2019, 6,30) )).sum(:price)
    @a19_27dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,30)..Date.new(2019, 6,30) )).sum(:price)
    # N° Subt A19-06 / W27
    @a19_27_06mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,30)..Date.new(2019, 6,30) )).sum(:price)
    @a19_27_06mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,30)..Date.new(2019, 6,30) )).sum(:price)
    @a19_27_06mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,30)..Date.new(2019, 6,30) )).sum(:price)

    # A19-06 / W26
    @a19_26dm_da = Date.new(2019, 6,23).sunday?
    @a19_26dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,23)..Date.new(2019, 6,23) )).sum(:price)
    @a19_26dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,23)..Date.new(2019, 6,23) )).sum(:price)
    @a19_26dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,23)..Date.new(2019, 6,23) )).sum(:price)

    @a19_26ln_da = Date.new(2019, 6,24).monday?
    @a19_26ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,24)..Date.new(2019, 6,24) )).sum(:price)
    @a19_26ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,24)..Date.new(2019, 6,24) )).sum(:price)
    @a19_26ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,24)..Date.new(2019, 6,24) )).sum(:price)

    @a19_26ma_da = Date.new(2019, 6,25).tuesday?
    @a19_26ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,25)..Date.new(2019, 6,25) )).sum(:price)
    @a19_26ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,25)..Date.new(2019, 6,25) )).sum(:price)
    @a19_26ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,25)..Date.new(2019, 6,25) )).sum(:price)

    @a19_26mi_da = Date.new(2019, 6,26).wednesday?
    @a19_26mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,26)..Date.new(2019, 6,26) )).sum(:price)
    @a19_26mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,26)..Date.new(2019, 6,26) )).sum(:price)
    @a19_26mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,26)..Date.new(2019, 6,26) )).sum(:price)

    @a19_26ju_da = Date.new(2019, 6,27).thursday?
    @a19_26ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,27)..Date.new(2019, 6,27) )).sum(:price)
    @a19_26ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,27)..Date.new(2019, 6,27) )).sum(:price)
    @a19_26ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,27)..Date.new(2019, 6,27) )).sum(:price)

    @a19_26vi_da = Date.new(2019, 6,28).friday?
    @a19_26vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,28)..Date.new(2019, 6,28) )).sum(:price)
    @a19_26vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,28)..Date.new(2019, 6,28) )).sum(:price)
    @a19_26vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,28)..Date.new(2019, 6,28) )).sum(:price)

    @a19_26sa_da = Date.new(2019, 6,29).saturday?
    @a19_26sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,29)..Date.new(2019, 6,29) )).sum(:price)
    @a19_26sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,29)..Date.new(2019, 6,29) )).sum(:price)
    @a19_26sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,29)..Date.new(2019, 6,29) )).sum(:price)
    # A19-06 / W26
    @a19_26mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,23)..Date.new(2019, 6,29) )).sum(:price)
    @a19_26mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,23)..Date.new(2019, 6,29) )).sum(:price)
    @a19_26mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,23)..Date.new(2019, 6,29) )).sum(:price)

    # A19-06 / W25
    @a19_25dm_da = Date.new(2019, 6,16).sunday?
    @a19_25dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,16)..Date.new(2019, 6,16) )).sum(:price)
    @a19_25dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,16)..Date.new(2019, 6,16) )).sum(:price)
    @a19_25dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,16)..Date.new(2019, 6,16) )).sum(:price)

    @a19_25ln_da = Date.new(2019, 6,17).monday?
    @a19_25ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,17)..Date.new(2019, 6,17) )).sum(:price)
    @a19_25ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,17)..Date.new(2019, 6,17) )).sum(:price)
    @a19_25ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,17)..Date.new(2019, 6,17) )).sum(:price)

    @a19_25ma_da = Date.new(2019, 6,18).tuesday?
    @a19_25ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,18)..Date.new(2019, 6,18) )).sum(:price)
    @a19_25ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,18)..Date.new(2019, 6,18) )).sum(:price)
    @a19_25ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,18)..Date.new(2019, 6,18) )).sum(:price)

    @a19_25mi_da = Date.new(2019, 6,19).wednesday?
    @a19_25mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,19)..Date.new(2019, 6,19) )).sum(:price)
    @a19_25mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,19)..Date.new(2019, 6,19) )).sum(:price)
    @a19_25mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,19)..Date.new(2019, 6,19) )).sum(:price)

    @a19_25ju_da = Date.new(2019, 6,20).thursday?
    @a19_25ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,20)..Date.new(2019, 6,20) )).sum(:price)
    @a19_25ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,20)..Date.new(2019, 6,20) )).sum(:price)
    @a19_25ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,20)..Date.new(2019, 6,20) )).sum(:price)

    @a19_25vi_da = Date.new(2019, 6,21).friday?
    @a19_25vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,21)..Date.new(2019, 6,21) )).sum(:price)
    @a19_25vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,21)..Date.new(2019, 6,21) )).sum(:price)
    @a19_25vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,21)..Date.new(2019, 6,21) )).sum(:price)

    @a19_25sa_da = Date.new(2019, 6,22).saturday?
    @a19_25sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,22)..Date.new(2019, 6,22) )).sum(:price)
    @a19_25sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,22)..Date.new(2019, 6,22) )).sum(:price)
    @a19_25sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,22)..Date.new(2019, 6,22) )).sum(:price)
    # A19-06 / W25
    @a19_25mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,16)..Date.new(2019, 6,22) )).sum(:price)
    @a19_25mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,16)..Date.new(2019, 6,22) )).sum(:price)
    @a19_25mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,16)..Date.new(2019, 6,22) )).sum(:price)

    # A19-06 / W24
    @a19_24dm_da = Date.new(2019, 6, 9).sunday?
    @a19_24dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6, 9)..Date.new(2019, 6, 9) )).sum(:price)
    @a19_24dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6, 9)..Date.new(2019, 6, 9) )).sum(:price)
    @a19_24dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6, 9)..Date.new(2019, 6, 9) )).sum(:price)

    @a19_24ln_da = Date.new(2019, 6,10).monday?
    @a19_24ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,10)..Date.new(2019, 6,10) )).sum(:price)
    @a19_24ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,10)..Date.new(2019, 6,10) )).sum(:price)
    @a19_24ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,10)..Date.new(2019, 6,10) )).sum(:price)

    @a19_24ma_da = Date.new(2019, 6,11).tuesday?
    @a19_24ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,11)..Date.new(2019, 6,11) )).sum(:price)
    @a19_24ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,11)..Date.new(2019, 6,11) )).sum(:price)
    @a19_24ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,11)..Date.new(2019, 6,11) )).sum(:price)

    @a19_24mi_da = Date.new(2019, 6,12).wednesday?
    @a19_24mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,12)..Date.new(2019, 6,12) )).sum(:price)
    @a19_24mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,12)..Date.new(2019, 6,12) )).sum(:price)
    @a19_24mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,12)..Date.new(2019, 6,12) )).sum(:price)

    @a19_24ju_da = Date.new(2019, 6,13).thursday?
    @a19_24ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,13)..Date.new(2019, 6,13) )).sum(:price)
    @a19_24ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,13)..Date.new(2019, 6,13) )).sum(:price)
    @a19_24ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,13)..Date.new(2019, 6,13) )).sum(:price)

    @a19_24vi_da = Date.new(2019, 6,14).friday?
    @a19_24vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,14)..Date.new(2019, 6,14) )).sum(:price)
    @a19_24vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,14)..Date.new(2019, 6,14) )).sum(:price)
    @a19_24vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,14)..Date.new(2019, 6,14) )).sum(:price)

    @a19_24sa_da = Date.new(2019, 6,15).saturday?
    @a19_24sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,15)..Date.new(2019, 6,15) )).sum(:price)
    @a19_24sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,15)..Date.new(2019, 6,15) )).sum(:price)
    @a19_24sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,15)..Date.new(2019, 6,15) )).sum(:price)
    # A19-06 / W24
    @a19_24mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6, 9)..Date.new(2019, 6,15) )).sum(:price)
    @a19_24mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6, 9)..Date.new(2019, 6,15) )).sum(:price)
    @a19_24mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6, 9)..Date.new(2019, 6,15) )).sum(:price)

    # A19-06 / W23
    @date_a19_23dm = Date.new(2019, 6, 2).sunday?
    @a19_23dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6, 2)..Date.new(2019, 6, 2) )).sum(:price)
    @a19_23dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6, 2)..Date.new(2019, 6, 2) )).sum(:price)
    @a19_23dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6, 2)..Date.new(2019, 6, 2) )).sum(:price)

    @a19_23ln_da = Date.new(2019, 6, 3).monday?
    @a19_23ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6, 3)..Date.new(2019, 6, 3) )).sum(:price)
    @a19_23ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6, 3)..Date.new(2019, 6, 3) )).sum(:price)
    @a19_23ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6, 3)..Date.new(2019, 6, 3) )).sum(:price)

    @a19_23ma_da = Date.new(2019, 6, 4).tuesday?
    @a19_23ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6, 4)..Date.new(2019, 6, 4) )).sum(:price)
    @a19_23ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6, 4)..Date.new(2019, 6, 4) )).sum(:price)
    @a19_23ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6, 4)..Date.new(2019, 6, 4) )).sum(:price)

    @a19_23mi_da = Date.new(2019, 6, 5).wednesday?
    @a19_23mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6, 5)..Date.new(2019, 6, 5) )).sum(:price)
    @a19_23mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6, 5)..Date.new(2019, 6, 5) )).sum(:price)
    @a19_23mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6, 5)..Date.new(2019, 6, 5) )).sum(:price)

    @a19_23ju_da = Date.new(2019, 6, 6).thursday?
    @a19_23ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6, 6)..Date.new(2019, 6, 6) )).sum(:price)
    @a19_23ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6, 6)..Date.new(2019, 6, 6) )).sum(:price)
    @a19_23ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6, 6)..Date.new(2019, 6, 6) )).sum(:price)

    @a19_23vi_da = Date.new(2019, 6, 7).friday?
    @a19_23vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6, 7)..Date.new(2019, 6, 7) )).sum(:price)
    @a19_23vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6, 7)..Date.new(2019, 6, 7) )).sum(:price)
    @a19_23vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6, 7)..Date.new(2019, 6, 7) )).sum(:price)

    @a19_23sa_da = Date.new(2019, 6, 8).saturday?
    @a19_23sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6, 8)..Date.new(2019, 6, 8) )).sum(:price)
    @a19_23sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6, 8)..Date.new(2019, 6, 8) )).sum(:price)
    @a19_23sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6, 8)..Date.new(2019, 6, 8) )).sum(:price)
    # A19-06 / W23
    @a19_23mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6, 2)..Date.new(2019, 6, 8) )).sum(:price)
    @a19_23mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6, 2)..Date.new(2019, 6, 8) )).sum(:price)
    @a19_23mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6, 2)..Date.new(2019, 6, 8) )).sum(:price)


    # A19-06 / W22
    @date_a19_22sa = Date.new(2019, 6, 1).saturday?
    @a19_22sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6, 1)..Date.new(2019, 6, 1) )).sum(:price)
    @a19_22sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6, 1)..Date.new(2019, 6, 1) )).sum(:price)
    @a19_22sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6, 1)..Date.new(2019, 6, 1) )).sum(:price)
    # A19-06 / W22
    @a19_22_06mv_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6, 1)..Date.new(2019, 6, 1) )).sum(:price)
    @a19_22_06mv_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6, 1)..Date.new(2019, 6, 1) )).sum(:price)
    @a19_22_06mv_pj=Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6, 1)..Date.new(2019, 6, 1) )).sum(:price)
    # A18-05/06 / W22
    @a19_22mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,26)..Date.new(2019, 6, 1) )).sum(:price)
    @a19_22mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,26)..Date.new(2019, 6, 1) )).sum(:price)
    @a19_22mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,26)..Date.new(2019, 6, 1) )).sum(:price)


    # A19-05 / W22
    @date_a19_22dm = Date.new(2019, 5,26).sunday?
    @a19_22dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,26)..Date.new(2019, 5,26) )).sum(:price)
    @a19_22dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,26)..Date.new(2019, 5,26) )).sum(:price)
    @a19_22dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,26)..Date.new(2019, 5,26) )).sum(:price)

    @date_a19_22ln = Date.new(2019, 5,27).monday?
    @a19_22ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,27)..Date.new(2019, 5,27) )).sum(:price)
    @a19_22ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,27)..Date.new(2019, 5,27) )).sum(:price)
    @a19_22ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,27)..Date.new(2019, 5,27) )).sum(:price)

    @date_a19_22ma = Date.new(2019, 5,28).tuesday?
    @a19_22ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,28)..Date.new(2019, 5,28) )).sum(:price)
    @a19_22ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,28)..Date.new(2019, 5,28) )).sum(:price)
    @a19_22ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,28)..Date.new(2019, 5,28) )).sum(:price)

    @date_a19_22mi = Date.new(2019, 5,29).wednesday?
    @a19_22mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,29)..Date.new(2019, 5,29) )).sum(:price)
    @a19_22mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,29)..Date.new(2019, 5,29) )).sum(:price)
    @a19_22mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,29)..Date.new(2019, 5,29) )).sum(:price)

    @date_a19_22ju = Date.new(2019, 5,30).thursday?
    @a19_22ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,30)..Date.new(2019, 5,30) )).sum(:price)
    @a19_22ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,30)..Date.new(2019, 5,30) )).sum(:price)
    @a19_22ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,30)..Date.new(2019, 5,30) )).sum(:price)

    @date_a19_22vi = Date.new(2019, 5,31).friday?
    @a19_22vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,31)..Date.new(2019, 5,31) )).sum(:price)
    @a19_22vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,31)..Date.new(2019, 5,31) )).sum(:price)
    @a19_22vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,31)..Date.new(2019, 5,31) )).sum(:price)
    # A19-05 / W22
    @a19_22_05mv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,26)..Date.new(2019, 5,31) )).sum(:price)
    @a19_22_05mv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,26)..Date.new(2019, 5,31) )).sum(:price)
    @a19_22_05mv_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,26)..Date.new(2019, 5,31) )).sum(:price)


    # A19-05 / W21
    @date_a19_21dm = Date.new(2019, 5,19).sunday?
    @a19_21dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,19)..Date.new(2019, 5,19) )).sum(:price)
    @a19_21dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,19)..Date.new(2019, 5,19) )).sum(:price)
    @a19_21dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,19)..Date.new(2019, 5,19) )).sum(:price)

    @date_a19_21ln = Date.new(2019, 5,20).monday?
    @a19_21ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,20)..Date.new(2019, 5,20) )).sum(:price)
    @a19_21ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,20)..Date.new(2019, 5,20) )).sum(:price)
    @a19_21ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,20)..Date.new(2019, 5,20) )).sum(:price)

    @date_a19_21ma = Date.new(2019, 5,21).tuesday?
    @a19_21ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,21)..Date.new(2019, 5,21) )).sum(:price)
    @a19_21ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,21)..Date.new(2019, 5,21) )).sum(:price)
    @a19_21ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,21)..Date.new(2019, 5,21) )).sum(:price)

    @date_a19_21mi = Date.new(2019, 5,22).wednesday?
    @a19_21mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,22)..Date.new(2019, 5,22) )).sum(:price)
    @a19_21mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,22)..Date.new(2019, 5,22) )).sum(:price)
    @a19_21mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,22)..Date.new(2019, 5,22) )).sum(:price)

    @date_a19_21ju = Date.new(2019, 5,23).thursday?
    @a19_21ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,23)..Date.new(2019, 5,23) )).sum(:price)
    @a19_21ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,23)..Date.new(2019, 5,23) )).sum(:price)
    @a19_21ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,23)..Date.new(2019, 5,23) )).sum(:price)

    @date_a19_21vi = Date.new(2019, 5,24).friday?
    @a19_21vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,24)..Date.new(2019, 5,24) )).sum(:price)
    @a19_21vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,24)..Date.new(2019, 5,24) )).sum(:price)
    @a19_21vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,24)..Date.new(2019, 5,24) )).sum(:price)

    @date_a19_21sa = Date.new(2019, 5,25).saturday?
    @a19_21sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,25)..Date.new(2019, 5,25) )).sum(:price)
    @a19_21sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,25)..Date.new(2019, 5,25) )).sum(:price)
    @a19_21sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,25)..Date.new(2019, 5,25) )).sum(:price)
    # A19-05 / W21
    @a19_21mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,19)..Date.new(2019, 5,25) )).sum(:price)
    @a19_21mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,19)..Date.new(2019, 5,25) )).sum(:price)
    @a19_21mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,19)..Date.new(2019, 5,25) )).sum(:price)

    # A19-05 / W20
    @date_a19_20dm = Date.new(2019, 5,12).sunday?
    @a19_20dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,12)..Date.new(2019, 5,12) )).sum(:price)
    @a19_20dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,12)..Date.new(2019, 5,12) )).sum(:price)
    @a19_20dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,12)..Date.new(2019, 5,12) )).sum(:price)

    @date_a19_20ln = Date.new(2019, 5,13).monday?
    @a19_20ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,13)..Date.new(2019, 5,13) )).sum(:price)
    @a19_20ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,13)..Date.new(2019, 5,13) )).sum(:price)
    @a19_20ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,13)..Date.new(2019, 5,13) )).sum(:price)

    @date_a19_20ma = Date.new(2019, 5,14).tuesday?
    @a19_20ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,14)..Date.new(2019, 5,14) )).sum(:price)
    @a19_20ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,14)..Date.new(2019, 5,14) )).sum(:price)
    @a19_20ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,14)..Date.new(2019, 5,14) )).sum(:price)

    @date_a19_20mi = Date.new(2019, 5,15).wednesday?
    @a19_20mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,15)..Date.new(2019, 5,15) )).sum(:price)
    @a19_20mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,15)..Date.new(2019, 5,15) )).sum(:price)
    @a19_20mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,15)..Date.new(2019, 5,15) )).sum(:price)

    @date_a19_20ju = Date.new(2019, 5,16).thursday?
    @a19_20ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,16)..Date.new(2019, 5,16) )).sum(:price)
    @a19_20ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,16)..Date.new(2019, 5,16) )).sum(:price)
    @a19_20ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,16)..Date.new(2019, 5,16) )).sum(:price)

    @date_a19_20vi = Date.new(2019, 5,17).friday?
    @a19_20vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,17)..Date.new(2019, 5,17) )).sum(:price)
    @a19_20vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,17)..Date.new(2019, 5,17) )).sum(:price)
    @a19_20vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,17)..Date.new(2019, 5,17) )).sum(:price)

    @date_a19_20sa = Date.new(2019, 5,18).saturday?
    @a19_20sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,18)..Date.new(2019, 5,18) )).sum(:price)
    @a19_20sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,18)..Date.new(2019, 5,18) )).sum(:price)
    @a19_20sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,18)..Date.new(2019, 5,18) )).sum(:price)
    # A19-05 / W20
    @a19_20mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,12)..Date.new(2019, 5,18) )).sum(:price)
    @a19_20mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,12)..Date.new(2019, 5,18) )).sum(:price)
    @a19_20mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,12)..Date.new(2019, 5,18) )).sum(:price)

    # A19-05 / W19
    @date_a19_19dm = Date.new(2019, 5, 5).sunday?
    @a19_19dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5, 5)..Date.new(2019, 5, 5) )).sum(:price)
    @a19_19dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5, 5)..Date.new(2019, 5, 5) )).sum(:price)
    @a19_19dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5, 5)..Date.new(2019, 5, 5) )).sum(:price)

    @date_a19_19ln = Date.new(2019, 5, 6).monday?
    @a19_19ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5, 6)..Date.new(2019, 5, 6) )).sum(:price)
    @a19_19ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5, 6)..Date.new(2019, 5, 6) )).sum(:price)
    @a19_19ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5, 6)..Date.new(2019, 5, 6) )).sum(:price)

    @date_a19_19ma = Date.new(2019, 5, 7).tuesday?
    @a19_19ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5, 7)..Date.new(2019, 5, 7) )).sum(:price)
    @a19_19ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5, 7)..Date.new(2019, 5, 7) )).sum(:price)
    @a19_19ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5, 7)..Date.new(2019, 5, 7) )).sum(:price)

    @date_a19_19mi = Date.new(2019, 5, 8).wednesday?
    @a19_19mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5, 8)..Date.new(2019, 5, 8) )).sum(:price)
    @a19_19mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5, 8)..Date.new(2019, 5, 8) )).sum(:price)
    @a19_19mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5, 8)..Date.new(2019, 5, 8) )).sum(:price)

    @date_a19_19ju = Date.new(2019, 5, 9).thursday?
    @a19_19ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5, 9)..Date.new(2019, 5, 9) )).sum(:price)
    @a19_19ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5, 9)..Date.new(2019, 5, 9) )).sum(:price)
    @a19_19ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5, 9)..Date.new(2019, 5, 9) )).sum(:price)

    @date_a19_19vi = Date.new(2019, 5,10).friday?
    @a19_19vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,10)..Date.new(2019, 5,10) )).sum(:price)
    @a19_19vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,10)..Date.new(2019, 5,10) )).sum(:price)
    @a19_19vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,10)..Date.new(2019, 5,10) )).sum(:price)

    @date_a19_19sa = Date.new(2019, 5,11).saturday?
    @a19_19sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,11)..Date.new(2019, 5,11) )).sum(:price)
    @a19_19sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,11)..Date.new(2019, 5,11) )).sum(:price)
    @a19_19sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,11)..Date.new(2019, 5,11) )).sum(:price)
    # A19-05 / W19
    @a19_19mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5, 5)..Date.new(2019, 5,11) )).sum(:price)
    @a19_19mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5, 5)..Date.new(2019, 5,11) )).sum(:price)
    @a19_19mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5, 5)..Date.new(2019, 5,11) )).sum(:price)

# --
    # A19_18 - mayo
    @a19_18mi_da = Date.new(2019, 5, 1).wednesday?
    @a19_18mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5, 1)..Date.new(2019, 5, 1) )).sum(:price)
    @a19_18mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5, 1)..Date.new(2019, 5, 1) )).sum(:price)
    @a19_18mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5, 1)..Date.new(2019, 5, 1) )).sum(:price)

    @a19_18ju_da = Date.new(2019, 5, 2).thursday?
    @a19_18ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5, 2)..Date.new(2019, 5, 2) )).sum(:price)
    @a19_18ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5, 2)..Date.new(2019, 5, 2) )).sum(:price)
    @a19_18ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5, 2)..Date.new(2019, 5, 2) )).sum(:price)

    @a19_18vi_da = Date.new(2019, 5, 3).friday?
    @a19_18vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5, 3)..Date.new(2019, 5, 3) )).sum(:price)
    @a19_18vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5, 3)..Date.new(2019, 5, 3) )).sum(:price)
    @a19_18vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5, 3)..Date.new(2019, 5, 3) )).sum(:price)

    @a19_18sa_da = Date.new(2019, 5, 4).saturday?
    @a19_18sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5, 4)..Date.new(2019, 5, 4) )).sum(:price)
    @a19_18sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5, 4)..Date.new(2019, 5, 4) )).sum(:price)
    @a19_18sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5, 4)..Date.new(2019, 5, 4) )).sum(:price)
    # A19_18 - Mayo
    @a19_18_05mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5, 1)..Date.new(2019, 5, 4) )).sum(:price)
    @a19_18_05mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5, 1)..Date.new(2019, 5, 4) )).sum(:price)
    @a19_18_05mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5, 1)..Date.new(2019, 5, 4) )).sum(:price)
    # A19_18 - Abril/Mayo
    @a19_18mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,28)..Date.new(2019, 5, 4) )).sum(:price)
    @a19_18mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,28)..Date.new(2019, 5, 4) )).sum(:price)
    @a19_18mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,28)..Date.new(2019, 5, 4) )).sum(:price)


    # A19_18 - abril
    @a19_18dm_da = Date.new(2019, 4,28).sunday?
    @a19_18dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,28)..Date.new(2019, 4,28) )).sum(:price)
    @a19_18dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,28)..Date.new(2019, 4,28) )).sum(:price)
    @a19_18dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,28)..Date.new(2019, 4,28) )).sum(:price)

    @a19_18ln_da = Date.new(2019, 4,29).monday?
    @a19_18ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,29)..Date.new(2019, 4,29) )).sum(:price)
    @a19_18ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,29)..Date.new(2019, 4,29) )).sum(:price)
    @a19_18ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,29)..Date.new(2019, 4,29) )).sum(:price)

    @a19_18ma_da = Date.new(2019, 4,30).tuesday?
    @a19_18ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,30)..Date.new(2019, 4,30) )).sum(:price)
    @a19_18ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,30)..Date.new(2019, 4,30) )).sum(:price)
    @a19_18ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,30)..Date.new(2019, 4,30) )).sum(:price)
    # A19_18 - Abril
    @a19_18_04mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,28)..Date.new(2019, 4,30) )).sum(:price)
    @a19_18_04mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,28)..Date.new(2019, 4,30) )).sum(:price)
    @a19_18_04mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,28)..Date.new(2019, 4,30) )).sum(:price)


    # A19_17 - Abril
    @a19_17dm_da = Date.new(2019, 4,21).sunday?
    @a19_17dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,21)..Date.new(2019, 4,21) )).sum(:price)
    @a19_17dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,21)..Date.new(2019, 4,21) )).sum(:price)
    @a19_17dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,21)..Date.new(2019, 4,21) )).sum(:price)

    @a19_17ln_da = Date.new(2019, 4,22).monday?
    @a19_17ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,22)..Date.new(2019, 4,22) )).sum(:price)
    @a19_17ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,22)..Date.new(2019, 4,22) )).sum(:price)
    @a19_17ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,22)..Date.new(2019, 4,22) )).sum(:price)

    @a19_17ma_da = Date.new(2019, 4,23).tuesday?
    @a19_17ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,23)..Date.new(2019, 4,23) )).sum(:price)
    @a19_17ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,23)..Date.new(2019, 4,23) )).sum(:price)
    @a19_17ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,23)..Date.new(2019, 4,23) )).sum(:price)

    @a19_17mi_da = Date.new(2019, 4,24).wednesday?
    @a19_17mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,24)..Date.new(2019, 4,24) )).sum(:price)
    @a19_17mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,24)..Date.new(2019, 4,24) )).sum(:price)
    @a19_17mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,24)..Date.new(2019, 4,24) )).sum(:price)

    @a19_17ju_da = Date.new(2019, 4,25).thursday?
    @a19_17ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,25)..Date.new(2019, 4,25) )).sum(:price)
    @a19_17ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,25)..Date.new(2019, 4,25) )).sum(:price)
    @a19_17ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,25)..Date.new(2019, 4,25) )).sum(:price)

    @a19_17vi_da = Date.new(2019, 4,26).friday?
    @a19_17vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,26)..Date.new(2019, 4,26) )).sum(:price)
    @a19_17vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,26)..Date.new(2019, 4,26) )).sum(:price)
    @a19_17vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,26)..Date.new(2019, 4,26) )).sum(:price)

    @a19_17sa_da = Date.new(2019, 4,27).saturday?
    @a19_17sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,27)..Date.new(2019, 4,27) )).sum(:price)
    @a19_17sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,27)..Date.new(2019, 4,27) )).sum(:price)
    @a19_17sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,27)..Date.new(2019, 4,27) )).sum(:price)
    # A19_17 - Abril
    @a19_17mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,21)..Date.new(2019, 4,27) )).sum(:price)
    @a19_17mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,21)..Date.new(2019, 4,27) )).sum(:price)
    @a19_17mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,21)..Date.new(2019, 4,27) )).sum(:price)


    # A19_16 - Abril
    @a19_16dm_da = Date.new(2019, 4,14).sunday?
    @a19_16dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,14)..Date.new(2019, 4,14) )).sum(:price)
    @a19_16dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,14)..Date.new(2019, 4,14) )).sum(:price)
    @a19_16dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,14)..Date.new(2019, 4,14) )).sum(:price)

    @a19_16ln_da = Date.new(2019, 4,15).monday?
    @a19_16ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,15)..Date.new(2019, 4,15) )).sum(:price)
    @a19_16ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,15)..Date.new(2019, 4,15) )).sum(:price)
    @a19_16ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,15)..Date.new(2019, 4,15) )).sum(:price)

    @a19_16ma_da = Date.new(2019, 4,16).tuesday?
    @a19_16ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,16)..Date.new(2019, 4,16) )).sum(:price)
    @a19_16ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,16)..Date.new(2019, 4,16) )).sum(:price)
    @a19_16ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,16)..Date.new(2019, 4,16) )).sum(:price)

    @a19_16mi_da = Date.new(2019, 4,17).wednesday?
    @a19_16mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,17)..Date.new(2019, 4,17) )).sum(:price)
    @a19_16mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,17)..Date.new(2019, 4,17) )).sum(:price)
    @a19_16mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,17)..Date.new(2019, 4,17) )).sum(:price)

    @a19_16ju_da = Date.new(2019, 4,18).thursday?
    @a19_16ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,18)..Date.new(2019, 4,18) )).sum(:price)
    @a19_16ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,18)..Date.new(2019, 4,18) )).sum(:price)
    @a19_16ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,18)..Date.new(2019, 4,18) )).sum(:price)

    @a19_16vi_da = Date.new(2019, 4,19).friday?
    @a19_16vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,19)..Date.new(2019, 4,19) )).sum(:price)
    @a19_16vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,19)..Date.new(2019, 4,19) )).sum(:price)
    @a19_16vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,19)..Date.new(2019, 4,19) )).sum(:price)

    @a19_16sa_da = Date.new(2019, 4,20).saturday?
    @a19_16sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,20)..Date.new(2019, 4,20) )).sum(:price)
    @a19_16sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,20)..Date.new(2019, 4,20) )).sum(:price)
    @a19_16sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,20)..Date.new(2019, 4,20) )).sum(:price)
    # A19_16 - Abril
    @a19_16mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,14)..Date.new(2019, 4,20) )).sum(:price)
    @a19_16mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,14)..Date.new(2019, 4,20) )).sum(:price)
    @a19_16mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,14)..Date.new(2019, 4,20) )).sum(:price)


    # A19_15 - Abril
    @a19_15dm_da = Date.new(2019, 4, 7).sunday?
    @a19_15dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4, 7)..Date.new(2019, 4, 7) )).sum(:price)
    @a19_15dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4, 7)..Date.new(2019, 4, 7) )).sum(:price)
    @a19_15dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4, 7)..Date.new(2019, 4, 7) )).sum(:price)

    @a19_15ln_da = Date.new(2019, 4, 8).monday?
    @a19_15ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4, 8)..Date.new(2019, 4, 8) )).sum(:price)
    @a19_15ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4, 8)..Date.new(2019, 4, 8) )).sum(:price)
    @a19_15ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4, 8)..Date.new(2019, 4, 8) )).sum(:price)

    @a19_15ma_da = Date.new(2019, 4, 9).tuesday?
    @a19_15ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4, 9)..Date.new(2019, 4, 9) )).sum(:price)
    @a19_15ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4, 9)..Date.new(2019, 4, 9) )).sum(:price)
    @a19_15ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4, 9)..Date.new(2019, 4, 9) )).sum(:price)

    @a19_15mi_da = Date.new(2019, 4,10).wednesday?
    @a19_15mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,10)..Date.new(2019, 4,10) )).sum(:price)
    @a19_15mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,10)..Date.new(2019, 4,10) )).sum(:price)
    @a19_15mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,10)..Date.new(2019, 4,10) )).sum(:price)

    @a19_15ju_da = Date.new(2019, 4,11).thursday?
    @a19_15ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,11)..Date.new(2019, 4,11) )).sum(:price)
    @a19_15ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,11)..Date.new(2019, 4,11) )).sum(:price)
    @a19_15ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,11)..Date.new(2019, 4,11) )).sum(:price)

    @a19_15vi_da = Date.new(2019, 4,12).friday?
    @a19_15vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,12)..Date.new(2019, 4,12) )).sum(:price)
    @a19_15vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,12)..Date.new(2019, 4,12) )).sum(:price)
    @a19_15vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,12)..Date.new(2019, 4,12) )).sum(:price)

    @a19_15sa_da = Date.new(2019, 4,13).saturday?
    @a19_15sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,13)..Date.new(2019, 4,13) )).sum(:price)
    @a19_15sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,13)..Date.new(2019, 4,13) )).sum(:price)
    @a19_15sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,13)..Date.new(2019, 4,13) )).sum(:price)
    # A19_15 - Abril
    @a19_15mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4, 7)..Date.new(2019, 4,13) )).sum(:price)
    @a19_15mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4, 7)..Date.new(2019, 4,13) )).sum(:price)
    @a19_15mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4, 7)..Date.new(2019, 4,13) )).sum(:price)

    # A19_14 - Abril
    @a19_14ln_da = Date.new(2019, 4, 1).monday?
    @a19_14ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4, 1)..Date.new(2019, 4, 1) )).sum(:price)
    @a19_14ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4, 1)..Date.new(2019, 4, 1) )).sum(:price)
    @a19_14ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4, 1)..Date.new(2019, 4, 1) )).sum(:price)

    @a19_14ma_da = Date.new(2019, 4, 2).tuesday?
    @a19_14ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4, 2)..Date.new(2019, 4, 2) )).sum(:price)
    @a19_14ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4, 2)..Date.new(2019, 4, 2) )).sum(:price)
    @a19_14ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4, 2)..Date.new(2019, 4, 2) )).sum(:price)

    @a19_14mi_da = Date.new(2019, 4, 3).wednesday?
    @a19_14mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4, 3)..Date.new(2019, 4, 3) )).sum(:price)
    @a19_14mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4, 3)..Date.new(2019, 4, 3) )).sum(:price)
    @a19_14mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4, 3)..Date.new(2019, 4, 3) )).sum(:price)

    @a19_14ju_da = Date.new(2019, 4, 4).thursday?
    @a19_14ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4, 4)..Date.new(2019, 4, 4) )).sum(:price)
    @a19_14ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4, 4)..Date.new(2019, 4, 4) )).sum(:price)
    @a19_14ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4, 4)..Date.new(2019, 4, 4) )).sum(:price)

    @a19_14vi_da = Date.new(2019, 4, 5).friday?
    @a19_14vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4, 5)..Date.new(2019, 4, 5) )).sum(:price)
    @a19_14vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4, 5)..Date.new(2019, 4, 5) )).sum(:price)
    @a19_14vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4, 5)..Date.new(2019, 4, 5) )).sum(:price)

    @a19_14sa_da = Date.new(2019, 4, 6).saturday?
    @a19_14sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4, 6)..Date.new(2019, 4, 6) )).sum(:price)
    @a19_14sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4, 6)..Date.new(2019, 4, 6) )).sum(:price)
    @a19_14sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4, 6)..Date.new(2019, 4, 6) )).sum(:price)
    # A19_14 - Abril
    @a19_14_04mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4, 1)..Date.new(2019, 4, 6) )).sum(:price)
    @a19_14_04mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4, 1)..Date.new(2019, 4, 6) )).sum(:price)
    @a19_14_04mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4, 1)..Date.new(2019, 4, 6) )).sum(:price)
    # A19_14 - Mar/Abr
    @a19_14mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,31)..Date.new(2019, 4, 6) )).sum(:price)
    @a19_14mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,31)..Date.new(2019, 4, 6) )).sum(:price)
    @a19_14mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,31)..Date.new(2019, 4, 6) )).sum(:price)


    # A19_14 - Marzo
    @a19_14dm_da = Date.new(2019, 3,31).sunday?
    @a19_14dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,31)..Date.new(2019, 3,31) )).sum(:price)
    @a19_14dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,31)..Date.new(2019, 3,31) )).sum(:price)
    @a19_14dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,31)..Date.new(2019, 3,31) )).sum(:price)
    # A19_14 - Marzo
    @a19_14_03mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,31)..Date.new(2019, 3,31) )).sum(:price)
    @a19_14_03mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,31)..Date.new(2019, 3,31) )).sum(:price)
    @a19_14_03mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,31)..Date.new(2019, 3,31) )).sum(:price)

    # A19_13 - Marzo
    @a19_13dm_da = Date.new(2019, 3,24).sunday?
    @a19_13dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,24)..Date.new(2019, 3,24) )).sum(:price)
    @a19_13dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,24)..Date.new(2019, 3,24) )).sum(:price)
    @a19_13dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,24)..Date.new(2019, 3,24) )).sum(:price)

    @a19_13ln_da = Date.new(2019, 3,25).monday?
    @a19_13ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,25)..Date.new(2019, 3,25) )).sum(:price)
    @a19_13ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,25)..Date.new(2019, 3,25) )).sum(:price)
    @a19_13ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,25)..Date.new(2019, 3,25) )).sum(:price)

    @a19_13ma_da = Date.new(2019, 3,26).tuesday?
    @a19_13ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,26)..Date.new(2019, 3,26) )).sum(:price)
    @a19_13ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,26)..Date.new(2019, 3,26) )).sum(:price)
    @a19_13ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,26)..Date.new(2019, 3,26) )).sum(:price)

    @a19_13mi_da = Date.new(2019, 3,27).wednesday?
    @a19_13mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,27)..Date.new(2019, 3,27) )).sum(:price)
    @a19_13mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,27)..Date.new(2019, 3,27) )).sum(:price)
    @a19_13mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,27)..Date.new(2019, 3,27) )).sum(:price)

    @a19_13ju_da = Date.new(2019, 3,28).thursday?
    @a19_13ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,28)..Date.new(2019, 3,28) )).sum(:price)
    @a19_13ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,28)..Date.new(2019, 3,28) )).sum(:price)
    @a19_13ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,28)..Date.new(2019, 3,28) )).sum(:price)

    @a19_13vi_da = Date.new(2019, 3,29).friday?
    @a19_13vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,29)..Date.new(2019, 3,29) )).sum(:price)
    @a19_13vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,29)..Date.new(2019, 3,29) )).sum(:price)
    @a19_13vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,29)..Date.new(2019, 3,29) )).sum(:price)

    @a19_13sa_da = Date.new(2019, 3,30).saturday?
    @a19_13sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,30)..Date.new(2019, 3,30) )).sum(:price)
    @a19_13sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,30)..Date.new(2019, 3,30) )).sum(:price)
    @a19_13sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,30)..Date.new(2019, 3,30) )).sum(:price)
    # A19_13 - Marzo
    @a19_13mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,24)..Date.new(2019, 3,30) )).sum(:price)
    @a19_13mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,24)..Date.new(2019, 3,30) )).sum(:price)
    @a19_13mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,24)..Date.new(2019, 3,30) )).sum(:price)


    # A19_12 - Marzo
    @a19_12dm_da = Date.new(2019, 3,17).sunday?
    @a19_12dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,17)..Date.new(2019, 3,17) )).sum(:price)
    @a19_12dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,17)..Date.new(2019, 3,17) )).sum(:price)
    @a19_12dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,17)..Date.new(2019, 3,17) )).sum(:price)

    @a19_12ln_da = Date.new(2019, 3,18).monday?
    @a19_12ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,18)..Date.new(2019, 3,18) )).sum(:price)
    @a19_12ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,18)..Date.new(2019, 3,18) )).sum(:price)
    @a19_12ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,18)..Date.new(2019, 3,18) )).sum(:price)

    @a19_12ma_da = Date.new(2019, 3,19).tuesday?
    @a19_12ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,19)..Date.new(2019, 3,19) )).sum(:price)
    @a19_12ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,19)..Date.new(2019, 3,19) )).sum(:price)
    @a19_12ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,19)..Date.new(2019, 3,19) )).sum(:price)

    @a19_12mi_da = Date.new(2019, 3,20).wednesday?
    @a19_12mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,20)..Date.new(2019, 3,20) )).sum(:price)
    @a19_12mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,20)..Date.new(2019, 3,20) )).sum(:price)
    @a19_12mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,20)..Date.new(2019, 3,20) )).sum(:price)

    @a19_12ju_da = Date.new(2019, 3,21).thursday?
    @a19_12ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,21)..Date.new(2019, 3,21) )).sum(:price)
    @a19_12ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,21)..Date.new(2019, 3,21) )).sum(:price)
    @a19_12ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,21)..Date.new(2019, 3,21) )).sum(:price)

    @a19_12vi_da = Date.new(2019, 3,22).friday?
    @a19_12vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,22)..Date.new(2019, 3,22) )).sum(:price)
    @a19_12vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,22)..Date.new(2019, 3,22) )).sum(:price)
    @a19_12vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,22)..Date.new(2019, 3,22) )).sum(:price)

    @a19_12sa_da = Date.new(2019, 3,23).saturday?
    @a19_12sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,23)..Date.new(2019, 3,23) )).sum(:price)
    @a19_12sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,23)..Date.new(2019, 3,23) )).sum(:price)
    @a19_12sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,23)..Date.new(2019, 3,23) )).sum(:price)
    # A19_12 - Marzo
    @a19_12mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,17)..Date.new(2019, 3,23) )).sum(:price)
    @a19_12mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,17)..Date.new(2019, 3,23) )).sum(:price)
    @a19_12mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,17)..Date.new(2019, 3,23) )).sum(:price)


    # A19_11 - Marzo
    @a19_11dm_da = Date.new(2019, 3,10).sunday?
    @a19_11dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,10)..Date.new(2019, 3,10) )).sum(:price)
    @a19_11dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,10)..Date.new(2019, 3,10) )).sum(:price)
    @a19_11dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,10)..Date.new(2019, 3,10) )).sum(:price)

    @a19_11ln_da = Date.new(2019, 3,11).monday?
    @a19_11ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,11)..Date.new(2019, 3,11) )).sum(:price)
    @a19_11ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,11)..Date.new(2019, 3,11) )).sum(:price)
    @a19_11ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,11)..Date.new(2019, 3,11) )).sum(:price)

    @a19_11ma_da = Date.new(2019, 3,12).tuesday?
    @a19_11ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,12)..Date.new(2019, 3,12) )).sum(:price)
    @a19_11ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,12)..Date.new(2019, 3,12) )).sum(:price)
    @a19_11ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,12)..Date.new(2019, 3,12) )).sum(:price)

    @a19_11mi_da = Date.new(2019, 3,13).wednesday?
    @a19_11mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,12)..Date.new(2019, 3,16) )).sum(:price)
    @a19_11mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,12)..Date.new(2019, 3,16) )).sum(:price)
    @a19_11mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,12)..Date.new(2019, 3,16) )).sum(:price)

    @a19_11ju_da = Date.new(2019, 3,14).thursday?
    @a19_11ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,14)..Date.new(2019, 3,14) )).sum(:price)
    @a19_11ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,14)..Date.new(2019, 3,14) )).sum(:price)
    @a19_11ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,14)..Date.new(2019, 3,14) )).sum(:price)

    @a19_11vi_da = Date.new(2019, 3,15).friday?
    @a19_11vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,15)..Date.new(2019, 3,15) )).sum(:price)
    @a19_11vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,15)..Date.new(2019, 3,15) )).sum(:price)
    @a19_11vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,15)..Date.new(2019, 3,15) )).sum(:price)

    @a19_11sa_da = Date.new(2019, 3,16).saturday?
    @a19_11sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,16)..Date.new(2019, 3,16) )).sum(:price)
    @a19_11sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,16)..Date.new(2019, 3,16) )).sum(:price)
    @a19_11sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,16)..Date.new(2019, 3,16) )).sum(:price)
    # A19_11 - Marzo
    @a19_11mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,10)..Date.new(2019, 3,16) )).sum(:price)
    @a19_11mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,10)..Date.new(2019, 3,16) )).sum(:price)
    @a19_11mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,10)..Date.new(2019, 3,16) )).sum(:price)


    # A19_10 - Marzo
    @a19_10dm_da = Date.new(2019, 3, 3).sunday?
    @a19_10dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3, 3)..Date.new(2019, 3, 3) )).sum(:price)
    @a19_10dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3, 3)..Date.new(2019, 3, 3) )).sum(:price)
    @a19_10dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3, 3)..Date.new(2019, 3, 3) )).sum(:price)

    @a19_10ln_da = Date.new(2019, 3, 4).monday?
    @a19_10ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3, 4)..Date.new(2019, 3, 4) )).sum(:price)
    @a19_10ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3, 4)..Date.new(2019, 3, 4) )).sum(:price)
    @a19_10ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3, 4)..Date.new(2019, 3, 4) )).sum(:price)

    @a19_10ma_da = Date.new(2019, 3, 5).tuesday?
    @a19_10ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3, 5)..Date.new(2019, 3, 5) )).sum(:price)
    @a19_10ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3, 5)..Date.new(2019, 3, 5) )).sum(:price)
    @a19_10ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3, 5)..Date.new(2019, 3, 5) )).sum(:price)

    @a19_10mi_da = Date.new(2019, 3, 6).wednesday?
    @a19_10mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3, 6)..Date.new(2019, 3, 6) )).sum(:price)
    @a19_10mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3, 6)..Date.new(2019, 3, 6) )).sum(:price)
    @a19_10mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3, 6)..Date.new(2019, 3, 6) )).sum(:price)

    @a19_10ju_da = Date.new(2019, 3, 7).thursday?
    @a19_10ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3, 7)..Date.new(2019, 3, 7) )).sum(:price)
    @a19_10ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3, 7)..Date.new(2019, 3, 7) )).sum(:price)
    @a19_10ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3, 7)..Date.new(2019, 3, 7) )).sum(:price)

    @a19_10vi_da = Date.new(2019, 3, 8).friday?
    @a19_10vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3, 8)..Date.new(2019, 3, 8) )).sum(:price)
    @a19_10vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3, 8)..Date.new(2019, 3, 8) )).sum(:price)
    @a19_10vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3, 8)..Date.new(2019, 3, 8) )).sum(:price)

    @a19_10sa_da = Date.new(2019, 3, 9).saturday?
    @a19_10sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3, 9)..Date.new(2019, 3, 9) )).sum(:price)
    @a19_10sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3, 9)..Date.new(2019, 3, 9) )).sum(:price)
    @a19_10sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3, 9)..Date.new(2019, 3, 9) )).sum(:price)
    # A19_10 - Marzo
    @a19_10mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3, 3)..Date.new(2019, 3, 9) )).sum(:price)
    @a19_10mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3, 3)..Date.new(2019, 3, 9) )).sum(:price)
    @a19_10mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3, 3)..Date.new(2019, 3, 9) )).sum(:price)


    # A19_09 - Marzo
    @a19_09vi_da = Date.new(2019, 3, 1).friday?
    @a19_09vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3, 1)..Date.new(2019, 3, 1) )).sum(:price)
    @a19_09vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3, 1)..Date.new(2019, 3, 1) )).sum(:price)
    @a19_09vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3, 1)..Date.new(2019, 3, 1) )).sum(:price)

    @a19_09sa_da = Date.new(2019, 3, 2).saturday?
    @a19_09sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3, 2)..Date.new(2019, 3, 2) )).sum(:price)
    @a19_09sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3, 2)..Date.new(2019, 3, 2) )).sum(:price)
    @a19_09sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3, 2)..Date.new(2019, 3, 2) )).sum(:price)
    # A19_09 - Marzo
    @a19_09_03mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3, 1)..Date.new(2019, 3, 2) )).sum(:price)
    @a19_09_03mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3, 1)..Date.new(2019, 3, 2) )).sum(:price)
    @a19_09_03mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3, 1)..Date.new(2019, 3, 2) )).sum(:price)
    # A19_09 - FEB/Mar
    @a19_09mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,24)..Date.new(2019, 3, 2) )).sum(:price)
    @a19_09mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,24)..Date.new(2019, 3, 2) )).sum(:price)
    @a19_09mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,24)..Date.new(2019, 3, 2) )).sum(:price)


    # A19_09 - Febrero
    @a19_09dm_da = Date.new(2019, 2,24).sunday?
    @a19_09dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,24)..Date.new(2019, 2,24) )).sum(:price)
    @a19_09dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,24)..Date.new(2019, 2,24) )).sum(:price)
    @a19_09dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,24)..Date.new(2019, 2,24) )).sum(:price)

    @a19_09ln_da = Date.new(2019, 2,25).monday?
    @a19_09ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,25)..Date.new(2019, 2,25) )).sum(:price)
    @a19_09ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,25)..Date.new(2019, 2,25) )).sum(:price)
    @a19_09ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,25)..Date.new(2019, 2,25) )).sum(:price)

    @a19_09ma_da = Date.new(2019, 2,26).tuesday?
    @a19_09ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,26)..Date.new(2019, 2,26) )).sum(:price)
    @a19_09ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,26)..Date.new(2019, 2,26) )).sum(:price)
    @a19_09ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,26)..Date.new(2019, 2,26) )).sum(:price)

    @a19_09mi_da = Date.new(2019, 2,27).wednesday?
    @a19_09mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,27)..Date.new(2019, 2,27) )).sum(:price)
    @a19_09mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,27)..Date.new(2019, 2,27) )).sum(:price)
    @a19_09mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,27)..Date.new(2019, 2,27) )).sum(:price)

    @a19_09ju_da = Date.new(2019, 2,28).thursday?
    @a19_09ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,28)..Date.new(2019, 2,28) )).sum(:price)
    @a19_09ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,28)..Date.new(2019, 2,28) )).sum(:price)
    @a19_09ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,28)..Date.new(2019, 2,28) )).sum(:price)
    # A19_09 - Febrero
    @a19_09_02mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,24)..Date.new(2019, 2,28) )).sum(:price)
    @a19_09_02mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,24)..Date.new(2019, 2,28) )).sum(:price)
    @a19_09_02mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,24)..Date.new(2019, 2,28) )).sum(:price)


    # A19_08 - Febrero
    @a19_08dm_da = Date.new(2019, 2,17).sunday?
    @a19_08dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,17)..Date.new(2019, 2,17) )).sum(:price)
    @a19_08dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,17)..Date.new(2019, 2,17) )).sum(:price)
    @a19_08dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,17)..Date.new(2019, 2,17) )).sum(:price)

    @a19_08ln_da = Date.new(2019, 2,18).monday?
    @a19_08ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,18)..Date.new(2019, 2,18) )).sum(:price)
    @a19_08ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,18)..Date.new(2019, 2,18) )).sum(:price)
    @a19_08ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,18)..Date.new(2019, 2,18) )).sum(:price)

    @a19_08ma_da = Date.new(2019, 2,19).tuesday?
    @a19_08ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,19)..Date.new(2019, 2,19) )).sum(:price)
    @a19_08ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,19)..Date.new(2019, 2,19) )).sum(:price)
    @a19_08ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,19)..Date.new(2019, 2,19) )).sum(:price)

    @a19_08mi_da = Date.new(2019, 2,20).wednesday?
    @a19_08mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,20)..Date.new(2019, 2,20) )).sum(:price)
    @a19_08mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,20)..Date.new(2019, 2,20) )).sum(:price)
    @a19_08mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,20)..Date.new(2019, 2,20) )).sum(:price)

    @a19_08ju_da = Date.new(2019, 2,21).thursday?
    @a19_08ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,21)..Date.new(2019, 2,21) )).sum(:price)
    @a19_08ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,21)..Date.new(2019, 2,21) )).sum(:price)
    @a19_08ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,21)..Date.new(2019, 2,21) )).sum(:price)

    @a19_08vi_da = Date.new(2019, 2,22).friday?
    @a19_08vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,22)..Date.new(2019, 2,22) )).sum(:price)
    @a19_08vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,22)..Date.new(2019, 2,22) )).sum(:price)
    @a19_08vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,22)..Date.new(2019, 2,22) )).sum(:price)

    @a19_08sa_da = Date.new(2019, 2,23).saturday?
    @a19_08sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,23)..Date.new(2019, 2,23) )).sum(:price)
    @a19_08sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,23)..Date.new(2019, 2,23) )).sum(:price)
    @a19_08sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,23)..Date.new(2019, 2,23) )).sum(:price)
    # A19_08 - Febrero
    @a19_08mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,17)..Date.new(2019, 2,23) )).sum(:price)
    @a19_08mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,17)..Date.new(2019, 2,23) )).sum(:price)
    @a19_08mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,17)..Date.new(2019, 2,23) )).sum(:price)


    # A19_07 - Febrero
    @a19_07dm_da = Date.new(2019, 2,10).sunday?
    @a19_07dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,10)..Date.new(2019, 2,10) )).sum(:price)
    @a19_07dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,10)..Date.new(2019, 2,10) )).sum(:price)
    @a19_07dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,10)..Date.new(2019, 2,10) )).sum(:price)

    @a19_07ln_da = Date.new(2019, 2,11).monday?
    @a19_07ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,11)..Date.new(2019, 2,11) )).sum(:price)
    @a19_07ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,11)..Date.new(2019, 2,11) )).sum(:price)
    @a19_07ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,11)..Date.new(2019, 2,11) )).sum(:price)

    @a19_07ma_da = Date.new(2019, 2,12).tuesday?
    @a19_07ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,12)..Date.new(2019, 2,12) )).sum(:price)
    @a19_07ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,12)..Date.new(2019, 2,12) )).sum(:price)
    @a19_07ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,12)..Date.new(2019, 2,12) )).sum(:price)

    @a19_07mi_da = Date.new(2019, 2,13).wednesday?
    @a19_07mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,12)..Date.new(2019, 2,16) )).sum(:price)
    @a19_07mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,12)..Date.new(2019, 2,16) )).sum(:price)
    @a19_07mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,12)..Date.new(2019, 2,16) )).sum(:price)

    @a19_07ju_da = Date.new(2019, 2,14).thursday?
    @a19_07ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,14)..Date.new(2019, 2,14) )).sum(:price)
    @a19_07ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,14)..Date.new(2019, 2,14) )).sum(:price)
    @a19_07ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,14)..Date.new(2019, 2,14) )).sum(:price)

    @a19_07vi_da = Date.new(2019, 2,15).friday?
    @a19_07vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,15)..Date.new(2019, 2,15) )).sum(:price)
    @a19_07vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,15)..Date.new(2019, 2,15) )).sum(:price)
    @a19_07vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,15)..Date.new(2019, 2,15) )).sum(:price)

    @a19_07sa_da = Date.new(2019, 2,16).saturday?
    @a19_07sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,16)..Date.new(2019, 2,16) )).sum(:price)
    @a19_07sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,16)..Date.new(2019, 2,16) )).sum(:price)
    @a19_07sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,16)..Date.new(2019, 2,16) )).sum(:price)
    # A19_07 - Febrero
    @a19_07mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,10)..Date.new(2019, 2,16) )).sum(:price)
    @a19_07mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,10)..Date.new(2019, 2,16) )).sum(:price)
    @a19_07mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,10)..Date.new(2019, 2,16) )).sum(:price)


    # A19_06 - Febrero
    @a19_06dm_da = Date.new(2019, 2, 3).sunday?
    @a19_06dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2, 3)..Date.new(2019, 2, 3) )).sum(:price)
    @a19_06dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2, 3)..Date.new(2019, 2, 3) )).sum(:price)
    @a19_06dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2, 3)..Date.new(2019, 2, 3) )).sum(:price)

    @a19_06ln_da = Date.new(2019, 2, 4).monday?
    @a19_06ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2, 4)..Date.new(2019, 2, 4) )).sum(:price)
    @a19_06ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2, 4)..Date.new(2019, 2, 4) )).sum(:price)
    @a19_06ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2, 4)..Date.new(2019, 2, 4) )).sum(:price)

    @a19_06ma_da = Date.new(2019, 2, 5).tuesday?
    @a19_06ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2, 5)..Date.new(2019, 2, 5) )).sum(:price)
    @a19_06ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2, 5)..Date.new(2019, 2, 5) )).sum(:price)
    @a19_06ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2, 5)..Date.new(2019, 2, 5) )).sum(:price)

    @a19_06mi_da = Date.new(2019, 2, 6).wednesday?
    @a19_06mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2, 6)..Date.new(2019, 2, 6) )).sum(:price)
    @a19_06mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2, 6)..Date.new(2019, 2, 6) )).sum(:price)
    @a19_06mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2, 6)..Date.new(2019, 2, 6) )).sum(:price)

    @a19_06ju_da = Date.new(2019, 2, 7).thursday?
    @a19_06ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2, 7)..Date.new(2019, 2, 7) )).sum(:price)
    @a19_06ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2, 7)..Date.new(2019, 2, 7) )).sum(:price)
    @a19_06ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2, 7)..Date.new(2019, 2, 7) )).sum(:price)

    @a19_06vi_da = Date.new(2019, 2, 8).friday?
    @a19_06vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2, 8)..Date.new(2019, 2, 8) )).sum(:price)
    @a19_06vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2, 8)..Date.new(2019, 2, 8) )).sum(:price)
    @a19_06vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2, 8)..Date.new(2019, 2, 8) )).sum(:price)

    @a19_06sa_da = Date.new(2019, 2, 9).saturday?
    @a19_06sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2, 9)..Date.new(2019, 2, 9) )).sum(:price)
    @a19_06sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2, 9)..Date.new(2019, 2, 9) )).sum(:price)
    @a19_06sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2, 9)..Date.new(2019, 2, 9) )).sum(:price)
    # A19_06 - Febrero
    @a19_06mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2, 3)..Date.new(2019, 2, 9) )).sum(:price)
    @a19_06mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2, 3)..Date.new(2019, 2, 9) )).sum(:price)
    @a19_06mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2, 3)..Date.new(2019, 2, 9) )).sum(:price)


    # A19_05 - Febrero
    @a19_05vi_da = Date.new(2019, 2, 1).friday?
    @a19_05vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2, 1)..Date.new(2019, 2, 1) )).sum(:price)
    @a19_05vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2, 1)..Date.new(2019, 2, 1) )).sum(:price)
    @a19_05vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2, 1)..Date.new(2019, 2, 1) )).sum(:price)

    @a19_05sa_da = Date.new(2019, 2, 2).saturday?
    @a19_05sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2, 2)..Date.new(2019, 2, 2) )).sum(:price)
    @a19_05sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2, 2)..Date.new(2019, 2, 2) )).sum(:price)
    @a19_05sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2, 2)..Date.new(2019, 2, 2) )).sum(:price)
    # A19_05 - Febrero
    @a19_05_02mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2, 1)..Date.new(2019, 2, 2) )).sum(:price)
    @a19_05_02mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2, 1)..Date.new(2019, 2, 2) )).sum(:price)
    @a19_05_02mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2, 1)..Date.new(2019, 2, 2) )).sum(:price)
    # A19_05 - Ene/Feb
    @a19_05mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,27)..Date.new(2019, 2, 2) )).sum(:price)
    @a19_05mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,27)..Date.new(2019, 2, 2) )).sum(:price)
    @a19_05mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,27)..Date.new(2019, 2, 2) )).sum(:price)


    # A19_05 - Enero
    @a19_05dm_da = Date.new(2019, 1,27).sunday?
    @a19_05dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,27)..Date.new(2019, 1,27) )).sum(:price)
    @a19_05dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,27)..Date.new(2019, 1,27) )).sum(:price)
    @a19_05dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,27)..Date.new(2019, 1,27) )).sum(:price)

    @a19_05ln_da = Date.new(2019, 1,28).monday?
    @a19_05ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,28)..Date.new(2019, 1,28) )).sum(:price)
    @a19_05ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,28)..Date.new(2019, 1,28) )).sum(:price)
    @a19_05ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,28)..Date.new(2019, 1,28) )).sum(:price)

    @a19_05ma_da = Date.new(2019, 1,29).tuesday?
    @a19_05ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,29)..Date.new(2019, 1,29) )).sum(:price)
    @a19_05ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,29)..Date.new(2019, 1,29) )).sum(:price)
    @a19_05ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,29)..Date.new(2019, 1,29) )).sum(:price)

    @a19_05mi_da = Date.new(2019, 1,30).wednesday?
    @a19_05mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,30)..Date.new(2019, 1,30) )).sum(:price)
    @a19_05mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,30)..Date.new(2019, 1,30) )).sum(:price)
    @a19_05mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,30)..Date.new(2019, 1,30) )).sum(:price)

    @a19_05ju_da = Date.new(2019, 1,31).thursday?
    @a19_05ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,31)..Date.new(2019, 1,31) )).sum(:price)
    @a19_05ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,31)..Date.new(2019, 1,31) )).sum(:price)
    @a19_05ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,31)..Date.new(2019, 1,31) )).sum(:price)
    # A19_05 - Enero
    @a19_05_01mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,27)..Date.new(2019, 1,31) )).sum(:price)
    @a19_05_01mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,27)..Date.new(2019, 1,31) )).sum(:price)
    @a19_05_01mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,27)..Date.new(2019, 1,31) )).sum(:price)

# -------------
    # A19_04 - Enero
    @a19_04dm_da = Date.new(2019, 1,20).sunday?
    @a19_04dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,20)..Date.new(2019, 1,20) )).sum(:price)
    @a19_04dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,20)..Date.new(2019, 1,20) )).sum(:price)
    @a19_04dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,20)..Date.new(2019, 1,20) )).sum(:price)

    @a19_04ln_da = Date.new(2019, 1,21).monday?
    @a19_04ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,21)..Date.new(2019, 1,21) )).sum(:price)
    @a19_04ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,21)..Date.new(2019, 1,21) )).sum(:price)
    @a19_04ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,21)..Date.new(2019, 1,21) )).sum(:price)

    @a19_04ma_da = Date.new(2019, 1,22).tuesday?
    @a19_04ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,22)..Date.new(2019, 1,22) )).sum(:price)
    @a19_04ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,22)..Date.new(2019, 1,22) )).sum(:price)
    @a19_04ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,22)..Date.new(2019, 1,22) )).sum(:price)

    @a19_04mi_da = Date.new(2019, 1,23).wednesday?
    @a19_04mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,23)..Date.new(2019, 1,23) )).sum(:price)
    @a19_04mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,23)..Date.new(2019, 1,23) )).sum(:price)
    @a19_04mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,23)..Date.new(2019, 1,23) )).sum(:price)

    @a19_04ju_da = Date.new(2019, 1,24).thursday?
    @a19_04ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,24)..Date.new(2019, 1,24) )).sum(:price)
    @a19_04ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,24)..Date.new(2019, 1,24) )).sum(:price)
    @a19_04ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,24)..Date.new(2019, 1,24) )).sum(:price)

    @a19_04vi_da = Date.new(2019, 1,25).friday?
    @a19_04vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,25)..Date.new(2019, 1,25) )).sum(:price)
    @a19_04vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,25)..Date.new(2019, 1,25) )).sum(:price)
    @a19_04vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,25)..Date.new(2019, 1,25) )).sum(:price)

    @a19_04sa_da = Date.new(2019, 1,26).saturday?
    @a19_04sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,26)..Date.new(2019, 1,26) )).sum(:price)
    @a19_04sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,26)..Date.new(2019, 1,26) )).sum(:price)
    @a19_04sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,26)..Date.new(2019, 1,26) )).sum(:price)
    # A19_04 - Ene
    @a19_04mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,20)..Date.new(2019, 1,26) )).sum(:price)
    @a19_04mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,20)..Date.new(2019, 1,26) )).sum(:price)
    @a19_04mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,20)..Date.new(2019, 1,26) )).sum(:price)


    # A19_03 - Enero
    @a19_03dm_da = Date.new(2019, 1,13).sunday?
    @a19_03dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,13)..Date.new(2019, 1,13) )).sum(:price)
    @a19_03dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,13)..Date.new(2019, 1,13) )).sum(:price)
    @a19_03dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,13)..Date.new(2019, 1,13) )).sum(:price)

    @a19_03ln_da = Date.new(2019, 1,14).monday?
    @a19_03ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,14)..Date.new(2019, 1,14) )).sum(:price)
    @a19_03ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,14)..Date.new(2019, 1,14) )).sum(:price)
    @a19_03ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,14)..Date.new(2019, 1,14) )).sum(:price)

    @a19_03ma_da = Date.new(2019, 1,15).tuesday?
    @a19_03ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,15)..Date.new(2019, 1,15) )).sum(:price)
    @a19_03ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,15)..Date.new(2019, 1,15) )).sum(:price)
    @a19_03ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,15)..Date.new(2019, 1,15) )).sum(:price)

    @a19_03mi_da = Date.new(2019, 1,16).wednesday?
    @a19_03mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,16)..Date.new(2019, 1,16) )).sum(:price)
    @a19_03mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,16)..Date.new(2019, 1,16) )).sum(:price)
    @a19_03mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,16)..Date.new(2019, 1,16) )).sum(:price)

    @a19_03ju_da = Date.new(2019, 1,17).thursday?
    @a19_03ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,17)..Date.new(2019, 1,17) )).sum(:price)
    @a19_03ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,17)..Date.new(2019, 1,17) )).sum(:price)
    @a19_03ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,17)..Date.new(2019, 1,17) )).sum(:price)

    @a19_03vi_da = Date.new(2019, 1,18).friday?
    @a19_03vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,18)..Date.new(2019, 1,18) )).sum(:price)
    @a19_03vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,18)..Date.new(2019, 1,18) )).sum(:price)
    @a19_03vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,18)..Date.new(2019, 1,18) )).sum(:price)

    @a19_03sa_da = Date.new(2019, 1,19).saturday?
    @a19_03sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,19)..Date.new(2019, 1,19) )).sum(:price)
    @a19_03sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,19)..Date.new(2019, 1,19) )).sum(:price)
    @a19_03sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,19)..Date.new(2019, 1,19) )).sum(:price)
    # A19_03 - Ene
    @a19_03mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,13)..Date.new(2019, 1,19) )).sum(:price)
    @a19_03mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,13)..Date.new(2019, 1,19) )).sum(:price)
    @a19_03mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,13)..Date.new(2019, 1,19) )).sum(:price)

    # A19_02 - Enero
    @a19_02dm_da = Date.new(2019, 1, 6).sunday?
    @a19_02dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1, 6)..Date.new(2019, 1, 6) )).sum(:price)
    @a19_02dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1, 6)..Date.new(2019, 1, 6) )).sum(:price)
    @a19_02dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1, 6)..Date.new(2019, 1, 6) )).sum(:price)

    @a19_02ln_da = Date.new(2019, 1, 7).monday?
    @a19_02ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1, 7)..Date.new(2019, 1, 7) )).sum(:price)
    @a19_02ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1, 7)..Date.new(2019, 1, 7) )).sum(:price)
    @a19_02ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1, 7)..Date.new(2019, 1, 7) )).sum(:price)

    @a19_02ma_da = Date.new(2019, 1, 8).tuesday?
    @a19_02ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1, 8)..Date.new(2019, 1, 8) )).sum(:price)
    @a19_02ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1, 8)..Date.new(2019, 1, 8) )).sum(:price)
    @a19_02ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1, 8)..Date.new(2019, 1, 8) )).sum(:price)

    @a19_02mi_da = Date.new(2019, 1, 9).wednesday?
    @a19_02mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1, 9)..Date.new(2019, 1, 9) )).sum(:price)
    @a19_02mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1, 9)..Date.new(2019, 1, 9) )).sum(:price)
    @a19_02mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1, 9)..Date.new(2019, 1, 9) )).sum(:price)

    @a19_02ju_da = Date.new(2019, 1,10).thursday?
    @a19_02ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,10)..Date.new(2019, 1,10) )).sum(:price)
    @a19_02ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,10)..Date.new(2019, 1,10) )).sum(:price)
    @a19_02ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,10)..Date.new(2019, 1,10) )).sum(:price)

    @a19_02vi_da = Date.new(2019, 1,11).friday?
    @a19_02vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,11)..Date.new(2019, 1,11) )).sum(:price)
    @a19_02vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,11)..Date.new(2019, 1,11) )).sum(:price)
    @a19_02vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,11)..Date.new(2019, 1,11) )).sum(:price)

    @a19_02sa_da = Date.new(2019, 1,12).saturday?
    @a19_02sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,12)..Date.new(2019, 1,12) )).sum(:price)
    @a19_02sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,12)..Date.new(2019, 1,12) )).sum(:price)
    @a19_02sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,12)..Date.new(2019, 1,12) )).sum(:price)
    # A19_02 - Ene
    @a19_02mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1, 6)..Date.new(2019, 1,12) )).sum(:price)
    @a19_02mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1, 6)..Date.new(2019, 1,12) )).sum(:price)
    @a19_02mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1, 6)..Date.new(2019, 1,12) )).sum(:price)


    # A19_01 - Ene
    @a19_01ma_da = Date.new(2019, 1, 1).tuesday?
    @a19_01ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 1, 1) )).sum(:price)
    @a19_01ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 1, 1) )).sum(:price)
    @a19_01ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 1, 1) )).sum(:price)

    @a19_01mi_da = Date.new(2019, 1, 2).wednesday?
    @a19_01mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1, 2)..Date.new(2019, 1, 2) )).sum(:price)
    @a19_01mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1, 2)..Date.new(2019, 1, 2) )).sum(:price)
    @a19_01mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1, 2)..Date.new(2019, 1, 2) )).sum(:price)

    @a19_01ju_da = Date.new(2019, 1, 3).thursday?
    @a19_01ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1, 3)..Date.new(2019, 1, 3) )).sum(:price)
    @a19_01ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1, 3)..Date.new(2019, 1, 3) )).sum(:price)
    @a19_01ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1, 3)..Date.new(2019, 1, 3) )).sum(:price)

    @a19_01vi_da = Date.new(2019, 1, 4).friday?
    @a19_01vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1, 4)..Date.new(2019, 1, 4) )).sum(:price)
    @a19_01vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1, 4)..Date.new(2019, 1, 4) )).sum(:price)
    @a19_01vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1, 4)..Date.new(2019, 1, 4) )).sum(:price)

    @a19_01sa_da = Date.new(2019, 1, 5).saturday?
    @a19_01sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1, 5)..Date.new(2019, 1, 5) )).sum(:price)
    @a19_01sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1, 5)..Date.new(2019, 1, 5) )).sum(:price)
    @a19_01sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1, 5)..Date.new(2019, 1, 5) )).sum(:price)
    # A19_01 - Enero
    @a19_01_01mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 1, 5) )).sum(:price)
    @a19_01_01mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 1, 5) )).sum(:price)
    @a19_01_01mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 1, 5) )).sum(:price)
    # A18_53 - Dic / A19_01 - Ene
    @a19_01mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,30)..Date.new(2019, 1, 5) )).sum(:price)
    @a19_01mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,30)..Date.new(2019, 1, 5) )).sum(:price)
    @a19_01mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,30)..Date.new(2019, 1, 5) )).sum(:price)


    # ***   Año 2018   ***
    # A18_53 - Dic
    @a18_53dm_da = Date.new(2018,12,30).sunday?
    @a18_53dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,30)..Date.new(2018,014,30) )).sum(:price)
    @a18_53dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,30)..Date.new(2018,014,30) )).sum(:price)
    @a18_53dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,30)..Date.new(2018,014,30) )).sum(:price)

    @a18_53ln_da = Date.new(2018,12,31).monday?
    @a18_53ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,31)..Date.new(2018,014,31) )).sum(:price)
    @a18_53ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,31)..Date.new(2018,014,31) )).sum(:price)
    @a18_53ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,31)..Date.new(2018,014,31) )).sum(:price)
    # A18_53 - Dic
    @a18_53_12mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,30)..Date.new(2018,014,31) )).sum(:price)
    @a18_53_12mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,30)..Date.new(2018,014,31) )).sum(:price)
    @a18_53_12mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,30)..Date.new(2018,014,31) )).sum(:price)


    # A18_52 - Dic
    @a18_52dm_da = Date.new(2018,12,23).sunday?
    @a18_52dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,23)..Date.new(2018,014,23) )).sum(:price)
    @a18_52dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,23)..Date.new(2018,014,23) )).sum(:price)
    @a18_52dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,23)..Date.new(2018,014,23) )).sum(:price)

    @a18_52ln_da = Date.new(2018,12,24).monday?
    @a18_52ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,24)..Date.new(2018,014,24) )).sum(:price)
    @a18_52ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,24)..Date.new(2018,014,24) )).sum(:price)
    @a18_52ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,24)..Date.new(2018,014,24) )).sum(:price)

    @a18_52ma_da = Date.new(2018,12,25).tuesday?
    @a18_52ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,25)..Date.new(2018,014,25) )).sum(:price)
    @a18_52ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,25)..Date.new(2018,014,25) )).sum(:price)
    @a18_52ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,25)..Date.new(2018,014,25) )).sum(:price)

    @a18_52mi_da = Date.new(2018,12,26).wednesday?
    @a18_52mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,26)..Date.new(2018,014,26) )).sum(:price)
    @a18_52mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,26)..Date.new(2018,014,26) )).sum(:price)
    @a18_52mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,26)..Date.new(2018,014,26) )).sum(:price)

    @a18_52ju_da = Date.new(2018,12,27).thursday?
    @a18_52ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,27)..Date.new(2018,014,27) )).sum(:price)
    @a18_52ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,27)..Date.new(2018,014,27) )).sum(:price)
    @a18_52ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,27)..Date.new(2018,014,27) )).sum(:price)

    @a18_52vi_da = Date.new(2018,12,28).friday?
    @a18_52vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,28)..Date.new(2018,014,28) )).sum(:price)
    @a18_52vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,28)..Date.new(2018,014,28) )).sum(:price)
    @a18_52vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,28)..Date.new(2018,014,28) )).sum(:price)

    @a18_52sa_da = Date.new(2018,12,29).saturday?
    @a18_52sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,29)..Date.new(2018,014,29) )).sum(:price)
    @a18_52sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,29)..Date.new(2018,014,29) )).sum(:price)
    @a18_52sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,29)..Date.new(2018,014,29) )).sum(:price)
    # A18_52 - Dic
    @a18_52mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,23)..Date.new(2018,014,29) )).sum(:price)
    @a18_52mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,23)..Date.new(2018,014,29) )).sum(:price)
    @a18_52mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,23)..Date.new(2018,014,29) )).sum(:price)

    # A18_51 - Dic
    @a18_51dm_da = Date.new(2018,12,16).sunday?
    @a18_51dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,16)..Date.new(2018,014,16) )).sum(:price)
    @a18_51dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,16)..Date.new(2018,014,16) )).sum(:price)
    @a18_51dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,16)..Date.new(2018,014,16) )).sum(:price)

    @a18_51ln_da = Date.new(2018,12,17).monday?
    @a18_51ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,17)..Date.new(2018,014,17) )).sum(:price)
    @a18_51ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,17)..Date.new(2018,014,17) )).sum(:price)
    @a18_51ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,17)..Date.new(2018,014,17) )).sum(:price)

    @a18_51ma_da = Date.new(2018,12,18).tuesday?
    @a18_51ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,18)..Date.new(2018,014,18) )).sum(:price)
    @a18_51ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,18)..Date.new(2018,014,18) )).sum(:price)
    @a18_51ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,18)..Date.new(2018,014,18) )).sum(:price)

    @a18_51mi_da = Date.new(2018,12,19).wednesday?
    @a18_51mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,19)..Date.new(2018,014,19) )).sum(:price)
    @a18_51mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,19)..Date.new(2018,014,19) )).sum(:price)
    @a18_51mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,19)..Date.new(2018,014,19) )).sum(:price)

    @a18_51ju_da = Date.new(2018,12,20).thursday?
    @a18_51ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,20)..Date.new(2018,014,20) )).sum(:price)
    @a18_51ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,20)..Date.new(2018,014,20) )).sum(:price)
    @a18_51ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,20)..Date.new(2018,014,20) )).sum(:price)

    @a18_51vi_da = Date.new(2018,12,21).friday?
    @a18_51vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,21)..Date.new(2018,014,21) )).sum(:price)
    @a18_51vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,21)..Date.new(2018,014,21) )).sum(:price)
    @a18_51vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,21)..Date.new(2018,014,21) )).sum(:price)

    @a18_51sa_da = Date.new(2018,12,22).saturday?
    @a18_51sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,22)..Date.new(2018,014,22) )).sum(:price)
    @a18_51sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,22)..Date.new(2018,014,22) )).sum(:price)
    @a18_51sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,22)..Date.new(2018,014,22) )).sum(:price)
    # A18_51 - Dic
    @a18_51mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,16)..Date.new(2018,014,22) )).sum(:price)
    @a18_51mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,16)..Date.new(2018,014,22) )).sum(:price)
    @a18_51mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,16)..Date.new(2018,014,22) )).sum(:price)

    # A18_50 - Dic
    @a18_50dm_da = Date.new(2018,12, 9).sunday?
    @a18_50dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 9)..Date.new(2018,014, 9) )).sum(:price)
    @a18_50dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 9)..Date.new(2018,014, 9) )).sum(:price)
    @a18_50dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 9)..Date.new(2018,014, 9) )).sum(:price)

    @a18_50ln_da = Date.new(2018,11,10).monday?
    @a18_50ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,10)..Date.new(2018,014,10) )).sum(:price)
    @a18_50ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,10)..Date.new(2018,014,10) )).sum(:price)
    @a18_50ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,10)..Date.new(2018,014,10) )).sum(:price)

    @a18_50ma_da = Date.new(2018,12,11).tuesday?
    @a18_50ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,11)..Date.new(2018,014,11) )).sum(:price)
    @a18_50ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,11)..Date.new(2018,014,11) )).sum(:price)
    @a18_50ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,11)..Date.new(2018,014,11) )).sum(:price)

    @a18_50mi_da = Date.new(2018,12,12).wednesday?
    @a18_50mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,12)..Date.new(2018,014,12) )).sum(:price)
    @a18_50mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,12)..Date.new(2018,014,12) )).sum(:price)
    @a18_50mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,12)..Date.new(2018,014,12) )).sum(:price)

    @a18_50ju_da = Date.new(2018,12,13).thursday?
    @a18_50ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,13)..Date.new(2018,014,13) )).sum(:price)
    @a18_50ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,13)..Date.new(2018,014,13) )).sum(:price)
    @a18_50ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,13)..Date.new(2018,014,13) )).sum(:price)

    @a18_50vi_da = Date.new(2018,12,14).friday?
    @a18_50vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,14)..Date.new(2018,014,14) )).sum(:price)
    @a18_50vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,14)..Date.new(2018,014,14) )).sum(:price)
    @a18_50vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,14)..Date.new(2018,014,14) )).sum(:price)

    @a18_50sa_da = Date.new(2018,12,15).saturday?
    @a18_50sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,15)..Date.new(2018,014,15) )).sum(:price)
    @a18_50sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,15)..Date.new(2018,014,15) )).sum(:price)
    @a18_50sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,15)..Date.new(2018,014,15) )).sum(:price)
    # A18_50 - Dic
    @a18_50mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 9)..Date.new(2018,014,15) )).sum(:price)
    @a18_50mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 9)..Date.new(2018,014,15) )).sum(:price)
    @a18_50mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 9)..Date.new(2018,014,15) )).sum(:price)

    # A18_49 - Dic
    @a18_49dm_da = Date.new(2018,12, 2).sunday?
    @a18_49dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 2)..Date.new(2018,014, 2) )).sum(:price)
    @a18_49dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 2)..Date.new(2018,014, 2) )).sum(:price)
    @a18_49dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 2)..Date.new(2018,014, 2) )).sum(:price)

    @a18_49ln_da = Date.new(2018,12, 3).monday?
    @a18_49ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 3)..Date.new(2018,014, 3) )).sum(:price)
    @a18_49ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 3)..Date.new(2018,014, 3) )).sum(:price)
    @a18_49ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 3)..Date.new(2018,014, 3) )).sum(:price)

    @a18_49ma_da = Date.new(2018,12, 4).tuesday?
    @a18_49ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 4)..Date.new(2018,014, 4) )).sum(:price)
    @a18_49ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 4)..Date.new(2018,014, 4) )).sum(:price)
    @a18_49ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 4)..Date.new(2018,014, 4) )).sum(:price)

    @a18_49mi_da = Date.new(2018,12, 5).wednesday?
    @a18_49mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 5)..Date.new(2018,014, 5) )).sum(:price)
    @a18_49mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 5)..Date.new(2018,014, 5) )).sum(:price)
    @a18_49mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 5)..Date.new(2018,014, 5) )).sum(:price)

    @a18_49ju_da = Date.new(2018,12, 6).thursday?
    @a18_49ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 6)..Date.new(2018,014, 6) )).sum(:price)
    @a18_49ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 6)..Date.new(2018,014, 6) )).sum(:price)
    @a18_49ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 6)..Date.new(2018,014, 6) )).sum(:price)

    @a18_49vi_da = Date.new(2018,12, 7).friday?
    @a18_49vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 7)..Date.new(2018,014, 7) )).sum(:price)
    @a18_49vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 7)..Date.new(2018,014, 7) )).sum(:price)
    @a18_49vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 7)..Date.new(2018,014, 7) )).sum(:price)

    @a18_49sa_da = Date.new(2018,12, 8).saturday?
    @a18_49sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 8)..Date.new(2018,014, 8) )).sum(:price)
    @a18_49sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 8)..Date.new(2018,014, 8) )).sum(:price)
    @a18_49sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 8)..Date.new(2018,014, 8) )).sum(:price)
    # A18_49 - Dic
    @a18_49mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 2)..Date.new(2018,014, 8) )).sum(:price)
    @a18_49mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 2)..Date.new(2018,014, 8) )).sum(:price)
    @a18_49mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 2)..Date.new(2018,014, 8) )).sum(:price)

    # A18_48 - Dic
    @a18_48sa_da = Date.new(2018,12, 1).saturday?
    @a18_48sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014, 1) )).sum(:price)
    @a18_48sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014, 1) )).sum(:price)
    @a18_48sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014, 1) )).sum(:price)
    # A18_48 - Dic
    @a18_48_12mv_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014, 1) )).sum(:price)
    @a18_48_12mv_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014, 1) )).sum(:price)
    @a18_48_12mv_pj=Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014, 1) )).sum(:price)
    # A18_48 - Dic
    @a18_48mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,25)..Date.new(2018,014, 1) )).sum(:price)
    @a18_48mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,25)..Date.new(2018,014, 1) )).sum(:price)
    @a18_48mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,25)..Date.new(2018,014, 1) )).sum(:price)


    # A18_48 - Nov
    @a18_48dm_da = Date.new(2018,11,25).sunday?
    @a18_48dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,25)..Date.new(2018,013,25) )).sum(:price)
    @a18_48dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,25)..Date.new(2018,013,25) )).sum(:price)
    @a18_48dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,25)..Date.new(2018,013,25) )).sum(:price)

    @a18_48ln_da = Date.new(2018,11,26).monday?
    @a18_48ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,26)..Date.new(2018,013,26) )).sum(:price)
    @a18_48ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,26)..Date.new(2018,013,26) )).sum(:price)
    @a18_48ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,26)..Date.new(2018,013,26) )).sum(:price)

    @a18_48ma_da = Date.new(2018,11,27).tuesday?
    @a18_48ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,27)..Date.new(2018,013,27) )).sum(:price)
    @a18_48ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,27)..Date.new(2018,013,27) )).sum(:price)
    @a18_48ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,27)..Date.new(2018,013,27) )).sum(:price)

    @a18_48mi_da = Date.new(2018,11,28).wednesday?
    @a18_48mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,28)..Date.new(2018,013,28) )).sum(:price)
    @a18_48mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,28)..Date.new(2018,013,28) )).sum(:price)
    @a18_48mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,28)..Date.new(2018,013,28) )).sum(:price)

    @a18_48ju_da = Date.new(2018,11,29).thursday?
    @a18_48ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,29)..Date.new(2018,013,29) )).sum(:price)
    @a18_48ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,29)..Date.new(2018,013,29) )).sum(:price)
    @a18_48ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,29)..Date.new(2018,013,29) )).sum(:price)

    @a18_48vi_da = Date.new(2018,11,30).friday?
    @a18_48vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,30)..Date.new(2018,013,30) )).sum(:price)
    @a18_48vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,30)..Date.new(2018,013,30) )).sum(:price)
    @a18_48vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,30)..Date.new(2018,013,30) )).sum(:price)
    # A18_48 - Nov
    @a18_48_11mv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,25)..Date.new(2018,013,30) )).sum(:price)
    @a18_48_11mv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,25)..Date.new(2018,013,30) )).sum(:price)
    @a18_48_11mv_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,25)..Date.new(2018,013,30) )).sum(:price)

    # A18_47 - Nov
    @a18_47dm_da = Date.new(2018,11,18).sunday?
    @a18_47dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,18)..Date.new(2018,013,18) )).sum(:price)
    @a18_47dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,18)..Date.new(2018,013,18) )).sum(:price)
    @a18_47dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,18)..Date.new(2018,013,18) )).sum(:price)

    @a18_47ln_da = Date.new(2018,11,19).monday?
    @a18_47ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,19)..Date.new(2018,013,19) )).sum(:price)
    @a18_47ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,19)..Date.new(2018,013,19) )).sum(:price)
    @a18_47ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,19)..Date.new(2018,013,19) )).sum(:price)

    @a18_47ma_da = Date.new(2018,11,20).tuesday?
    @a18_47ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,20)..Date.new(2018,013,20) )).sum(:price)
    @a18_47ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,20)..Date.new(2018,013,20) )).sum(:price)
    @a18_47ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,20)..Date.new(2018,013,20) )).sum(:price)

    @a18_47mi_da = Date.new(2018,11,21).wednesday?
    @a18_47mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,21)..Date.new(2018,013,21) )).sum(:price)
    @a18_47mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,21)..Date.new(2018,013,21) )).sum(:price)
    @a18_47mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,21)..Date.new(2018,013,21) )).sum(:price)

    @a18_47ju_da = Date.new(2018,11,22).thursday?
    @a18_47ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,22)..Date.new(2018,013,22) )).sum(:price)
    @a18_47ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,22)..Date.new(2018,013,22) )).sum(:price)
    @a18_47ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,22)..Date.new(2018,013,22) )).sum(:price)

    @a18_47vi_da = Date.new(2018,11,23).friday?
    @a18_47vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,23)..Date.new(2018,013,23) )).sum(:price)
    @a18_47vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,23)..Date.new(2018,013,23) )).sum(:price)
    @a18_47vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,23)..Date.new(2018,013,23) )).sum(:price)

    @a18_47sa_da = Date.new(2018,11,24).saturday?
    @a18_47sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,24)..Date.new(2018,013,24) )).sum(:price)
    @a18_47sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,24)..Date.new(2018,013,24) )).sum(:price)
    @a18_47sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,24)..Date.new(2018,013,24) )).sum(:price)
    # A18-11 / W47
    @a18_47mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,18)..Date.new(2018,013,24) )).sum(:price)
    @a18_47mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,18)..Date.new(2018,013,24) )).sum(:price)
    @a18_47mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,18)..Date.new(2018,013,24) )).sum(:price)

    # A18-11 / W46
    @a18_46dm_da = Date.new(2018,11,11).sunday?
    @a18_46dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,11)..Date.new(2018,013,11) )).sum(:price)
    @a18_46dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,11)..Date.new(2018,013,11) )).sum(:price)
    @a18_46dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,11)..Date.new(2018,013,11) )).sum(:price)

    @a18_46ln_da = Date.new(2018,11,12).monday?
    @a18_46ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,12)..Date.new(2018,013,12) )).sum(:price)
    @a18_46ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,12)..Date.new(2018,013,12) )).sum(:price)
    @a18_46ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,12)..Date.new(2018,013,12) )).sum(:price)

    @a18_46ma_da = Date.new(2018,11,13).tuesday?
    @a18_46ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,13)..Date.new(2018,013,13) )).sum(:price)
    @a18_46ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,13)..Date.new(2018,013,13) )).sum(:price)
    @a18_46ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,13)..Date.new(2018,013,13) )).sum(:price)

    @a18_46mi_da = Date.new(2018,11,14).wednesday?
    @a18_46mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,14)..Date.new(2018,013,14) )).sum(:price)
    @a18_46mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,14)..Date.new(2018,013,14) )).sum(:price)
    @a18_46mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,14)..Date.new(2018,013,14) )).sum(:price)

    @a18_46ju_da = Date.new(2018,11,15).thursday?
    @a18_46ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,15)..Date.new(2018,013,15) )).sum(:price)
    @a18_46ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,15)..Date.new(2018,013,15) )).sum(:price)
    @a18_46ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,15)..Date.new(2018,013,15) )).sum(:price)

    @a18_46vi_da = Date.new(2018,11,16).friday?
    @a18_46vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,16)..Date.new(2018,013,16) )).sum(:price)
    @a18_46vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,16)..Date.new(2018,013,16) )).sum(:price)
    @a18_46vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,16)..Date.new(2018,013,16) )).sum(:price)

    @a18_46sa_da = Date.new(2018,11,17).saturday?
    @a18_46sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,17)..Date.new(2018,013,17) )).sum(:price)
    @a18_46sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,17)..Date.new(2018,013,17) )).sum(:price)
    @a18_46sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,17)..Date.new(2018,013,17) )).sum(:price)
    # A18-11 / W46
    @a18_46mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,11)..Date.new(2018,013,17) )).sum(:price)
    @a18_46mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,11)..Date.new(2018,013,17) )).sum(:price)
    @a18_46mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,11)..Date.new(2018,013,17) )).sum(:price)

    # A18-11 / W45
    @a18_45dm_da = Date.new(2018,11, 4).sunday?
    @a18_45dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013, 4)..Date.new(2018,013, 4) )).sum(:price)
    @a18_45dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013, 4)..Date.new(2018,013, 4) )).sum(:price)
    @a18_45dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013, 4)..Date.new(2018,013, 4) )).sum(:price)

    @a18_45ln_da = Date.new(2018,11, 5).monday?
    @a18_45ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013, 5)..Date.new(2018,013, 5) )).sum(:price)
    @a18_45ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013, 5)..Date.new(2018,013, 5) )).sum(:price)
    @a18_45ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013, 5)..Date.new(2018,013, 5) )).sum(:price)

    @a18_45ma_da = Date.new(2018,11, 6).tuesday?
    @a18_45ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013, 6)..Date.new(2018,013, 6) )).sum(:price)
    @a18_45ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013, 6)..Date.new(2018,013, 6) )).sum(:price)
    @a18_45ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013, 6)..Date.new(2018,013, 6) )).sum(:price)

    @a18_45mi_da = Date.new(2018,11, 7).wednesday?
    @a18_45mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013, 7)..Date.new(2018,013, 7) )).sum(:price)
    @a18_45mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013, 7)..Date.new(2018,013, 7) )).sum(:price)
    @a18_45mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013, 7)..Date.new(2018,013, 7) )).sum(:price)

    @a18_45ju_da = Date.new(2018,11, 8).thursday?
    @a18_45ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013, 8)..Date.new(2018,013, 8) )).sum(:price)
    @a18_45ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013, 8)..Date.new(2018,013, 8) )).sum(:price)
    @a18_45ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013, 8)..Date.new(2018,013, 8) )).sum(:price)

    @a18_45vi_da = Date.new(2018,11, 9).friday?
    @a18_45vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013, 9)..Date.new(2018,013, 9) )).sum(:price)
    @a18_45vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013, 9)..Date.new(2018,013, 9) )).sum(:price)
    @a18_45vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013, 9)..Date.new(2018,013, 9) )).sum(:price)

    @a18_45sa_da = Date.new(2018,11,10).saturday?
    @a18_45sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,10)..Date.new(2018,013,10) )).sum(:price)
    @a18_45sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,10)..Date.new(2018,013,10) )).sum(:price)
    @a18_45sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,10)..Date.new(2018,013,10) )).sum(:price)
    # A18-11 / W45
    @a18_45mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013, 4)..Date.new(2018,013,10) )).sum(:price)
    @a18_45mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013, 4)..Date.new(2018,013,10) )).sum(:price)
    @a18_45mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013, 4)..Date.new(2018,013,10) )).sum(:price)


    # A18-11 / W44
    @a18_44ju_da = Date.new(2018,11, 1).thursday?
    @a18_44ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013, 1) )).sum(:price)
    @a18_44ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013, 1) )).sum(:price)
    @a18_44ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013, 1) )).sum(:price)

    @a18_44vi_da = Date.new(2018,11, 2).friday?
    @a18_44vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013, 2)..Date.new(2018,013, 2) )).sum(:price)
    @a18_44vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013, 2)..Date.new(2018,013, 2) )).sum(:price)
    @a18_44vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013, 2)..Date.new(2018,013, 2) )).sum(:price)

    @a18_44sa_da = Date.new(2018,11, 3).saturday?
    @a18_44sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013, 3)..Date.new(2018,013, 3) )).sum(:price)
    @a18_44sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013, 3)..Date.new(2018,013, 3) )).sum(:price)
    @a18_44sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013, 3)..Date.new(2018,013, 3) )).sum(:price)
    # A18-11 / W44
    @a18_44_11mv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013, 3) )).sum(:price)
    @a18_44_11mv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013, 3) )).sum(:price)
    @a18_44_11mv_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013, 3) )).sum(:price)
    # A18-11 / W44
    @a18_44mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,28)..Date.new(2018,013, 3) )).sum(:price)
    @a18_44mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,28)..Date.new(2018,013, 3) )).sum(:price)
    @a18_44mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,28)..Date.new(2018,013, 3) )).sum(:price)


    # A18-10 / W44
    @a18_44dm_da = Date.new(2018,10,28).sunday?
    @a18_44dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,28)..Date.new(2018,012,28) )).sum(:price)
    @a18_44dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,28)..Date.new(2018,012,28) )).sum(:price)
    @a18_44dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,28)..Date.new(2018,012,28) )).sum(:price)

    @a18_44ln_da = Date.new(2018,10,29).monday?
    @a18_44ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,29)..Date.new(2018,012,29) )).sum(:price)
    @a18_44ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,29)..Date.new(2018,012,29) )).sum(:price)
    @a18_44ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,29)..Date.new(2018,012,29) )).sum(:price)

    @a18_44ma_da = Date.new(2018,10,30).tuesday?
    @a18_44ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,30)..Date.new(2018,012,30) )).sum(:price)
    @a18_44ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,30)..Date.new(2018,012,30) )).sum(:price)
    @a18_44ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,30)..Date.new(2018,012,30) )).sum(:price)

    @a18_44mi_da = Date.new(2018,10,31).wednesday?
    @a18_44mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,31)..Date.new(2018,012,31) )).sum(:price)
    @a18_44mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,31)..Date.new(2018,012,31) )).sum(:price)
    @a18_44mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,31)..Date.new(2018,012,31) )).sum(:price)
    # A18-10 / W44
    @a18_44_10mv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,28)..Date.new(2018,012,31) )).sum(:price)
    @a18_44_10mv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,28)..Date.new(2018,012,31) )).sum(:price)
    @a18_44_10mv_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,28)..Date.new(2018,012,31) )).sum(:price)

    # A18-10 / W43
    @a18_43dm_da = Date.new(2018,10,21).sunday?
    @a18_43dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,21)..Date.new(2018,012,21) )).sum(:price)
    @a18_43dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,21)..Date.new(2018,012,21) )).sum(:price)
    @a18_43dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,21)..Date.new(2018,012,21) )).sum(:price)

    @a18_43ln_da = Date.new(2018,10,22).monday?
    @a18_43ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,22)..Date.new(2018,012,22) )).sum(:price)
    @a18_43ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,22)..Date.new(2018,012,22) )).sum(:price)
    @a18_43ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,22)..Date.new(2018,012,22) )).sum(:price)

    @a18_43ma_da = Date.new(2018,10,23).tuesday?
    @a18_43ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,23)..Date.new(2018,012,23) )).sum(:price)
    @a18_43ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,23)..Date.new(2018,012,23) )).sum(:price)
    @a18_43ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,23)..Date.new(2018,012,23) )).sum(:price)

    @a18_43mi_da = Date.new(2018,10,24).wednesday?
    @a18_43mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,24)..Date.new(2018,012,24) )).sum(:price)
    @a18_43mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,24)..Date.new(2018,012,24) )).sum(:price)
    @a18_43mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,24)..Date.new(2018,012,24) )).sum(:price)

    @a18_43ju_da = Date.new(2018,10,25).thursday?
    @a18_43ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,25)..Date.new(2018,012,25) )).sum(:price)
    @a18_43ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,25)..Date.new(2018,012,25) )).sum(:price)
    @a18_43ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,25)..Date.new(2018,012,25) )).sum(:price)

    @a18_43vi_da = Date.new(2018,10,26).friday?
    @a18_43vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,26)..Date.new(2018,012,26) )).sum(:price)
    @a18_43vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,26)..Date.new(2018,012,26) )).sum(:price)
    @a18_43vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,26)..Date.new(2018,012,26) )).sum(:price)

    @a18_43sa_da = Date.new(2018,10,27).saturday?
    @a18_43sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,27)..Date.new(2018,012,27) )).sum(:price)
    @a18_43sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,27)..Date.new(2018,012,27) )).sum(:price)
    @a18_43sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,27)..Date.new(2018,012,27) )).sum(:price)
    # A18-10 / W43
    @a18_43mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,21)..Date.new(2018,012,27) )).sum(:price)
    @a18_43mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,21)..Date.new(2018,012,27) )).sum(:price)
    @a18_43mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,21)..Date.new(2018,012,27) )).sum(:price)

    # A18-10 / W42
    @a18_42dm_da = Date.new(2018,10,14).sunday?
    @a18_42dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,14)..Date.new(2018,012,14) )).sum(:price)
    @a18_42dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,14)..Date.new(2018,012,14) )).sum(:price)
    @a18_42dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,14)..Date.new(2018,012,14) )).sum(:price)

    @a18_42ln_da = Date.new(2018,10,15).monday?
    @a18_42ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,15)..Date.new(2018,012,15) )).sum(:price)
    @a18_42ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,15)..Date.new(2018,012,15) )).sum(:price)
    @a18_42ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,15)..Date.new(2018,012,15) )).sum(:price)

    @a18_42ma_da = Date.new(2018,10,16).tuesday?
    @a18_42ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,16)..Date.new(2018,012,16) )).sum(:price)
    @a18_42ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,16)..Date.new(2018,012,16) )).sum(:price)
    @a18_42ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,16)..Date.new(2018,012,16) )).sum(:price)

    @a18_42mi_da = Date.new(2018,10,17).wednesday?
    @a18_42mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,17)..Date.new(2018,012,17) )).sum(:price)
    @a18_42mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,17)..Date.new(2018,012,17) )).sum(:price)
    @a18_42mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,17)..Date.new(2018,012,17) )).sum(:price)

    @a18_42ju_da = Date.new(2018,10,18).thursday?
    @a18_42ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,18)..Date.new(2018,012,18) )).sum(:price)
    @a18_42ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,18)..Date.new(2018,012,18) )).sum(:price)
    @a18_42ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,18)..Date.new(2018,012,18) )).sum(:price)

    @a18_42vi_da = Date.new(2018,10,19).friday?
    @a18_42vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,19)..Date.new(2018,012,19) )).sum(:price)
    @a18_42vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,19)..Date.new(2018,012,19) )).sum(:price)
    @a18_42vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,19)..Date.new(2018,012,19) )).sum(:price)

    @a18_42sa_da = Date.new(2018,10,20).saturday?
    @a18_42sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,20)..Date.new(2018,012,20) )).sum(:price)
    @a18_42sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,20)..Date.new(2018,012,20) )).sum(:price)
    @a18_42sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,20)..Date.new(2018,012,20) )).sum(:price)
    # A18-10 / W42
    @a18_42mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,14)..Date.new(2018,012,20) )).sum(:price)
    @a18_42mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,14)..Date.new(2018,012,20) )).sum(:price)
    @a18_42mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,14)..Date.new(2018,012,20) )).sum(:price)

    # A18-10 / W41
    @a18_41dm_da = Date.new(2018,10, 7).sunday?
    @a18_41dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012, 7)..Date.new(2018,012, 7) )).sum(:price)
    @a18_41dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012, 7)..Date.new(2018,012, 7) )).sum(:price)
    @a18_41dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012, 7)..Date.new(2018,012, 7) )).sum(:price)

    @a18_41ln_da = Date.new(2018,10, 8).monday?
    @a18_41ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012, 8)..Date.new(2018,012, 8) )).sum(:price)
    @a18_41ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012, 8)..Date.new(2018,012, 8) )).sum(:price)
    @a18_41ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012, 8)..Date.new(2018,012, 8) )).sum(:price)

    @a18_41ma_da = Date.new(2018,10, 9).tuesday?
    @a18_41ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012, 9)..Date.new(2018,012, 9) )).sum(:price)
    @a18_41ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012, 9)..Date.new(2018,012, 9) )).sum(:price)
    @a18_41ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012, 9)..Date.new(2018,012, 9) )).sum(:price)

    @a18_41mi_da = Date.new(2018,10,10).wednesday?
    @a18_41mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,10)..Date.new(2018,012,10) )).sum(:price)
    @a18_41mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,10)..Date.new(2018,012,10) )).sum(:price)
    @a18_41mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,10)..Date.new(2018,012,10) )).sum(:price)

    @a18_41ju_da = Date.new(2018,10,11).thursday?
    @a18_41ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,11)..Date.new(2018,012,11) )).sum(:price)
    @a18_41ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,11)..Date.new(2018,012,11) )).sum(:price)
    @a18_41ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,11)..Date.new(2018,012,11) )).sum(:price)

    @a18_41vi_da = Date.new(2018,10,12).friday?
    @a18_41vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,12)..Date.new(2018,012,12) )).sum(:price)
    @a18_41vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,12)..Date.new(2018,012,12) )).sum(:price)
    @a18_41vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,12)..Date.new(2018,012,12) )).sum(:price)

    @a18_41sa_da = Date.new(2018,10,13).saturday?
    @a18_41sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,13)..Date.new(2018,012,13) )).sum(:price)
    @a18_41sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,13)..Date.new(2018,012,13) )).sum(:price)
    @a18_41sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,13)..Date.new(2018,012,13) )).sum(:price)
    # A18-10 / W41
    @a18_41mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012, 7)..Date.new(2018,012,13) )).sum(:price)
    @a18_41mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012, 7)..Date.new(2018,012,13) )).sum(:price)
    @a18_41mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012, 7)..Date.new(2018,012,13) )).sum(:price)


    # A18-10 / W40
    @a18_40ln_da = Date.new(2018,10, 1).monday?
    @a18_40ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012, 1) )).sum(:price)
    @a18_40ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012, 1) )).sum(:price)
    @a18_40ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012, 1) )).sum(:price)

    @a18_40ma_da = Date.new(2018,10, 2).tuesday?
    @a18_40ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012, 2)..Date.new(2018,012, 2) )).sum(:price)
    @a18_40ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012, 2)..Date.new(2018,012, 2) )).sum(:price)
    @a18_40ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012, 2)..Date.new(2018,012, 2) )).sum(:price)

    @a18_40mi_da = Date.new(2018,10, 3).wednesday?
    @a18_40mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012, 3)..Date.new(2018,012, 3) )).sum(:price)
    @a18_40mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012, 3)..Date.new(2018,012, 3) )).sum(:price)
    @a18_40mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012, 3)..Date.new(2018,012, 3) )).sum(:price)

    @a18_40ju_da = Date.new(2018,10, 4).thursday?
    @a18_40ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012, 4)..Date.new(2018,012, 4) )).sum(:price)
    @a18_40ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012, 4)..Date.new(2018,012, 4) )).sum(:price)
    @a18_40ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012, 4)..Date.new(2018,012, 4) )).sum(:price)

    @a18_40vi_da = Date.new(2018,10, 5).friday?
    @a18_40vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012, 5)..Date.new(2018,012, 5) )).sum(:price)
    @a18_40vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012, 5)..Date.new(2018,012, 5) )).sum(:price)
    @a18_40vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012, 5)..Date.new(2018,012, 5) )).sum(:price)

    @a18_40sa_da = Date.new(2018,10, 6).saturday?
    @a18_40sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012, 6)..Date.new(2018,012, 6) )).sum(:price)
    @a18_40sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012, 6)..Date.new(2018,012, 6) )).sum(:price)
    @a18_40sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012, 6)..Date.new(2018,012, 6) )).sum(:price)
    # N° Subt A18-10 / W40
    @a18_40_10mv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012, 6) )).sum(:price)
    @a18_40_10mv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012, 6) )).sum(:price)
    @a18_40_10mv_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012, 6) )).sum(:price)
    # A18-10 / W40
    @a18_40mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,30)..Date.new(2018,012, 6) )).sum(:price)
    @a18_40mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,30)..Date.new(2018,012, 6) )).sum(:price)
    @a18_40mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,30)..Date.new(2018,012, 6) )).sum(:price)

    # ***  Sep 2018  ***
    # A18-09 / W40
    @a18_40dm_da = Date.new(2018, 9,30).sunday?
    @a18_40dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,30)..Date.new(2018,011,30) )).sum(:price)
    @a18_40dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,30)..Date.new(2018,011,30) )).sum(:price)
    @a18_40dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,30)..Date.new(2018,011,30) )).sum(:price)
    # N° Subt A18-09 / W40
    @a18_40_09mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,30)..Date.new(2018,011,30) )).sum(:price)
    @a18_40_09mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,30)..Date.new(2018,011,30) )).sum(:price)
    @a18_40_09mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,30)..Date.new(2018,011,30) )).sum(:price)

    # A18-09 / W39
    @a18_39dm_da = Date.new(2018, 9,23).sunday?
    @a18_39dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,23)..Date.new(2018,011,23) )).sum(:price)
    @a18_39dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,23)..Date.new(2018,011,23) )).sum(:price)
    @a18_39dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,23)..Date.new(2018,011,23) )).sum(:price)

    @a18_39ln_da = Date.new(2018, 9,24).monday?
    @a18_39ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,24)..Date.new(2018,011,24) )).sum(:price)
    @a18_39ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,24)..Date.new(2018,011,24) )).sum(:price)
    @a18_39ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,24)..Date.new(2018,011,24) )).sum(:price)

    @a18_39ma_da = Date.new(2018, 9,25).tuesday?
    @a18_39ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,25)..Date.new(2018,011,25) )).sum(:price)
    @a18_39ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,25)..Date.new(2018,011,25) )).sum(:price)
    @a18_39ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,25)..Date.new(2018,011,25) )).sum(:price)

    @a18_39mi_da = Date.new(2018, 9,26).wednesday?
    @a18_39mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,26)..Date.new(2018,011,26) )).sum(:price)
    @a18_39mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,26)..Date.new(2018,011,26) )).sum(:price)
    @a18_39mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,26)..Date.new(2018,011,26) )).sum(:price)

    @a18_39ju_da = Date.new(2018, 9,27).thursday?
    @a18_39ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,27)..Date.new(2018,011,27) )).sum(:price)
    @a18_39ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,27)..Date.new(2018,011,27) )).sum(:price)
    @a18_39ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,27)..Date.new(2018,011,27) )).sum(:price)

    @a18_39vi_da = Date.new(2018, 9,28).friday?
    @a18_39vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,28)..Date.new(2018,011,28) )).sum(:price)
    @a18_39vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,28)..Date.new(2018,011,28) )).sum(:price)
    @a18_39vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,28)..Date.new(2018,011,28) )).sum(:price)

    @a18_39sa_da = Date.new(2018, 9,29).saturday?
    @a18_39sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,29)..Date.new(2018,011,29) )).sum(:price)
    @a18_39sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,29)..Date.new(2018,011,29) )).sum(:price)
    @a18_39sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,29)..Date.new(2018,011,29) )).sum(:price)
    # A18-09 / W39
    @a18_39mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,23)..Date.new(2018,011,29) )).sum(:price)
    @a18_39mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,23)..Date.new(2018,011,29) )).sum(:price)
    @a18_39mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,23)..Date.new(2018,011,29) )).sum(:price)

    # A18-09 / W38
    @a18_38dm_da = Date.new(2018, 9,16).sunday?
    @a18_38dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,16)..Date.new(2018,011,16) )).sum(:price)
    @a18_38dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,16)..Date.new(2018,011,16) )).sum(:price)
    @a18_38dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,16)..Date.new(2018,011,16) )).sum(:price)

    @a18_38ln_da = Date.new(2018, 9,17).monday?
    @a18_38ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,17)..Date.new(2018,011,17) )).sum(:price)
    @a18_38ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,17)..Date.new(2018,011,17) )).sum(:price)
    @a18_38ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,17)..Date.new(2018,011,17) )).sum(:price)

    @a18_38ma_da = Date.new(2018, 9,18).tuesday?
    @a18_38ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,18)..Date.new(2018,011,18) )).sum(:price)
    @a18_38ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,18)..Date.new(2018,011,18) )).sum(:price)
    @a18_38ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,18)..Date.new(2018,011,18) )).sum(:price)

    @a18_38mi_da = Date.new(2018, 9,19).wednesday?
    @a18_38mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,19)..Date.new(2018,011,19) )).sum(:price)
    @a18_38mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,19)..Date.new(2018,011,19) )).sum(:price)
    @a18_38mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,19)..Date.new(2018,011,19) )).sum(:price)

    @a18_38ju_da = Date.new(2018, 9,20).thursday?
    @a18_38ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,20)..Date.new(2018,011,20) )).sum(:price)
    @a18_38ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,20)..Date.new(2018,011,20) )).sum(:price)
    @a18_38ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,20)..Date.new(2018,011,20) )).sum(:price)

    @a18_38vi_da = Date.new(2018, 9,21).friday?
    @a18_38vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,21)..Date.new(2018,011,21) )).sum(:price)
    @a18_38vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,21)..Date.new(2018,011,21) )).sum(:price)
    @a18_38vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,21)..Date.new(2018,011,21) )).sum(:price)

    @a18_38sa_da = Date.new(2018, 9,22).saturday?
    @a18_38sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,22)..Date.new(2018,011,22) )).sum(:price)
    @a18_38sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,22)..Date.new(2018,011,22) )).sum(:price)
    @a18_38sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,22)..Date.new(2018,011,22) )).sum(:price)
    # A18-09 / W38
    @a18_38mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,16)..Date.new(2018,011,22) )).sum(:price)
    @a18_38mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,16)..Date.new(2018,011,22) )).sum(:price)
    @a18_38mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,16)..Date.new(2018,011,22) )).sum(:price)

    # A18-09 / W37
    @a18_37dm_da = Date.new(2018, 9, 9).sunday?
    @a18_37dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 9)..Date.new(2018,011, 9) )).sum(:price)
    @a18_37dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 9)..Date.new(2018,011, 9) )).sum(:price)
    @a18_37dm_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 9)..Date.new(2018,011, 9) )).sum(:price)

    @a18_37ln_da = Date.new(2018, 9,10).monday?
    @a18_37ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,10)..Date.new(2018,011,10) )).sum(:price)
    @a18_37ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,10)..Date.new(2018,011,10) )).sum(:price)
    @a18_37ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,10)..Date.new(2018,011,10) )).sum(:price)

    @a18_37ma_da = Date.new(2018, 9,11).tuesday?
    @a18_37ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,11)..Date.new(2018,011,11) )).sum(:price)
    @a18_37ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,11)..Date.new(2018,011,11) )).sum(:price)
    @a18_37ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,11)..Date.new(2018,011,11) )).sum(:price)

    @a18_37mi_da = Date.new(2018, 9,12).wednesday?
    @a18_37mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,12)..Date.new(2018,011,12) )).sum(:price)
    @a18_37mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,12)..Date.new(2018,011,12) )).sum(:price)
    @a18_37mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,12)..Date.new(2018,011,12) )).sum(:price)

    @a18_37ju_da = Date.new(2018, 9,13).thursday?
    @a18_37ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,13)..Date.new(2018,011,13) )).sum(:price)
    @a18_37ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,13)..Date.new(2018,011,13) )).sum(:price)
    @a18_37ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,13)..Date.new(2018,011,13) )).sum(:price)

    @a18_37vi_da = Date.new(2018, 9,14).friday?
    @a18_37vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,14)..Date.new(2018,011,14) )).sum(:price)
    @a18_37vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,14)..Date.new(2018,011,14) )).sum(:price)
    @a18_37vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,14)..Date.new(2018,011,14) )).sum(:price)

    @a18_37sa_da = Date.new(2018, 9,15).saturday?
    @a18_37sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,15)..Date.new(2018,011,15) )).sum(:price)
    @a18_37sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,15)..Date.new(2018,011,15) )).sum(:price)
    @a18_37sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,15)..Date.new(2018,011,15) )).sum(:price)
    # A18-09 / W37
    @a18_37mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 9)..Date.new(2018,011,15) )).sum(:price)
    @a18_37mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 9)..Date.new(2018,011,15) )).sum(:price)
    @a18_37mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 9)..Date.new(2018,011,15) )).sum(:price)

    # A18-09 / W36
    @date_a18_36dm = Date.new(2018, 9, 2).sunday?
    @a18_36dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 2)..Date.new(2018,011, 2) )).sum(:price)
    @a18_36dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 2)..Date.new(2018,011, 2) )).sum(:price)
    @a18_36dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 2)..Date.new(2018,011, 2) )).sum(:price)

    @a18_36ln_da = Date.new(2018, 9, 3).monday?
    @a18_36ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 3)..Date.new(2018,011, 3) )).sum(:price)
    @a18_36ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 3)..Date.new(2018,011, 3) )).sum(:price)
    @a18_36ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 3)..Date.new(2018,011, 3) )).sum(:price)

    @a18_36ma_da = Date.new(2018, 9, 4).tuesday?
    @a18_36ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 4)..Date.new(2018,011, 4) )).sum(:price)
    @a18_36ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 4)..Date.new(2018,011, 4) )).sum(:price)
    @a18_36ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 4)..Date.new(2018,011, 4) )).sum(:price)

    @a18_36mi_da = Date.new(2018, 9, 5).wednesday?
    @a18_36mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 5)..Date.new(2018,011, 5) )).sum(:price)
    @a18_36mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 5)..Date.new(2018,011, 5) )).sum(:price)
    @a18_36mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 5)..Date.new(2018,011, 5) )).sum(:price)

    @a18_36ju_da = Date.new(2018, 9, 6).thursday?
    @a18_36ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 6)..Date.new(2018,011, 6) )).sum(:price)
    @a18_36ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 6)..Date.new(2018,011, 6) )).sum(:price)
    @a18_36ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 6)..Date.new(2018,011, 6) )).sum(:price)

    @a18_36vi_da = Date.new(2018, 9, 7).friday?
    @a18_36vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 7)..Date.new(2018,011, 7) )).sum(:price)
    @a18_36vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 7)..Date.new(2018,011, 7) )).sum(:price)
    @a18_36vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 7)..Date.new(2018,011, 7) )).sum(:price)

    @a18_36sa_da = Date.new(2018, 9, 8).saturday?
    @a18_36sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 8)..Date.new(2018,011, 8) )).sum(:price)
    @a18_36sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 8)..Date.new(2018,011, 8) )).sum(:price)
    @a18_36sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 8)..Date.new(2018,011, 8) )).sum(:price)
    # A18-09 / W36
    @a18_36mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 2)..Date.new(2018,011, 8) )).sum(:price)
    @a18_36mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 2)..Date.new(2018,011, 8) )).sum(:price)
    @a18_36mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 2)..Date.new(2018,011, 8) )).sum(:price)


    # A18-09 / W35
    @date_a18_35sa = Date.new(2018, 9, 1).saturday?
    @a18_35sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011, 1) )).sum(:price)
    @a18_35sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011, 1) )).sum(:price)
    @a18_35sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011, 1) )).sum(:price)
    # A18-09 / W35
    @a18_35_09mv_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011, 1) )).sum(:price)
    @a18_35_09mv_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011, 1) )).sum(:price)
    @a18_35_09mv_pj=Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011, 1) )).sum(:price)
    # A18-08/09 / W35
    @a18_35mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,26)..Date.new(2018,011, 1) )).sum(:price)
    @a18_35mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,26)..Date.new(2018,011, 1) )).sum(:price)
    @a18_35mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,26)..Date.new(2018,011, 1) )).sum(:price)


    # A18-08 / W35
    @date_a18_35dm = Date.new(2018, 8,26).sunday?
    @a18_35dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,26)..Date.new(2018,010,26) )).sum(:price)
    @a18_35dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,26)..Date.new(2018,010,26) )).sum(:price)
    @a18_35dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,26)..Date.new(2018,010,26) )).sum(:price)

    @date_a18_35ln = Date.new(2018, 8,27).monday?
    @a18_35ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,27)..Date.new(2018,010,27) )).sum(:price)
    @a18_35ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,27)..Date.new(2018,010,27) )).sum(:price)
    @a18_35ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,27)..Date.new(2018,010,27) )).sum(:price)

    @date_a18_35ma = Date.new(2018, 8,28).tuesday?
    @a18_35ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,28)..Date.new(2018,010,28) )).sum(:price)
    @a18_35ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,28)..Date.new(2018,010,28) )).sum(:price)
    @a18_35ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,28)..Date.new(2018,010,28) )).sum(:price)

    @date_a18_35mi = Date.new(2018, 8,29).wednesday?
    @a18_35mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,29)..Date.new(2018,010,29) )).sum(:price)
    @a18_35mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,29)..Date.new(2018,010,29) )).sum(:price)
    @a18_35mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,29)..Date.new(2018,010,29) )).sum(:price)

    @date_a18_35ju = Date.new(2018, 8,30).thursday?
    @a18_35ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,30)..Date.new(2018,010,30) )).sum(:price)
    @a18_35ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,30)..Date.new(2018,010,30) )).sum(:price)
    @a18_35ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,30)..Date.new(2018,010,30) )).sum(:price)

    @date_a18_35vi = Date.new(2018, 8,31).friday?
    @a18_35vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,31)..Date.new(2018,010,31) )).sum(:price)
    @a18_35vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,31)..Date.new(2018,010,31) )).sum(:price)
    @a18_35vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,31)..Date.new(2018,010,31) )).sum(:price)
    # N° Semana A18-08 / W31
    @a18_35_08mv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,26)..Date.new(2018,010,31) )).sum(:price)
    @a18_35_08mv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,26)..Date.new(2018,010,31) )).sum(:price)
    @a18_35_08mv_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,26)..Date.new(2018,010,31) )).sum(:price)


    # N° Semana A18-08 / W34
    @date_a18_34dm = Date.new(2018, 8,19).sunday?
    @a18_34dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,19)..Date.new(2018,010,19) )).sum(:price)
    @a18_34dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,19)..Date.new(2018,010,19) )).sum(:price)
    @a18_34dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,19)..Date.new(2018,010,19) )).sum(:price)

    @date_a18_34ln = Date.new(2018, 8,20).monday?
    @a18_34ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,20)..Date.new(2018,010,20) )).sum(:price)
    @a18_34ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,20)..Date.new(2018,010,20) )).sum(:price)
    @a18_34ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,20)..Date.new(2018,010,20) )).sum(:price)

    @date_a18_34ma = Date.new(2018, 8,21).tuesday?
    @a18_34ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,21)..Date.new(2018,010,21) )).sum(:price)
    @a18_34ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,21)..Date.new(2018,010,21) )).sum(:price)
    @a18_34ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,21)..Date.new(2018,010,21) )).sum(:price)

    @date_a18_34mi = Date.new(2018, 8,22).wednesday?
    @a18_34mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,22)..Date.new(2018,010,22) )).sum(:price)
    @a18_34mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,22)..Date.new(2018,010,22) )).sum(:price)
    @a18_34mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,22)..Date.new(2018,010,22) )).sum(:price)

    @date_a18_34ju = Date.new(2018, 8,23).thursday?
    @a18_34ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,23)..Date.new(2018,010,23) )).sum(:price)
    @a18_34ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,23)..Date.new(2018,010,23) )).sum(:price)
    @a18_34ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,23)..Date.new(2018,010,23) )).sum(:price)

    @date_a18_34vi = Date.new(2018, 8,24).friday?
    @a18_34vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,24)..Date.new(2018,010,24) )).sum(:price)
    @a18_34vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,24)..Date.new(2018,010,24) )).sum(:price)
    @a18_34vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,24)..Date.new(2018,010,24) )).sum(:price)

    @date_a18_34sa = Date.new(2018, 8,25).saturday?
    @a18_34sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,25)..Date.new(2018,010,25) )).sum(:price)
    @a18_34sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,25)..Date.new(2018,010,25) )).sum(:price)
    @a18_34sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,25)..Date.new(2018,010,25) )).sum(:price)
    # N° Semana A18-08 / W34
    @a18_34mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,19)..Date.new(2018,010,25) )).sum(:price)
    @a18_34mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,19)..Date.new(2018,010,25) )).sum(:price)
    @a18_34mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,19)..Date.new(2018,010,25) )).sum(:price)

    # N° Semana A18-08 / W33
    @date_a18_33dm = Date.new(2018, 8,12).sunday?
    @a18_33dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,12)..Date.new(2018,010,12) )).sum(:price)
    @a18_33dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,12)..Date.new(2018,010,12) )).sum(:price)
    @a18_33dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,12)..Date.new(2018,010,12) )).sum(:price)

    @date_a18_33ln = Date.new(2018, 8,13).monday?
    @a18_33ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,13)..Date.new(2018,010,13) )).sum(:price)
    @a18_33ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,13)..Date.new(2018,010,13) )).sum(:price)
    @a18_33ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,13)..Date.new(2018,010,13) )).sum(:price)

    @date_a18_33ma = Date.new(2018, 8,14).tuesday?
    @a18_33ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,14)..Date.new(2018,010,14) )).sum(:price)
    @a18_33ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,14)..Date.new(2018,010,14) )).sum(:price)
    @a18_33ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,14)..Date.new(2018,010,14) )).sum(:price)

    @date_a18_33mi = Date.new(2018, 8,15).wednesday?
    @a18_33mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,15)..Date.new(2018,010,15) )).sum(:price)
    @a18_33mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,15)..Date.new(2018,010,15) )).sum(:price)
    @a18_33mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,15)..Date.new(2018,010,15) )).sum(:price)

    @date_a18_33ju = Date.new(2018, 8,16).thursday?
    @a18_33ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,16)..Date.new(2018,010,16) )).sum(:price)
    @a18_33ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,16)..Date.new(2018,010,16) )).sum(:price)
    @a18_33ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,16)..Date.new(2018,010,16) )).sum(:price)

    @date_a18_33vi = Date.new(2018, 8,17).friday?
    @a18_33vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,17)..Date.new(2018,010,17) )).sum(:price)
    @a18_33vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,17)..Date.new(2018,010,17) )).sum(:price)
    @a18_33vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,17)..Date.new(2018,010,17) )).sum(:price)

    @date_a18_33sa = Date.new(2018, 8,18).saturday?
    @a18_33sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,18)..Date.new(2018,010,18) )).sum(:price)
    @a18_33sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,18)..Date.new(2018,010,18) )).sum(:price)
    @a18_33sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,18)..Date.new(2018,010,18) )).sum(:price)
    # N° Semana A18-08 / W33
    @a18_33mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,12)..Date.new(2018,010,18) )).sum(:price)
    @a18_33mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,12)..Date.new(2018,010,18) )).sum(:price)
    @a18_33mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,12)..Date.new(2018,010,18) )).sum(:price)

    # N° Semana A18-08 / W32
    @date_a18_32dm = Date.new(2018, 8, 5).sunday?
    @a18_32dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010, 5)..Date.new(2018,010, 5) )).sum(:price)
    @a18_32dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010, 5)..Date.new(2018,010, 5) )).sum(:price)
    @a18_32dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010, 5)..Date.new(2018,010, 5) )).sum(:price)

    @date_a18_32ln = Date.new(2018, 8, 6).monday?
    @a18_32ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010, 6)..Date.new(2018,010, 6) )).sum(:price)
    @a18_32ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010, 6)..Date.new(2018,010, 6) )).sum(:price)
    @a18_32ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010, 6)..Date.new(2018,010, 6) )).sum(:price)

    @date_a18_32ma = Date.new(2018, 8, 7).tuesday?
    @a18_32ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010, 7)..Date.new(2018,010, 7) )).sum(:price)
    @a18_32ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010, 7)..Date.new(2018,010, 7) )).sum(:price)
    @a18_32ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010, 7)..Date.new(2018,010, 7) )).sum(:price)

    @date_a18_32mi = Date.new(2018, 8, 8).wednesday?
    @a18_32mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010, 8)..Date.new(2018,010, 8) )).sum(:price)
    @a18_32mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010, 8)..Date.new(2018,010, 8) )).sum(:price)
    @a18_32mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010, 8)..Date.new(2018,010, 8) )).sum(:price)

    @date_a18_32ju = Date.new(2018, 8, 9).thursday?
    @a18_32ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010, 9)..Date.new(2018,010, 9) )).sum(:price)
    @a18_32ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010, 9)..Date.new(2018,010, 9) )).sum(:price)
    @a18_32ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010, 9)..Date.new(2018,010, 9) )).sum(:price)

    @date_a18_32vi = Date.new(2018, 8,10).friday?
    @a18_32vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,10)..Date.new(2018,010,10) )).sum(:price)
    @a18_32vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,10)..Date.new(2018,010,10) )).sum(:price)
    @a18_32vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,10)..Date.new(2018,010,10) )).sum(:price)

    @date_a18_32sa = Date.new(2018, 8,11).saturday?
    @a18_32sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,11)..Date.new(2018,010,11) )).sum(:price)
    @a18_32sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,11)..Date.new(2018,010,11) )).sum(:price)
    @a18_32sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,11)..Date.new(2018,010,11) )).sum(:price)
    # N° Semana A18-08 / W32
    @a18_32mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010, 5)..Date.new(2018,010,11) )).sum(:price)
    @a18_32mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010, 5)..Date.new(2018,010,11) )).sum(:price)
    @a18_32mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010, 5)..Date.new(2018,010,11) )).sum(:price)

    # N° Semana A18-08 / W31
    @date_a18_31mi = Date.new(2018, 8, 1).wednesday?
    @a18_31mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010, 1) )).sum(:price)
    @a18_31mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010, 1) )).sum(:price)
    @a18_31mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010, 1) )).sum(:price)

    @date_a18_31ju = Date.new(2018, 8, 2).thursday?
    @a18_31ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010, 2)..Date.new(2018,010, 2) )).sum(:price)
    @a18_31ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010, 2)..Date.new(2018,010, 2) )).sum(:price)
    @a18_31ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010, 2)..Date.new(2018,010, 2) )).sum(:price)

    @date_a18_31vi = Date.new(2018, 8, 3).friday?
    @a18_31vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010, 3)..Date.new(2018,010, 3) )).sum(:price)
    @a18_31vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010, 3)..Date.new(2018,010, 3) )).sum(:price)
    @a18_31vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010, 3)..Date.new(2018,010, 3) )).sum(:price)

    @date_a18_31sa = Date.new(2018, 8, 4).saturday?
    @a18_31sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010, 4)..Date.new(2018,010, 4) )).sum(:price)
    @a18_31sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010, 4)..Date.new(2018,010, 4) )).sum(:price)
    @a18_31sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010, 4)..Date.new(2018,010, 4) )).sum(:price)
    # N° Semana A18-08 / W31
    @a18_31_08mv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010, 4) )).sum(:price)
    @a18_31_08mv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010, 4) )).sum(:price)
    @a18_31_08mv_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010, 4) )).sum(:price)
    # N° Semana A18-08 / W31
    @a18_31mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,29)..Date.new(2018,010, 4) )).sum(:price)
    @a18_31mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,29)..Date.new(2018,010, 4) )).sum(:price)
    @a18_31mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,29)..Date.new(2018,010, 4) )).sum(:price)


    # N° Semana A18-07 / W31
    @date_a18_31dm = Date.new(2018, 7,29).sunday?
    @a18_31dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,29)..Date.new(2018, 7,29) )).sum(:price)
    @a18_31dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,29)..Date.new(2018, 7,29) )).sum(:price)
    @a18_31dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,29)..Date.new(2018, 7,29) )).sum(:price)

    @date_a18_31ln = Date.new(2018, 7,30).monday?
    @a18_31ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,30)..Date.new(2018, 7,30) )).sum(:price)
    @a18_31ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,30)..Date.new(2018, 7,30) )).sum(:price)
    @a18_31ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,30)..Date.new(2018, 7,30) )).sum(:price)

    @date_a18_31ma = Date.new(2018, 7,31).tuesday?
    @a18_31ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,31)..Date.new(2018, 7,31) )).sum(:price)
    @a18_31ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,31)..Date.new(2018, 7,31) )).sum(:price)
    @a18_31ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,31)..Date.new(2018, 7,31) )).sum(:price)
    # N° Semana A18-07 / W31
    @a18_31_07mv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,29)..Date.new(2018, 7,31) )).sum(:price)
    @a18_31_07mv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,29)..Date.new(2018, 7,31) )).sum(:price)
    @a18_31_07mv_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,29)..Date.new(2018, 7,31) )).sum(:price)


    # N° Semana A18-07 / W30
    @date_a18_30dm = Date.new(2018, 7,22).sunday?
    @a18_30dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,22)..Date.new(2018, 7,22) )).sum(:price)
    @a18_30dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,22)..Date.new(2018, 7,22) )).sum(:price)
    @a18_30dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,22)..Date.new(2018, 7,22) )).sum(:price)

    @date_a18_30ln = Date.new(2018, 7,23).monday?
    @a18_30ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,23)..Date.new(2018, 7,23) )).sum(:price)
    @a18_30ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,23)..Date.new(2018, 7,23) )).sum(:price)
    @a18_30ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,23)..Date.new(2018, 7,23) )).sum(:price)

    @date_a18_30ma = Date.new(2018, 7,24).tuesday?
    @a18_30ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,24)..Date.new(2018, 7,24) )).sum(:price)
    @a18_30ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,24)..Date.new(2018, 7,24) )).sum(:price)
    @a18_30ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,24)..Date.new(2018, 7,24) )).sum(:price)

    @date_a18_30mi = Date.new(2018, 7,25).wednesday?
    @a18_30mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,25)..Date.new(2018, 7,25) )).sum(:price)
    @a18_30mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,25)..Date.new(2018, 7,25) )).sum(:price)
    @a18_30mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,25)..Date.new(2018, 7,25) )).sum(:price)

    @date_a18_30ju = Date.new(2018, 7,26).thursday?
    @a18_30ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,26)..Date.new(2018, 7,26) )).sum(:price)
    @a18_30ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,26)..Date.new(2018, 7,26) )).sum(:price)
    @a18_30ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,26)..Date.new(2018, 7,26) )).sum(:price)

    @date_a18_30vi = Date.new(2018, 7,27).friday?
    @a18_30vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,27)..Date.new(2018, 7,27) )).sum(:price)
    @a18_30vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,27)..Date.new(2018, 7,27) )).sum(:price)
    @a18_30vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,27)..Date.new(2018, 7,27) )).sum(:price)

    @date_a18_30sa = Date.new(2018, 7,28).saturday?
    @a18_30sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,28)..Date.new(2018, 7,28) )).sum(:price)
    @a18_30sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,28)..Date.new(2018, 7,28) )).sum(:price)
    @a18_30sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,28)..Date.new(2018, 7,28) )).sum(:price)
    # N° Semana A18-07 / W30
    @a18_30mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,22)..Date.new(2018, 7,28) )).sum(:price)
    @a18_30mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,22)..Date.new(2018, 7,28) )).sum(:price)
    @a18_30mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,22)..Date.new(2018, 7,28) )).sum(:price)

    # N° Semana A18-07 / W29
    @date_a18_29dm = Date.new(2018, 7,15).sunday?
    @a18_29dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,15)..Date.new(2018, 7,15) )).sum(:price)
    @a18_29dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,15)..Date.new(2018, 7,15) )).sum(:price)
    @a18_29dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,15)..Date.new(2018, 7,15) )).sum(:price)

    @date_a18_29ln = Date.new(2018, 7,16).monday?
    @a18_29ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,16)..Date.new(2018, 7,16) )).sum(:price)
    @a18_29ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,16)..Date.new(2018, 7,16) )).sum(:price)
    @a18_29ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,16)..Date.new(2018, 7,16) )).sum(:price)

    @date_a18_29ma = Date.new(2018, 7,17).tuesday?
    @a18_29ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,17)..Date.new(2018, 7,17) )).sum(:price)
    @a18_29ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,17)..Date.new(2018, 7,17) )).sum(:price)
    @a18_29ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,17)..Date.new(2018, 7,17) )).sum(:price)

    @date_a18_29mi = Date.new(2018, 7,18).wednesday?
    @a18_29mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,18)..Date.new(2018, 7,18) )).sum(:price)
    @a18_29mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,18)..Date.new(2018, 7,18) )).sum(:price)
    @a18_29mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,18)..Date.new(2018, 7,18) )).sum(:price)

    @date_a18_29ju = Date.new(2018, 7,19).thursday?
    @a18_29ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,19)..Date.new(2018, 7,19) )).sum(:price)
    @a18_29ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,19)..Date.new(2018, 7,19) )).sum(:price)
    @a18_29ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,19)..Date.new(2018, 7,19) )).sum(:price)

    @date_a18_29vi = Date.new(2018, 7,20).friday?
    @a18_29vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,20)..Date.new(2018, 7,20) )).sum(:price)
    @a18_29vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,20)..Date.new(2018, 7,20) )).sum(:price)
    @a18_29vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,20)..Date.new(2018, 7,20) )).sum(:price)

    @date_a18_29sa = Date.new(2018, 7,21).saturday?
    @a18_29sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,21)..Date.new(2018, 7,21) )).sum(:price)
    @a18_29sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,21)..Date.new(2018, 7,21) )).sum(:price)
    @a18_29sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,21)..Date.new(2018, 7,21) )).sum(:price)
    # N° Semana A18-07 / W29
    @a18_29mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,15)..Date.new(2018, 7,21) )).sum(:price)
    @a18_29mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,15)..Date.new(2018, 7,21) )).sum(:price)
    @a18_29mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,15)..Date.new(2018, 7,21) )).sum(:price)

    # N° Semana A18-07 / W28
    @date_a18_28dm = Date.new(2018, 7, 8).sunday?
    @a18_28dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7, 8)..Date.new(2018, 7, 8) )).sum(:price)
    @a18_28dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7, 8)..Date.new(2018, 7, 8) )).sum(:price)
    @a18_28dm_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 7, 8)..Date.new(2018, 7, 8) )).sum(:price)

    @date_a18_28ln = Date.new(2018, 7, 9).monday?
    @a18_28ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7, 9)..Date.new(2018, 7, 9) )).sum(:price)
    @a18_28ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7, 9)..Date.new(2018, 7, 9) )).sum(:price)
    @a18_28ln_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 7, 9)..Date.new(2018, 7, 9) )).sum(:price)

    @date_a18_28ma = Date.new(2018, 7,10).tuesday?
    @a18_28ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,10)..Date.new(2018, 7,10) )).sum(:price)
    @a18_28ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,10)..Date.new(2018, 7,10) )).sum(:price)
    @a18_28ma_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 7,10)..Date.new(2018, 7,10) )).sum(:price)

    @date_a18_28mi = Date.new(2018, 7,11).wednesday?
    @a18_28mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,11)..Date.new(2018, 7,11) )).sum(:price)
    @a18_28mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,11)..Date.new(2018, 7,11) )).sum(:price)
    @a18_28mi_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 7,11)..Date.new(2018, 7,11) )).sum(:price)

    @date_a18_28ju = Date.new(2018, 7,12).thursday?
    @a18_28ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,12)..Date.new(2018, 7,12) )).sum(:price)
    @a18_28ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,12)..Date.new(2018, 7,12) )).sum(:price)
    @a18_28ju_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 7,12)..Date.new(2018, 7,12) )).sum(:price)

    @date_a18_28vi = Date.new(2018, 7,13).friday?
    @a18_28vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,13)..Date.new(2018, 7,13) )).sum(:price)
    @a18_28vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,13)..Date.new(2018, 7,13) )).sum(:price)
    @a18_28vi_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 7,13)..Date.new(2018, 7,13) )).sum(:price)

    @date_a18_28sa = Date.new(2018, 7,14).saturday?
    @a18_28sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,14)..Date.new(2018, 7,14) )).sum(:price)
    @a18_28sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,14)..Date.new(2018, 7,14) )).sum(:price)
    @a18_28sa_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 7,14)..Date.new(2018, 7,14) )).sum(:price)
    # N° Semana A18-07 / W28
    @a18_28mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7, 8)..Date.new(2018, 7,14) )).sum(:price)
    @a18_28mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7, 8)..Date.new(2018, 7,14) )).sum(:price)
    @a18_28mv_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 7, 8)..Date.new(2018, 7,14) )).sum(:price)

    # N° Semana A18-07 / W27
    @date_a18_27dm = Date.new(2018, 7, 1).sunday?
    @a18_27dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7, 1)..Date.new(2018, 7, 1) )).sum(:price)
    @a18_27dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7, 1)..Date.new(2018, 7, 1) )).sum(:price)
    @a18_27dm_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 7, 1)..Date.new(2018, 7, 1) )).sum(:price)

    @date_a18_27ln = Date.new(2018, 7, 2).monday?
    @a18_27ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7, 2)..Date.new(2018, 7, 2) )).sum(:price)
    @a18_27ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7, 2)..Date.new(2018, 7, 2) )).sum(:price)
    @a18_27ln_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 7, 2)..Date.new(2018, 7, 2) )).sum(:price)

    @date_a18_27ma = Date.new(2018, 7, 3).tuesday?
    @a18_27ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7, 3)..Date.new(2018, 7, 3) )).sum(:price)
    @a18_27ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7, 3)..Date.new(2018, 7, 3) )).sum(:price)
    @a18_27ma_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 7, 3)..Date.new(2018, 7, 3) )).sum(:price)

    @date_a18_27mi = Date.new(2018, 7, 4).wednesday?
    @a18_27mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7, 4)..Date.new(2018, 7, 4) )).sum(:price)
    @a18_27mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7, 4)..Date.new(2018, 7, 4) )).sum(:price)
    @a18_27mi_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 7, 4)..Date.new(2018, 7, 4) )).sum(:price)

    @date_a18_27ju = Date.new(2018, 7, 5).thursday?
    @a18_27ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7, 5)..Date.new(2018, 7, 5) )).sum(:price)
    @a18_27ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7, 5)..Date.new(2018, 7, 5) )).sum(:price)
    @a18_27ju_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 7, 5)..Date.new(2018, 7, 5) )).sum(:price)

    @date_a18_27vi = Date.new(2018, 7, 6).friday?
    @a18_27vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7, 6)..Date.new(2018, 7, 6) )).sum(:price)
    @a18_27vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7, 6)..Date.new(2018, 7, 6) )).sum(:price)
    @a18_27vi_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 7, 6)..Date.new(2018, 7, 6) )).sum(:price)

    @date_a18_27sa = Date.new(2018, 7, 7).saturday?
    @a18_27sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7, 7)..Date.new(2018, 7, 7) )).sum(:price)
    @a18_27sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7, 7)..Date.new(2018, 7, 7) )).sum(:price)
    @a18_27sa_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 7, 7)..Date.new(2018, 7, 7) )).sum(:price)
    # N° Semana A18-07 / W27
    @a18_27mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7, 1)..Date.new(2018, 7, 7) )).sum(:price)
    @a18_27mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7, 1)..Date.new(2018, 7, 7) )).sum(:price)
    @a18_27mv_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 7, 1)..Date.new(2018, 7, 7) )).sum(:price)

    # N° Semana A18-06 / W26
    @date_a18_26dm = Date.new(2018, 6,24).sunday?
    @a18_26dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,24)..Date.new(2018, 6,24) )).sum(:price)
    @a18_26dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,24)..Date.new(2018, 6,24) )).sum(:price)
    @a18_26dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,24)..Date.new(2018, 6,24) )).sum(:price)

    @date_a18_26ln = Date.new(2018, 6,25).monday?
    @a18_26ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,25)..Date.new(2018, 6,25) )).sum(:price)
    @a18_26ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,25)..Date.new(2018, 6,25) )).sum(:price)
    @a18_26ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,25)..Date.new(2018, 6,25) )).sum(:price)

    @date_a18_26ma = Date.new(2018, 6,26).tuesday?
    @a18_26ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,26)..Date.new(2018, 6,26) )).sum(:price)
    @a18_26ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,26)..Date.new(2018, 6,26) )).sum(:price)
    @a18_26ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,26)..Date.new(2018, 6,26) )).sum(:price)

    @date_a18_26mi = Date.new(2018, 6,27).wednesday?
    @a18_26mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,27)..Date.new(2018, 6,27) )).sum(:price)
    @a18_26mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,27)..Date.new(2018, 6,27) )).sum(:price)
    @a18_26mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,27)..Date.new(2018, 6,27) )).sum(:price)

    @date_a18_26ju = Date.new(2018, 6,28).thursday?
    @a18_26ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,28)..Date.new(2018, 6,28) )).sum(:price)
    @a18_26ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,28)..Date.new(2018, 6,28) )).sum(:price)
    @a18_26ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,28)..Date.new(2018, 6,28) )).sum(:price)

    @date_a18_26vi = Date.new(2018, 6,29).friday?
    @a18_26vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,29)..Date.new(2018, 6,29) )).sum(:price)
    @a18_26vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,29)..Date.new(2018, 6,29) )).sum(:price)
    @a18_26vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,29)..Date.new(2018, 6,29) )).sum(:price)

    @date_a18_26sa = Date.new(2018, 6,30).saturday?
    @a18_26sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,30)..Date.new(2018, 6,30) )).sum(:price)
    @a18_26sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,30)..Date.new(2018, 6,30) )).sum(:price)
    @a18_26sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,30)..Date.new(2018, 6,30) )).sum(:price)
    # N° Semana A18-06 / W26
    @a18_26mv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,24)..Date.new(2018, 6,30) )).sum(:price)
    @a18_26mv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,24)..Date.new(2018, 6,30) )).sum(:price)
    @a18_26mv_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,24)..Date.new(2018, 6,30) )).sum(:price)

    # N° Semana A18-06 / W25
    @date_a18_25dm = Date.new(2018, 6,17).sunday?
    @a18_25dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,17)..Date.new(2018, 6,17) )).sum(:price)
    @a18_25dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,17)..Date.new(2018, 6,17) )).sum(:price)
    @a18_25dm_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6,17)..Date.new(2018, 6,17) )).sum(:price)

    @date_a18_25ln = Date.new(2018, 6,18).monday?
    @a18_25ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,18)..Date.new(2018, 6,18) )).sum(:price)
    @a18_25ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,18)..Date.new(2018, 6,18) )).sum(:price)
    @a18_25ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,18)..Date.new(2018, 6,18) )).sum(:price)

    @date_a18_25ma = Date.new(2018, 6,19).tuesday?
    @a18_25ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,19)..Date.new(2018, 6,19) )).sum(:price)
    @a18_25ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,19)..Date.new(2018, 6,19) )).sum(:price)
    @a18_25ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,19)..Date.new(2018, 6,19) )).sum(:price)

    @date_a18_25mi = Date.new(2018, 6,20).wednesday?
    @a18_25mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,20)..Date.new(2018, 6,20) )).sum(:price)
    @a18_25mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,20)..Date.new(2018, 6,20) )).sum(:price)
    @a18_25mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,20)..Date.new(2018, 6,20) )).sum(:price)

    @date_a18_25ju = Date.new(2018, 6,21).thursday?
    @a18_25ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,21)..Date.new(2018, 6,21) )).sum(:price)
    @a18_25ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,21)..Date.new(2018, 6,21) )).sum(:price)
    @a18_25ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,21)..Date.new(2018, 6,21) )).sum(:price)

    @date_a18_25vi = Date.new(2018, 6,22).friday?
    @a18_25vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,22)..Date.new(2018, 6,22) )).sum(:price)
    @a18_25vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,22)..Date.new(2018, 6,22) )).sum(:price)
    @a18_25vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,22)..Date.new(2018, 6,22) )).sum(:price)

    @date_a18_25sa = Date.new(2018, 6,23).saturday?
    @a18_25sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,23)..Date.new(2018, 6,23) )).sum(:price)
    @a18_25sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,23)..Date.new(2018, 6,23) )).sum(:price)
    @a18_25sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,23)..Date.new(2018, 6,23) )).sum(:price)
    # N° Semana A18-06 / W25
    @a18_25mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,17)..Date.new(2018, 6,23) )).sum(:price)
    @a18_25mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,17)..Date.new(2018, 6,23) )).sum(:price)
    @a18_25mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,17)..Date.new(2018, 6,23) )).sum(:price)

    # N° Semana A18-06 / W24
    @date_a18_24dm = Date.new(2018, 6,10).sunday?
    @a18_24dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,10)..Date.new(2018, 6,10) )).sum(:price)
    @a18_24dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,10)..Date.new(2018, 6,10) )).sum(:price)
    @a18_24dm_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6,10)..Date.new(2018, 6,10) )).sum(:price)

    @date_a18_24ln = Date.new(2018, 6,11).monday?
    @a18_24ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,11)..Date.new(2018, 6,11) )).sum(:price)
    @a18_24ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,11)..Date.new(2018, 6,11) )).sum(:price)
    @a18_24ln_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6,11)..Date.new(2018, 6,11) )).sum(:price)

    @date_a18_24ma = Date.new(2018, 6,12).tuesday?
    @a18_24ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,12)..Date.new(2018, 6,12) )).sum(:price)
    @a18_24ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,12)..Date.new(2018, 6,12) )).sum(:price)
    @a18_24ma_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6,12)..Date.new(2018, 6,12) )).sum(:price)

    @date_a18_24mi = Date.new(2018, 6,13).wednesday?
    @a18_24mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,13)..Date.new(2018, 6,13) )).sum(:price)
    @a18_24mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,13)..Date.new(2018, 6,13) )).sum(:price)
    @a18_24mi_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6,13)..Date.new(2018, 6,13) )).sum(:price)

    @date_a18_24ju = Date.new(2018, 6,14).thursday?
    @a18_24ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,14)..Date.new(2018, 6,14) )).sum(:price)
    @a18_24ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,14)..Date.new(2018, 6,14) )).sum(:price)
    @a18_24ju_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6,14)..Date.new(2018, 6,14) )).sum(:price)

    @date_a18_24vi = Date.new(2018, 6,15).friday?
    @a18_24vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,15)..Date.new(2018, 6,15) )).sum(:price)
    @a18_24vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,15)..Date.new(2018, 6,15) )).sum(:price)
    @a18_24vi_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6,15)..Date.new(2018, 6,15) )).sum(:price)

    @date_a18_24sa = Date.new(2018, 6,16).saturday?
    @a18_24sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 6,16) )).sum(:price)
    @a18_24sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 6,16) )).sum(:price)
    @a18_24sa_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6,16)..Date.new(2018, 6,16) )).sum(:price)
    # N° Semana A18-05 / W21
    @a18_24mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,10)..Date.new(2018, 6,16) )).sum(:price)
    @a18_24mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,10)..Date.new(2018, 6,16) )).sum(:price)
    @a18_24mv_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6,10)..Date.new(2018, 6,16) )).sum(:price)

    # N° Semana A18-06 / W23
    @date_a18_23dm = Date.new(2018, 6, 3).sunday?
    @a18_23dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6, 3)..Date.new(2018, 6, 3) )).sum(:price)
    @a18_23dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6, 3)..Date.new(2018, 6, 3) )).sum(:price)
    @a18_23dm_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6, 3)..Date.new(2018, 6, 3) )).sum(:price)

    @date_a18_23ln = Date.new(2018, 6, 4).monday?
    @a18_23ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6, 4)..Date.new(2018, 6, 4) )).sum(:price)
    @a18_23ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6, 4)..Date.new(2018, 6, 4) )).sum(:price)
    @a18_23ln_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6, 4)..Date.new(2018, 6, 4) )).sum(:price)

    @date_a18_23ma = Date.new(2018, 6, 5).tuesday?
    @a18_23ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6, 5)..Date.new(2018, 6, 5) )).sum(:price)
    @a18_23ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6, 5)..Date.new(2018, 6, 5) )).sum(:price)
    @a18_23ma_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6, 5)..Date.new(2018, 6, 5) )).sum(:price)

    @date_a18_23mi = Date.new(2018, 6, 6).wednesday?
    @a18_23mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6, 6)..Date.new(2018, 6, 6) )).sum(:price)
    @a18_23mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6, 6)..Date.new(2018, 6, 6) )).sum(:price)
    @a18_23mi_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6, 6)..Date.new(2018, 6, 6) )).sum(:price)

    @date_a18_23ju = Date.new(2018, 6, 7).thursday?
    @a18_23ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6, 7)..Date.new(2018, 6, 7) )).sum(:price)
    @a18_23ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6, 7)..Date.new(2018, 6, 7) )).sum(:price)
    @a18_23ju_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6, 7)..Date.new(2018, 6, 7) )).sum(:price)

    @date_a18_23vi = Date.new(2018, 6, 8).friday?
    @a18_23vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6, 8)..Date.new(2018, 6, 8) )).sum(:price)
    @a18_23vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6, 8)..Date.new(2018, 6, 8) )).sum(:price)
    @a18_23vi_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6, 8)..Date.new(2018, 6, 8) )).sum(:price)

    @date_a18_23sa = Date.new(2018, 6, 9).saturday?
    @a18_23sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6, 9)..Date.new(2018, 6, 9) )).sum(:price)
    @a18_23sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6, 9)..Date.new(2018, 6, 9) )).sum(:price)
    @a18_23sa_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6, 9)..Date.new(2018, 6, 9) )).sum(:price)
    # N° Semana A18-06 / W23
    @a18_23mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6, 3)..Date.new(2018, 6, 9) )).sum(:price)
    @a18_23mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6, 3)..Date.new(2018, 6, 9) )).sum(:price)
    @a18_23mv_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 6, 3)..Date.new(2018, 6, 9) )).sum(:price)

    # N° Semana A18-06 / W22
    @date_a18_22vi = Date.new(2018, 6, 1).friday?
    @a18_22vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6, 1)..Date.new(2018, 6, 1) )).sum(:price)
    @a18_22vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6, 1)..Date.new(2018, 6, 1) )).sum(:price)
    @a18_22vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6, 1)..Date.new(2018, 6, 1) )).sum(:price)

    @date_a18_22sa = Date.new(2018, 6, 2).saturday?
    @a18_22sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6, 2)..Date.new(2018, 6, 2) )).sum(:price)
    @a18_22sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6, 2)..Date.new(2018, 6, 2) )).sum(:price)
    @a18_22sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6, 2)..Date.new(2018, 6, 2) )).sum(:price)
    # N° Semana A18-06 / W22
    @a18_22_06mv_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6, 1)..Date.new(2018, 6, 2) )).sum(:price)
    @a18_22_06mv_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6, 1)..Date.new(2018, 6, 2) )).sum(:price)
    @a18_22_06mv_pj=Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6, 1)..Date.new(2018, 6, 2) )).sum(:price)
    # N° Semana A18-06 / W22
    @a18_22mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,27)..Date.new(2018, 6, 2) )).sum(:price)
    @a18_22mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,27)..Date.new(2018, 6, 2) )).sum(:price)
    @a18_22mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 5,27)..Date.new(2018, 6, 2) )).sum(:price)

    # Mayo 2018
    # N° Semana A18-05 / W22
    @date_a18_22dm = Date.new(2018, 5,27).sunday?
    @a18_22dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,27)..Date.new(2018, 5,27) )).sum(:price)
    @a18_22dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,27)..Date.new(2018, 5,27) )).sum(:price)
    @a18_22dm_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5,27)..Date.new(2018, 5,27) )).sum(:price)

    @date_a18_22ln = Date.new(2018, 5,28).monday?
    @a18_22ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,28)..Date.new(2018, 5,28) )).sum(:price)
    @a18_22ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,28)..Date.new(2018, 5,28) )).sum(:price)
    @a18_22ln_pj = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5,28)..Date.new(2018, 5,28) )).sum(:price)

    @date_a18_22ma = Date.new(2018, 5,29).tuesday?
    @a18_22ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,29)..Date.new(2018, 5,29) )).sum(:price)
    @a18_22ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,29)..Date.new(2018, 5,29) )).sum(:price)
    @a18_22ma_pj = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5,29)..Date.new(2018, 5,29) )).sum(:price)

    @date_a18_22mi = Date.new(2018, 5,30).wednesday?
    @a18_22mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,30)..Date.new(2018, 5,30) )).sum(:price)
    @a18_22mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,30)..Date.new(2018, 5,30) )).sum(:price)
    @a18_22mi_pj = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5,30)..Date.new(2018, 5,30) )).sum(:price)

    @date_a18_22ju = Date.new(2018, 5,31).thursday?
    @a18_22ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,31)..Date.new(2018, 5,31) )).sum(:price)
    @a18_22ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,31)..Date.new(2018, 5,31) )).sum(:price)
    @a18_22ju_pj = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5,31)..Date.new(2018, 5,31) )).sum(:price)
    # N° Semana A18-05 / W22
    @a18_22_05mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,27)..Date.new(2018, 5,31) )).sum(:price)
    @a18_22_05mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,27)..Date.new(2018, 5,31) )).sum(:price)
    @a18_22_05mv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 5,27)..Date.new(2018, 5,31) )).sum(:price)

    # N° Semana A18-05 / W21
    @date_a18_21dm = Date.new(2018, 5,20).sunday?
    @a18_21dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,20)..Date.new(2018, 5,20) )).sum(:price)
    @a18_21dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,20)..Date.new(2018, 5,20) )).sum(:price)
    @a18_21dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 5,20)..Date.new(2018, 5,20) )).sum(:price)

    @date_a18_21ln = Date.new(2018, 5,21).monday?
    @a18_21ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,21)..Date.new(2018, 5,21) )).sum(:price)
    @a18_21ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,21)..Date.new(2018, 5,21) )).sum(:price)
    @a18_21ln_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5,21)..Date.new(2018, 5,21) )).sum(:price)

    @date_a18_21ma = Date.new(2018, 5,22).tuesday?
    @a18_21ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,22)..Date.new(2018, 5,22) )).sum(:price)
    @a18_21ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,22)..Date.new(2018, 5,22) )).sum(:price)
    @a18_21ma_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5,22)..Date.new(2018, 5,22) )).sum(:price)

    @date_a18_21mi = Date.new(2018, 5,23).wednesday?
    @a18_21mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,23)..Date.new(2018, 5,23) )).sum(:price)
    @a18_21mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,23)..Date.new(2018, 5,23) )).sum(:price)
    @a18_21mi_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5,23)..Date.new(2018, 5,23) )).sum(:price)

    @date_a18_21ju = Date.new(2018, 5,24).thursday?
    @a18_21ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,24)..Date.new(2018, 5,24) )).sum(:price)
    @a18_21ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,24)..Date.new(2018, 5,24) )).sum(:price)
    @a18_21ju_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5,24)..Date.new(2018, 5,24) )).sum(:price)

    @date_a18_21vi = Date.new(2018, 5,25).friday?
    @a18_21vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,25)..Date.new(2018, 5,25) )).sum(:price)
    @a18_21vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,25)..Date.new(2018, 5,25) )).sum(:price)
    @a18_21vi_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5,25)..Date.new(2018, 5,25) )).sum(:price)

    @date_a18_21sa = Date.new(2018, 5,26).saturday?
    @a18_21sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,26)..Date.new(2018, 5,26) )).sum(:price)
    @a18_21sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,26)..Date.new(2018, 5,26) )).sum(:price)
    @a18_21sa_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5,26)..Date.new(2018, 5,26) )).sum(:price)
    # N° Semana A18-05 / W21
    @a18_21mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,20)..Date.new(2018, 5,26) )).sum(:price)
    @a18_21mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,20)..Date.new(2018, 5,26) )).sum(:price)
    @a18_21mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 5,20)..Date.new(2018, 5,26) )).sum(:price)

    # N° Semana A18-05 / W20
    @date_a18_20dm = Date.new(2018, 5,13).sunday?
    @a18_20dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,13)..Date.new(2018, 5,13) )).sum(:price)
    @a18_20dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,13)..Date.new(2018, 5,13) )).sum(:price)
    @a18_20dm_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5,13)..Date.new(2018, 5,13) )).sum(:price)

    @date_a18_20ln = Date.new(2018, 5,14).monday?
    @a18_20ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,14)..Date.new(2018, 5,14) )).sum(:price)
    @a18_20ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,14)..Date.new(2018, 5,14) )).sum(:price)
    @a18_20ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 5,14)..Date.new(2018, 5,14) )).sum(:price)

    @date_a18_20ma = Date.new(2018, 5,15).tuesday?
    @a18_20ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,15)..Date.new(2018, 5,15) )).sum(:price)
    @a18_20ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,15)..Date.new(2018, 5,15) )).sum(:price)
    @a18_20ma_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5,15)..Date.new(2018, 5,15) )).sum(:price)

    @date_a18_20mi = Date.new(2018, 5,16).wednesday?
    @a18_20mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 5,16) )).sum(:price)
    @a18_20mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 5,16) )).sum(:price)
    @a18_20mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 5,16) )).sum(:price)

    @date_a18_20ju = Date.new(2018, 5,17).thursday?
    @a18_20ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,17)..Date.new(2018, 5,17) )).sum(:price)
    @a18_20ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,17)..Date.new(2018, 5,17) )).sum(:price)
    @a18_20ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 5,17)..Date.new(2018, 5,17) )).sum(:price)

    @date_a18_20vi = Date.new(2018, 5,18).friday?
    @a18_20vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,18)..Date.new(2018, 5,18) )).sum(:price)
    @a18_20vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,18)..Date.new(2018, 5,18) )).sum(:price)
    @a18_20vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 5,18)..Date.new(2018, 5,18) )).sum(:price)

    @date_a18_20sa = Date.new(2018, 5,19).saturday?
    @a18_20sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,19)..Date.new(2018, 5,19) )).sum(:price)
    @a18_20sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,19)..Date.new(2018, 5,19) )).sum(:price)
    @a18_20sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 5,19)..Date.new(2018, 5,19) )).sum(:price)
    # N° Semana A18-05 / A18_20
    @a18_20mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,13)..Date.new(2018, 5,19) )).sum(:price)
    @a18_20mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,13)..Date.new(2018, 5,19) )).sum(:price)
    @a18_20mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 5,13)..Date.new(2018, 5,19) )).sum(:price)

    # N° Semana A18-05 / W19
    @date_a18_19dm = Date.new(2018, 5, 6).sunday?
    @a18_19dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5, 6)..Date.new(2018, 5, 6) )).sum(:price)
    @a18_19dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5, 6)..Date.new(2018, 5, 6) )).sum(:price)
    @a18_19dm_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5, 6)..Date.new(2018, 5, 6) )).sum(:price)

    @date_a18_19ln = Date.new(2018, 5, 7).monday?
    @a18_19ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5, 7)..Date.new(2018, 5, 7) )).sum(:price)
    @a18_19ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5, 7)..Date.new(2018, 5, 7) )).sum(:price)
    @a18_19ln_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5, 7)..Date.new(2018, 5, 7) )).sum(:price)

    @date_a18_19ma = Date.new(2018, 5, 8).tuesday?
    @a18_19ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5, 8)..Date.new(2018, 5, 8) )).sum(:price)
    @a18_19ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5, 8)..Date.new(2018, 5, 8) )).sum(:price)
    @a18_19ma_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5, 8)..Date.new(2018, 5, 8) )).sum(:price)

    @date_a18_19mi = Date.new(2018, 5, 9).wednesday?
    @a18_19mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5, 9)..Date.new(2018, 5, 9) )).sum(:price)
    @a18_19mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5, 9)..Date.new(2018, 5, 9) )).sum(:price)
    @a18_19mi_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5, 9)..Date.new(2018, 5, 9) )).sum(:price)

    @date_a18_19ju = Date.new(2018, 5,10).thursday?
    @a18_19ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,10)..Date.new(2018, 5,10) )).sum(:price)
    @a18_19ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,10)..Date.new(2018, 5,10) )).sum(:price)
    @a18_19ju_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5,10)..Date.new(2018, 5,10) )).sum(:price)

    @date_a18_19vi = Date.new(2018, 5,11).friday?
    @a18_19vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,11)..Date.new(2018, 5,11) )).sum(:price)
    @a18_19vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,11)..Date.new(2018, 5,11) )).sum(:price)
    @a18_19vi_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5,11)..Date.new(2018, 5,11) )).sum(:price)

    @date_a18_19sa = Date.new(2018, 5,12).saturday?
    @a18_19sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,12)..Date.new(2018, 5,12) )).sum(:price)
    @a18_19sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,12)..Date.new(2018, 5,12) )).sum(:price)
    @a18_19sa_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5,12)..Date.new(2018, 5,12) )).sum(:price)
    # N° Semana A18-05 / W19
    @a18_19mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5, 6)..Date.new(2018, 5,12) )).sum(:price)
    @a18_19mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5, 6)..Date.new(2018, 5,12) )).sum(:price)
    @a18_19mv_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5, 6)..Date.new(2018, 5,12) )).sum(:price)

    # N° Semana A18-05 / W18
    @date_a18_18ma = Date.new(2018, 5, 1).tuesday?
    @a18_18ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5, 1)..Date.new(2018, 5, 1) )).sum(:price)
    @a18_18ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5, 1)..Date.new(2018, 5, 1) )).sum(:price)
    @a18_18ma_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5, 1)..Date.new(2018, 5, 1) )).sum(:price)

    @date_a18_18mi = Date.new(2018, 5, 2).wednesday?
    @a18_18mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5, 2)..Date.new(2018, 5, 2) )).sum(:price)
    @a18_18mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5, 2)..Date.new(2018, 5, 2) )).sum(:price)
    @a18_18mi_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5, 2)..Date.new(2018, 5, 2) )).sum(:price)

    @date_a18_18ju = Date.new(2018, 5, 3).thursday?
    @a18_18ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5, 3)..Date.new(2018, 5, 3) )).sum(:price)
    @a18_18ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5, 3)..Date.new(2018, 5, 3) )).sum(:price)
    @a18_18ju_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5, 3)..Date.new(2018, 5, 3) )).sum(:price)

    @date_a18_18vi = Date.new(2018, 5, 4).friday?
    @a18_18vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5, 4)..Date.new(2018, 5, 4) )).sum(:price)
    @a18_18vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5, 4)..Date.new(2018, 5, 4) )).sum(:price)
    @a18_18vi_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5, 4)..Date.new(2018, 5, 4) )).sum(:price)

    @date_a18_18sa = Date.new(2018, 5, 5).saturday?
    @a18_18sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5, 5)..Date.new(2018, 5, 5) )).sum(:price)
    @a18_18sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5, 5)..Date.new(2018, 5, 5) )).sum(:price)
    @a18_18sa_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5, 5)..Date.new(2018, 5, 5) )).sum(:price)
    # N° Semana A18-05 / W18 _ subt
    @a18_18_05mv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5, 1)..Date.new(2018, 5, 5) )).sum(:price)
    @a18_18_05mv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5, 1)..Date.new(2018, 5, 5) )).sum(:price)
    @a18_18_05mv_pj= Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 5, 1)..Date.new(2018, 5, 5) )).sum(:price)
    # N° Semana A18-04/05 / W18
    @a18_18mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,29)..Date.new(2018, 5, 5) )).sum(:price)
    @a18_18mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,29)..Date.new(2018, 5, 5) )).sum(:price)
    @a18_18mv_pj  = Movement.where(mov_type: 'J',mov_date: (Date.new(2018, 4,29)..Date.new(2018, 5, 5) )).sum(:price)

     # * * *  Abril  * * *
    # N° Semana A18-04 / W18
    @date_a18_18dm = Date.new(2018, 4,29).sunday?
    @a18_18dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,29)..Date.new(2018, 4,29) )).sum(:price)
    @a18_18dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,29)..Date.new(2018, 4,29) )).sum(:price)
    @a18_18dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,29)..Date.new(2018, 4,29) )).sum(:price)

    @date_a18_18ln = Date.new(2018, 4,30).monday?
    @a18_18ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,30)..Date.new(2018, 4,30) )).sum(:price)
    @a18_18ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,30)..Date.new(2018, 4,30) )).sum(:price)
    @a18_18ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,30)..Date.new(2018, 4,30) )).sum(:price)
    # N° Semana A18-04 / W18
    @a18_18_04mv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,29)..Date.new(2018, 4,30) )).sum(:price)
    @a18_18_04mv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,29)..Date.new(2018, 4,30) )).sum(:price)
    @a18_18_04mv_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,29)..Date.new(2018, 4,30) )).sum(:price)

    # N° Semana A18-04 / W17
    @a18_17dm_da = Date.new(2018, 4,22).sunday?
    @a18_17dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,22)..Date.new(2018, 4,22) )).sum(:price)
    @a18_17dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,22)..Date.new(2018, 4,22) )).sum(:price)
    @a18_17dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,22)..Date.new(2018, 4,22) )).sum(:price)

    @date_a18_17ln = Date.new(2018, 4,23).monday?
    @a18_17ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,23)..Date.new(2018, 4,23) )).sum(:price)
    @a18_17ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,23)..Date.new(2018, 4,23) )).sum(:price)
    @a18_17ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,23)..Date.new(2018, 4,23) )).sum(:price)

    @date_a18_17ma = Date.new(2018, 4,24).tuesday?
    @a18_17ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,24)..Date.new(2018, 4,24) )).sum(:price)
    @a18_17ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,24)..Date.new(2018, 4,24) )).sum(:price)
    @a18_17ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,24)..Date.new(2018, 4,24) )).sum(:price)

    @date_a18_17mi = Date.new(2018, 4,25).wednesday?
    @a18_17mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,25)..Date.new(2018, 4,25) )).sum(:price)
    @a18_17mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,25)..Date.new(2018, 4,25) )).sum(:price)
    @a18_17mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,25)..Date.new(2018, 4,25) )).sum(:price)

    @date_a18_17ju = Date.new(2018, 4,26).thursday?
    @a18_17ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,26)..Date.new(2018, 4,26) )).sum(:price)
    @a18_17ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,26)..Date.new(2018, 4,26) )).sum(:price)
    @a18_17ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,26)..Date.new(2018, 4,26) )).sum(:price)

    @date_a18_17vi = Date.new(2018, 4,27).friday?
    @a18_17vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,27)..Date.new(2018, 4,27) )).sum(:price)
    @a18_17vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,27)..Date.new(2018, 4,27) )).sum(:price)
    @a18_17vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,27)..Date.new(2018, 4,27) )).sum(:price)

    @date_a18_17sa = Date.new(2018, 4,28).saturday?
    @a18_17sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,28)..Date.new(2018, 4,28) )).sum(:price)
    @a18_17sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,28)..Date.new(2018, 4,28) )).sum(:price)
    @a18_17sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,28)..Date.new(2018, 4,28) )).sum(:price)
    # N° Semana A18-04 / W17
    @a18_17mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,22)..Date.new(2018, 4,28) )).sum(:price)
    @a18_17mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,22)..Date.new(2018, 4,28) )).sum(:price)
    @a18_17mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,22)..Date.new(2018, 4,28) )).sum(:price)


    # N° Semana A18-04 / W16
    @date_w16dm = Date.new(2018, 4,15).sunday?
    @w16dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,15)..Date.new(2018, 4,15) )).sum(:price)
    @w16dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,15)..Date.new(2018, 4,15) )).sum(:price)
    @w16dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,15)..Date.new(2018, 4,15) )).sum(:price)

    @date_w16ln = Date.new(2018, 4,16).monday?
    @w16ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 4,16) )).sum(:price)
    @w16ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 4,16) )).sum(:price)
    @w16ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 4,16) )).sum(:price)

    @date_w16ma = Date.new(2018, 4,17).tuesday?
    @w16ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,17)..Date.new(2018, 4,17) )).sum(:price)
    @w16ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,17)..Date.new(2018, 4,17) )).sum(:price)
    @w16ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,17)..Date.new(2018, 4,17) )).sum(:price)

    @date_w16mi = Date.new(2018, 4,18).wednesday?
    @w16mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,18)..Date.new(2018, 4,18) )).sum(:price)
    @w16mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,18)..Date.new(2018, 4,18) )).sum(:price)
    @w16mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,18)..Date.new(2018, 4,18) )).sum(:price)

    @date_w16ju = Date.new(2018, 4,19).thursday?
    @w16ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,19)..Date.new(2018, 4,19) )).sum(:price)
    @w16ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,19)..Date.new(2018, 4,19) )).sum(:price)
    @w16ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,19)..Date.new(2018, 4,19) )).sum(:price)

    @date_w16vi = Date.new(2018, 4,20).friday?
    @w16vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,20)..Date.new(2018, 4,20) )).sum(:price)
    @w16vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,20)..Date.new(2018, 4,20) )).sum(:price)
    @w16vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,20)..Date.new(2018, 4,20) )).sum(:price)

    @date_w16sa = Date.new(2018, 4,21).saturday?
    @w16sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,21)..Date.new(2018, 4,21) )).sum(:price)
    @w16sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,21)..Date.new(2018, 4,21) )).sum(:price)
    @w16sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,21)..Date.new(2018, 4,21) )).sum(:price)
    # N° Semana A18-04 / W16
    @w16mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,15)..Date.new(2018, 4,21) )).sum(:price)
    @w16mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,15)..Date.new(2018, 4,21) )).sum(:price)
    @w16mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,15)..Date.new(2018, 4,21) )).sum(:price)

    # N° Semana A18-04 / W15
    @date_w15dm = Date.new(2018, 4, 8).sunday?
    @w15dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4, 8)..Date.new(2018, 4, 8) )).sum(:price)
    @w15dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4, 8)..Date.new(2018, 4, 8) )).sum(:price)
    @w15dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4, 8)..Date.new(2018, 4, 8) )).sum(:price)

    @date_w15ln = Date.new(2018, 4, 9).monday?
    @w15ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4, 9)..Date.new(2018, 4, 9) )).sum(:price)
    @w15ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4, 9)..Date.new(2018, 4, 9) )).sum(:price)
    @w15ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4, 9)..Date.new(2018, 4, 9) )).sum(:price)

    @date_w15ma = Date.new(2018, 4,10).tuesday?
    @w15ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,10)..Date.new(2018, 4,10) )).sum(:price)
    @w15ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,10)..Date.new(2018, 4,10) )).sum(:price)
    @w15ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,10)..Date.new(2018, 4,10) )).sum(:price)

    @date_w15mi = Date.new(2018, 4,11).wednesday?
    @w15mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,11)..Date.new(2018, 4,11) )).sum(:price)
    @w15mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,11)..Date.new(2018, 4,11) )).sum(:price)
    @w15mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,11)..Date.new(2018, 4,11) )).sum(:price)

    @date_w15ju = Date.new(2018, 4,12).thursday?
    @w15ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,12)..Date.new(2018, 4,12) )).sum(:price)
    @w15ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,12)..Date.new(2018, 4,12) )).sum(:price)
    @w15ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,12)..Date.new(2018, 4,12) )).sum(:price)

    @date_w15vi = Date.new(2018, 4,13).friday?
    @w15vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,13)..Date.new(2018, 4,13) )).sum(:price)
    @w15vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,13)..Date.new(2018, 4,13) )).sum(:price)
    @w15vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,13)..Date.new(2018, 4,13) )).sum(:price)

    @date_w15sa = Date.new(2018, 4,14).saturday?
    @w15sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,14)..Date.new(2018, 4,14) )).sum(:price)
    @w15sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,14)..Date.new(2018, 4,14) )).sum(:price)
    @w15sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,14)..Date.new(2018, 4,14) )).sum(:price)
    # N° Semana A18-04 / W15
    @w15mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4, 8)..Date.new(2018, 4,14) )).sum(:price)
    @w15mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4, 8)..Date.new(2018, 4,14) )).sum(:price)
    @w15mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4, 8)..Date.new(2018, 4,14) )).sum(:price)

    # N° Semana A18-04 / W14
    @date_w14dm = Date.new(2018, 4, 1).sunday?
    @w14dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4, 1)..Date.new(2018, 4, 1) )).sum(:price)
    @w14dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4, 1)..Date.new(2018, 4, 1) )).sum(:price)
    @w14dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4, 1)..Date.new(2018, 4, 1) )).sum(:price)

    @date_w14ln = Date.new(2018, 4, 2).monday?
    @w14ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4, 2)..Date.new(2018, 4, 2) )).sum(:price)
    @w14ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4, 2)..Date.new(2018, 4, 2) )).sum(:price)
    @w14ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4, 2)..Date.new(2018, 4, 2) )).sum(:price)

    @date_w14ma = Date.new(2018, 4, 3).tuesday?
    @w14ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4, 3)..Date.new(2018, 4, 3) )).sum(:price)
    @w14ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4, 3)..Date.new(2018, 4, 3) )).sum(:price)
    @w14ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4, 3)..Date.new(2018, 4, 3) )).sum(:price)

    @date_w14mi = Date.new(2018, 4, 4).wednesday?
    @w14mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4, 4)..Date.new(2018, 4, 4) )).sum(:price)
    @w14mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4, 4)..Date.new(2018, 4, 4) )).sum(:price)
    @w14mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4, 4)..Date.new(2018, 4, 4) )).sum(:price)

    @date_w14ju = Date.new(2018, 4, 5).thursday?
    @w14ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4, 5)..Date.new(2018, 4, 5) )).sum(:price)
    @w14ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4, 5)..Date.new(2018, 4, 5) )).sum(:price)
    @w14ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4, 5)..Date.new(2018, 4, 5) )).sum(:price)

    @date_w14vi = Date.new(2018, 4, 6).friday?
    @w14vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4, 6)..Date.new(2018, 4, 6) )).sum(:price)
    @w14vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4, 6)..Date.new(2018, 4, 6) )).sum(:price)
    @w14vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4, 6)..Date.new(2018, 4, 6) )).sum(:price)

    @date_w14sa = Date.new(2018, 4, 7).saturday?
    @w14sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4, 7)..Date.new(2018, 4, 7) )).sum(:price)
    @w14sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4, 7)..Date.new(2018, 4, 7) )).sum(:price)
    @w14sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4, 7)..Date.new(2018, 4, 7) )).sum(:price)
    # N° Semana A18-04 / W14
    @w14mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4, 1)..Date.new(2018, 4, 7) )).sum(:price)
    @w14mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4, 1)..Date.new(2018, 4, 7) )).sum(:price)
    @w14mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4, 1)..Date.new(2018, 4, 7) )).sum(:price)


    # N° Semana A18-03 / W13
    @date_w13dm = Date.new(2018, 3,25).sunday?
    @w13dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,25)..Date.new(2018, 3,25) )).sum(:price)
    @w13dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,25)..Date.new(2018, 3,25) )).sum(:price)
    @w13dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,25)..Date.new(2018, 3,25) )).sum(:price)

    @date_w13ln = Date.new(2018, 3,26).monday?
    @w13ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,26)..Date.new(2018, 3,26) )).sum(:price)
    @w13ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,26)..Date.new(2018, 3,26) )).sum(:price)
    @w13ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,26)..Date.new(2018, 3,26) )).sum(:price)

    @date_w13ma = Date.new(2018, 3,27).tuesday?
    @w13ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,27)..Date.new(2018, 3,27) )).sum(:price)
    @w13ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,27)..Date.new(2018, 3,27) )).sum(:price)
    @w13ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,27)..Date.new(2018, 3,27) )).sum(:price)

    @date_w13mi = Date.new(2018, 3,28).wednesday?
    @w13mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,28)..Date.new(2018, 3,28) )).sum(:price)
    @w13mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,28)..Date.new(2018, 3,28) )).sum(:price)
    @w13mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,28)..Date.new(2018, 3,28) )).sum(:price)

    @date_w13ju = Date.new(2018, 3,29).thursday?
    @w13ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,29)..Date.new(2018, 3,29) )).sum(:price)
    @w13ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,29)..Date.new(2018, 3,29) )).sum(:price)
    @w13ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,29)..Date.new(2018, 3,29) )).sum(:price)

    @date_w13vi = Date.new(2018, 3,30).friday?
    @w13vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,30)..Date.new(2018, 3,30) )).sum(:price)
    @w13vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,30)..Date.new(2018, 3,30) )).sum(:price)
    @w13vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,30)..Date.new(2018, 3,30) )).sum(:price)

    @date_w13sa = Date.new(2018, 3,31).saturday?
    @w13sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,31)..Date.new(2018, 3,31) )).sum(:price)
    @w13sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,31)..Date.new(2018, 3,31) )).sum(:price)
    @w13sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,31)..Date.new(2018, 3,31) )).sum(:price)
    # N° Semana A18-03 / W13
    @a18_13mv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,25)..Date.new(2018, 3,31) )).sum(:price)
    @a18_13mv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,25)..Date.new(2018, 3,31) )).sum(:price)
    @a18_13mv_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,25)..Date.new(2018, 3,31) )).sum(:price)


    # N° Semana A18-03 / W12
    @date_w12dm = Date.new(2018, 3,18).sunday?
    @w12dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,18)..Date.new(2018, 3,18) )).sum(:price)
    @w12dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,18)..Date.new(2018, 3,18) )).sum(:price)
    @w12dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,18)..Date.new(2018, 3,18) )).sum(:price)

    @date_w12ln = Date.new(2018, 3,19).monday?
    @w12ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,19)..Date.new(2018, 3,19) )).sum(:price)
    @w12ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,19)..Date.new(2018, 3,19) )).sum(:price)
    @w12ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,19)..Date.new(2018, 3,19) )).sum(:price)

    @date_w12ma = Date.new(2018, 3,20).tuesday?
    @w12ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,20)..Date.new(2018, 3,20) )).sum(:price)
    @w12ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,20)..Date.new(2018, 3,20) )).sum(:price)
    @w12ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,20)..Date.new(2018, 3,20) )).sum(:price)

    @date_w12mi = Date.new(2018, 3,21).wednesday?
    @w12mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,21)..Date.new(2018, 3,21) )).sum(:price)
    @w12mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,21)..Date.new(2018, 3,21) )).sum(:price)
    @w12mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,21)..Date.new(2018, 3,21) )).sum(:price)

    @date_w12ju = Date.new(2018, 3,22).thursday?
    @w12ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,22)..Date.new(2018, 3,22) )).sum(:price)
    @w12ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,22)..Date.new(2018, 3,22) )).sum(:price)
    @w12ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,22)..Date.new(2018, 3,22) )).sum(:price)

    @date_w12vi = Date.new(2018, 3,23).friday?
    @w12vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,23)..Date.new(2018, 3,23) )).sum(:price)
    @w12vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,23)..Date.new(2018, 3,23) )).sum(:price)
    @w12vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,23)..Date.new(2018, 3,23) )).sum(:price)

    @date_w12sa = Date.new(2018, 3,24).saturday?
    @w12sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,24)..Date.new(2018, 3,24) )).sum(:price)
    @w12sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,24)..Date.new(2018, 3,24) )).sum(:price)
    @w12sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,24)..Date.new(2018, 3,24) )).sum(:price)
    # N° Semana A18-03 / W12
    @w12mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,18)..Date.new(2018, 3,24) )).sum(:price)
    @w12mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,18)..Date.new(2018, 3,24) )).sum(:price)
    @w12mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,18)..Date.new(2018, 3,24) )).sum(:price)


    # N° Semana A18-03 / W11
    @date_w11dm = Date.new(2018, 3,11).sunday?
    @w11dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,11)..Date.new(2018, 3,11) )).sum(:price)
    @w11dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,11)..Date.new(2018, 3,11) )).sum(:price)
    @w11dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,11)..Date.new(2018, 3,11) )).sum(:price)

    @date_w11ln = Date.new(2018, 3,12).monday?
    @w11ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,12)..Date.new(2018, 3,12) )).sum(:price)
    @w11ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,12)..Date.new(2018, 3,12) )).sum(:price)
    @w11ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,12)..Date.new(2018, 3,12) )).sum(:price)

    @date_w11ma = Date.new(2018, 3,13).tuesday?
    @w11ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,13)..Date.new(2018, 3,13) )).sum(:price)
    @w11ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,13)..Date.new(2018, 3,13) )).sum(:price)
    @w11ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,13)..Date.new(2018, 3,13) )).sum(:price)

    @date_w11mi = Date.new(2018, 3,14).wednesday?
    @w11mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,14)..Date.new(2018, 3,14) )).sum(:price)
    @w11mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,14)..Date.new(2018, 3,14) )).sum(:price)
    @w11mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,14)..Date.new(2018, 3,14) )).sum(:price)

    @date_w11ju = Date.new(2018, 3,15).thursday?
    @w11ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,15)..Date.new(2018, 3,15) )).sum(:price)
    @w11ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,15)..Date.new(2018, 3,15) )).sum(:price)
    @w11ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,15)..Date.new(2018, 3,15) )).sum(:price)

    @date_w11vi = Date.new(2018, 3,16).friday?
    @w11vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 3,16) )).sum(:price)
    @w11vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 3,16) )).sum(:price)
    @w11vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 3,16) )).sum(:price)

    @date_w11sa = Date.new(2018, 3,17).saturday?
    @w11sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,17)..Date.new(2018, 3,17) )).sum(:price)
    @w11sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,17)..Date.new(2018, 3,17) )).sum(:price)
    @w11sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,17)..Date.new(2018, 3,17) )).sum(:price)
    # N° Semana A18-03 / W11
    @w11mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,11)..Date.new(2018, 3,17) )).sum(:price)
    @w11mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,11)..Date.new(2018, 3,17) )).sum(:price)
    @w11mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,11)..Date.new(2018, 3,17) )).sum(:price)


    # N° Semana A18-03 / W10
    @date_w10dm = Date.new(2018, 3, 4).sunday?
    @w10dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3, 4)..Date.new(2018, 3, 4) )).sum(:price)
    @w10dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3, 4)..Date.new(2018, 3, 4) )).sum(:price)
    @w10dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3, 4)..Date.new(2018, 3, 4) )).sum(:price)

    @date_w10ln = Date.new(2018, 3, 5).monday?
    @w10ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3, 5)..Date.new(2018, 3, 5) )).sum(:price)
    @w10ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3, 5)..Date.new(2018, 3, 5) )).sum(:price)
    @w10ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3, 5)..Date.new(2018, 3, 5) )).sum(:price)

    @date_w10ma = Date.new(2018, 3, 6).tuesday?
    @w10ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3, 6)..Date.new(2018, 3, 6) )).sum(:price)
    @w10ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3, 6)..Date.new(2018, 3, 6) )).sum(:price)
    @w10ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3, 6)..Date.new(2018, 3, 6) )).sum(:price)

    @date_w10mi = Date.new(2018, 3, 7).wednesday?
    @w10mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3, 7)..Date.new(2018, 3, 7) )).sum(:price)
    @w10mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3, 7)..Date.new(2018, 3, 7) )).sum(:price)
    @w10mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3, 7)..Date.new(2018, 3, 7) )).sum(:price)

    @date_w10ju = Date.new(2018, 3, 8).thursday?
    @w10ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3, 8)..Date.new(2018, 3, 8) )).sum(:price)
    @w10ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3, 8)..Date.new(2018, 3, 8) )).sum(:price)
    @w10ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3, 8)..Date.new(2018, 3, 8) )).sum(:price)

    @date_w10vi = Date.new(2018, 3, 9).friday?
    @w10vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3, 9)..Date.new(2018, 3, 9) )).sum(:price)
    @w10vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3, 9)..Date.new(2018, 3, 9) )).sum(:price)
    @w10vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3, 9)..Date.new(2018, 3, 9) )).sum(:price)

    @date_w10sa = Date.new(2018, 3,10).saturday?
    @w10sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,10)..Date.new(2018, 3,10) )).sum(:price)
    @w10sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,10)..Date.new(2018, 3,10) )).sum(:price)
    @w10sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,10)..Date.new(2018, 3,10) )).sum(:price)
    # N° Semana A18-03 / W10
    @w10mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3, 4)..Date.new(2018, 3,10) )).sum(:price)
    @w10mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3, 4)..Date.new(2018, 3,10) )).sum(:price)
    @w10mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3, 4)..Date.new(2018, 3,10) )).sum(:price)

    # N° Semana A18-03 / W09
    @date_w09ju = Date.new(2018, 3, 1).thursday?
    @w09ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3, 1)..Date.new(2018, 3, 1) )).sum(:price)
    @w09ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3, 1)..Date.new(2018, 3, 1) )).sum(:price)
    @w09ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3, 1)..Date.new(2018, 3, 1) )).sum(:price)

    @date_w09vi = Date.new(2018, 3, 2).friday?
    @w09vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3, 2)..Date.new(2018, 3, 2) )).sum(:price)
    @w09vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3, 2)..Date.new(2018, 3, 2) )).sum(:price)
    @w09vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3, 2)..Date.new(2018, 3, 2) )).sum(:price)

    @date_w09sa = Date.new(2018, 3, 3).saturday?
    @w09sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3, 3)..Date.new(2018, 3, 3) )).sum(:price)
    @w09sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3, 3)..Date.new(2018, 3, 3) )).sum(:price)
    @w09sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3, 3)..Date.new(2018, 3, 3) )).sum(:price)
    # N° Semana A18-03 / W09
    @a18_09_03mv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3, 1)..Date.new(2018, 3, 3) )).sum(:price)
    @a18_09_03mv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3, 1)..Date.new(2018, 3, 3) )).sum(:price)
    @a18_09_03mv_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3, 1)..Date.new(2018, 3, 3) )).sum(:price)
    # N° Semana A18_02-03 / W09 all
    @w09mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,25)..Date.new(2018, 3, 3) )).sum(:price)
    @w09mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,25)..Date.new(2018, 3, 3) )).sum(:price)
    @w09mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,25)..Date.new(2018, 3, 3) )).sum(:price)

    # N° Semana A18-02 / W09
    @date_w09dm = Date.new(2018, 2,25).sunday?
    @w09dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,25)..Date.new(2018, 2,25) )).sum(:price)
    @w09dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,25)..Date.new(2018, 2,25) )).sum(:price)
    @w09dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,25)..Date.new(2018, 2,25) )).sum(:price)

    @date_w09ln = Date.new(2018, 2,26).monday?
    @w09ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,26)..Date.new(2018, 2,26) )).sum(:price)
    @w09ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,26)..Date.new(2018, 2,26) )).sum(:price)
    @w09ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,26)..Date.new(2018, 2,26) )).sum(:price)

    @date_w09ma = Date.new(2018, 2,27).tuesday?
    @w09ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,27)..Date.new(2018, 2,27) )).sum(:price)
    @w09ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,27)..Date.new(2018, 2,27) )).sum(:price)
    @w09ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,27)..Date.new(2018, 2,27) )).sum(:price)

    @date_w09mi = Date.new(2018, 2,28).wednesday?
    @w09mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,28)..Date.new(2018, 2,28) )).sum(:price)
    @w09mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,28)..Date.new(2018, 2,28) )).sum(:price)
    @w09mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,28)..Date.new(2018, 2,28) )).sum(:price)
    # N° Semana A18-02 / W09
    @a18_09_02mv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,25)..Date.new(2018, 2,28) )).sum(:price)
    @a18_09_02mv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,25)..Date.new(2018, 2,28) )).sum(:price)
    @a18_09_02mv_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,25)..Date.new(2018, 2,28) )).sum(:price)


    # N° Semana A18-02 / W08
    @date_w08dm = Date.new(2018, 2,18).sunday?
    @w08dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,18)..Date.new(2018, 2,18) )).sum(:price)
    @w08dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,18)..Date.new(2018, 2,18) )).sum(:price)
    @w08dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,18)..Date.new(2018, 2,18) )).sum(:price)

    @date_w08ln = Date.new(2018, 2,19).monday?
    @w08ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,19)..Date.new(2018, 2,19) )).sum(:price)
    @w08ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,19)..Date.new(2018, 2,19) )).sum(:price)
    @w08ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,19)..Date.new(2018, 2,19) )).sum(:price)

    @date_w08ma = Date.new(2018, 2,20).tuesday?
    @w08ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,20)..Date.new(2018, 2,20) )).sum(:price)
    @w08ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,20)..Date.new(2018, 2,20) )).sum(:price)
    @w08ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,20)..Date.new(2018, 2,20) )).sum(:price)

    @date_w08mi = Date.new(2018, 2,21).wednesday?
    @w08mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,21)..Date.new(2018, 2,21) )).sum(:price)
    @w08mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,21)..Date.new(2018, 2,21) )).sum(:price)
    @w08mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,21)..Date.new(2018, 2,21) )).sum(:price)

    @date_w08ju = Date.new(2018, 2,22).thursday?
    @w08ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,22)..Date.new(2018, 2,22) )).sum(:price)
    @w08ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,22)..Date.new(2018, 2,22) )).sum(:price)
    @w08ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,22)..Date.new(2018, 2,22) )).sum(:price)

    @date_w08vi = Date.new(2018, 2,23).friday?
    @w08vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,23)..Date.new(2018, 2,23) )).sum(:price)
    @w08vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,23)..Date.new(2018, 2,23) )).sum(:price)
    @w08vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,23)..Date.new(2018, 2,23) )).sum(:price)

    @date_w08sa = Date.new(2018, 2,24).saturday?
    @w08sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,24)..Date.new(2018, 2,24) )).sum(:price)
    @w08sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,24)..Date.new(2018, 2,24) )).sum(:price)
    @w08sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,24)..Date.new(2018, 2,24) )).sum(:price)
    # N° Semana A18-02 / W08
    @w08mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,18)..Date.new(2018, 2,24) )).sum(:price)
    @w08mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,18)..Date.new(2018, 2,24) )).sum(:price)
    @w08mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,18)..Date.new(2018, 2,24) )).sum(:price)


    # N° Semana A18-02 / W07
    @date_w07dm = Date.new(2018, 2,11).sunday?
    @w07dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,11)..Date.new(2018, 2,11) )).sum(:price)
    @w07dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,11)..Date.new(2018, 2,11) )).sum(:price)
    @w07dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,11)..Date.new(2018, 2,11) )).sum(:price)

    @date_w07ln = Date.new(2018, 2,12).monday?
    @w07ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,12)..Date.new(2018, 2,12) )).sum(:price)
    @w07ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,12)..Date.new(2018, 2,12) )).sum(:price)
    @w07ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,12)..Date.new(2018, 2,12) )).sum(:price)

    @date_w07ma = Date.new(2018, 2,13).tuesday?
    @w07ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 2,13) )).sum(:price)
    @w07ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 2,13) )).sum(:price)
    @w07ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 2,13) )).sum(:price)

    @date_w07mi = Date.new(2018, 2,14).wednesday?
    @w07mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,14)..Date.new(2018, 2,14) )).sum(:price)
    @w07mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,14)..Date.new(2018, 2,14) )).sum(:price)
    @w07mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,14)..Date.new(2018, 2,14) )).sum(:price)

    @date_w07ju = Date.new(2018, 2,15).thursday?
    @w07ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,15)..Date.new(2018, 2,15) )).sum(:price)
    @w07ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,15)..Date.new(2018, 2,15) )).sum(:price)
    @w07ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,15)..Date.new(2018, 2,15) )).sum(:price)

    @date_w07vi = Date.new(2018, 2,16).friday?
    @w07vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,16)..Date.new(2018, 2,16) )).sum(:price)
    @w07vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,16)..Date.new(2018, 2,16) )).sum(:price)
    @w07vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,16)..Date.new(2018, 2,16) )).sum(:price)

    @date_w07sa = Date.new(2018, 2,17).saturday?
    @w07sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,17)..Date.new(2018, 2,17) )).sum(:price)
    @w07sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,17)..Date.new(2018, 2,17) )).sum(:price)
    @w07sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,17)..Date.new(2018, 2,17) )).sum(:price)
    # N° Semana A18-02 / W07
    @w07mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,11)..Date.new(2018, 2,17) )).sum(:price)
    @w07mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,11)..Date.new(2018, 2,17) )).sum(:price)
    @w07mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,11)..Date.new(2018, 2,17) )).sum(:price)


    # N° Semana A18-02 / W06
    @date_w06dm = Date.new(2018, 2, 4).sunday?
    @w06dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2, 4)..Date.new(2018, 2, 4) )).sum(:price)
    @w06dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2, 4)..Date.new(2018, 2, 4) )).sum(:price)
    @w06dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2, 4)..Date.new(2018, 2, 4) )).sum(:price)

    @date_w06ln = Date.new(2018, 2, 5).monday?
    @w06ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2, 5)..Date.new(2018, 2, 5) )).sum(:price)
    @w06ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2, 5)..Date.new(2018, 2, 5) )).sum(:price)
    @w06ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2, 5)..Date.new(2018, 2, 5) )).sum(:price)

    @date_w06ma = Date.new(2018, 2, 6).tuesday?
    @w06ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2, 6)..Date.new(2018, 2, 6) )).sum(:price)
    @w06ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2, 6)..Date.new(2018, 2, 6) )).sum(:price)
    @w06ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2, 6)..Date.new(2018, 2, 6) )).sum(:price)

    @date_w06mi = Date.new(2018, 2, 7).wednesday?
    @w06mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2, 7)..Date.new(2018, 2, 7) )).sum(:price)
    @w06mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2, 7)..Date.new(2018, 2, 7) )).sum(:price)
    @w06mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2, 7)..Date.new(2018, 2, 7) )).sum(:price)

    @date_w06ju = Date.new(2018, 2, 8).thursday?
    @w06ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2, 8)..Date.new(2018, 2, 8) )).sum(:price)
    @w06ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2, 8)..Date.new(2018, 2, 8) )).sum(:price)
    @w06ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2, 8)..Date.new(2018, 2, 8) )).sum(:price)

    @date_w06vi = Date.new(2018, 2, 9).friday?
    @w06vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2, 9)..Date.new(2018, 2, 9) )).sum(:price)
    @w06vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2, 9)..Date.new(2018, 2, 9) )).sum(:price)
    @w06vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2, 9)..Date.new(2018, 2, 9) )).sum(:price)

    @date_w06sa = Date.new(2018, 2, 10).saturday?
    @w06sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,10)..Date.new(2018, 2,10) )).sum(:price)
    @w06sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,10)..Date.new(2018, 2,10) )).sum(:price)
    @w06sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,10)..Date.new(2018, 2,10) )).sum(:price)
    # N° Semana A18-02 / W06
    @w06mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2, 4)..Date.new(2018, 2,10) )).sum(:price)
    @w06mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2, 4)..Date.new(2018, 2,10) )).sum(:price)
    @w06mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2, 4)..Date.new(2018, 2,10) )).sum(:price)


    # N° Semana A18-02 / W05
    @date_w05ju = Date.new(2018, 2, 1).thursday?
    @w05ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2, 1)..Date.new(2018, 2, 1) )).sum(:price)
    @w05ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2, 1)..Date.new(2018, 2, 1) )).sum(:price)
    @w05ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2, 1)..Date.new(2018, 2, 1) )).sum(:price)

    @date_w05vi = Date.new(2018, 2, 2).friday?
    @w05vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2, 2)..Date.new(2018, 2, 2) )).sum(:price)
    @w05vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2, 2)..Date.new(2018, 2, 2) )).sum(:price)
    @w05vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2, 2)..Date.new(2018, 2, 2) )).sum(:price)

    @date_w05sa = Date.new(2018, 2, 3).saturday?
    @w05sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2, 3)..Date.new(2018, 2, 3) )).sum(:price)
    @w05sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2, 3)..Date.new(2018, 2, 3) )).sum(:price)
    @w05sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2, 3)..Date.new(2018, 2, 3) )).sum(:price)
    # N° Semana A18-02 / W05
    @w2_05mv_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2, 1)..Date.new(2018, 2, 3) )).sum(:price)
    @w2_05mv_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2, 1)..Date.new(2018, 2, 3) )).sum(:price)
    @w2_05mv_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2, 1)..Date.new(2018, 2, 3) )).sum(:price)
    # N° Semana A1801-2 / W05 all
    @w05mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,28)..Date.new(2018, 2, 3) )).sum(:price)
    @w05mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,28)..Date.new(2018, 2, 3) )).sum(:price)
    @w05mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,28)..Date.new(2018, 2, 3) )).sum(:price)


    # N° Semana A18-01 / W05
    @date_w05dm = Date.new(2018, 1,28).sunday?
    @w05dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,28)..Date.new(2018, 1,28) )).sum(:price)
    @w05dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,28)..Date.new(2018, 1,28) )).sum(:price)
    @w05dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,28)..Date.new(2018, 1,28) )).sum(:price)

    @date_w05ln = Date.new(2018, 1,29).monday?
    @w05ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,29)..Date.new(2018, 1,29) )).sum(:price)
    @w05ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,29)..Date.new(2018, 1,29) )).sum(:price)
    @w05ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,29)..Date.new(2018, 1,29) )).sum(:price)

    @date_w05ma = Date.new(2018, 1,30).tuesday?
    @w05ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,30)..Date.new(2018, 1,30) )).sum(:price)
    @w05ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,30)..Date.new(2018, 1,30) )).sum(:price)
    @w05ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,30)..Date.new(2018, 1,30) )).sum(:price)

    @date_w05mi = Date.new(2018, 1,31).wednesday?
    @w05mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,31)..Date.new(2018, 1,31) )).sum(:price)
    @w05mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,31)..Date.new(2018, 1,31) )).sum(:price)
    @w05mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,31)..Date.new(2018, 1,31) )).sum(:price)
    # N° Semana A18-01 / W05
    @w1_05mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,28)..Date.new(2018, 1,31) )).sum(:price)
    @w1_05mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,28)..Date.new(2018, 1,31) )).sum(:price)
    @w1_05mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,28)..Date.new(2018, 1,31) )).sum(:price)


    # N° Semana A18-01 / W04
    @date_w04dm = Date.new(2018, 1,21).sunday?
    @w04dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,21)..Date.new(2018, 1,21) )).sum(:price)
    @w04dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,21)..Date.new(2018, 1,21) )).sum(:price)
    @w04dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,21)..Date.new(2018, 1,21) )).sum(:price)

    @date_w04ln = Date.new(2018, 1,22).monday?
    @w04ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,22)..Date.new(2018, 1,22) )).sum(:price)
    @w04ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,22)..Date.new(2018, 1,22) )).sum(:price)
    @w04ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,22)..Date.new(2018, 1,22) )).sum(:price)

    @date_w04ma = Date.new(2018, 1,23).tuesday?
    @w04ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,23)..Date.new(2018, 1,23) )).sum(:price)
    @w04ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,23)..Date.new(2018, 1,23) )).sum(:price)
    @w04ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,23)..Date.new(2018, 1,23) )).sum(:price)

    @date_w04mi = Date.new(2018, 1,24).wednesday?
    @w04mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,24)..Date.new(2018, 1,24) )).sum(:price)
    @w04mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,24)..Date.new(2018, 1,24) )).sum(:price)
    @w04mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,24)..Date.new(2018, 1,24) )).sum(:price)

    @date_w04ju = Date.new(2018, 1,25).thursday?
    @w04ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,25)..Date.new(2018, 1,25) )).sum(:price)
    @w04ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,25)..Date.new(2018, 1,25) )).sum(:price)
    @w04ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,25)..Date.new(2018, 1,25) )).sum(:price)

    @date_w04vi = Date.new(2018, 1,26).friday?
    @w04vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,26)..Date.new(2018, 1,26) )).sum(:price)
    @w04vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,26)..Date.new(2018, 1,26) )).sum(:price)
    @w04vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,26)..Date.new(2018, 1,26) )).sum(:price)

    @date_w04sa = Date.new(2018, 1,27).saturday?
    @w04sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,27)..Date.new(2018, 1,27) )).sum(:price)
    @w04sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,27)..Date.new(2018, 1,27) )).sum(:price)
    @w04sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,27)..Date.new(2018, 1,27) )).sum(:price)
    # N° Semana A18-01 / W04
    @w04mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,21)..Date.new(2018, 1,27) )).sum(:price)
    @w04mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,21)..Date.new(2018, 1,27) )).sum(:price)
    @w04mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,21)..Date.new(2018, 1,27) )).sum(:price)


    # N° Semana A18-01 / W03
    @date_w03dm = Date.new(2018, 1,14).sunday?
    @w03dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,14)..Date.new(2018, 1,14) )).sum(:price)
    @w03dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,14)..Date.new(2018, 1,14) )).sum(:price)
    @w03dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,14)..Date.new(2018, 1,14) )).sum(:price)

    @date_w03ln = Date.new(2018, 1,15).monday?
    @w03ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,15)..Date.new(2018, 1,15) )).sum(:price)
    @w03ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,15)..Date.new(2018, 1,15) )).sum(:price)
    @w03ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,15)..Date.new(2018, 1,15) )).sum(:price)

    @date_w03ma = Date.new(2018, 1,16).tuesday?
    @w03ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,16)..Date.new(2018, 1,16) )).sum(:price)
    @w03ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,16)..Date.new(2018, 1,16) )).sum(:price)
    @w03ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,16)..Date.new(2018, 1,16) )).sum(:price)

    @date_w03mi = Date.new(2018, 1,17).wednesday?
    @w03mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,17)..Date.new(2018, 1,17) )).sum(:price)
    @w03mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,17)..Date.new(2018, 1,17) )).sum(:price)
    @w03mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,17)..Date.new(2018, 1,17) )).sum(:price)

    @date_w03ju = Date.new(2018, 1,18).thursday?
    @w03ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,18)..Date.new(2018, 1,18) )).sum(:price)
    @w03ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,18)..Date.new(2018, 1,18) )).sum(:price)
    @w03ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,18)..Date.new(2018, 1,18) )).sum(:price)

    @date_w03vi = Date.new(2018, 1,19).friday?
    @w03vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,19)..Date.new(2018, 1,19) )).sum(:price)
    @w03vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,19)..Date.new(2018, 1,19) )).sum(:price)
    @w03vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,19)..Date.new(2018, 1,19) )).sum(:price)

    @date_w03sa = Date.new(2018, 1,20).saturday?
    @w03sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,20)..Date.new(2018, 1,20) )).sum(:price)
    @w03sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,20)..Date.new(2018, 1,20) )).sum(:price)
    @w03sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,20)..Date.new(2018, 1,20) )).sum(:price)
    # N° Semana A18-01 / W03
    @w03mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,14)..Date.new(2018, 1,20) )).sum(:price)
    @w03mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,14)..Date.new(2018, 1,20) )).sum(:price)
    @w03mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,14)..Date.new(2018, 1,20) )).sum(:price)


    # N° Semana A18-01 / W02
    @date_w02dm = Date.new(2018, 1, 7).sunday?
    @w02dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1, 7)..Date.new(2018, 1, 7) )).sum(:price)
    @w02dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1, 7)..Date.new(2018, 1, 7) )).sum(:price)
    @w02dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1, 7)..Date.new(2018, 1, 7) )).sum(:price)

    @date_w02ln = Date.new(2018, 1, 8).monday?
    @w02ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1, 8)..Date.new(2018, 1, 8) )).sum(:price)
    @w02ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1, 8)..Date.new(2018, 1, 8) )).sum(:price)
    @w02ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1, 8)..Date.new(2018, 1, 8) )).sum(:price)

    @date_w02ma = Date.new(2018, 1, 9).tuesday?
    @w02ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1, 9)..Date.new(2018, 1, 9) )).sum(:price)
    @w02ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1, 9)..Date.new(2018, 1, 9) )).sum(:price)
    @w02ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1, 9)..Date.new(2018, 1, 9) )).sum(:price)

    @date_w02mi = Date.new(2018, 1,10).wednesday?
    @w02mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,10)..Date.new(2018, 1,10) )).sum(:price)
    @w02mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,10)..Date.new(2018, 1,10) )).sum(:price)
    @w02mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,10)..Date.new(2018, 1,10) )).sum(:price)

    @date_w02ju = Date.new(2018, 1,11).thursday?
    @w02ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,11)..Date.new(2018, 1,11) )).sum(:price)
    @w02ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,11)..Date.new(2018, 1,11) )).sum(:price)
    @w02ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,11)..Date.new(2018, 1,11) )).sum(:price)

    @date_w02vi = Date.new(2018, 1,12).friday?
    @w02vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,12)..Date.new(2018, 1,12) )).sum(:price)
    @w02vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,12)..Date.new(2018, 1,12) )).sum(:price)
    @w02vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,12)..Date.new(2018, 1,12) )).sum(:price)

    @date_w02sa = Date.new(2018, 1,13).saturday?
    @w02sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 1,13) )).sum(:price)
    @w02sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 1,13) )).sum(:price)
    @w02sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 1,13) )).sum(:price)
    # N° Semana A18-01 / W02
    @w02mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1, 7)..Date.new(2018, 1,13) )).sum(:price)
    @w02mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1, 7)..Date.new(2018, 1,13) )).sum(:price)
    @w02mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1, 7)..Date.new(2018, 1,13) )).sum(:price)


    # N° Semana A8-01 / a18_01
    @date_a18_01ln = Date.new(2018, 1, 1).monday?
    @a18_01ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 1, 1) )).sum(:price)
    @a18_01ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 1, 1) )).sum(:price)
    @a18_01ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 1, 1) )).sum(:price)

    @date_a18_01ma = Date.new(2018, 1, 2).tuesday?
    @a18_01ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1, 2)..Date.new(2018, 1, 2) )).sum(:price)
    @a18_01ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1, 2)..Date.new(2018, 1, 2) )).sum(:price)
    @a18_01ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1, 2)..Date.new(2018, 1, 2) )).sum(:price)

    @date_a18_01mi = Date.new(2018, 1, 3).wednesday?
    @a18_01mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1, 3)..Date.new(2018, 1, 3) )).sum(:price)
    @a18_01mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1, 3)..Date.new(2018, 1, 3) )).sum(:price)
    @a18_01mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1, 3)..Date.new(2018, 1, 3) )).sum(:price)

    @date_a18_01ju = Date.new(2018, 1, 4).thursday?
    @a18_01ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1, 4)..Date.new(2018, 1, 4) )).sum(:price)
    @a18_01ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1, 4)..Date.new(2018, 1, 4) )).sum(:price)
    @a18_01ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1, 4)..Date.new(2018, 1, 4) )).sum(:price)

    @date_a18_01vi = Date.new(2018, 1, 5).friday?
    @a18_01vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1, 5)..Date.new(2018, 1, 5) )).sum(:price)
    @a18_01vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1, 5)..Date.new(2018, 1, 5) )).sum(:price)
    @a18_01vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1, 5)..Date.new(2018, 1, 5) )).sum(:price)

    @date_a18_01sa = Date.new(2018, 1, 6).saturday?
    @a18_01sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1, 6)..Date.new(2018, 1, 6) )).sum(:price)
    @a18_01sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1, 6)..Date.new(2018, 1, 6) )).sum(:price)
    @a18_01sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1, 6)..Date.new(2018, 1, 6) )).sum(:price)

    @a18_01_01mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 1, 6) )).sum(:price)
    @a18_01_01mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 1, 6) )).sum(:price)
    @a18_01_01mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 1, 6) )).sum(:price)

    @a18_01mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,31)..Date.new(2018, 1, 6) )).sum(:price)
    @a18_01mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,31)..Date.new(2018, 1, 6) )).sum(:price)
    @a18_01mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,31)..Date.new(2018, 1, 6) )).sum(:price)


    # ---  2018  ---
    # N° Semana A17_53 - M12
    @a17_53dm_da = Date.new(2017,014,31).sunday?
    @a17_53dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,31)..Date.new(2017,014,31) )).sum(:price)
    @a17_53dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,31)..Date.new(2017,014,31) )).sum(:price)
    @a17_53dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,31)..Date.new(2017,014,31) )).sum(:price)

    @a17_53_12mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,31)..Date.new(2017,014,31) )).sum(:price)
    @a17_53_12mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,31)..Date.new(2017,014,31) )).sum(:price)
    @a17_53_12mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,31)..Date.new(2017,014,31) )).sum(:price)

    @a17_53mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,31)..Date.new(2017,014,31) )).sum(:price)
    @a17_53mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,31)..Date.new(2017,014,31) )).sum(:price)
    @a17_53mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,31)..Date.new(2017,014,31) )).sum(:price)

    # N° Semana M12 / W52
    @w52dm_da = Date.new(2017,014,24).sunday?
    @w52dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,24)..Date.new(2017,014,24) )).sum(:price)
    @w52dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,24)..Date.new(2017,014,24) )).sum(:price)
    @w52dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,24)..Date.new(2017,014,24) )).sum(:price)

    @w52ln_da = Date.new(2017,014,25).monday?
    @w52ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,25)..Date.new(2017,014,25) )).sum(:price)
    @w52ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,25)..Date.new(2017,014,25) )).sum(:price)
    @w52ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,25)..Date.new(2017,014,25) )).sum(:price)

    @w52ma_da = Date.new(2017,014,26).tuesday?
    @w52ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,26)..Date.new(2017,014,26) )).sum(:price)
    @w52ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,26)..Date.new(2017,014,26) )).sum(:price)
    @w52ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,26)..Date.new(2017,014,26) )).sum(:price)

    @w52mi_da = Date.new(2017,014,27).wednesday?
    @w52mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,27)..Date.new(2017,014,27) )).sum(:price)
    @w52mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,27)..Date.new(2017,014,27) )).sum(:price)
    @w52mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,27)..Date.new(2017,014,27) )).sum(:price)

    @w52ju_da = Date.new(2017,014,28).thursday?
    @w52ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,28)..Date.new(2017,014,28) )).sum(:price)
    @w52ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,28)..Date.new(2017,014,28) )).sum(:price)
    @w52ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,28)..Date.new(2017,014,28) )).sum(:price)

    @w52vi_da = Date.new(2017,014,29).friday?
    @w52vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,29)..Date.new(2017,014,29) )).sum(:price)
    @w52vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,29)..Date.new(2017,014,29) )).sum(:price)
    @w52vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,29)..Date.new(2017,014,29) )).sum(:price)

    @w52sa_da = Date.new(2017,014,30).saturday?
    @w52sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,30)..Date.new(2017,014,30) )).sum(:price)
    @w52sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,30)..Date.new(2017,014,30) )).sum(:price)
    @w52sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,30)..Date.new(2017,014,30) )).sum(:price)

    @w52mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,24)..Date.new(2017,014,30) )).sum(:price)
    @w52mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,24)..Date.new(2017,014,30) )).sum(:price)
    @w52mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,24)..Date.new(2017,014,30) )).sum(:price)

    # N° Semana M12 / W51
    @w51dm_da = Date.new(2017,014,17).sunday?
    @w51dm_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,17)..Date.new(2017,014,17) )).sum(:price)
    @w51dm_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,17)..Date.new(2017,014,17) )).sum(:price)
    @w51dm_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,17)..Date.new(2017,014,17) )).sum(:price)

    @w51ln_da = Date.new(2017,014,18).monday?
    @w51ln_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,18)..Date.new(2017,014,18) )).sum(:price)
    @w51ln_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,18)..Date.new(2017,014,18) )).sum(:price)
    @w51ln_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,18)..Date.new(2017,014,18) )).sum(:price)

    @w51ma_da = Date.new(2017,014,19).tuesday?
    @w51ma_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,19)..Date.new(2017,014,19) )).sum(:price)
    @w51ma_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,19)..Date.new(2017,014,19) )).sum(:price)
    @w51ma_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,19)..Date.new(2017,014,19) )).sum(:price)

    @w51mi_da = Date.new(2017,014,20).wednesday?
    @w51mi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,20)..Date.new(2017,014,20) )).sum(:price)
    @w51mi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,20)..Date.new(2017,014,20) )).sum(:price)
    @w51mi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,20)..Date.new(2017,014,20) )).sum(:price)

    @w51ju_da = Date.new(2017,014,21).thursday?
    @w51ju_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,21)..Date.new(2017,014,21) )).sum(:price)
    @w51ju_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,21)..Date.new(2017,014,21) )).sum(:price)
    @w51ju_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,21)..Date.new(2017,014,21) )).sum(:price)

    @w51vi_da = Date.new(2017,014,22).friday?
    @w51vi_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,22)..Date.new(2017,014,22) )).sum(:price)
    @w51vi_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,22)..Date.new(2017,014,22) )).sum(:price)
    @w51vi_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,22)..Date.new(2017,014,22) )).sum(:price)

    @w51sa_da = Date.new(2017,014,23).saturday?
    @w51sa_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,23)..Date.new(2017,014,23) )).sum(:price)
    @w51sa_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,23)..Date.new(2017,014,23) )).sum(:price)
    @w51sa_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,23)..Date.new(2017,014,23) )).sum(:price)

    @w51mv_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,17)..Date.new(2017,014,23) )).sum(:price)
    @w51mv_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,17)..Date.new(2017,014,23) )).sum(:price)
    @w51mv_pj  = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,17)..Date.new(2017,014,23) )).sum(:price)


    # N° Semana M12 / W50 // STW313 - Week 1 //
    @w50dm_da = Date.new(2017,014,10).sunday?
    @w50dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,10)..Date.new(2017,014,10) )).sum(:price)
    @w50dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,10)..Date.new(2017,014,10) )).sum(:price)
    @w50dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,014,10)..Date.new(2017,014,10) )).sum(:price)

    @w50ln_da = Date.new(2017,014,11).monday?
    @w50ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,11) )).sum(:price)
    @w50ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,11) )).sum(:price)
    @w50ln_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,11) )).sum(:price)

    @w50ma_da = Date.new(2017,014,12).tuesday?
    @w50ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,12)..Date.new(2017,014,12) )).sum(:price)
    @w50ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,12)..Date.new(2017,014,12) )).sum(:price)
    @w50ma_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,12)..Date.new(2017,014,12) )).sum(:price)

    @w50mi_da = Date.new(2017,014,13).wednesday?
    @w50mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,13)..Date.new(2017,014,13) )).sum(:price)
    @w50mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,13)..Date.new(2017,014,13) )).sum(:price)
    @w50mi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,13)..Date.new(2017,014,13) )).sum(:price)

    @w50ju_da = Date.new(2017,014,14).thursday?
    @w50ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,14)..Date.new(2017,014,14) )).sum(:price)
    @w50ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,14)..Date.new(2017,014,14) )).sum(:price)
    @w50ju_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,14)..Date.new(2017,014,14) )).sum(:price)

    @w50vi_da = Date.new(2017,014,15).friday?
    @w50vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,15)..Date.new(2017,014,15) )).sum(:price)
    @w50vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,15)..Date.new(2017,014,15) )).sum(:price)
    @w50vi_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,15)..Date.new(2017,014,15) )).sum(:price)

    @w50sa_da = Date.new(2017,014,16).saturday?
    @w50sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,16)..Date.new(2017,014,16) )).sum(:price)
    @w50sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,16)..Date.new(2017,014,16) )).sum(:price)
    @w50sa_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,16)..Date.new(2017,014,16) )).sum(:price)

    @w50mv_in3 = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,10)..Date.new(2017,014,16) )).sum(:price)
    @w50mv_eg3 = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,10)..Date.new(2017,014,16) )).sum(:price)
    @w50mv_pj3 = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,10)..Date.new(2017,014,16) )).sum(:price)


    # ------------------------------------
    # N° Semana M12 / W50  //STU379 End //
    @w50dm_da = Date.new(2017,014,10).sunday?
    @w50dm_in9 = Movement.where(mov_type: 'I×', mov_date: (Date.new(2017,014,10)..Date.new(2017,014,10) )).sum(:price)
    @w50dm_eg9 = Movement.where(mov_type: 'E×', mov_date: (Date.new(2017,014,10)..Date.new(2017,014,10) )).sum(:price)
    @w50dm_pj9 = Movement.where(mov_type: 'L×', mov_date: (Date.new(2017,014,10)..Date.new(2017,014,10) )).sum(:price)

    @w50ln_da = Date.new(2017,014,11).monday?
    @w50ln_in9 = Movement.where(mov_type: 'I×', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,11) )).sum(:price)
    @w50ln_eg9 = Movement.where(mov_type: 'E×', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,11) )).sum(:price)
    @w50ln_pj9 = Movement.where(mov_type: 'L×', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,11) )).sum(:price)

    @w50ma_da = Date.new(2017,014,12).tuesday?
    @w50ma_in9 = Movement.where(mov_type: 'I×', mov_date: (Date.new(2017,014,12)..Date.new(2017,014,12) )).sum(:price)
    @w50ma_eg9 = Movement.where(mov_type: 'E×', mov_date: (Date.new(2017,014,12)..Date.new(2017,014,12) )).sum(:price)
    @w50ma_pj9 = Movement.where(mov_type: 'L×', mov_date: (Date.new(2017,014,12)..Date.new(2017,014,12) )).sum(:price)

    @w50mi_da = Date.new(2017,014,13).wednesday?
    @w50mi_in9 = Movement.where(mov_type: 'I×', mov_date: (Date.new(2017,014,13)..Date.new(2017,014,13) )).sum(:price)
    @w50mi_eg9 = Movement.where(mov_type: 'E×', mov_date: (Date.new(2017,014,13)..Date.new(2017,014,13) )).sum(:price)
    @w50mi_pj9 = Movement.where(mov_type: 'L×', mov_date: (Date.new(2017,014,13)..Date.new(2017,014,13) )).sum(:price)

    @w50ju_da = Date.new(2017,014,14).thursday?
    @w50ju_in9 = Movement.where(mov_type: 'I×', mov_date: (Date.new(2017,014,14)..Date.new(2017,014,14) )).sum(:price)
    @w50ju_eg9 = Movement.where(mov_type: 'E×', mov_date: (Date.new(2017,014,14)..Date.new(2017,014,14) )).sum(:price)
    @w50ju_pj9 = Movement.where(mov_type: 'L×', mov_date: (Date.new(2017,014,14)..Date.new(2017,014,14) )).sum(:price)

    @w50mv_in9 = Movement.where(mov_type: 'I×', mov_date: (Date.new(2017,014,10)..Date.new(2017,014,14) )).sum(:price)
    @w50mv_eg9 = Movement.where(mov_type: 'E×', mov_date: (Date.new(2017,014,10)..Date.new(2017,014,14) )).sum(:price)
    @w50mv_pj9 = Movement.where(mov_type: 'L×', mov_date: (Date.new(2017,014,10)..Date.new(2017,014,14) )).sum(:price)

    @w50mv_in = @w50mv_in3 + @w50mv_in9
    @w50mv_eg = @w50mv_eg3 + @w50mv_eg9
    @w50mv_ot = @w50mv_pj3 + @w50mv_pj9

    # N° Semana M12 / W49
    @w49dm_da = Date.new(2017,014, 3).sunday?
    @w49dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 3)..Date.new(2017,014, 3) )).sum(:price)
    @w49dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 3)..Date.new(2017,014, 3) )).sum(:price)
    @w49dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,014, 3)..Date.new(2017,014, 3) )).sum(:price)

    @w49ln_da = Date.new(2017,014, 4).monday?
    @w49ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 4)..Date.new(2017,014, 4) )).sum(:price)
    @w49ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 4)..Date.new(2017,014, 4) )).sum(:price)
    @w49ln_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,014, 4)..Date.new(2017,014, 4) )).sum(:price)

    @w49ma_da = Date.new(2017,014, 5).tuesday?
    @w49ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 5)..Date.new(2017,014, 5) )).sum(:price)
    @w49ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 5)..Date.new(2017,014, 5) )).sum(:price)
    @w49ma_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,014, 5)..Date.new(2017,014, 5) )).sum(:price)

    @w49mi_da = Date.new(2017,014, 6).wednesday?
    @w49mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 6)..Date.new(2017,014, 6) )).sum(:price)
    @w49mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 6)..Date.new(2017,014, 6) )).sum(:price)
    @w49mi_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,014, 6)..Date.new(2017,014, 6) )).sum(:price)

    @w49ju_da = Date.new(2017,014, 7).thursday?
    @w49ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 7)..Date.new(2017,014, 7) )).sum(:price)
    @w49ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 7)..Date.new(2017,014, 7) )).sum(:price)
    @w49ju_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,014, 7)..Date.new(2017,014, 7) )).sum(:price)

    @w49vi_da = Date.new(2017,014, 8).friday?
    @w49vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 8)..Date.new(2017,014, 8) )).sum(:price)
    @w49vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 8)..Date.new(2017,014, 8) )).sum(:price)
    @w49vi_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,014, 8)..Date.new(2017,014, 8) )).sum(:price)

    @w49sa_da = Date.new(2017,014, 9).saturday?
    @w49sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 9)..Date.new(2017,014, 9) )).sum(:price)
    @w49sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 9)..Date.new(2017,014, 9) )).sum(:price)
    @w49sa_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,014, 9)..Date.new(2017,014, 9) )).sum(:price)

    @w49mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 3)..Date.new(2017,014, 9) )).sum(:price)
    @w49mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 3)..Date.new(2017,014, 9) )).sum(:price)
    @w49mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,014, 3)..Date.new(2017,014, 9) )).sum(:price)


    # N° Semana M11 / W48 / M12
    @w48vi_da = Date.new(2017,014, 1).friday?
    @w48vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014, 1) )).sum(:price)
    @w48vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014, 1) )).sum(:price)
    @w48vi_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014, 1) )).sum(:price)

    @w48sa_da = Date.new(2017,014, 2).saturday?
    @w48sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 2)..Date.new(2017,014, 2) )).sum(:price)
    @w48sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 2)..Date.new(2017,014, 2) )).sum(:price)
    @w48sa_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,014, 2)..Date.new(2017,014, 2) )).sum(:price)

    @a17_48_12mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014, 2) )).sum(:price)
    @a17_48_12mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014, 2) )).sum(:price)
    @a17_48_12mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,014, 1)..Date.new(2017,014, 2) )).sum(:price)

    @w48mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,26)..Date.new(2017,014, 2) )).sum(:price)
    @w48mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,26)..Date.new(2017,014, 2) )).sum(:price)
    @w48mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013,26)..Date.new(2017,014, 2) )).sum(:price)


    # N° Semana M11 / W48 / M12
    @w48dm_da = Date.new(2017,013,26).sunday?
    @w48dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,26)..Date.new(2017,013,26) )).sum(:price)
    @w48dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,26)..Date.new(2017,013,26) )).sum(:price)
    @w48dm_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,26)..Date.new(2017,013,26) )).sum(:price)

    @w48ln_da = Date.new(2017,013,27).monday?
    @w48ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,27)..Date.new(2017,013,27) )).sum(:price)
    @w48ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,27)..Date.new(2017,013,27) )).sum(:price)
    @w48ln_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,27)..Date.new(2017,013,27) )).sum(:price)

    @w48ma_da = Date.new(2017,013,28).tuesday?
    @w48ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,28)..Date.new(2017,013,28) )).sum(:price)
    @w48ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,28)..Date.new(2017,013,28) )).sum(:price)
    @w48ma_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,28)..Date.new(2017,013,28) )).sum(:price)

    @w48mi_da = Date.new(2017,013,29).wednesday?
    @w48mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,29)..Date.new(2017,013,29) )).sum(:price)
    @w48mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,29)..Date.new(2017,013,29) )).sum(:price)
    @w48mi_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,29)..Date.new(2017,013,29) )).sum(:price)

    @w48ju_da = Date.new(2017,013,30).thursday?
    @w48ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,30)..Date.new(2017,013,30) )).sum(:price)
    @w48ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,30)..Date.new(2017,013,30) )).sum(:price)
    @w48ju_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,30)..Date.new(2017,013,30) )).sum(:price)

    @a17_48_11mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,26)..Date.new(2017,013,30) )).sum(:price)
    @a17_48_11mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,26)..Date.new(2017,013,30) )).sum(:price)
    @a17_48_11mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013,26)..Date.new(2017,013,30) )).sum(:price)

    # N° Semana M11 / W47
    @w47dm_da = Date.new(2017,013,19).sunday?
    @w47dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,19)..Date.new(2017,013,19) )).sum(:price)
    @w47dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,19)..Date.new(2017,013,19) )).sum(:price)
    @w47dm_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,19)..Date.new(2017,013,19) )).sum(:price)

    @w47ln_da = Date.new(2017,013,20).monday?
    @w47ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,20)..Date.new(2017,013,20) )).sum(:price)
    @w47ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,20)..Date.new(2017,013,20) )).sum(:price)
    @w47ln_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,20)..Date.new(2017,013,20) )).sum(:price)

    @w47ma_da = Date.new(2017,013,21).tuesday?
    @w47ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,21)..Date.new(2017,013,21) )).sum(:price)
    @w47ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,21)..Date.new(2017,013,21) )).sum(:price)
    @w47ma_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,21)..Date.new(2017,013,21) )).sum(:price)

    @w47mi_da = Date.new(2017,013,22).wednesday?
    @w47mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,22)..Date.new(2017,013,22) )).sum(:price)
    @w47mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,22)..Date.new(2017,013,22) )).sum(:price)
    @w47mi_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,22)..Date.new(2017,013,22) )).sum(:price)

    @w47ju_da = Date.new(2017,013,23).thursday?
    @w47ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,23)..Date.new(2017,013,23) )).sum(:price)
    @w47ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,23)..Date.new(2017,013,23) )).sum(:price)
    @w47ju_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,23)..Date.new(2017,013,23) )).sum(:price)

    @w47vi_da = Date.new(2017,013,24).friday?
    @w47vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,24)..Date.new(2017,013,24) )).sum(:price)
    @w47vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,24)..Date.new(2017,013,24) )).sum(:price)
    @w47vi_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,24)..Date.new(2017,013,24) )).sum(:price)

    @w47sa_da = Date.new(2017,013,25).saturday?
    @w47sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,25)..Date.new(2017,013,25) )).sum(:price)
    @w47sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,25)..Date.new(2017,013,25) )).sum(:price)
    @w47sa_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,25)..Date.new(2017,013,25) )).sum(:price)

    @w47mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,19)..Date.new(2017,013,25) )).sum(:price)
    @w47mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,19)..Date.new(2017,013,25) )).sum(:price)
    @w47mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013,19)..Date.new(2017,013,25) )).sum(:price)

    # N° Semana anterior M11 / W46
    @w46dm_da = Date.new(2017,013,12).sunday?
    @w46dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,12)..Date.new(2017,013,12) )).sum(:price)
    @w46dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,12)..Date.new(2017,013,12) )).sum(:price)
    @w46dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013,12)..Date.new(2017,013,12) )).sum(:price)

    @w46ln_da = Date.new(2017,013,13).monday?
    @w46ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,13)..Date.new(2017,013,13) )).sum(:price)
    @w46ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,13)..Date.new(2017,013,13) )).sum(:price)
    @w46ln_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,13)..Date.new(2017,013,13) )).sum(:price)

    @w46ma_da = Date.new(2017,013,14).tuesday?
    @w46ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,14)..Date.new(2017,013,14) )).sum(:price)
    @w46ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,14)..Date.new(2017,013,14) )).sum(:price)
    @w46ma_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,14)..Date.new(2017,013,14) )).sum(:price)

    @w46mi_da = Date.new(2017,013,15).wednesday?
    @w46mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,15)..Date.new(2017,013,15) )).sum(:price)
    @w46mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,15)..Date.new(2017,013,15) )).sum(:price)
    @w46mi_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,15)..Date.new(2017,013,15) )).sum(:price)

    @w46ju_da = Date.new(2017,013,16).thursday?
    @w46ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,16)..Date.new(2017,013,16) )).sum(:price)
    @w46ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,16)..Date.new(2017,013,16) )).sum(:price)
    @w46ju_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,16)..Date.new(2017,013,16) )).sum(:price)

    @w46vi_da = Date.new(2017,013,17).friday?
    @w46vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,17)..Date.new(2017,013,17) )).sum(:price)
    @w46vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,17)..Date.new(2017,013,17) )).sum(:price)
    @w46vi_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,17)..Date.new(2017,013,17) )).sum(:price)

    @w46sa_da = Date.new(2017,013,18).saturday?
    @w46sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,18)..Date.new(2017,013,18) )).sum(:price)
    @w46sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,18)..Date.new(2017,013,18) )).sum(:price)
    @w46sa_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,18)..Date.new(2017,013,18) )).sum(:price)

    @w46mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,12)..Date.new(2017,013,18) )).sum(:price)
    @w46mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,12)..Date.new(2017,013,18) )).sum(:price)
    @w46mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013,12)..Date.new(2017,013,18) )).sum(:price)

    # N° Semana anterior M11 / W45
    @w45dm_da = Date.new(2017,013,05).sunday?
    @w45dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,05)..Date.new(2017,013,05) )).sum(:price)
    @w45dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,05)..Date.new(2017,013,05) )).sum(:price)
    @w45dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013,05)..Date.new(2017,013,05) )).sum(:price)

    @w45ln_da = Date.new(2017,013,6).monday?
    @w45ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013, 6)..Date.new(2017,013, 6) )).sum(:price)
    @w45ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013, 6)..Date.new(2017,013, 6) )).sum(:price)
    @w45ln_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013, 6)..Date.new(2017,013, 6) )).sum(:price)

    @w45ma_da = Date.new(2017,013,7).tuesday?
    @w45ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013, 7)..Date.new(2017,013, 7) )).sum(:price)
    @w45ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013, 7)..Date.new(2017,013, 7) )).sum(:price)
    @w45ma_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013, 7)..Date.new(2017,013, 7) )).sum(:price)

    @w45mi_da = Date.new(2017,013,8).wednesday?
    @w45mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013, 8)..Date.new(2017,013, 8) )).sum(:price)
    @w45mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013, 8)..Date.new(2017,013, 8) )).sum(:price)
    @w45mi_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013, 8)..Date.new(2017,013, 8) )).sum(:price)

    @w45ju_da = Date.new(2017,013,9).thursday?
    @w45ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013, 9)..Date.new(2017,013, 9) )).sum(:price)
    @w45ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013, 9)..Date.new(2017,013, 9) )).sum(:price)
    @w45ju_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013, 9)..Date.new(2017,013, 9) )).sum(:price)

    @w45vi_da = Date.new(2017,013,10).friday?
    @w45vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,10)..Date.new(2017,013,10) )).sum(:price)
    @w45vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,10)..Date.new(2017,013,10) )).sum(:price)
    @w45vi_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,10)..Date.new(2017,013,10) )).sum(:price)

    @w45sa_da = Date.new(2017,013,11).saturday?
    @w45sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,11)..Date.new(2017,013,11) )).sum(:price)
    @w45sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,11)..Date.new(2017,013,11) )).sum(:price)
    @w45sa_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013,11)..Date.new(2017,013,11) )).sum(:price)

    @w45mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013, 5)..Date.new(2017,013,11) )).sum(:price)
    @w45mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013, 5)..Date.new(2017,013,11) )).sum(:price)
    @w45mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013, 5)..Date.new(2017,013,11) )).sum(:price)

    # N° Semana anterior M10 / W44 / M11
    @w44mi_da = Date.new(2017,013,01).wednesday?
    @w44mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,01)..Date.new(2017,013,01) )).sum(:price)
    @w44mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,01)..Date.new(2017,013,01) )).sum(:price)
    @w44mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013,01)..Date.new(2017,013,01) )).sum(:price)

    @w44ju_da = Date.new(2017,013,02).thursday?
    @w44ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,02)..Date.new(2017,013,02) )).sum(:price)
    @w44ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,02)..Date.new(2017,013,02) )).sum(:price)
    @w44ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013,02)..Date.new(2017,013,02) )).sum(:price)

    @w44vi_da = Date.new(2017,013,03).friday?
    @w44vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,03)..Date.new(2017,013,03) )).sum(:price)
    @w44vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,03)..Date.new(2017,013,03) )).sum(:price)
    @w44vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013,03)..Date.new(2017,013,03) )).sum(:price)

    @w44sa_da = Date.new(2017,013,04).saturday?
    @w44sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,04)..Date.new(2017,013,04) )).sum(:price)
    @w44sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,04)..Date.new(2017,013,04) )).sum(:price)
    @w44sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013,04)..Date.new(2017,013,04) )).sum(:price)

    @a17_44_11mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013, 1)..Date.new(2017,013, 4) )).sum(:price)
    @a17_44_11mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013, 1)..Date.new(2017,013, 4) )).sum(:price)
    @a17_44_11mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013, 1)..Date.new(2017,013, 4) )).sum(:price)

    @w44mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,29)..Date.new(2017,013, 4) )).sum(:price)
    @w44mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,29)..Date.new(2017,013, 4) )).sum(:price)
    @w44mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,29)..Date.new(2017,013, 4) )).sum(:price)

    # N° Semana anterior M10 / W44 / M11
    @w44dm_da = Date.new(2017,012,29).sunday?
    @w44dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,29)..Date.new(2017,012,29) )).sum(:price)
    @w44dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,29)..Date.new(2017,012,29) )).sum(:price)
    @w44dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,29)..Date.new(2017,012,29) )).sum(:price)

    @w44ln_da = Date.new(2017,012,30).monday?
    @w44ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,30)..Date.new(2017,012,30) )).sum(:price)
    @w44ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,30)..Date.new(2017,012,30) )).sum(:price)
    @w44ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,30)..Date.new(2017,012,30) )).sum(:price)

    @w44ma_da = Date.new(2017,012,31).tuesday?
    @w44ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,31)..Date.new(2017,012,31) )).sum(:price)
    @w44ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,31)..Date.new(2017,012,31) )).sum(:price)
    @w44ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,31)..Date.new(2017,012,31) )).sum(:price)

    @a17_44_10mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,29)..Date.new(2017,012,31) )).sum(:price)
    @a17_44_10mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,29)..Date.new(2017,012,31) )).sum(:price)
    @a17_44_10mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,29)..Date.new(2017,012,31) )).sum(:price)

    # N° Semana M10 / W43
    @w43dm_da = Date.new(2017,012,22).sunday?
    @w43dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,22)..Date.new(2017,012,22) )).sum(:price)
    @w43dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,22)..Date.new(2017,012,22) )).sum(:price)
    @w43dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,22)..Date.new(2017,012,22) )).sum(:price)

    @w43ln_da = Date.new(2017,012,23).monday?
    @w43ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,23)..Date.new(2017,012,23) )).sum(:price)
    @w43ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,23)..Date.new(2017,012,23) )).sum(:price)
    @w43ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,23)..Date.new(2017,012,23) )).sum(:price)

    @w43ma_da = Date.new(2017,012,24).tuesday?
    @w43ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,24)..Date.new(2017,012,24) )).sum(:price)
    @w43ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,24)..Date.new(2017,012,24) )).sum(:price)
    @w43ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,24)..Date.new(2017,012,24) )).sum(:price)

    @w43mi_da = Date.new(2017,012,25).wednesday?
    @w43mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,25)..Date.new(2017,012,25) )).sum(:price)
    @w43mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,25)..Date.new(2017,012,25) )).sum(:price)
    @w43mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,25)..Date.new(2017,012,25) )).sum(:price)

    @w43ju_da = Date.new(2017,012,26).thursday?
    @w43ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,26)..Date.new(2017,012,26) )).sum(:price)
    @w43ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,26)..Date.new(2017,012,26) )).sum(:price)
    @w43ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,26)..Date.new(2017,012,26) )).sum(:price)

    @w43vi_da = Date.new(2017,012,27).friday?
    @w43vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,27)..Date.new(2017,012,27) )).sum(:price)
    @w43vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,27)..Date.new(2017,012,27) )).sum(:price)
    @w43vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,27)..Date.new(2017,012,27) )).sum(:price)

    @w43sa_da = Date.new(2017,012,28).saturday?
    @w43sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,28)..Date.new(2017,012,28) )).sum(:price)
    @w43sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,28)..Date.new(2017,012,28) )).sum(:price)
    @w43sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,28)..Date.new(2017,012,28) )).sum(:price)

    @w43mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,22)..Date.new(2017,012,28) )).sum(:price)
    @w43mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,22)..Date.new(2017,012,28) )).sum(:price)
    @w43mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,22)..Date.new(2017,012,28) )).sum(:price)

    # N° Semana M10 / W42
    @w42dm_da = Date.new(2017,012,15).sunday?
    @w42dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,15)..Date.new(2017,012,15) )).sum(:price)
    @w42dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,15)..Date.new(2017,012,15) )).sum(:price)
    @w42dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,15)..Date.new(2017,012,15) )).sum(:price)

    @w42ln_da = Date.new(2017,012,16).monday?
    @w42ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,16)..Date.new(2017,012,16) )).sum(:price)
    @w42ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,16)..Date.new(2017,012,16) )).sum(:price)
    @w42ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,16)..Date.new(2017,012,16) )).sum(:price)

    @w42ma_da = Date.new(2017,012,17).tuesday?
    @w42ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,17)..Date.new(2017,012,17) )).sum(:price)
    @w42ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,17)..Date.new(2017,012,17) )).sum(:price)
    @w42ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,17)..Date.new(2017,012,17) )).sum(:price)

    @w42mi_da = Date.new(2017,012,18).wednesday?
    @w42mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,18)..Date.new(2017,012,18) )).sum(:price)
    @w42mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,18)..Date.new(2017,012,18) )).sum(:price)
    @w42mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,18)..Date.new(2017,012,18) )).sum(:price)

    @w42ju_da = Date.new(2017,012,19).thursday?
    @w42ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,19)..Date.new(2017,012,19) )).sum(:price)
    @w42ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,19)..Date.new(2017,012,19) )).sum(:price)
    @w42ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,19)..Date.new(2017,012,19) )).sum(:price)

    @w42vi_da = Date.new(2017,012,20).friday?
    @w42vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,20)..Date.new(2017,012,20) )).sum(:price)
    @w42vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,20)..Date.new(2017,012,20) )).sum(:price)
    @w42vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,20)..Date.new(2017,012,20) )).sum(:price)

    @w42sa_da = Date.new(2017,012,21).saturday?
    @w42sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,21)..Date.new(2017,012,21) )).sum(:price)
    @w42sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,21)..Date.new(2017,012,21) )).sum(:price)
    @w42sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,21)..Date.new(2017,012,21) )).sum(:price)

    @w42mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,15)..Date.new(2017,012,21) )).sum(:price)
    @w42mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,15)..Date.new(2017,012,21) )).sum(:price)
    @w42mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,15)..Date.new(2017,012,21) )).sum(:price)


    # N° Semana anterior M10 / W41
    @w41dm_da = Date.new(2017,012, 8).sunday?
    @w41dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012, 8)..Date.new(2017,012, 8) )).sum(:price)
    @w41dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012, 8)..Date.new(2017,012, 8) )).sum(:price)
    @w41dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012, 8)..Date.new(2017,012, 8) )).sum(:price)

    @w41ln_da = Date.new(2017,012, 9).monday?
    @w41ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012, 9)..Date.new(2017,012, 9) )).sum(:price)
    @w41ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012, 9)..Date.new(2017,012, 9) )).sum(:price)
    @w41ln_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,012, 9)..Date.new(2017,012, 9) )).sum(:price)

    @w41ma_da = Date.new(2017,012,10).tuesday?
    @w41ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,10)..Date.new(2017,012,10) )).sum(:price)
    @w41ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,10)..Date.new(2017,012,10) )).sum(:price)
    @w41ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,10)..Date.new(2017,012,10) )).sum(:price)

    @w41mi_da = Date.new(2017,012,11).wednesday?
    @w41mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,11)..Date.new(2017,012,11) )).sum(:price)
    @w41mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,11)..Date.new(2017,012,11) )).sum(:price)
    @w41mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,11)..Date.new(2017,012,11) )).sum(:price)

    @w41ju_da = Date.new(2017,012,12).thursday?
    @w41ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,12)..Date.new(2017,012,12) )).sum(:price)
    @w41ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,12)..Date.new(2017,012,12) )).sum(:price)
    @w41ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,12)..Date.new(2017,012,12) )).sum(:price)

    @w41vi_da = Date.new(2017,012,13).friday?
    @w41vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,13)..Date.new(2017,012,13) )).sum(:price)
    @w41vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,13)..Date.new(2017,012,13) )).sum(:price)
    @w41vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,13)..Date.new(2017,012,13) )).sum(:price)

    @w41sa_da = Date.new(2017,012,14).saturday?
    @w41sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,14)..Date.new(2017,012,14) )).sum(:price)
    @w41sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,14)..Date.new(2017,012,14) )).sum(:price)
    @w41sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,14)..Date.new(2017,012,14) )).sum(:price)

    @w41mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012, 8)..Date.new(2017,012,14) )).sum(:price)
    @w41mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012, 8)..Date.new(2017,012,14) )).sum(:price)
    @w41mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012, 8)..Date.new(2017,012,14) )).sum(:price)

    # N° Semana anterior M10 / W40
    @w40dm_da = Date.new(2017,012, 1).sunday?
    @w40dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012, 1) )).sum(:price)
    @w40dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012, 1) )).sum(:price)
    @w40dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012, 1)..Date.new(2017,012, 1) )).sum(:price)

    @w40ln_da = Date.new(2017,012, 2).monday?
    @w40ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012, 2)..Date.new(2017,012, 2) )).sum(:price)
    @w40ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012, 2)..Date.new(2017,012, 2) )).sum(:price)
    @w40ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012, 2)..Date.new(2017,012, 2) )).sum(:price)

    @w40ma_da = Date.new(2017,012, 3).tuesday?
    @w40ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012, 3)..Date.new(2017,012, 3) )).sum(:price)
    @w40ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012, 3)..Date.new(2017,012, 3) )).sum(:price)
    @w40ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012, 3)..Date.new(2017,012, 3) )).sum(:price)

    @w40mi_da = Date.new(2017,012, 4).wednesday?
    @w40mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012, 4)..Date.new(2017,012, 4) )).sum(:price)
    @w40mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012, 4)..Date.new(2017,012, 4) )).sum(:price)
    @w40mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012, 4)..Date.new(2017,012, 4) )).sum(:price)

    @w40ju_da = Date.new(2017,012, 5).thursday?
    @w40ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012, 5)..Date.new(2017,012, 5) )).sum(:price)
    @w40ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012, 5)..Date.new(2017,012, 5) )).sum(:price)
    @w40ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012, 5)..Date.new(2017,012, 5) )).sum(:price)

    @w40vi_da = Date.new(2017,012, 6).friday?
    @w40vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012, 6)..Date.new(2017,012, 6) )).sum(:price)
    @w40vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012, 6)..Date.new(2017,012, 6) )).sum(:price)
    @w40vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012, 6)..Date.new(2017,012, 6) )).sum(:price)

    @w40sa_da = Date.new(2017,012, 7).saturday?
    @w40sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012, 7)..Date.new(2017,012, 7) )).sum(:price)
    @w40sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012, 7)..Date.new(2017,012, 7) )).sum(:price)
    @w40sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012, 7)..Date.new(2017,012, 7) )).sum(:price)

    @w40mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012, 7) )).sum(:price)
    @w40mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012, 7) )).sum(:price)
    @w40mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012, 1)..Date.new(2017,012, 7) )).sum(:price)

    # N° Semana anterior W39 - M09 / M10
    @w39dm_da = Date.new(2017,011,24).sunday?
    @w39dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,24)..Date.new(2017,011,24) )).sum(:price)
    @w39dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,24)..Date.new(2017,011,24) )).sum(:price)
    @w39dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,24)..Date.new(2017,011,24) )).sum(:price)

    @w39ln_da = Date.new(2017,011,25).monday?
    @w39ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,25)..Date.new(2017,011,25) )).sum(:price)
    @w39ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,25)..Date.new(2017,011,25) )).sum(:price)
    @w39ln_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,011,25)..Date.new(2017,011,25) )).sum(:price)

    @w39ma_da = Date.new(2017,011,26).tuesday?
    @w39ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,26)..Date.new(2017,011,26) )).sum(:price)
    @w39ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,26)..Date.new(2017,011,26) )).sum(:price)
    @w39ma_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,011,26)..Date.new(2017,011,26) )).sum(:price)

    @w39mi_da = Date.new(2017,011,27).wednesday?
    @w39mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,27)..Date.new(2017,011,27) )).sum(:price)
    @w39mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,27)..Date.new(2017,011,27) )).sum(:price)
    @w39mi_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,011,27)..Date.new(2017,011,27) )).sum(:price)

    @w39ju_da = Date.new(2017,011,28).thursday?
    @w39ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,28)..Date.new(2017,011,28) )).sum(:price)
    @w39ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,28)..Date.new(2017,011,28) )).sum(:price)
    @w39ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,28)..Date.new(2017,011,28) )).sum(:price)

    @w39vi_da = Date.new(2017,011,29).friday?
    @w39vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,29)..Date.new(2017,011,29) )).sum(:price)
    @w39vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,29)..Date.new(2017,011,29) )).sum(:price)
    @w39vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,29)..Date.new(2017,011,29) )).sum(:price)

    @w39sa_da = Date.new(2017,011,30).saturday?
    @w39sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,30)..Date.new(2017,011,30) )).sum(:price)
    @w39sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,30)..Date.new(2017,011,30) )).sum(:price)
    @w39sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,30)..Date.new(2017,011,30) )).sum(:price)

    @w39mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,24)..Date.new(2017,011,30) )).sum(:price)
    @w39mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,24)..Date.new(2017,011,30) )).sum(:price)
    @w39mv_pj = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,011,24)..Date.new(2017,011,30) )).sum(:price)

    # N° Semana anterior M09 / W38 - * Nata *
    @w38dm_da = Date.new(2017,011,17).sunday?
    @w38dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,17)..Date.new(2017,011,17) )).sum(:price)
    @w38dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,17)..Date.new(2017,011,17) )).sum(:price)
    @w38dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,17)..Date.new(2017,011,17) )).sum(:price)

    @w38ln_da = Date.new(2017,011,18).monday?
    @w38ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,18)..Date.new(2017,011,18) )).sum(:price)
    @w38ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,18)..Date.new(2017,011,18) )).sum(:price)
    @w38ln_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,011,18)..Date.new(2017,011,18) )).sum(:price)

    @w38ma_da = Date.new(2017,011,19).tuesday?
    @w38ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,19)..Date.new(2017,011,19) )).sum(:price)
    @w38ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,19)..Date.new(2017,011,19) )).sum(:price)
    @w38ma_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,011,19)..Date.new(2017,011,19) )).sum(:price)

    @w38mi_da = Date.new(2017,011,20).wednesday?
    @w38mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,20)..Date.new(2017,011,20) )).sum(:price)
    @w38mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,20)..Date.new(2017,011,20) )).sum(:price)
    @w38mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,20)..Date.new(2017,011,20) )).sum(:price)

    @w38ju_da = Date.new(2017,011,21).thursday?
    @w38ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,21)..Date.new(2017,011,21) )).sum(:price)
    @w38ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,21)..Date.new(2017,011,21) )).sum(:price)
    @w38ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,21)..Date.new(2017,011,21) )).sum(:price)

    @w38vi_da = Date.new(2017,011,22).friday?
    @w38vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,22)..Date.new(2017,011,22) )).sum(:price)
    @w38vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,22)..Date.new(2017,011,22) )).sum(:price)
    @w38vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,22)..Date.new(2017,011,22) )).sum(:price)

    @w38sa_da = Date.new(2017,011,23).saturday?
    @w38sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,23)..Date.new(2017,011,23) )).sum(:price)
    @w38sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,23)..Date.new(2017,011,23) )).sum(:price)
    @w38sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,23)..Date.new(2017,011,23) )).sum(:price)

    @w38mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,17)..Date.new(2017,011,23) )).sum(:price)
    @w38mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,17)..Date.new(2017,011,23) )).sum(:price)
    @w38mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,17)..Date.new(2017,011,23) )).sum(:price)

    # N° Semana anterior M09 / a17_37
    @a17_37dm_da = Date.new(2017,011,10).sunday?
    @a17_37dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,10)..Date.new(2017,011,10) )).sum(:price)
    @a17_37dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,10)..Date.new(2017,011,10) )).sum(:price)
    @a17_37dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,10)..Date.new(2017,011,10) )).sum(:price)

    @a17_37ln_da = Date.new(2017,011,11).monday?
    @a17_37ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,11)..Date.new(2017,011,11) )).sum(:price)
    @a17_37ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,11)..Date.new(2017,011,11) )).sum(:price)
    @a17_37ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,11)..Date.new(2017,011,11) )).sum(:price)

    @a17_37ma_da = Date.new(2017,011,12).tuesday?
    @a17_37ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,12)..Date.new(2017,011,12) )).sum(:price)
    @a17_37ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,12)..Date.new(2017,011,12) )).sum(:price)
    @a17_37ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,12)..Date.new(2017,011,12) )).sum(:price)

    @a17_37mi_da = Date.new(2017,011,13).wednesday?
    @a17_37mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,13)..Date.new(2017,011,13) )).sum(:price)
    @a17_37mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,13)..Date.new(2017,011,13) )).sum(:price)
    @a17_37mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,13)..Date.new(2017,011,13) )).sum(:price)

    @a17_37ju_da = Date.new(2017,011,14).thursday?
    @a17_37ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,14)..Date.new(2017,011,14) )).sum(:price)
    @a17_37ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,14)..Date.new(2017,011,14) )).sum(:price)
    @a17_37ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,14)..Date.new(2017,011,14) )).sum(:price)

    @a17_37vi_da = Date.new(2017,011,15).friday?
    @a17_37vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,15)..Date.new(2017,011,15) )).sum(:price)
    @a17_37vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,15)..Date.new(2017,011,15) )).sum(:price)
    @a17_37vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,15)..Date.new(2017,011,15) )).sum(:price)

    @a17_37sa_da = Date.new(2017,011,16).saturday?
    @a17_37sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,16)..Date.new(2017,011,16) )).sum(:price)
    @a17_37sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,16)..Date.new(2017,011,16) )).sum(:price)
    @a17_37sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,16)..Date.new(2017,011,16) )).sum(:price)

    @a17_37mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,10)..Date.new(2017,011,16) )).sum(:price)
    @a17_37mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,10)..Date.new(2017,011,16) )).sum(:price)
    @a17_37mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,10)..Date.new(2017,011,16) )).sum(:price)


    # N° Semana anterior M09 / a17_36
    @a17_36dm_da = Date.new(2017,011, 3).sunday?
    @a17_36dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011, 3)..Date.new(2017,011, 3) )).sum(:price)
    @a17_36dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011, 3)..Date.new(2017,011, 3) )).sum(:price)
    @a17_36dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011, 3)..Date.new(2017,011, 3) )).sum(:price)

    @a17_36ln_da = Date.new(2017,011, 4).monday?
    @a17_36ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011, 4)..Date.new(2017,011, 4) )).sum(:price)
    @a17_36ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011, 4)..Date.new(2017,011, 4) )).sum(:price)
    @a17_36ln_pj = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,011, 4)..Date.new(2017,011, 4) )).sum(:price)

    @a17_36ma_da = Date.new(2017,011, 5).tuesday?
    @a17_36ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011, 5)..Date.new(2017,011, 5) )).sum(:price)
    @a17_36ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011, 5)..Date.new(2017,011, 5) )).sum(:price)
    @a17_36ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011, 5)..Date.new(2017,011, 5) )).sum(:price)

    @a17_36mi_da = Date.new(2017,011, 6).wednesday?
    @a17_36mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011, 6)..Date.new(2017,011, 6) )).sum(:price)
    @a17_36mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011, 6)..Date.new(2017,011, 6) )).sum(:price)
    @a17_36mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011, 6)..Date.new(2017,011, 6) )).sum(:price)

    @a17_36ju_da = Date.new(2017,011, 7).thursday?
    @a17_36ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011, 7)..Date.new(2017,011, 7) )).sum(:price)
    @a17_36ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011, 7)..Date.new(2017,011, 7) )).sum(:price)
    @a17_36ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011, 7)..Date.new(2017,011, 7) )).sum(:price)

    @a17_36vi_da = Date.new(2017,011, 8).friday?
    @a17_36vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011, 8)..Date.new(2017,011, 8) )).sum(:price)
    @a17_36vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011, 8)..Date.new(2017,011, 8) )).sum(:price)
    @a17_36vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011, 8)..Date.new(2017,011, 8) )).sum(:price)

    @a17_36sa_da = Date.new(2017,011, 9).saturday?
    @a17_36sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011, 9)..Date.new(2017,011, 9) )).sum(:price)
    @a17_36sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011, 9)..Date.new(2017,011, 9) )).sum(:price)
    @a17_36sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011, 9)..Date.new(2017,011, 9) )).sum(:price)

    @a17_36mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,03)..Date.new(2017,011, 9) )).sum(:price)
    @a17_36mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,03)..Date.new(2017,011, 9) )).sum(:price)
    @a17_36mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,03)..Date.new(2017,011, 9) )).sum(:price)

    # N° Semana a17_35 - M08 / M09
    @a17_35vi_da = Date.new(2017,011,01).friday?
    @a17_35vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011, 1) )).sum(:price)
    @a17_35vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011, 1) )).sum(:price)
    @a17_35vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011, 1)..Date.new(2017,011, 1) )).sum(:price)

    @a17_35sa_da = Date.new(2017,011,02).saturday?
    @a17_35sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011, 2)..Date.new(2017,011, 2) )).sum(:price)
    @a17_35sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011, 2)..Date.new(2017,011, 2) )).sum(:price)
    @a17_35sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011, 2)..Date.new(2017,011, 2) )).sum(:price)

    @a17_35_09mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011, 2) )).sum(:price)
    @a17_35_09mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011, 2) )).sum(:price)
    @a17_35_09mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011, 1)..Date.new(2017,011, 2) )).sum(:price)

    @a17_35mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,27)..Date.new(2017,011, 2) )).sum(:price)
    @a17_35mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,27)..Date.new(2017,011, 2) )).sum(:price)
    @a17_35mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,27)..Date.new(2017,011, 2) )).sum(:price)


    # N° Semana a17_35 - M08 / M09
    @a17_35dm_da = Date.new(2017,010,27).sunday?
    @a17_35dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,27)..Date.new(2017,010,27) )).sum(:price)
    @a17_35dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,27)..Date.new(2017,010,27) )).sum(:price)
    @a17_35dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,27)..Date.new(2017,010,27) )).sum(:price)

    @a17_35ln_da = Date.new(2017,010,28).monday?
    @a17_35ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,28)..Date.new(2017,010,28) )).sum(:price)
    @a17_35ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,28)..Date.new(2017,010,28) )).sum(:price)
    @a17_35ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,28)..Date.new(2017,010,28) )).sum(:price)

    @a17_35ma_da = Date.new(2017,010,29).tuesday?
    @a17_35ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,29)..Date.new(2017,010,29) )).sum(:price)
    @a17_35ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,29)..Date.new(2017,010,29) )).sum(:price)
    @a17_35ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,29)..Date.new(2017,010,29) )).sum(:price)

    @a17_35mi_da = Date.new(2017,010,30).wednesday?
    @a17_35mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,30)..Date.new(2017,010,30) )).sum(:price)
    @a17_35mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,30)..Date.new(2017,010,30) )).sum(:price)
    @a17_35mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,30)..Date.new(2017,010,30) )).sum(:price)

    @a17_35ju_da = Date.new(2017,010,31).thursday?
    @a17_35ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,31)..Date.new(2017,010,31) )).sum(:price)
    @a17_35ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,31)..Date.new(2017,010,31) )).sum(:price)
    @a17_35ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,31)..Date.new(2017,010,31) )).sum(:price)

    @a17_35_08mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,27)..Date.new(2017,010,31) )).sum(:price)
    @a17_35_08mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,27)..Date.new(2017,010,31) )).sum(:price)
    @a17_35_08mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,27)..Date.new(2017,010,31) )).sum(:price)

    # N° Semana a17_34 - M08
    @a17_34dm_da = Date.new(2017,010,20).sunday?
    @a17_34dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,20)..Date.new(2017,010,20) )).sum(:price)
    @a17_34dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,20)..Date.new(2017,010,20) )).sum(:price)
    @a17_34dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,20)..Date.new(2017,010,20) )).sum(:price)

    @a17_34ln_da = Date.new(2017,010,21).monday?
    @a17_34ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,21)..Date.new(2017,010,21) )).sum(:price)
    @a17_34ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,21)..Date.new(2017,010,21) )).sum(:price)
    @a17_34ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,21)..Date.new(2017,010,21) )).sum(:price)

    @a17_34ma_da = Date.new(2017,010,22).tuesday?
    @a17_34ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,22)..Date.new(2017,010,22) )).sum(:price)
    @a17_34ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,22)..Date.new(2017,010,22) )).sum(:price)
    @a17_34ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,22)..Date.new(2017,010,22) )).sum(:price)

    @a17_34mi_da = Date.new(2017,010,23).wednesday?
    @a17_34mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,23)..Date.new(2017,010,23) )).sum(:price)
    @a17_34mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,23)..Date.new(2017,010,23) )).sum(:price)
    @a17_34mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,23)..Date.new(2017,010,23) )).sum(:price)

    @a17_34ju_da = Date.new(2017,010,24).thursday?
    @a17_34ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,24)..Date.new(2017,010,24) )).sum(:price)
    @a17_34ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,24)..Date.new(2017,010,24) )).sum(:price)
    @a17_34ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,24)..Date.new(2017,010,24) )).sum(:price)

    @a17_34vi_da = Date.new(2017,010,25).friday?
    @a17_34vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,25)..Date.new(2017,010,25) )).sum(:price)
    @a17_34vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,25)..Date.new(2017,010,25) )).sum(:price)
    @a17_34vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,25)..Date.new(2017,010,25) )).sum(:price)

    @a17_34sa_da = Date.new(2017,010,26).saturday?
    @a17_34sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,26)..Date.new(2017,010,26) )).sum(:price)
    @a17_34sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,26)..Date.new(2017,010,26) )).sum(:price)
    @a17_34sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,26)..Date.new(2017,010,26) )).sum(:price)

    @a17_34mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,20)..Date.new(2017,010,26) )).sum(:price)
    @a17_34mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,20)..Date.new(2017,010,26) )).sum(:price)
    @a17_34mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,20)..Date.new(2017,010,26) )).sum(:price)

    # N° Semana a17_33 - M08
    @a17_33dm_da = Date.new(2017,010,13).sunday?
    @a17_33dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,13)..Date.new(2017,010,13) )).sum(:price)
    @a17_33dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,13)..Date.new(2017,010,13) )).sum(:price)
    @a17_33dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,13)..Date.new(2017,010,13) )).sum(:price)

    @a17_33ln_da = Date.new(2017,010,14).monday?
    @a17_33ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,14)..Date.new(2017,010,14) )).sum(:price)
    @a17_33ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,14)..Date.new(2017,010,14) )).sum(:price)
    @a17_33ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,14)..Date.new(2017,010,14) )).sum(:price)

    @a17_33ma_da = Date.new(2017,010,15).tuesday?
    @a17_33ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,15)..Date.new(2017,010,15) )).sum(:price)
    @a17_33ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,15)..Date.new(2017,010,15) )).sum(:price)
    @a17_33ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,15)..Date.new(2017,010,15) )).sum(:price)

    @a17_33mi_da = Date.new(2017,010,16).wednesday?
    @a17_33mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,16)..Date.new(2017,010,16) )).sum(:price)
    @a17_33mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,16)..Date.new(2017,010,16) )).sum(:price)
    @a17_33mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,16)..Date.new(2017,010,16) )).sum(:price)

    @a17_33ju_da = Date.new(2017,010,17).thursday?
    @a17_33ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,17)..Date.new(2017,010,17) )).sum(:price)
    @a17_33ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,17)..Date.new(2017,010,17) )).sum(:price)
    @a17_33ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,17)..Date.new(2017,010,17) )).sum(:price)

    @a17_33vi_da = Date.new(2017,010,18).friday?
    @a17_33vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,18)..Date.new(2017,010,18) )).sum(:price)
    @a17_33vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,18)..Date.new(2017,010,18) )).sum(:price)
    @a17_33vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,18)..Date.new(2017,010,18) )).sum(:price)

    @a17_33sa_da = Date.new(2017,010,19).saturday?
    @a17_33sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,19)..Date.new(2017,010,19) )).sum(:price)
    @a17_33sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,19)..Date.new(2017,010,19) )).sum(:price)
    @a17_33sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,19)..Date.new(2017,010,19) )).sum(:price)

    @a17_33mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,13)..Date.new(2017,010,19) )).sum(:price)
    @a17_33mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,13)..Date.new(2017,010,19) )).sum(:price)
    @a17_33mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,13)..Date.new(2017,010,19) )).sum(:price)

    # N° Semana A17_32 - M08
    @a17_32dm_da = Date.new(2017,010, 6).sunday?
    @a17_32dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010, 6)..Date.new(2017,010, 6) )).sum(:price)
    @a17_32dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010, 6)..Date.new(2017,010, 6) )).sum(:price)
    @a17_32dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010, 6)..Date.new(2017,010, 6) )).sum(:price)

    @a17_32ln_da = Date.new(2017,010, 7).monday?
    @a17_32ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010, 7)..Date.new(2017,010, 7) )).sum(:price)
    @a17_32ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010, 7)..Date.new(2017,010, 7) )).sum(:price)
    @a17_32ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010, 7)..Date.new(2017,010, 7) )).sum(:price)

    @a17_32ma_da = Date.new(2017,010, 8).tuesday?
    @a17_32ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010, 8)..Date.new(2017,010, 8) )).sum(:price)
    @a17_32ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010, 8)..Date.new(2017,010, 8) )).sum(:price)
    @a17_32ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010, 8)..Date.new(2017,010, 8) )).sum(:price)

    @a17_32mi_da = Date.new(2017,010, 9).wednesday?
    @a17_32mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010, 9)..Date.new(2017,010, 9) )).sum(:price)
    @a17_32mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010, 9)..Date.new(2017,010, 9) )).sum(:price)
    @a17_32mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010, 9)..Date.new(2017,010, 9) )).sum(:price)

    @a17_32ju_da = Date.new(2017,010,10).thursday?
    @a17_32ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,10)..Date.new(2017,010,10) )).sum(:price)
    @a17_32ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,10)..Date.new(2017,010,10) )).sum(:price)
    @a17_32ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,10)..Date.new(2017,010,10) )).sum(:price)

    @a17_32vi_da = Date.new(2017,010,11).friday?
    @a17_32vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,11)..Date.new(2017,010,11) )).sum(:price)
    @a17_32vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,11)..Date.new(2017,010,11) )).sum(:price)
    @a17_32vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,11)..Date.new(2017,010,11) )).sum(:price)

    @a17_32sa_da = Date.new(2017,010,12).saturday?
    @a17_32sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,12)..Date.new(2017,010,12) )).sum(:price)
    @a17_32sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,12)..Date.new(2017,010,12) )).sum(:price)
    @a17_32sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,12)..Date.new(2017,010,12) )).sum(:price)
    # N° Semana a17_32 - M08
    @a17_32mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010, 6)..Date.new(2017,010,12) )).sum(:price)
    @a17_32mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010, 6)..Date.new(2017,010,12) )).sum(:price)
    @a17_32mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010, 6)..Date.new(2017,010,12) )).sum(:price)

    # N° Semana A17_31 - M7/8
    @a17_31ma_da = Date.new(2017,010, 1).tuesday?
    @a17_31ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010, 1)..Date.new(2017,010, 1) )).sum(:price)
    @a17_31ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010, 1)..Date.new(2017,010, 1) )).sum(:price)
    @a17_31ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010, 1)..Date.new(2017,010, 1) )).sum(:price)

    @a17_31mi_da = Date.new(2017,010, 2).wednesday?
    @a17_31mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010, 2)..Date.new(2017,010, 2) )).sum(:price)
    @a17_31mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010, 2)..Date.new(2017,010, 2) )).sum(:price)
    @a17_31mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010, 2)..Date.new(2017,010, 2) )).sum(:price)

    @a17_31ju_da = Date.new(2017,010, 3).thursday?
    @a17_31ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010, 3)..Date.new(2017,010, 3) )).sum(:price)
    @a17_31ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010, 3)..Date.new(2017,010, 3) )).sum(:price)
    @a17_31ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010, 3)..Date.new(2017,010, 3) )).sum(:price)

    @a17_31vi_da = Date.new(2017,010, 4).friday?
    @a17_31vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010, 4)..Date.new(2017,010, 4) )).sum(:price)
    @a17_31vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010, 4)..Date.new(2017,010, 4) )).sum(:price)
    @a17_31vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010, 4)..Date.new(2017,010, 4) )).sum(:price)

    @a17_31sa_da = Date.new(2017,010, 5).saturday?
    @a17_31sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010, 5)..Date.new(2017,010, 5) )).sum(:price)
    @a17_31sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010, 5)..Date.new(2017,010, 5) )).sum(:price)
    @a17_31sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010, 5)..Date.new(2017,010, 5) )).sum(:price)
    # N° Semana a17_31 - M7/8 subt
    @a17_31_08mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010, 1)..Date.new(2017,010, 5) )).sum(:price)
    @a17_31_08mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010, 1)..Date.new(2017,010, 5) )).sum(:price)
    @a17_31_08mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010, 1)..Date.new(2017,010, 5) )).sum(:price)
    # N° Semana a17_31 - M7/8
    @a17_31mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,30)..Date.new(2017,010, 5) )).sum(:price)
    @a17_31mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,30)..Date.new(2017,010, 5) )).sum(:price)
    @a17_31mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,30)..Date.new(2017,010, 5) )).sum(:price)


    # Julio 2017
    # N° Semana a17_31 - M7
    @a17_31dm_da = Date.new(2017, 7,30).sunday?
    @a17_31dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,30)..Date.new(2017, 7,30) )).sum(:price)
    @a17_31dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,30)..Date.new(2017, 7,30) )).sum(:price)
    @a17_31dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,30)..Date.new(2017, 7,30) )).sum(:price)

    @a17_31ln_da = Date.new(2017, 7,31).monday?
    @a17_31ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,31)..Date.new(2017, 7,31) )).sum(:price)
    @a17_31ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,31)..Date.new(2017, 7,31) )).sum(:price)
    @a17_31ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,31)..Date.new(2017, 7,31) )).sum(:price)
    # N° Semana A17_31 - M7
    @a17_31_07mv_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,30)..Date.new(2017, 7,31) )).sum(:price)
    @a17_31_07mv_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,30)..Date.new(2017, 7,31) )).sum(:price)
    @a17_31_07mv_pj=Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,30)..Date.new(2017, 7,31) )).sum(:price)

    # N° Semana a17_30 - M7
    @a17_30dm_da = Date.new(2017, 7,23).sunday?
    @a17_30dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,23)..Date.new(2017, 7,23) )).sum(:price)
    @a17_30dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,23)..Date.new(2017, 7,23) )).sum(:price)
    @a17_30dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,23)..Date.new(2017, 7,23) )).sum(:price)

    @a17_30ln_da = Date.new(2017, 7,24).monday?
    @a17_30ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,24)..Date.new(2017, 7,24) )).sum(:price)
    @a17_30ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,24)..Date.new(2017, 7,24) )).sum(:price)
    @a17_30ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,24)..Date.new(2017, 7,24) )).sum(:price)

    @a17_30ma_da = Date.new(2017, 7,25).tuesday?
    @a17_30ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,25)..Date.new(2017, 7,25) )).sum(:price)
    @a17_30ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,25)..Date.new(2017, 7,25) )).sum(:price)
    @a17_30ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,25)..Date.new(2017, 7,25) )).sum(:price)

    @a17_30mi_da = Date.new(2017, 7,26).wednesday?
    @a17_30mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,26)..Date.new(2017, 7,26) )).sum(:price)
    @a17_30mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,26)..Date.new(2017, 7,26) )).sum(:price)
    @a17_30mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,26)..Date.new(2017, 7,26) )).sum(:price)

    @a17_30ju_da = Date.new(2017, 7,27).thursday?
    @a17_30ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,27)..Date.new(2017, 7,27) )).sum(:price)
    @a17_30ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,27)..Date.new(2017, 7,27) )).sum(:price)
    @a17_30ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,27)..Date.new(2017, 7,27) )).sum(:price)

    @a17_30vi_da = Date.new(2017, 7,28).friday?
    @a17_30vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,28)..Date.new(2017, 7,28) )).sum(:price)
    @a17_30vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,28)..Date.new(2017, 7,28) )).sum(:price)
    @a17_30vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,28)..Date.new(2017, 7,28) )).sum(:price)

    @a17_30sa_da = Date.new(2017, 7,29).saturday?
    @a17_30sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,29)..Date.new(2017, 7,29) )).sum(:price)
    @a17_30sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,29)..Date.new(2017, 7,29) )).sum(:price)
    @a17_30sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,29)..Date.new(2017, 7,29) )).sum(:price)
    # N° Semana A17_30 - M7
    @a17_30mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,23)..Date.new(2017, 7,29) )).sum(:price)
    @a17_30mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,23)..Date.new(2017, 7,29) )).sum(:price)
    @a17_30mv_pj = Movement.where(mov_type: 'L', mov_date: (Date.new(2017, 7,23)..Date.new(2017, 7,29) )).sum(:price)


    # N° Semana a17_29 - M7
    @a17_29dm_da = Date.new(2017, 7,16).sunday?
    @a17_29dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,16)..Date.new(2017, 7,16) )).sum(:price)
    @a17_29dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,16)..Date.new(2017, 7,16) )).sum(:price)
    @a17_29dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,16)..Date.new(2017, 7,16) )).sum(:price)

    @a17_29ln_da = Date.new(2017, 7,17).monday?
    @a17_29ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,17)..Date.new(2017, 7,17) )).sum(:price)
    @a17_29ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,17)..Date.new(2017, 7,17) )).sum(:price)
    @a17_29ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,17)..Date.new(2017, 7,17) )).sum(:price)

    @a17_29ma_da = Date.new(2017, 7,18).tuesday?
    @a17_29ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,18)..Date.new(2017, 7,18) )).sum(:price)
    @a17_29ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,18)..Date.new(2017, 7,18) )).sum(:price)
    @a17_29ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,18)..Date.new(2017, 7,18) )).sum(:price)

    @a17_29mi_da = Date.new(2017, 7,19).wednesday?
    @a17_29mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,19)..Date.new(2017, 7,19) )).sum(:price)
    @a17_29mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,19)..Date.new(2017, 7,19) )).sum(:price)
    @a17_29mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,19)..Date.new(2017, 7,19) )).sum(:price)

    @a17_29ju_da = Date.new(2017, 7,20).thursday?
    @a17_29ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,20)..Date.new(2017, 7,20) )).sum(:price)
    @a17_29ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,20)..Date.new(2017, 7,20) )).sum(:price)
    @a17_29ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,20)..Date.new(2017, 7,20) )).sum(:price)

    @a17_29vi_da = Date.new(2017, 7,21).friday?
    @a17_29vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,21)..Date.new(2017, 7,21) )).sum(:price)
    @a17_29vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,21)..Date.new(2017, 7,21) )).sum(:price)
    @a17_29vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,21)..Date.new(2017, 7,21) )).sum(:price)

    @a17_29sa_da = Date.new(2017, 7,22).saturday?
    @a17_29sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,22)..Date.new(2017, 7,22) )).sum(:price)
    @a17_29sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,22)..Date.new(2017, 7,22) )).sum(:price)
    @a17_29sa_pj = Movement.where(mov_type: 'L', mov_date: (Date.new(2017, 7,22)..Date.new(2017, 7,22) )).sum(:price)
    # N° Semana a17_29 - M7
    @a17_29mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,16)..Date.new(2017, 7,22) )).sum(:price)
    @a17_29mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,16)..Date.new(2017, 7,22) )).sum(:price)
    @a17_29mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,16)..Date.new(2017, 7,22) )).sum(:price)


    # N° Semana a17_28 - M7
    @a17_28dm_da = Date.new(2017, 7, 9).sunday?
    @a17_28dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7, 9)..Date.new(2017, 7, 9) )).sum(:price)
    @a17_28dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7, 9)..Date.new(2017, 7, 9) )).sum(:price)
    @a17_28dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7, 9)..Date.new(2017, 7, 9) )).sum(:price)

    @a17_28ln_da = Date.new(2017, 7,10).monday?
    @a17_28ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,10)..Date.new(2017, 7,10) )).sum(:price)
    @a17_28ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,10)..Date.new(2017, 7,10) )).sum(:price)
    @a17_28ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,10)..Date.new(2017, 7,10) )).sum(:price)

    @a17_28ma_da = Date.new(2017, 7,11).tuesday?
    @a17_28ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,11)..Date.new(2017, 7,11) )).sum(:price)
    @a17_28ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,11)..Date.new(2017, 7,11) )).sum(:price)
    @a17_28ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,11)..Date.new(2017, 7,11) )).sum(:price)

    @a17_28mi_da = Date.new(2017, 7,12).wednesday?
    @a17_28mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,12)..Date.new(2017, 7,12) )).sum(:price)
    @a17_28mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,12)..Date.new(2017, 7,12) )).sum(:price)
    @a17_28mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,12)..Date.new(2017, 7,12) )).sum(:price)

    @a17_28ju_da = Date.new(2017, 7,13).thursday?
    @a17_28ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,13)..Date.new(2017, 7,13) )).sum(:price)
    @a17_28ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,13)..Date.new(2017, 7,13) )).sum(:price)
    @a17_28ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,13)..Date.new(2017, 7,13) )).sum(:price)

    @a17_28vi_da = Date.new(2017, 7,14).friday?
    @a17_28vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,14)..Date.new(2017, 7,14) )).sum(:price)
    @a17_28vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,14)..Date.new(2017, 7,14) )).sum(:price)
    @a17_28vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,14)..Date.new(2017, 7,14) )).sum(:price)

    @a17_28sa_da = Date.new(2017, 7,15).saturday?
    @a17_28sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,15)..Date.new(2017, 7,15) )).sum(:price)
    @a17_28sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,15)..Date.new(2017, 7,15) )).sum(:price)
    @a17_28sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,15)..Date.new(2017, 7,15) )).sum(:price)
    # N° Semana a17_28 - M7
    @a17_28mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7, 9)..Date.new(2017, 7,15) )).sum(:price)
    @a17_28mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7, 9)..Date.new(2017, 7,15) )).sum(:price)
    @a17_28mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7, 9)..Date.new(2017, 7,15) )).sum(:price)


    # N° Semana a17_27 - M7
    @a17_27dm_da = Date.new(2017, 7, 2).sunday?
    @a17_27dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7, 2)..Date.new(2017, 7, 2) )).sum(:price)
    @a17_27dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7, 2)..Date.new(2017, 7, 2) )).sum(:price)
    @a17_27dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7, 2)..Date.new(2017, 7, 2) )).sum(:price)

    @a17_27ln_da = Date.new(2017, 7, 3).monday?
    @a17_27ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7, 3)..Date.new(2017, 7, 3) )).sum(:price)
    @a17_27ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7, 3)..Date.new(2017, 7, 3) )).sum(:price)
    @a17_27ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7, 3)..Date.new(2017, 7, 3) )).sum(:price)

    @a17_27ma_da = Date.new(2017, 7, 4).tuesday?
    @a17_27ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7, 4)..Date.new(2017, 7, 4) )).sum(:price)
    @a17_27ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7, 4)..Date.new(2017, 7, 4) )).sum(:price)
    @a17_27ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7, 4)..Date.new(2017, 7, 4) )).sum(:price)

    @a17_27mi_da = Date.new(2017, 7, 5).wednesday?
    @a17_27mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7, 5)..Date.new(2017, 7, 5) )).sum(:price)
    @a17_27mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7, 5)..Date.new(2017, 7, 5) )).sum(:price)
    @a17_27mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7, 5)..Date.new(2017, 7, 5) )).sum(:price)

    @a17_27ju_da = Date.new(2017, 7, 6).thursday?
    @a17_27ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7, 6)..Date.new(2017, 7, 6) )).sum(:price)
    @a17_27ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7, 6)..Date.new(2017, 7, 6) )).sum(:price)
    @a17_27ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7, 6)..Date.new(2017, 7, 6) )).sum(:price)

    @a17_27vi_da = Date.new(2017, 7, 7).friday?
    @a17_27vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7, 7)..Date.new(2017, 7, 7) )).sum(:price)
    @a17_27vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7, 7)..Date.new(2017, 7, 7) )).sum(:price)
    @a17_27vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7, 7)..Date.new(2017, 7, 7) )).sum(:price)

    @a17_27sa_da = Date.new(2017, 7, 8).saturday?
    @a17_27sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7, 8)..Date.new(2017, 7, 8) )).sum(:price)
    @a17_27sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7, 8)..Date.new(2017, 7, 8) )).sum(:price)
    @a17_27sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7, 8)..Date.new(2017, 7, 8) )).sum(:price)
    # N° Semana a17_27 - M7
    @a17_27mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7, 2)..Date.new(2017, 7, 8) )).sum(:price)
    @a17_27mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7, 2)..Date.new(2017, 7, 8) )).sum(:price)
    @a17_27mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7, 2)..Date.new(2017, 7, 8) )).sum(:price)

    # N° Semana W26 - M6-7
    @a17_26sa_da = Date.new(2017, 7, 1).saturday?
    @a17_26sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7, 1)..Date.new(2017, 7, 1) )).sum(:price)
    @a17_26sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7, 1)..Date.new(2017, 7, 1) )).sum(:price)
    @a17_26sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7, 1)..Date.new(2017, 7, 1) )).sum(:price)
    # N° Semana W26 - M6-7
    @a17_26_07mv_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7, 1)..Date.new(2017, 7, 1) )).sum(:price)
    @a17_26_07mv_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7, 1)..Date.new(2017, 7, 1) )).sum(:price)
    @a17_26_07mv_pj=Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7, 1)..Date.new(2017, 7, 1) )).sum(:price)
    # N° Semana W26 - M6-7
    @a17_26mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,25)..Date.new(2017, 7, 1) )).sum(:price)
    @a17_26mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,25)..Date.new(2017, 7, 1) )).sum(:price)
    @a17_26mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,25)..Date.new(2017, 7, 1) )).sum(:price)


    # Junio 2017
    # N° Semana W26 - M6-7
    @a17_26dm_da = Date.new(2017, 6,25).sunday?
    @a17_26dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,25)..Date.new(2017, 6,25) )).sum(:price)
    @a17_26dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,25)..Date.new(2017, 6,25) )).sum(:price)
    @a17_26dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,25)..Date.new(2017, 6,25) )).sum(:price)

    @a17_26ln_da = Date.new(2017, 6,26).monday?
    @a17_26ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,26)..Date.new(2017, 6,26) )).sum(:price)
    @a17_26ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,26)..Date.new(2017, 6,26) )).sum(:price)
    @a17_26ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,26)..Date.new(2017, 6,26) )).sum(:price)

    @a17_26ma_da = Date.new(2017, 6,27).tuesday?
    @a17_26ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,27)..Date.new(2017, 6,27) )).sum(:price)
    @a17_26ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,27)..Date.new(2017, 6,27) )).sum(:price)
    @a17_26ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,27)..Date.new(2017, 6,27) )).sum(:price)

    @a17_26mi_da = Date.new(2017, 6,28).wednesday?
    @a17_26mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,28)..Date.new(2017, 6,28) )).sum(:price)
    @a17_26mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,28)..Date.new(2017, 6,28) )).sum(:price)
    @a17_26mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,28)..Date.new(2017, 6,28) )).sum(:price)

    @a17_26ju_da = Date.new(2017, 6,29).thursday?
    @a17_26ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,29)..Date.new(2017, 6,29) )).sum(:price)
    @a17_26ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,29)..Date.new(2017, 6,29) )).sum(:price)
    @a17_26ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,29)..Date.new(2017, 6,29) )).sum(:price)

    @a17_26vi_da = Date.new(2017, 6,30).friday?
    @a17_26vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,30)..Date.new(2017, 6,30) )).sum(:price)
    @a17_26vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,30)..Date.new(2017, 6,30) )).sum(:price)
    @a17_26vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,30)..Date.new(2017, 6,30) )).sum(:price)
    # N° Semana W26 - M6-7
    @a17_26_06mv_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,25)..Date.new(2017, 6,30) )).sum(:price)
    @a17_26_06mv_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,25)..Date.new(2017, 6,30) )).sum(:price)
    @a17_26_06mv_pj=Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,25)..Date.new(2017, 6,30) )).sum(:price)


    # N° Semana A17_M6 - W25
    @a17_25dm_da = Date.new(2017, 6,18).sunday?
    @a17_25dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,18)..Date.new(2017, 6,18) )).sum(:price)
    @a17_25dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,18)..Date.new(2017, 6,18) )).sum(:price)
    @a17_25dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,18)..Date.new(2017, 6,18) )).sum(:price)

    @a17_25ln_da = Date.new(2017, 6,19).monday?
    @a17_25ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,19)..Date.new(2017, 6,19) )).sum(:price)
    @a17_25ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,19)..Date.new(2017, 6,19) )).sum(:price)
    @a17_25ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,19)..Date.new(2017, 6,19) )).sum(:price)

    @a17_25ma_da = Date.new(2017, 6,20).tuesday?
    @a17_25ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,20)..Date.new(2017, 6,20) )).sum(:price)
    @a17_25ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,20)..Date.new(2017, 6,20) )).sum(:price)
    @a17_25ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,20)..Date.new(2017, 6,20) )).sum(:price)

    @a17_25mi_da = Date.new(2017, 6,21).wednesday?
    @a17_25mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,21)..Date.new(2017, 6,21) )).sum(:price)
    @a17_25mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,21)..Date.new(2017, 6,21) )).sum(:price)
    @a17_25mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,21)..Date.new(2017, 6,21) )).sum(:price)

    @a17_25ju_da = Date.new(2017, 6,22).thursday?
    @a17_25ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,22)..Date.new(2017, 6,22) )).sum(:price)
    @a17_25ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,22)..Date.new(2017, 6,22) )).sum(:price)
    @a17_25ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,22)..Date.new(2017, 6,22) )).sum(:price)

    @a17_25vi_da = Date.new(2017, 6,23).friday?
    @a17_25vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,23)..Date.new(2017, 6,23) )).sum(:price)
    @a17_25vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,23)..Date.new(2017, 6,23) )).sum(:price)
    @a17_25vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,23)..Date.new(2017, 6,23) )).sum(:price)

    @a17_25sa_da = Date.new(2017, 6,24).saturday?
    @a17_25sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,24)..Date.new(2017, 6,24) )).sum(:price)
    @a17_25sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,24)..Date.new(2017, 6,24) )).sum(:price)
    @a17_25sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,24)..Date.new(2017, 6,24) )).sum(:price)
    # N° Semana W25 - M6-7
    @a17_25mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,18)..Date.new(2017, 6,24) )).sum(:price)
    @a17_25mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,18)..Date.new(2017, 6,24) )).sum(:price)
    @a17_25mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,18)..Date.new(2017, 6,24) )).sum(:price)

    # N° Semana A17_M6 - W24
    @a17_24dm_da = Date.new(2017, 6,11).sunday?
    @a17_24dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,11)..Date.new(2017, 6,11) )).sum(:price)
    @a17_24dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,11)..Date.new(2017, 6,11) )).sum(:price)
    @a17_24dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,11)..Date.new(2017, 6,11) )).sum(:price)

    @a17_24ln_da = Date.new(2017, 6,12).monday?
    @a17_24ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,12)..Date.new(2017, 6,12) )).sum(:price)
    @a17_24ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,12)..Date.new(2017, 6,12) )).sum(:price)
    @a17_24ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,12)..Date.new(2017, 6,12) )).sum(:price)

    @a17_24ma_da = Date.new(2017, 6,13).tuesday?
    @a17_24ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,13)..Date.new(2017, 6,13) )).sum(:price)
    @a17_24ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,13)..Date.new(2017, 6,13) )).sum(:price)
    @a17_24ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,13)..Date.new(2017, 6,13) )).sum(:price)

    @a17_24mi_da = Date.new(2017, 6,14).wednesday?
    @a17_24mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,14)..Date.new(2017, 6,14) )).sum(:price)
    @a17_24mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,14)..Date.new(2017, 6,14) )).sum(:price)
    @a17_24mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,14)..Date.new(2017, 6,14) )).sum(:price)

    @a17_24ju_da = Date.new(2017, 6,15).thursday?
    @a17_24ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,15)..Date.new(2017, 6,15) )).sum(:price)
    @a17_24ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,15)..Date.new(2017, 6,15) )).sum(:price)
    @a17_24ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,15)..Date.new(2017, 6,15) )).sum(:price)

    @a17_24vi_da = Date.new(2017, 6,16).friday?
    @a17_24vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,16)..Date.new(2017, 6,16) )).sum(:price)
    @a17_24vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,16)..Date.new(2017, 6,16) )).sum(:price)
    @a17_24vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,16)..Date.new(2017, 6,16) )).sum(:price)

    @a17_24sa_da = Date.new(2017, 6,17).saturday?
    @a17_24sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,17)..Date.new(2017, 6,17) )).sum(:price)
    @a17_24sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,17)..Date.new(2017, 6,17) )).sum(:price)
    @a17_24sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,17)..Date.new(2017, 6,17) )).sum(:price)
    # N° Semana A17_M6 - W24
    @a17_24mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,11)..Date.new(2017, 6,17) )).sum(:price)
    @a17_24mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,11)..Date.new(2017, 6,17) )).sum(:price)
    @a17_24mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,11)..Date.new(2017, 6,17) )).sum(:price)

    # N° Semana A17_M6 - W23
    @a17_23dm_da = Date.new(2017, 6, 4).sunday?
    @a17_23dm_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6, 4)..Date.new(2017, 6, 4) )).sum(:price)
    @a17_23dm_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6, 4)..Date.new(2017, 6, 4) )).sum(:price)
    @a17_23dm_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6, 4)..Date.new(2017, 6, 4) )).sum(:price)

    @a17_23ln_da = Date.new(2017, 6, 5).monday?
    @a17_23ln_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6, 5)..Date.new(2017, 6, 5) )).sum(:price)
    @a17_23ln_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6, 5)..Date.new(2017, 6, 5) )).sum(:price)
    @a17_23ln_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6, 5)..Date.new(2017, 6, 5) )).sum(:price)

    @a17_23ma_da = Date.new(2017, 6, 6).tuesday?
    @a17_23ma_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6, 6)..Date.new(2017, 6, 6) )).sum(:price)
    @a17_23ma_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6, 6)..Date.new(2017, 6, 6) )).sum(:price)
    @a17_23ma_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6, 6)..Date.new(2017, 6, 6) )).sum(:price)

    @a17_23mi_da = Date.new(2017, 6, 7).wednesday?
    @a17_23mi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6, 7)..Date.new(2017, 6, 7) )).sum(:price)
    @a17_23mi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6, 7)..Date.new(2017, 6, 7) )).sum(:price)
    @a17_23mi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6, 7)..Date.new(2017, 6, 7) )).sum(:price)

    @a17_23ju_da = Date.new(2017, 6, 8).thursday?
    @a17_23ju_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6, 8)..Date.new(2017, 6, 8) )).sum(:price)
    @a17_23ju_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6, 8)..Date.new(2017, 6, 8) )).sum(:price)
    @a17_23ju_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6, 8)..Date.new(2017, 6, 8) )).sum(:price)

    @a17_23vi_da = Date.new(2017, 6, 9).friday?
    @a17_23vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6, 9)..Date.new(2017, 6, 9) )).sum(:price)
    @a17_23vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6, 9)..Date.new(2017, 6, 9) )).sum(:price)
    @a17_23vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6, 9)..Date.new(2017, 6, 9) )).sum(:price)

    @a17_23sa_da = Date.new(2017, 6,10).saturday?
    @a17_23sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,10)..Date.new(2017, 6,10) )).sum(:price)
    @a17_23sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,10)..Date.new(2017, 6,10) )).sum(:price)
    @a17_23sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,10)..Date.new(2017, 6,10) )).sum(:price)
    # N° Semana A17_M6 - W23
    @a17_23mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6, 4)..Date.new(2017, 6,10) )).sum(:price)
    @a17_23mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6, 4)..Date.new(2017, 6,10) )).sum(:price)
    @a17_23mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6, 4)..Date.new(2017, 6,10) )).sum(:price)

    # N° Semana A17_M6 - W22
    @a17_22vi_da = Date.new(2017, 6, 2).friday?
    @a17_22vi_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6, 2)..Date.new(2017, 6, 2) )).sum(:price)
    @a17_22vi_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6, 2)..Date.new(2017, 6, 2) )).sum(:price)
    @a17_22vi_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6, 2)..Date.new(2017, 6, 2) )).sum(:price)

    @a17_22sa_da = Date.new(2017, 6, 3).saturday?
    @a17_22sa_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6, 3)..Date.new(2017, 6, 3) )).sum(:price)
    @a17_22sa_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6, 3)..Date.new(2017, 6, 3) )).sum(:price)
    @a17_22sa_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6, 3)..Date.new(2017, 6, 3) )).sum(:price)
    # N° Semana A17_M6 - W22
    @a17_22mv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6, 2)..Date.new(2017, 6, 3) )).sum(:price)
    @a17_22mv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6, 2)..Date.new(2017, 6, 3) )).sum(:price)
    @a17_22mv_pj = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6, 2)..Date.new(2017, 6, 3) )).sum(:price)

    flash[:success] = "Diario semanas anteriores"
  end


  def see_months
    @movements  = Movement.where(mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month))


    # Septiembre 2019

    @a19_36_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 9, 1)..Date.new(2019, 8, 7) )).sum(:price)
    @a19_36_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 9, 1)..Date.new(2019, 8, 7) )).sum(:price)
    @a19_36_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 9, 1)..Date.new(2019, 8, 7) )).sum(:price)

    # Agosto 2019
    @a19_35_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,25)..Date.new(2019, 8,31) )).sum(:price)
    @a19_35_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,25)..Date.new(2019, 8,31) )).sum(:price)
    @a19_35_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,25)..Date.new(2019, 8,31) )).sum(:price)

    @a19_34_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,18)..Date.new(2019, 8,24) )).sum(:price)
    @a19_34_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,18)..Date.new(2019, 8,24) )).sum(:price)
    @a19_34_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,18)..Date.new(2019, 8,24) )).sum(:price)

    @a19_33_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8,11)..Date.new(2019, 8,17) )).sum(:price)
    @a19_33_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8,11)..Date.new(2019, 8,17) )).sum(:price)
    @a19_33_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8,11)..Date.new(2019, 8,17) )).sum(:price)

    @a19_32_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8, 4)..Date.new(2019, 8,10) )).sum(:price)
    @a19_32_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8, 4)..Date.new(2019, 8,10) )).sum(:price)
    @a19_32_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8, 4)..Date.new(2019, 8,10) )).sum(:price)

    @a19_31_08in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 8, 1)..Date.new(2019, 8, 3) )).sum(:price)
    @a19_31_08eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 8, 1)..Date.new(2019, 8, 3) )).sum(:price)
    @a19_31_08pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 8, 1)..Date.new(2019, 8, 3) )).sum(:price)


    # Julio 2019
    @a19_31_07in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,28)..Date.new(2019, 7,31) )).sum(:price)
    @a19_31_07eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,28)..Date.new(2019, 7,31) )).sum(:price)
    @a19_31_07pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,28)..Date.new(2019, 7,31) )).sum(:price)

    @a19_30_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,21)..Date.new(2019, 7,27) )).sum(:price)
    @a19_30_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,21)..Date.new(2019, 7,27) )).sum(:price)
    @a19_30_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,21)..Date.new(2019, 7,27) )).sum(:price)

    @a19_29_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7,14)..Date.new(2019, 7,20) )).sum(:price)
    @a19_29_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7,14)..Date.new(2019, 7,20) )).sum(:price)
    @a19_29_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7,14)..Date.new(2019, 7,20) )).sum(:price)

    @a19_28_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7, 7)..Date.new(2019, 7,13) )).sum(:price)
    @a19_28_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7, 7)..Date.new(2019, 7,13) )).sum(:price)
    @a19_28_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7, 7)..Date.new(2019, 7,13) )).sum(:price)

    @a19_27_07in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7, 1)..Date.new(2019, 7, 6) )).sum(:price)
    @a19_27_07eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7, 1)..Date.new(2019, 7, 6) )).sum(:price)
    @a19_27_07pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7, 1)..Date.new(2019, 7, 6) )).sum(:price)


    # Junio 2019
    @a19_27_06in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,30)..Date.new(2019, 6,30) )).sum(:price)
    @a19_27_06eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,30)..Date.new(2019, 6,30) )).sum(:price)
    @a19_27_06pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,30)..Date.new(2019, 6,30) )).sum(:price)

    @a19_26_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,23)..Date.new(2019, 6,29) )).sum(:price)
    @a19_26_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,23)..Date.new(2019, 6,29) )).sum(:price)
    @a19_26_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,23)..Date.new(2019, 6,29) )).sum(:price)

    @a19_25_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6,16)..Date.new(2019, 6,22) )).sum(:price)
    @a19_25_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6,16)..Date.new(2019, 6,22) )).sum(:price)
    @a19_25_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6,16)..Date.new(2019, 6,22) )).sum(:price)

    @a19_24_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6, 9)..Date.new(2019, 6,15) )).sum(:price)
    @a19_24_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6, 9)..Date.new(2019, 6,15) )).sum(:price)
    @a19_24_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6, 9)..Date.new(2019, 6,15) )).sum(:price)

    @a19_23_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6, 2)..Date.new(2019, 6, 8) )).sum(:price)
    @a19_23_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6, 2)..Date.new(2019, 6, 8) )).sum(:price)
    @a19_23_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6, 2)..Date.new(2019, 6, 8) )).sum(:price)

    @a19_22_06in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 6, 1)..Date.new(2019, 6, 1) )).sum(:price)
    @a19_22_06eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 6, 1)..Date.new(2019, 6, 1) )).sum(:price)
    @a19_22_06pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 6, 1)..Date.new(2019, 6, 1) )).sum(:price)


    # Mayo 2019
    @a19_22_05in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,26)..Date.new(2019, 5,31) )).sum(:price)
    @a19_22_05eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,26)..Date.new(2019, 5,31) )).sum(:price)
    @a19_22_05pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,26)..Date.new(2019, 5,31) )).sum(:price)

    @a19_21_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,19)..Date.new(2019, 5,25) )).sum(:price)
    @a19_21_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,19)..Date.new(2019, 5,25) )).sum(:price)
    @a19_21_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,19)..Date.new(2019, 5,25) )).sum(:price)

    @a19_20_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5,12)..Date.new(2019, 5,18) )).sum(:price)
    @a19_20_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5,12)..Date.new(2019, 5,18) )).sum(:price)
    @a19_20_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5,12)..Date.new(2019, 5,18) )).sum(:price)

    @a19_19_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5, 5)..Date.new(2019, 5,11) )).sum(:price)
    @a19_19_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5, 5)..Date.new(2019, 5,11) )).sum(:price)
    @a19_19_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5, 5)..Date.new(2019, 5,11) )).sum(:price)

    @a19_18_05in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 5, 1)..Date.new(2019, 5, 4) )).sum(:price)
    @a19_18_05eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 5, 1)..Date.new(2019, 5, 4) )).sum(:price)
    @a19_18_05pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 5, 1)..Date.new(2019, 5, 4) )).sum(:price)

    # Abril 2019
    @a19_18_04in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,28)..Date.new(2019, 4,30) )).sum(:price)
    @a19_18_04eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,28)..Date.new(2019, 4,30) )).sum(:price)
    @a19_18_04pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,28)..Date.new(2019, 4,30) )).sum(:price)

    @a19_17_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,21)..Date.new(2019, 4,27) )).sum(:price)
    @a19_17_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,21)..Date.new(2019, 4,27) )).sum(:price)
    @a19_17_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,21)..Date.new(2019, 4,27) )).sum(:price)

    @a19_16_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4,14)..Date.new(2019, 4,20) )).sum(:price)
    @a19_16_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4,14)..Date.new(2019, 4,20) )).sum(:price)
    @a19_16_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4,14)..Date.new(2019, 4,20) )).sum(:price)

    @a19_15_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4, 7)..Date.new(2019, 4,13) )).sum(:price)
    @a19_15_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4, 7)..Date.new(2019, 4,13) )).sum(:price)
    @a19_15_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4, 7)..Date.new(2019, 4,13) )).sum(:price)
    # ??
    @a19_14_04in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 4, 1)..Date.new(2019, 4, 6) )).sum(:price)
    @a19_14_04eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 4, 1)..Date.new(2019, 4, 6) )).sum(:price)
    @a19_14_04pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 4, 1)..Date.new(2019, 4, 6) )).sum(:price)

    # Marzo 2019
    @a19_14_03in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,31)..Date.new(2019, 3,31) )).sum(:price)
    @a19_14_03eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,31)..Date.new(2019, 3,31) )).sum(:price)
    @a19_14_03pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,31)..Date.new(2019, 3,31) )).sum(:price)

    @a19_13_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,24)..Date.new(2019, 3,30) )).sum(:price)
    @a19_13_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,24)..Date.new(2019, 3,30) )).sum(:price)
    @a19_13_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,24)..Date.new(2019, 3,30) )).sum(:price)

    @a19_12_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,17)..Date.new(2019, 3,23) )).sum(:price)
    @a19_12_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,17)..Date.new(2019, 3,23) )).sum(:price)
    @a19_12_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,17)..Date.new(2019, 3,23) )).sum(:price)

    @a19_11_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3,10)..Date.new(2019, 3,16) )).sum(:price)
    @a19_11_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3,10)..Date.new(2019, 3,16) )).sum(:price)
    @a19_11_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3,10)..Date.new(2019, 3,16) )).sum(:price)

    @a19_10_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3, 3)..Date.new(2019, 3, 9) )).sum(:price)
    @a19_10_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3, 3)..Date.new(2019, 3, 9) )).sum(:price)
    @a19_10_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3, 3)..Date.new(2019, 3, 9) )).sum(:price)

    @a19_09_03in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 3, 1)..Date.new(2019, 3, 2) )).sum(:price)
    @a19_09_03eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 3, 1)..Date.new(2019, 3, 2) )).sum(:price)
    @a19_09_03pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 3, 1)..Date.new(2019, 3, 2) )).sum(:price)

    # Febrero 2019
    @a19_09_02in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,24)..Date.new(2019, 2,28) )).sum(:price)
    @a19_09_02eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,24)..Date.new(2019, 2,28) )).sum(:price)
    @a19_09_02pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,24)..Date.new(2019, 2,28) )).sum(:price)

    @a19_08_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,17)..Date.new(2019, 2,23) )).sum(:price)
    @a19_08_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,17)..Date.new(2019, 2,23) )).sum(:price)
    @a19_08_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,17)..Date.new(2019, 2,23) )).sum(:price)

    @a19_07_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2,10)..Date.new(2019, 2,16) )).sum(:price)
    @a19_07_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2,10)..Date.new(2019, 2,16) )).sum(:price)
    @a19_07_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2,10)..Date.new(2019, 2,16) )).sum(:price)

    @a19_06_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2, 3)..Date.new(2019, 2, 9) )).sum(:price)
    @a19_06_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2, 3)..Date.new(2019, 2, 9) )).sum(:price)
    @a19_06_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2, 3)..Date.new(2019, 2, 9) )).sum(:price)

    @a19_05_02in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 2, 1)..Date.new(2019, 2, 2) )).sum(:price)
    @a19_05_02eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 2, 1)..Date.new(2019, 2, 2) )).sum(:price)
    @a19_05_02pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 2, 1)..Date.new(2019, 2, 2) )).sum(:price)

    # Ene 2019
    @a19_05_01in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,27)..Date.new(2019, 1,31) )).sum(:price)
    @a19_05_01eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,27)..Date.new(2019, 1,31) )).sum(:price)
    @a19_05_01pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,27)..Date.new(2019, 1,31) )).sum(:price)

    @a19_04_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,20)..Date.new(2019, 1,26) )).sum(:price)
    @a19_04_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,20)..Date.new(2019, 1,26) )).sum(:price)
    @a19_04_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,20)..Date.new(2019, 1,26) )).sum(:price)

    @a19_03_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1,13)..Date.new(2019, 1,19) )).sum(:price)
    @a19_03_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1,13)..Date.new(2019, 1,19) )).sum(:price)
    @a19_03_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1,13)..Date.new(2019, 1,19) )).sum(:price)

    @a19_02_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1, 6)..Date.new(2019, 1,12) )).sum(:price)
    @a19_02_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1, 6)..Date.new(2019, 1,12) )).sum(:price)
    @a19_02_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1, 6)..Date.new(2019, 1,12) )).sum(:price)

    @a19_01_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 1, 5) )).sum(:price)
    @a19_01_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 1, 5) )).sum(:price)
    @a19_01_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 1, 5) )).sum(:price)


    # Dic 2018
    @a18_53_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,30)..Date.new(2018,014,31) )).sum(:price)
    @a18_53_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,30)..Date.new(2018,014,31) )).sum(:price)
    @a18_53_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,30)..Date.new(2018,014,31) )).sum(:price)

    @a18_52_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,23)..Date.new(2018,014,29) )).sum(:price)
    @a18_52_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,23)..Date.new(2018,014,29) )).sum(:price)
    @a18_52_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,23)..Date.new(2018,014,29) )).sum(:price)

    @a18_51_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014,16)..Date.new(2018,014,22) )).sum(:price)
    @a18_51_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014,16)..Date.new(2018,014,22) )).sum(:price)
    @a18_51_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014,16)..Date.new(2018,014,22) )).sum(:price)

    @a18_50_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 9)..Date.new(2018,014,15) )).sum(:price)
    @a18_50_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 9)..Date.new(2018,014,15) )).sum(:price)
    @a18_50_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 9)..Date.new(2018,014,15) )).sum(:price)

    @a18_49_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 2)..Date.new(2018,014, 8) )).sum(:price)
    @a18_49_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 2)..Date.new(2018,014, 8) )).sum(:price)
    @a18_49_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 2)..Date.new(2018,014, 8) )).sum(:price)

    @a18_48_12in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014, 1) )).sum(:price)
    @a18_48_12eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014, 1) )).sum(:price)
    @a18_48_12pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014, 1) )).sum(:price)

    # Nov 2018
    @a18_48_11in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,25)..Date.new(2018,013,30) )).sum(:price)
    @a18_48_11eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,25)..Date.new(2018,013,30) )).sum(:price)
    @a18_48_11pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,25)..Date.new(2018,013,30) )).sum(:price)

    @a18_47_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,18)..Date.new(2018,013,24) )).sum(:price)
    @a18_47_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,18)..Date.new(2018,013,24) )).sum(:price)
    @a18_47_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,18)..Date.new(2018,013,24) )).sum(:price)

    @a18_46_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,11)..Date.new(2018,013,17) )).sum(:price)
    @a18_46_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,11)..Date.new(2018,013,17) )).sum(:price)
    @a18_46_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,11)..Date.new(2018,013,17) )).sum(:price)

    @a18_45_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013, 4)..Date.new(2018,013,10) )).sum(:price)
    @a18_45_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013, 4)..Date.new(2018,013,10) )).sum(:price)
    @a18_45_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013, 4)..Date.new(2018,013,10) )).sum(:price)

    @a18_44_11in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013, 3) )).sum(:price)
    @a18_44_11eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013, 3) )).sum(:price)
    @a18_44_11pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013, 3) )).sum(:price)


    # Oct 2018
    @a18_44_10in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,28)..Date.new(2018,012,31) )).sum(:price)
    @a18_44_10eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,28)..Date.new(2018,012,31) )).sum(:price)
    @a18_44_10pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,28)..Date.new(2018,012,31) )).sum(:price)

    @a18_43_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,21)..Date.new(2018,012,27) )).sum(:price)
    @a18_43_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,21)..Date.new(2018,012,27) )).sum(:price)
    @a18_43_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,21)..Date.new(2018,012,27) )).sum(:price)

    @a18_42_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,14)..Date.new(2018,012,20) )).sum(:price)
    @a18_42_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,14)..Date.new(2018,012,20) )).sum(:price)
    @a18_42_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,14)..Date.new(2018,012,20) )).sum(:price)

    @a18_41_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012, 7)..Date.new(2018,012,13) )).sum(:price)
    @a18_41_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012, 7)..Date.new(2018,012,13) )).sum(:price)
    @a18_41_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012, 7)..Date.new(2018,012,13) )).sum(:price)

    @a18_40_10in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012, 6) )).sum(:price)
    @a18_40_10eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012, 6) )).sum(:price)
    @a18_40_10pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012, 6) )).sum(:price)


    # Sept 2018
    @a18_40_09in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,30)..Date.new(2018,011,30) )).sum(:price)
    @a18_40_09eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,30)..Date.new(2018,011,30) )).sum(:price)
    @a18_40_09pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,30)..Date.new(2018,011,30) )).sum(:price)

    @a18_39_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,23)..Date.new(2018,011,29) )).sum(:price)
    @a18_39_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,23)..Date.new(2018,011,29) )).sum(:price)
    @a18_39_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,23)..Date.new(2018,011,29) )).sum(:price)

    @a18_38_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,16)..Date.new(2018,011,22) )).sum(:price)
    @a18_38_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,16)..Date.new(2018,011,22) )).sum(:price)
    @a18_38_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,16)..Date.new(2018,011,22) )).sum(:price)

    @a18_37_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 9)..Date.new(2018,011,15) )).sum(:price)
    @a18_37_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 9)..Date.new(2018,011,15) )).sum(:price)
    @a18_37_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 9)..Date.new(2018,011,15) )).sum(:price)

    @a18_36_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 2)..Date.new(2018,011, 8) )).sum(:price)
    @a18_36_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 2)..Date.new(2018,011, 8) )).sum(:price)
    @a18_36_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 2)..Date.new(2018,011, 8) )).sum(:price)
    # Sept 2018
    @a18_35_09in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011, 1) )).sum(:price)
    @a18_35_09eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011, 1) )).sum(:price)
    @a18_35_09pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011, 1) )).sum(:price)

    # Agosto 2018
    @a18_35_08in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,26)..Date.new(2018,010,31) )).sum(:price)
    @a18_35_08eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,26)..Date.new(2018,010,31) )).sum(:price)
    @a18_35_08pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,26)..Date.new(2018,010,31) )).sum(:price)

    @a18_34_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,19)..Date.new(2018,010,25) )).sum(:price)
    @a18_34_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,19)..Date.new(2018,010,25) )).sum(:price)
    @a18_34_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,19)..Date.new(2018,010,25) )).sum(:price)

    @a18_33_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,12)..Date.new(2018,010,18) )).sum(:price)
    @a18_33_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,12)..Date.new(2018,010,18) )).sum(:price)
    @a18_33_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,12)..Date.new(2018,010,18) )).sum(:price)

    @a18_32_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010, 5)..Date.new(2018,010,11) )).sum(:price)
    @a18_32_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010, 5)..Date.new(2018,010,11) )).sum(:price)
    @a18_32_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010, 5)..Date.new(2018,010,11) )).sum(:price)

    @a18_31_08in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010, 4) )).sum(:price)
    @a18_31_08eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010, 4) )).sum(:price)
    @a18_31_08pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010, 4) )).sum(:price)

    # Julio 2018
    @a18_31_07in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,29)..Date.new(2018, 7,31) )).sum(:price)
    @a18_31_07eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,29)..Date.new(2018, 7,31) )).sum(:price)
    @a18_31_07pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,29)..Date.new(2018, 7,31) )).sum(:price)

    @a18_30_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,22)..Date.new(2018, 7,28) )).sum(:price)
    @a18_30_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,22)..Date.new(2018, 7,28) )).sum(:price)
    @a18_30_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,22)..Date.new(2018, 7,28) )).sum(:price)

    @a18_29_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,15)..Date.new(2018, 7,21) )).sum(:price)
    @a18_29_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,15)..Date.new(2018, 7,21) )).sum(:price)
    @a18_29_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,15)..Date.new(2018, 7,21) )).sum(:price)

    @a18_28_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7, 8)..Date.new(2018, 7,14) )).sum(:price)
    @a18_28_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7, 8)..Date.new(2018, 7,14) )).sum(:price)
    @a18_28_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7, 8)..Date.new(2018, 7,14) )).sum(:price)

    @a18_27_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7, 1)..Date.new(2018, 7, 7) )).sum(:price)
    @a18_27_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7, 1)..Date.new(2018, 7, 7) )).sum(:price)
    @a18_27_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7, 1)..Date.new(2018, 7, 7) )).sum(:price)

    # Junio 2018
    @a18_26_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,24)..Date.new(2018, 6,30) )).sum(:price)
    @a18_26_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,24)..Date.new(2018, 6,30) )).sum(:price)
    @a18_26_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,24)..Date.new(2018, 6,30) )).sum(:price)

    @a18_25_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,17)..Date.new(2018, 6,23) )).sum(:price)
    @a18_25_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,17)..Date.new(2018, 6,23) )).sum(:price)
    @a18_25_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,17)..Date.new(2018, 6,23) )).sum(:price)

    @a18_24_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,10)..Date.new(2018, 6,16) )).sum(:price)
    @a18_24_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,10)..Date.new(2018, 6,16) )).sum(:price)
    @a18_24_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,10)..Date.new(2018, 6,16) )).sum(:price)

    @a18_23_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6, 3)..Date.new(2018, 6, 9) )).sum(:price)
    @a18_23_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6, 3)..Date.new(2018, 6, 9) )).sum(:price)
    @a18_23_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6, 3)..Date.new(2018, 6, 9) )).sum(:price)

    @a18_22_06in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6, 1)..Date.new(2018, 6, 2) )).sum(:price)
    @a18_22_06eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6, 1)..Date.new(2018, 6, 2) )).sum(:price)
    @a18_22_06pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6, 1)..Date.new(2018, 6, 2) )).sum(:price)

    # Mayo 2018
    @a18_22_05in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,27)..Date.new(2018, 5,31) )).sum(:price)
    @a18_22_05eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,27)..Date.new(2018, 5,31) )).sum(:price)
    @a18_22_05pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 5,27)..Date.new(2018, 5,31) )).sum(:price)

    @a18_21_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,20)..Date.new(2018, 5,26) )).sum(:price)
    @a18_21_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,20)..Date.new(2018, 5,26) )).sum(:price)
    @a18_21_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 5,20)..Date.new(2018, 5,26) )).sum(:price)

    @a18_20_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,13)..Date.new(2018, 5,19) )).sum(:price)
    @a18_20_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,13)..Date.new(2018, 5,19) )).sum(:price)
    @a18_20_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 5,13)..Date.new(2018, 5,19) )).sum(:price)

    @a18_19_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5, 6)..Date.new(2018, 5,12) )).sum(:price)
    @a18_19_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5, 6)..Date.new(2018, 5,12) )).sum(:price)
    @a18_19_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 5, 6)..Date.new(2018, 5,12) )).sum(:price)

    @a18_18_05in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5, 1)..Date.new(2018, 5, 5) )).sum(:price)
    @a18_18_05eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5, 1)..Date.new(2018, 5, 5) )).sum(:price)
    @a18_18_05pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 5, 1)..Date.new(2018, 5, 5) )).sum(:price)

    # Abr 2018
    @a18_18_04in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,29)..Date.new(2018, 4,30) )).sum(:price)
    @a18_18_04eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,29)..Date.new(2018, 4,30) )).sum(:price)
    @a18_18_04pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,29)..Date.new(2018, 4,30) )).sum(:price)

    @a18_17_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,22)..Date.new(2018, 4,28) )).sum(:price)
    @a18_17_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,22)..Date.new(2018, 4,28) )).sum(:price)
    @a18_17_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,22)..Date.new(2018, 4,28) )).sum(:price)

    @a18_16_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,15)..Date.new(2018, 4,21) )).sum(:price)
    @a18_16_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,15)..Date.new(2018, 4,21) )).sum(:price)
    @a18_16_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,15)..Date.new(2018, 4,21) )).sum(:price)

    @a18_15_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4, 8)..Date.new(2018, 4,14) )).sum(:price)
    @a18_15_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4, 8)..Date.new(2018, 4,14) )).sum(:price)
    @a18_15_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4, 8)..Date.new(2018, 4,14) )).sum(:price)

    @a18_14_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4, 1)..Date.new(2018, 4, 7) )).sum(:price)
    @a18_14_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4, 1)..Date.new(2018, 4, 7) )).sum(:price)
    @a18_14_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4, 1)..Date.new(2018, 4, 7) )).sum(:price)

    # Mar 2018
    @a18_13_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,25)..Date.new(2018, 3,31) )).sum(:price)
    @a18_13_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,25)..Date.new(2018, 3,31) )).sum(:price)
    @a18_13_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,25)..Date.new(2018, 3,31) )).sum(:price)

    @a18_12_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,18)..Date.new(2018, 3,24) )).sum(:price)
    @a18_12_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,18)..Date.new(2018, 3,24) )).sum(:price)
    @a18_12_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,18)..Date.new(2018, 3,24) )).sum(:price)

    @a18_11_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,11)..Date.new(2018, 3,17) )).sum(:price)
    @a18_11_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,11)..Date.new(2018, 3,17) )).sum(:price)
    @a18_11_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,11)..Date.new(2018, 3,17) )).sum(:price)

    @a18_10_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3, 4)..Date.new(2018, 3,10) )).sum(:price)
    @a18_10_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3, 4)..Date.new(2018, 3,10) )).sum(:price)
    @a18_10_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3, 4)..Date.new(2018, 3,10) )).sum(:price)

    @a18_09_03in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3, 1)..Date.new(2018, 3, 3) )).sum(:price)
    @a18_09_03eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3, 1)..Date.new(2018, 3, 3) )).sum(:price)
    @a18_09_03pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3, 1)..Date.new(2018, 3, 3) )).sum(:price)

    # Feb 2018
    @a18_09_02in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,25)..Date.new(2018, 2,28) )).sum(:price)
    @a18_09_02eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,25)..Date.new(2018, 2,28) )).sum(:price)
    @a18_09_02pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,25)..Date.new(2018, 2,28) )).sum(:price)

    @a18_08_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,18)..Date.new(2018, 2,24) )).sum(:price)
    @a18_08_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,18)..Date.new(2018, 2,24) )).sum(:price)
    @a18_08_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,18)..Date.new(2018, 2,24) )).sum(:price)

    @a18_07_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,11)..Date.new(2018, 2,17) )).sum(:price)
    @a18_07_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,11)..Date.new(2018, 2,17) )).sum(:price)
    @a18_07_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,11)..Date.new(2018, 2,17) )).sum(:price)

    @a18_06_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2, 4)..Date.new(2018, 2,10) )).sum(:price)
    @a18_06_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2, 4)..Date.new(2018, 2,10) )).sum(:price)
    @a18_06_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2, 4)..Date.new(2018, 2,10) )).sum(:price)

    @a18_05_02in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2, 1)..Date.new(2018, 2, 3) )).sum(:price)
    @a18_05_02eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2, 1)..Date.new(2018, 2, 3) )).sum(:price)
    @a18_05_02pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2, 1)..Date.new(2018, 2, 3) )).sum(:price)

    # Ene 2018
    @a18_05_01in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,28)..Date.new(2018, 1,31) )).sum(:price)
    @a18_05_01eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,28)..Date.new(2018, 1,31) )).sum(:price)
    @a18_05_01pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,28)..Date.new(2018, 1,31) )).sum(:price)

    @a18_04_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,21)..Date.new(2018, 1,27) )).sum(:price)
    @a18_04_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,21)..Date.new(2018, 1,27) )).sum(:price)
    @a18_04_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,21)..Date.new(2018, 1,27) )).sum(:price)

    @a18_03_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,14)..Date.new(2018, 1,20) )).sum(:price)
    @a18_03_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,14)..Date.new(2018, 1,20) )).sum(:price)
    @a18_03_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,14)..Date.new(2018, 1,20) )).sum(:price)

    @a18_02_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1, 7)..Date.new(2018, 1,13) )).sum(:price)
    @a18_02_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1, 7)..Date.new(2018, 1,13) )).sum(:price)
    @a18_02_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1, 7)..Date.new(2018, 1,13) )).sum(:price)

    @a18_01_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 1, 1)..Date.new(2018, 1, 6) )).sum(:price)
    @a18_01_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 1, 1)..Date.new(2018, 1, 6) )).sum(:price)
    @a18_01_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017, 1, 1)..Date.new(2018, 1, 6) )).sum(:price)

    # Año 2017
    # Diciembre 2017
    @a17_53_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,31)..Date.new(2018,014,31) )).sum(:price)
    @a17_53_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,31)..Date.new(2018,014,31) )).sum(:price)
    @a17_53_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,31)..Date.new(2018,014,31) )).sum(:price)

    @a17_52_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,24)..Date.new(2017,014,30) )).sum(:price)
    @a17_52_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,24)..Date.new(2017,014,30) )).sum(:price)
    @a17_52_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,24)..Date.new(2017,014,30) )).sum(:price)

    @a17_51_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,17)..Date.new(2017,014,23) )).sum(:price)
    @a17_51_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,17)..Date.new(2017,014,23) )).sum(:price)
    @a17_51_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,17)..Date.new(2017,014,23) )).sum(:price)

    @a17_50_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,10)..Date.new(2017,014,16) )).sum(:price)
    @a17_50_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,10)..Date.new(2017,014,16) )).sum(:price)
    @a17_50_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,10)..Date.new(2017,014,16) )).sum(:price)

    @a17_49_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 3)..Date.new(2017,014, 9) )).sum(:price)
    @a17_49_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 3)..Date.new(2017,014, 9) )).sum(:price)
    @a17_49_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,014, 3)..Date.new(2017,014, 9) )).sum(:price)

    @a17_48_12in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014, 2) )).sum(:price)
    @a17_48_12eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014, 2) )).sum(:price)
    @a17_48_12ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,014, 1)..Date.new(2017,014, 2) )).sum(:price)

    @a17_dc_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,31) )).sum(:price)
    @a17_dc_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,31) )).sum(:price)
    @a17_dc_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,31) )).sum(:price)

    # Noviembre 2017
    @a17_48_11in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,26)..Date.new(2017,013,30) )).sum(:price)
    @a17_48_11eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,26)..Date.new(2017,013,30) )).sum(:price)
    @a17_48_11ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013,26)..Date.new(2017,013,30) )).sum(:price)

    @a17_47_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,19)..Date.new(2017,013,25) )).sum(:price)
    @a17_47_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,19)..Date.new(2017,013,25) )).sum(:price)
    @a17_47_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013,19)..Date.new(2017,013,25) )).sum(:price)

    @a17_46_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013,12)..Date.new(2017,013,18) )).sum(:price)
    @a17_46_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013,12)..Date.new(2017,013,18) )).sum(:price)
    @a17_46_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013,12)..Date.new(2017,013,18) )).sum(:price)

    @a17_45_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013, 5)..Date.new(2017,013,11) )).sum(:price)
    @a17_45_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013, 5)..Date.new(2017,013,11) )).sum(:price)
    @a17_45_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013, 5)..Date.new(2017,013,11) )).sum(:price)

    @a17_44_11in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013, 1)..Date.new(2017,013, 4) )).sum(:price)
    @a17_44_11eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013, 1)..Date.new(2017,013, 4) )).sum(:price)
    @a17_44_11ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013, 1)..Date.new(2017,013, 4) )).sum(:price)

    @a17_nv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013, 1)..Date.new(2017,013,30) )).sum(:price)
    @a17_nv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013, 1)..Date.new(2017,013,30) )).sum(:price)
    @a17_nv_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,013, 1)..Date.new(2017,013,30) )).sum(:price)

    # Octubre 2017
    @a17_44_10in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,29)..Date.new(2017,012,31) )).sum(:price)
    @a17_44_10eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,29)..Date.new(2017,012,31) )).sum(:price)
    @a17_44_10ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012,29)..Date.new(2017,012,31) )).sum(:price)

    @a17_43_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,22)..Date.new(2017,012,28) )).sum(:price)
    @a17_43_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,22)..Date.new(2017,012,28) )).sum(:price)
    @a17_43_ct = Movement.where(mov_type: 'L°', mov_date:(Date.new(2017,012,22)..Date.new(2017,012,28) )).sum(:price)

    @a17_42_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012,15)..Date.new(2017,012,21) )).sum(:price)
    @a17_42_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012,15)..Date.new(2017,012,21) )).sum(:price)
    @a17_42_ct = Movement.where(mov_type: 'L°', mov_date:(Date.new(2017,012,15)..Date.new(2017,012,21) )).sum(:price)

    @a17_41_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012, 8)..Date.new(2017,012,14) )).sum(:price)
    @a17_41_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012, 8)..Date.new(2017,012,14) )).sum(:price)
    @a17_41_ct = Movement.where(mov_type: 'L°', mov_date:(Date.new(2017,012, 8)..Date.new(2017,012,14) )).sum(:price)

    @a17_40_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012, 7) )).sum(:price)
    @a17_40_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012, 7) )).sum(:price)
    @a17_40_ct = Movement.where(mov_type: 'L°', mov_date:(Date.new(2017,012, 1)..Date.new(2017,012, 7) )).sum(:price)

    @a17_oc_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012,31) )).sum(:price)
    @a17_oc_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012,31) )).sum(:price)
    @a17_oc_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,012, 1)..Date.new(2017,012,31) )).sum(:price)

    # Septiembre 2017
    @a17_39_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,24)..Date.new(2017,011,30) )).sum(:price)
    @a17_39_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,24)..Date.new(2017,011,30) )).sum(:price)
    @a17_39_ct = Movement.where(mov_type: 'L°', mov_date:(Date.new(2017,011,24)..Date.new(2017,011,30) )).sum(:price)

    @a17_38_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,17)..Date.new(2017,011,23) )).sum(:price)
    @a17_38_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,17)..Date.new(2017,011,23) )).sum(:price)
    @a17_38_ct = Movement.where(mov_type: 'L°', mov_date:(Date.new(2017,011,17)..Date.new(2017,011,23) )).sum(:price)

    @a17_37_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011,10)..Date.new(2017,011,16) )).sum(:price)
    @a17_37_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011,10)..Date.new(2017,011,16) )).sum(:price)
    @a17_37_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011,10)..Date.new(2017,011,16) )).sum(:price)

    @a17_36_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011, 3)..Date.new(2017,011, 9) )).sum(:price)
    @a17_36_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011, 3)..Date.new(2017,011, 9) )).sum(:price)
    @a17_36_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011, 3)..Date.new(2017,011, 9) )).sum(:price)

    @a17_35_09in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011, 2) )).sum(:price)
    @a17_35_09eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011, 2) )).sum(:price)
    @a17_35_09ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011, 1)..Date.new(2017,011, 2) )).sum(:price)

    @a17_sp_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011,30) )).sum(:price)
    @a17_sp_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011,30) )).sum(:price)
    @a17_sp_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,011, 1)..Date.new(2017,011,30) )).sum(:price)

    # Agosto 2017
    @a17_35_08in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,27)..Date.new(2017,010,31) )).sum(:price)
    @a17_35_08eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,27)..Date.new(2017,010,31) )).sum(:price)
    @a17_35_08ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,27)..Date.new(2017,010,31) )).sum(:price)

    @a17_34_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,20)..Date.new(2017,010,26) )).sum(:price)
    @a17_34_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,20)..Date.new(2017,010,26) )).sum(:price)
    @a17_34_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,20)..Date.new(2017,010,26) )).sum(:price)

    @a17_33_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010,13)..Date.new(2017,010,19) )).sum(:price)
    @a17_33_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010,13)..Date.new(2017,010,19) )).sum(:price)
    @a17_33_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010,13)..Date.new(2017,010,19) )).sum(:price)

    @a17_32_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010, 6)..Date.new(2017,010,12) )).sum(:price)
    @a17_32_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010, 6)..Date.new(2017,010,12) )).sum(:price)
    @a17_32_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010, 6)..Date.new(2017,010,12) )).sum(:price)

    @a17_31_08in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010, 1)..Date.new(2017,010, 5) )).sum(:price)
    @a17_31_08eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010, 1)..Date.new(2017,010, 5) )).sum(:price)
    @a17_31_08ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010, 1)..Date.new(2017,010, 5) )).sum(:price)

    @a17_ag_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010, 1)..Date.new(2017,010,31) )).sum(:price)
    @a17_ag_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010, 1)..Date.new(2017,010,31) )).sum(:price)
    @a17_ag_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017,010, 1)..Date.new(2017,010,31) )).sum(:price)

    # Julio 2017
    @a17_31_07in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,30)..Date.new(2017, 7,31) )).sum(:price)
    @a17_31_07eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,30)..Date.new(2017, 7,31) )).sum(:price)
    @a17_31_07ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,30)..Date.new(2017, 7,31) )).sum(:price)

    @a17_30_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,23)..Date.new(2017, 7,29) )).sum(:price)
    @a17_30_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,23)..Date.new(2017, 7,29) )).sum(:price)
    @a17_30_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,23)..Date.new(2017, 7,29) )).sum(:price)

    @a17_29_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7,16)..Date.new(2017, 7,22) )).sum(:price)
    @a17_29_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7,16)..Date.new(2017, 7,22) )).sum(:price)
    @a17_29_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7,16)..Date.new(2017, 7,22) )).sum(:price)

    @a17_28_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7, 9)..Date.new(2017, 7,15) )).sum(:price)
    @a17_28_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7, 9)..Date.new(2017, 7,15) )).sum(:price)
    @a17_28_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7, 9)..Date.new(2017, 7,15) )).sum(:price)

    @a17_27_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7, 2)..Date.new(2017, 7, 8) )).sum(:price)
    @a17_27_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7, 2)..Date.new(2017, 7, 8) )).sum(:price)
    @a17_27_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7, 2)..Date.new(2017, 7, 8) )).sum(:price)

    @a17_26_07in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7, 1)..Date.new(2017, 7, 1) )).sum(:price)
    @a17_26_07eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7, 1)..Date.new(2017, 7, 1) )).sum(:price)
    @a17_26_07ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7, 1)..Date.new(2017, 7, 1) )).sum(:price)

    @a17_jl_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 7, 1)..Date.new(2017, 7,31) )).sum(:price)
    @a17_jl_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 7, 1)..Date.new(2017, 7,31) )).sum(:price)
    @a17_jl_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 7, 1)..Date.new(2017, 7,31) )).sum(:price)

    # 2017 Junio
    @a17_26_06in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,25)..Date.new(2017, 6,30) )).sum(:price)
    @a17_26_06eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,25)..Date.new(2017, 6,30) )).sum(:price)
    @a17_26_06ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,25)..Date.new(2017, 6,30) )).sum(:price)

    @a17_25_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,18)..Date.new(2017, 6,24) )).sum(:price)
    @a17_25_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,18)..Date.new(2017, 6,24) )).sum(:price)
    @a17_25_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,18)..Date.new(2017, 6,24) )).sum(:price)

    @a17_24_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6,11)..Date.new(2017, 6,17) )).sum(:price)
    @a17_24_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6,11)..Date.new(2017, 6,17) )).sum(:price)
    @a17_24_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6,11)..Date.new(2017, 6,17) )).sum(:price)

    @a17_23_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6, 4)..Date.new(2017, 6,10) )).sum(:price)
    @a17_23_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6, 4)..Date.new(2017, 6,10) )).sum(:price)
    @a17_23_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6, 4)..Date.new(2017, 6,10) )).sum(:price)

    @a17_22_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6, 2)..Date.new(2017, 6, 3) )).sum(:price)
    @a17_22_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6, 2)..Date.new(2017, 6, 3) )).sum(:price)
    @a17_22_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6, 2)..Date.new(2017, 6, 3) )).sum(:price)
    # Junio 2017
    @a17_jn_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 6, 1)..Date.new(2017, 6,30) )).sum(:price)
    @a17_jn_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 6, 1)..Date.new(2017, 6,30) )).sum(:price)
    @a17_jn_ct = Movement.where(mov_type: 'L°',mov_date: (Date.new(2017, 6, 1)..Date.new(2017, 6,30) )).sum(:price)


    # meses
    # 2019
    @a19dc_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,014, 1)..Date.new(2019,014,31) )).sum(:price)
    @a19nv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,013, 1)..Date.new(2019,013,30) )).sum(:price)
    @a19oc_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,012, 1)..Date.new(2019,012,31) )).sum(:price)
    @a19sp_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,011, 1)..Date.new(2019,011,30) )).sum(:price)
    @a19ag_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,010, 1)..Date.new(2019,010,31) )).sum(:price)
    @a19jl_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  7, 1)..Date.new(2019,  7,31) )).sum(:price)
    @a19jn_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  6, 1)..Date.new(2019,  6,30) )).sum(:price)
    @a19my_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  5, 1)..Date.new(2019,  5,31) )).sum(:price)
    @a19ab_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  4, 1)..Date.new(2019,  4,30) )).sum(:price)
    @a19mz_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  3, 1)..Date.new(2019,  3,31) )).sum(:price)
    @a19fb_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    @a19en_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)
    # 2018
    @a18dc_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)
    @a18nv_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)
    @a18oc_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)
    @a18sp_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)
    @a18ag_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)
    @a18jl_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)
    @a18jn_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)
    @a18my_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)
    @a18ab_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)
    @a18mz_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)
    @a18fb_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)
    @a18en_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)
    @a17dc_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,31) )).sum(:price)

    @a1712_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 1)..Date.new(2017,013,14) )).sum(:price)
    @a1711_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013, 1)..Date.new(2017,013,30) )).sum(:price)
    @a1710_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012,31) )).sum(:price)
    @a1709_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011,30) )).sum(:price)
    @a1708_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010, 1)..Date.new(2017,010,31) )).sum(:price)
    @a1707_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 07, 1)..Date.new(2017, 07,31) )).sum(:price)
    @a1706_in = Movement.where(mov_type: 'I', mov_date: (DateTime.new(2017,6,1)..DateTime.new(2017,6,30) )).sum(:price)

    # 2019
    @a19dc_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,014, 1)..Date.new(2019,014,31) )).sum(:price)
    @a19nv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,013, 1)..Date.new(2019,013,30) )).sum(:price)
    @a19oc_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,012, 1)..Date.new(2019,012,31) )).sum(:price)
    @a19sp_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,011, 1)..Date.new(2019,011,30) )).sum(:price)
    @a19ag_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,010, 1)..Date.new(2019,010,31) )).sum(:price)
    @a19jl_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  7, 1)..Date.new(2019,  7,31) )).sum(:price)
    @a19jn_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  6, 1)..Date.new(2019,  6,30) )).sum(:price)
    @a19my_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  5, 1)..Date.new(2019,  5,31) )).sum(:price)
    @a19ab_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  4, 1)..Date.new(2019,  4,30) )).sum(:price)
    @a19mz_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  3, 1)..Date.new(2019,  3,31) )).sum(:price)
    @a19fb_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    @a19en_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)
    # 2018
    @a18dc_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)
    @a18nv_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)
    @a18oc_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)
    @a18sp_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)
    @a18ag_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)
    @a18jl_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)
    @a18jn_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)
    @a18my_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)
    @a18ab_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)
    @a18mz_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)
    @a18fb_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)
    @a18en_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)
    @a17dc_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,31) )).sum(:price)

    @a1712_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,14) )).sum(:price)
    @a1711_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013, 1)..Date.new(2017,013,30) )).sum(:price)
    @a1710_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012,31) )).sum(:price)
    @a1709_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011,30) )).sum(:price)
    @a1708_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010, 1)..Date.new(2017,010,31) )).sum(:price)
    @a1707_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 07, 1)..Date.new(2017, 07,31) )).sum(:price)
    @a1706_eg = Movement.where(mov_type: 'E', mov_date: (DateTime.new(2017,6,1)..DateTime.new(2017,6,30) )).sum(:price)

    # 2019
    @a19dc_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,014, 1)..Date.new(2019,014,31) )).sum(:price)
    @a19nv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,013, 1)..Date.new(2019,013,30) )).sum(:price)
    @a19oc_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,012, 1)..Date.new(2019,012,31) )).sum(:price)
    @a19sp_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,011, 1)..Date.new(2019,011,30) )).sum(:price)
    @a19ag_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,010, 1)..Date.new(2019,010,31) )).sum(:price)
    @a19jl_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  7, 1)..Date.new(2019,  7,31) )).sum(:price)
    @a19jn_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  6, 1)..Date.new(2019,  6,30) )).sum(:price)
    @a19my_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  5, 1)..Date.new(2019,  5,31) )).sum(:price)
    @a19ab_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  4, 1)..Date.new(2019,  4,30) )).sum(:price)
    @a19mz_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  3, 1)..Date.new(2019,  3,31) )).sum(:price)
    @a19fb_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    @a19en_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)
    # 2018
    @a18dc_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)
    @a18nv_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)
    @a18oc_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)
    @a18sp_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)
    @a18ag_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)
    @a18jl_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)
    @a18jn_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)
    @a18my_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)
    @a18ab_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)
    @a18mz_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)
    @a18fb_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)
    @a18en_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)

    @a17dc_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,31) )).sum(:price)

    @a1712_ct = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,14) )).sum(:price)
    @a1711_ct = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,013, 1)..Date.new(2017,013,30) )).sum(:price)
    @a1710_ct = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012,31) )).sum(:price)
    @a1709_ct = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011,30) )).sum(:price)
    @a1708_ct = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017,010, 1)..Date.new(2017,010,31) )).sum(:price)
    @a1707_ct = Movement.where(mov_type: 'L°', mov_date: (Date.new(2017, 07, 1)..Date.new(2017, 07,31) )).sum(:price)
    @a1706_ct = Movement.where(mov_type: 'L°', mov_date: (DateTime.new(2017,6,1)..DateTime.new(2017,6,30) )).sum(:price)

    # Totales
    @in    = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @in_w  = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @in_m  = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)

    @out   = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @out_w = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @out_m = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)

    @ct    = Movement.where(mov_type: 'L°', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @ct_w  = Movement.where(mov_type: 'L°', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @ct_m  = Movement.where(mov_type: 'L°', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)

    @tt_in = Movement.where(mov_type: 'I').sum(:price)
    @tt_eg = Movement.where(mov_type: 'E').sum(:price)
    @tt_ct = Movement.where(mov_type: 'L°').sum(:price)

  end


  def see_tiempo
    @movements = Movement.all

    # ---  Trim 10_11_12  --- /
    # def mes12_Nv16_Dc15
    @a12m_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)

    @a12m_an = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_dt = Movement.where(mov_type: 'A°', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_ea = @a12m_in - (@a12m_eg + @a12m_pj + @a12m_an + @a12m_dt)

    @a12m_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)

    @a12m_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    # @a12m_av = @a12m_in/31
    @nn_n  = 0
    @a12m_na = @a12m_ea - (@a12m_so+@a12m_to+@a12m_tx+@a12m_tm + @a12m_tr+@a12m_vr)

    # Financiera / Invergran / Servicrédito
    @a12m_fn = Movement.where(mov_type: 'Fª', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_fi = Movement.where(mov_type: 'F°', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_fs = Movement.where(mov_type: 'F×', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_nf = @a12m_na - (@a12m_fn + @a12m_fi + @a12m_fs)

    # ***  Contab 12 Diciembre  *** /
    @a12m_cd = Movement.where(mov_type: 'D', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_cr = Movement.where(mov_type: 'C', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)

    @a12m_pr = Movement.where(mov_type: 'F¹', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_pg = Movement.where(mov_type: 'F²', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_pi = Movement.where(mov_type: 'F³', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)

    @a12m_im = Movement.where(mov_type: 'M', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_lg = Movement.where(mov_type: 'L', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_ot = Movement.where(mov_type: 'O', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)

    @a12m_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_ps = Movement.where(mov_type: 'P', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_nc = ((@a12m_cd-@a12m_cr) + (@a12m_pr - (@a12m_pg+@a12m_pi))) - ((@a12m_im+@a12m_lg+ @a12m_ot) + (@a12m_hm+@a12m_ps+@a12m_ss))
    @a12m_tt = @a12m_nf + @a12m_nc

    # Bancos
    @a12m_bd = Movement.where(mov_type: 'B¹',mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_br = Movement.where(mov_type: 'B²',mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_bc = Movement.where(mov_type: 'B³',mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_bo = Movement.where(mov_type: 'B°',mov_date: (Date.new(2018,013,16)..Date.new(2018,014,12) )).sum(:price)
    @a12m_nb = (@a12m_bd - (@a12m_br+@a12m_bc+@a12m_bo) )


    # def mes 11 _ Oct16_Nov15
    @a11m_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)

    @a11m_an = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_dt = Movement.where(mov_type: 'A°', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_ea  = @a11m_in - (@a11m_eg + @a11m_pj + @a11m_an + @a11m_dt)

    @a11m_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)

    @a11m_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    # @a11m_av = @a11m_in/30
    @a11m_na = @a11m_ea - (@a11m_so+@a11m_to+@a11m_tx+@a11m_tm + @a11m_tr+@a11m_vr)

    # Financiera / Invergran / Servicrédito
    @a11m_fn = Movement.where(mov_type: 'Fª', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_fi = Movement.where(mov_type: 'F°', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_fs = Movement.where(mov_type: 'F×', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_nf = @a11m_na - (@a11m_fn + @a11m_fi +@a11m_fs)

    # ***  Contab 11 Nov  *** /
    @a11m_cd = Movement.where(mov_type: 'D', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_cr = Movement.where(mov_type: 'C', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)

    @a11m_pr = Movement.where(mov_type: 'F¹', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_pg = Movement.where(mov_type: 'F²', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_pi = Movement.where(mov_type: 'F³', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)

    @a11m_im = Movement.where(mov_type: 'M', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_lg = Movement.where(mov_type: 'L',  mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_ot = Movement.where(mov_type: 'O', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)

    @a11m_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_ps = Movement.where(mov_type: 'P', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_nc = ((@a11m_cd-@a11m_cr) + (@a11m_pr-(@a11m_pg+@a11m_pi))) - ((@a11m_im+@a11m_lg+@a11m_ot) + (@a11m_hm+@a11m_ps+@a11m_ss))
    @a11m_tt = @a11m_nf + @a11m_nc

    # Bancos
    @a11m_bd = Movement.where(mov_type: 'B¹',mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_br = Movement.where(mov_type: 'B²',mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_bc = Movement.where(mov_type: 'B³',mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    @a11m_bo = Movement.where(mov_type: 'B°',mov_date: (Date.new(2018,012,16)..Date.new(2018,013,15) )).sum(:price)
    # Total @a11m / Noviembre
    @a11m_nb = (@a11m_bd - (@a11m_br+@a11m_bc+@a11m_bo) )


    # def mes 10 _ Oct16_Nov15
    @a10m_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)

    @a10m_an = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_dt = Movement.where(mov_type: 'A°', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_ea = @a10m_in - (@a10m_eg + @a10m_pj + @a10m_an + @a10m_dt)

    # SubTotales Trim 10_11_12
    @a012in = @a10m_in+@a11m_in+@a12m_in
    @a012eg = @a10m_eg+@a11m_eg+@a12m_eg
    @a012pj = @a10m_pj+@a11m_pj+@a12m_pj
    @a012an = @a10m_an+@a11m_an+@a12m_an
    @a012dt = @a10m_dt+@a11m_dt+@a12m_dt
    # Neto¹ Trim 10_11_12
    @a012ea = @a10m_ea+@a11m_ea+@a12m_ea
    @a012av = @a012eg.nonzero? ? @a012in/@a012eg : 0

    @a10m_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)

    @a10m_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    # @a10m_av = @a10m_in/31
    # Neto 10 / 1a línea / subtotal 10_1
    @a10m_na = @a10m_ea - (@a10m_so+@a10m_to+@a10m_tx+@a10m_tm + @a10m_tr+@a10m_vr)
    # Netos_10_11_12
    @a012na = @a10m_na + @a11m_na + @a12m_na

    # SubTotales Trim 10_11_12
    @a012so = @a10m_so+@a11m_so+@a12m_so
    @a012to = @a10m_to+@a11m_to+@a12m_to
    @a012tx = @a10m_tx+@a11m_tx+@a12m_tx
    @a012tm = @a10m_tm+@a11m_tm+@a12m_tm
    @a012tr = @a10m_tr+@a11m_tr+@a12m_tr
    @a012vr = @a10m_vr+@a11m_vr+@a12m_vr

    # Financiera / Invergran / Servicrédito
    @a10m_fn = Movement.where(mov_type: 'Fª', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_fi = Movement.where(mov_type: 'F°', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_fs = Movement.where(mov_type: 'F×', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    # Neto 10_2 Oct / 1a línea / subtotal 10_2
    @a10m_nf = @a10m_na -(@a10m_fn + @a10m_fi + @a10m_fs)
    # Sub_Totales Trim 10_11_12 - Financ y Seguros
    @a012nf = @a10m_nf + @a11m_nf + @a12m_nf

    # SubTotales Trim 10_11_12 - Financ y Seguros
    @a012fn = @a10m_fn+@a11m_fn+@a12m_fn
    @a012fi = @a10m_fi+@a11m_fi+@a12m_fi
    @a012fs = @a10m_fs+@a11m_fs+@a12m_fs


    # ***  Contab 10  *** /
    @a10m_cd = Movement.where(mov_type: 'D', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_cr = Movement.where(mov_type: 'C', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)

    @a10m_pr = Movement.where(mov_type: 'F¹', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_pg = Movement.where(mov_type: 'F²', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_pi = Movement.where(mov_type: 'F³', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)

    @a10m_im = Movement.where(mov_type: 'M', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_lg = Movement.where(mov_type: 'L',  mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_ot = Movement.where(mov_type: 'O', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)

    @a10m_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_ps = Movement.where(mov_type: 'P', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    # Neto 10 / 1a línea / subtotal 10_3
    @a10m_nc = ((@a10m_cd-@a10m_cr) + (@a10m_pr - (@a10m_pg+@a10m_pi))) - ((@a10m_im+@a10m_lg+ @a10m_ot) + (@a10m_hm+@a10m_ps+@a10m_ss))

    # SubTotales Trim 10_11_12 - Contab, hm, ps
    @a012cd = @a10m_cd+@a11m_cd+@a12m_cd
    @a012cr = @a10m_cr+@a11m_cr+@a12m_cr
    @a012pr = @a10m_pr+@a11m_pr+@a12m_pr
    @a012pg = @a10m_pg+@a11m_pg+@a12m_pg
    @a012pi = @a10m_pi+@a11m_pi+@a12m_pi
    @a012im = @a10m_im+@a11m_im+@a12m_im
    @a012lg = @a10m_lg+@a11m_lg+@a12m_lg
    @a012ot = @a10m_ot+@a11m_ot+@a12m_ot
    @a012hm = @a10m_hm+@a11m_hm+@a12m_hm
    @a012ps = @a10m_ps+@a11m_ps+@a12m_ps
    @a012ss = @a10m_ss+@a11m_ss+@a12m_ss
    # Neto Contab 10_11_12
    @a012nc = @a10m_nc + @a11m_nc + @a12m_nc

    # **  Total semestre ***
    @a10m_tt = @a10m_nf + @a10m_nc
    @a012tt = @a10m_tt + @a11m_tt + @a12m_tt

    # Bancos
    @a10m_bd = Movement.where(mov_type: 'B¹',mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_br = Movement.where(mov_type: 'B²',mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_bc = Movement.where(mov_type: 'B³',mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)
    @a10m_bo = Movement.where(mov_type: 'B°',mov_date: (Date.new(2018,011,16)..Date.new(2018,012,15) )).sum(:price)

    # Bancos - Total Trim 10_11_12
    @a012bd = @a10m_bd+@a11m_bd+@a12m_bd
    @a012br = @a10m_br+@a11m_br+@a12m_br
    @a012bc = @a10m_bc+@a11m_bc+@a12m_bc
    @a012bo = @a10m_bo+@a11m_bo+@a12m_bo

    # Total Octubre
    @a10m_nb = (@a10m_bd -(@a10m_br+@a10m_bc+@a10m_bo) )
    @a012nb = (@a10m_nb + @a11m_nb + @a12m_nb)


    # *****
    # ---  Trim789  --- /
    # def mes9_Ag16_Sp15
    @a9m_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)

    @a9m_an = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_dt = Movement.where(mov_type: 'A°', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_ea = @a9m_in - (@a9m_eg + @a9m_pj + @a9m_an + @a9m_dt)

    @a9m_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)

    @a9m_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    # @a9m_av = @a9m_in/31
    @nn_n  = 0
    @a9m_na = @a9m_ea - (@a9m_so+@a9m_to+@a9m_tx+@a9m_tm + @a9m_tr+@a9m_vr)

    # Financiera / Invergran / Servicrédito
    @a9m_fn = Movement.where(mov_type: 'Fª', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_fi = Movement.where(mov_type: 'F°', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_fs = Movement.where(mov_type: 'F×', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_nf = @a9m_na - (@a9m_fn + @a9m_fi + @a9m_fs)

    # ***  Contab 9 Septiembre  *** /
    @a9m_cd = Movement.where(mov_type: 'D', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_cr = Movement.where(mov_type: 'C', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)

    @a9m_pr = Movement.where(mov_type: 'F¹', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_pg = Movement.where(mov_type: 'F²', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_pi = Movement.where(mov_type: 'F³', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)

    @a9m_im = Movement.where(mov_type: 'M', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_lg = Movement.where(mov_type: 'L', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_ot = Movement.where(mov_type: 'O', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)

    @a9m_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_ps = Movement.where(mov_type: 'P', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_nc = ((@a9m_cd-@a9m_cr) + (@a9m_pr - (@a9m_pg+@a9m_pi))) - ((@a9m_im+@a9m_lg+ @a9m_ot) + (@a9m_hm+@a9m_ps+@a9m_ss))
    @a9m_tt = @a9m_nf + @a9m_nc

    # Bancos
    @a9m_bd = Movement.where(mov_type: 'B¹',mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_br = Movement.where(mov_type: 'B²',mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_bc = Movement.where(mov_type: 'B³',mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_bo = Movement.where(mov_type: 'B°',mov_date: (Date.new(2018,010,16)..Date.new(2018,011,15) )).sum(:price)
    @a9m_nb = (@a9m_bd - (@a9m_br+@a9m_bc+@a9m_bo) )


    # def mes8_Jl16_Ag15
    @a8m_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)

    @a8m_an = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_dt = Movement.where(mov_type: 'A°', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_ea  = @a8m_in - (@a8m_eg + @a8m_pj + @a8m_an + @a8m_dt)

    @a8m_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)

    @a8m_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    # @a8m_av = @a8m_in/30
    @a8m_na = @a8m_ea - (@a8m_so+@a8m_to+@a8m_tx+@a8m_tm + @a8m_tr+@a8m_vr)

    # Financiera / Invergran / Servicrédito
    @a8m_fn = Movement.where(mov_type: 'Fª', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_fi = Movement.where(mov_type: 'F°', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_fs = Movement.where(mov_type: 'F×', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_nf = @a8m_na - (@a8m_fn + @a8m_fi +@a8m_fs)

    # ***  Contab 8 Agosto  *** /
    @a8m_cd = Movement.where(mov_type: 'D', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_cr = Movement.where(mov_type: 'C', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)

    @a8m_pr = Movement.where(mov_type: 'F¹', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_pg = Movement.where(mov_type: 'F²', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_pi = Movement.where(mov_type: 'F³', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)

    @a8m_im = Movement.where(mov_type: 'M', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_lg = Movement.where(mov_type: 'L',  mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_ot = Movement.where(mov_type: 'O', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)

    @a8m_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_ps = Movement.where(mov_type: 'P', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_nc = ((@a8m_cd-@a8m_cr) + (@a8m_pr - (@a8m_pg+@a8m_pi))) - ((@a8m_im+@a8m_lg+@a8m_ot) + (@a8m_hm+@a8m_ps+@a8m_ss))
    @a8m_tt = @a8m_nf + @a8m_nc

    # Bancos
    @a8m_bd = Movement.where(mov_type: 'B¹',mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_br = Movement.where(mov_type: 'B²',mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_bc = Movement.where(mov_type: 'B³',mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    @a8m_bo = Movement.where(mov_type: 'B°',mov_date: (Date.new(2018, 7,16)..Date.new(2018,010,15) )).sum(:price)
    # Total @a8m / Agosto
    @a8m_nb = (@a8m_bd - (@a8m_br+@a8m_bc+@a8m_bo) )


    # def mes7_Jun16_Jul15
    @a7m_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)

    @a7m_an = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_dt = Movement.where(mov_type: 'A°', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_ea = @a7m_in - (@a7m_eg + @a7m_pj + @a7m_an + @a7m_dt)

    # subTotales Trim789
    @a789in = @a7m_in+@a8m_in+@a9m_in
    @a789eg = @a7m_eg+@a8m_eg+@a9m_eg
    @a789pj = @a7m_pj+@a8m_pj+@a9m_pj
    @a789an = @a7m_an+@a8m_an+@a9m_an
    @a789dt = @a7m_dt+@a8m_dt+@a9m_dt
    # Neto¹ 789
    @a789ea = @a7m_ea+@a8m_ea+@a9m_ea
    @a789av = @a789eg.nonzero? ? @a789in/@a789eg : 0

    @a7m_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)

    @a7m_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    # @a7m_av = @a7m_in/31
    # Neto 7 / 1a línea / subtotal 7_1
    @a7m_na = @a7m_ea - (@a7m_so+@a7m_to+@a7m_tx+@a7m_tm + @a7m_tr+@a7m_vr)
    # Netos_789
    @a789na = @a7m_na + @a8m_na + @a9m_na

    # subTotales Trim789
    @a789so = @a7m_so+@a8m_so+@a9m_so
    @a789to = @a7m_to+@a8m_to+@a9m_to
    @a789tx = @a7m_tx+@a8m_tx+@a9m_tx
    @a789tm = @a7m_tm+@a8m_tm+@a9m_tm
    @a789tr = @a7m_tr+@a8m_tr+@a9m_tr
    @a789vr = @a7m_vr+@a8m_vr+@a9m_vr

    # Financiera / Invergran / Servicrédito
    @a7m_fn = Movement.where(mov_type: 'Fª', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_fi = Movement.where(mov_type: 'F°', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_fs = Movement.where(mov_type: 'F×', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    # Neto 7_2 Julio / 1a línea / subtotal 7_2
    @a7m_nf = @a7m_na -(@a7m_fn + @a7m_fi + @a7m_fs)
    # Sub_Totales Trim456 - Financ y Seguros
    @a789nf = @a7m_nf + @a8m_nf + @a9m_nf

    # SubTotales Trim789 - Financ y Seguros
    @a789fn = @a7m_fn+@a8m_fn+@a9m_fn
    @a789fi = @a7m_fi+@a8m_fi+@a9m_fi
    @a789fs = @a7m_fs+@a8m_fs+@a9m_fs


    # ***  Contab 7  *** /
    @a7m_cd = Movement.where(mov_type: 'D', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_cr = Movement.where(mov_type: 'C', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)

    @a7m_pr = Movement.where(mov_type: 'F¹', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_pg = Movement.where(mov_type: 'F²', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_pi = Movement.where(mov_type: 'F³', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)

    @a7m_im = Movement.where(mov_type: 'M', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_lg = Movement.where(mov_type: 'L',  mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_ot = Movement.where(mov_type: 'O', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)

    @a7m_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_ps = Movement.where(mov_type: 'P', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    # Neto 7 / 1a línea / subtotal 7_3
    @a7m_nc = ((@a7m_cd-@a7m_cr) + (@a7m_pr - (@a7m_pg+@a7m_pi))) - ((@a7m_im+@a7m_lg+ @a7m_ot) + (@a7m_hm+@a7m_ps+@a7m_ss))

    # SubTotales Trim789 - Contab, hm, ps, ss
    @a789cd = @a7m_cd+@a8m_cd+@a9m_cd
    @a789cr = @a7m_cr+@a8m_cr+@a9m_cr
    @a789pr = @a7m_pr+@a8m_pr+@a9m_pr
    @a789pg = @a7m_pg+@a8m_pg+@a9m_pg
    @a789pi = @a7m_pi+@a8m_pi+@a9m_pi
    @a789im = @a7m_im+@a8m_im+@a9m_im
    @a789lg = @a7m_lg+@a8m_lg+@a9m_lg
    @a789ot = @a7m_ot+@a8m_ot+@a9m_ot
    @a789hm = @a7m_hm+@a8m_hm+@a9m_hm
    @a789ps = @a7m_ps+@a8m_ps+@a9m_ps
    @a789ss = @a7m_ss+@a8m_ss+@a9m_ss
    # Neto Contab 789
    @a789nc = @a7m_nc + @a8m_nc + @a9m_nc

    # **  Total semestre ***
    @a7m_tt = @a7m_nf + @a7m_nc
    @a789tt = @a7m_tt + @a8m_tt + @a9m_tt

    # Bancos
    @a7m_bd = Movement.where(mov_type: 'B¹',mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_br = Movement.where(mov_type: 'B²',mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_bc = Movement.where(mov_type: 'B³',mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)
    @a7m_bo = Movement.where(mov_type: 'B°',mov_date: (Date.new(2018, 6,16)..Date.new(2018, 7,15) )).sum(:price)

    # Bancos - Total Trim456
    @a789bd = @a7m_bd+@a8m_bd+@a9m_bd
    @a789br = @a7m_br+@a8m_br+@a9m_br
    @a789bc = @a7m_bc+@a8m_bc+@a9m_bc
    @a789bo = @a7m_bo+@a8m_bo+@a9m_bo

    # Total Julio
    @a7m_nb = (@a7m_bd -(@a7m_br+@a7m_bc+@a7m_bo) )
    @a789nb = (@a7m_nb + @a8m_nb + @a9m_nb)


    # ---  Trim456  --- /
    # def mes6_My16_Jn15
    @a6m_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)

    @a6m_an = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_dt = Movement.where(mov_type: 'A°', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_ea  = @a6m_in - (@a6m_eg + @a6m_pj + @a6m_an + @a6m_dt)

    @a6m_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)

    @a6m_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    # @a6m_av = @a6m_in/31
    @nn_n  = 0
    @a6m_na = @a6m_ea - (@a6m_so+@a6m_to+@a6m_tx+@a6m_tm + @a6m_tr+@a6m_vr)

    # Financiera / Invergran / Servicrédito
    @a6m_fn = Movement.where(mov_type: 'Fª', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_fi = Movement.where(mov_type: 'F°', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_fs = Movement.where(mov_type: 'F×', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_nf = @a6m_na - (@a6m_fn + @a6m_fi + @a6m_fs)

    # *******  Contab 6 Junio  ******* /
    @a6m_cd = Movement.where(mov_type: 'D', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_cr = Movement.where(mov_type: 'C', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)

    @a6m_pr = Movement.where(mov_type: 'F¹', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_pg = Movement.where(mov_type: 'F²', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_pi = Movement.where(mov_type: 'F³', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)

    @a6m_im = Movement.where(mov_type: 'M', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_lg = Movement.where(mov_type: 'L', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_ot = Movement.where(mov_type: 'O', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)

    @a6m_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_ps = Movement.where(mov_type: 'P', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_nc = ((@a6m_cd-@a6m_cr) + (@a6m_pr - (@a6m_pg+@a6m_pi))) - ((@a6m_im+@a6m_lg+ @a6m_ot) + (@a6m_hm+@a6m_ps+@a6m_ss))
    @a6m_tt = @a6m_nf + @a6m_nc

    # Bancos
    @a6m_bd = Movement.where(mov_type: 'B¹',mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_br = Movement.where(mov_type: 'B²',mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_bc = Movement.where(mov_type: 'B³',mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_bo = Movement.where(mov_type: 'B°',mov_date: (Date.new(2018, 5,16)..Date.new(2018, 6,15) )).sum(:price)
    @a6m_nb = (@a6m_bd - (@a6m_br+@a6m_bc+@a6m_bo) )

    # -------------- /
    # def mes5_Ab13_My12
    @a5m_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)

    @a5m_an = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_dt = Movement.where(mov_type: 'A°', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_ea  = @a5m_in - (@a5m_eg + @a5m_pj + @a5m_an + @a5m_dt)

    @a5m_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)

    @a5m_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    # @a5m_av = @a5m_in/30
    @a5m_na = @a5m_ea - (@a5m_so+@a5m_to+@a5m_tx+@a5m_tm + @a5m_tr+@a5m_vr)

    # Financiera / Invergran / Servicrédito
    @a5m_fn = Movement.where(mov_type: 'Fª', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_fi = Movement.where(mov_type: 'F°', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_fs = Movement.where(mov_type: 'F×', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_nf = @a5m_na - (@a5m_fn + @a5m_fi +@a5m_fs)

    # *******  Contab 5 Mayo  ******* /
    @a5m_cd = Movement.where(mov_type: 'D', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_cr = Movement.where(mov_type: 'C', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)

    @a5m_pr = Movement.where(mov_type: 'F¹', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_pg = Movement.where(mov_type: 'F²', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_pi = Movement.where(mov_type: 'F³', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)

    @a5m_im = Movement.where(mov_type: 'M', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_lg = Movement.where(mov_type: 'L', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_ot = Movement.where(mov_type: 'O', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)

    @a5m_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_ps = Movement.where(mov_type: 'P', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_nc = ((@a5m_cd-@a5m_cr) + (@a5m_pr - (@a5m_pg+@a5m_pi))) - ((@a5m_im+@a5m_lg+ @a5m_ot) + (@a5m_hm+@a5m_ps+@a5m_ss))
    @a5m_tt = @a5m_nf + @a5m_nc

    # Bancos
    @a5m_bd = Movement.where(mov_type: 'B¹',mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_br = Movement.where(mov_type: 'B²',mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_bc = Movement.where(mov_type: 'B³',mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    @a5m_bo = Movement.where(mov_type: 'B°',mov_date: (Date.new(2018, 4,16)..Date.new(2018, 5,15) )).sum(:price)
    # Total @a5m / Mayo
    @a5m_nb = (@a5m_bd - (@a5m_br+@a5m_bc+@a5m_bo) )

    # -------------- /
    # def mes4_Mz13_Ab12
    @a4m_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)

    @a4m_an = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_dt = Movement.where(mov_type: 'A°', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_ea = @a4m_in - (@a4m_eg + @a4m_pj + @a4m_an + @a4m_dt)

    # subTotales Trim456
    @a456in = @a4m_in+@a5m_in+@a6m_in
    @a456eg = @a4m_eg+@a5m_eg+@a6m_eg
    @a456pj = @a4m_pj+@a5m_pj+@a6m_pj
    @a456an = @a4m_an+@a5m_an+@a6m_an
    @a456dt = @a4m_dt+@a5m_dt+@a6m_dt
    # Neto¹ 456
    @a456ea = @a4m_ea + @a5m_ea + @a6m_ea
    @a456av = @a456eg.nonzero? ? @a456in/@a456eg : 0

    @a4m_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)

    @a4m_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    # @a4m_av = @a4m_in/31
    # Neto 4 / 1a línea / subtotal 4_1
    @a4m_na = @a4m_ea - (@a4m_so+@a4m_to+@a4m_tx+@a4m_tm + @a4m_tr+@a4m_vr)
    # Netos_456
    @a456na = @a4m_na + @a5m_na + @a6m_na

    # subTotales Trim456
    @a456so = @a4m_so+@a5m_so+@a6m_so
    @a456to = @a4m_to+@a5m_to+@a6m_to
    @a456tx = @a4m_tx+@a5m_tx+@a6m_tx
    @a456tm = @a4m_tm+@a5m_tm+@a6m_tm
    @a456tr = @a4m_tr+@a5m_tr+@a6m_tr
    @a456vr = @a4m_vr+@a5m_vr+@a6m_vr

    # Financiera / Invergran / Servicrédito
    @a4m_fn = Movement.where(mov_type: 'Fª', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_fi = Movement.where(mov_type: 'F°', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_fs = Movement.where(mov_type: 'F×', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    # Neto 4_2 Abril / 1a línea / subtotal 4_2
    @a4m_nf = @a4m_na -(@a4m_fn + @a4m_fi + @a4m_fs)
    # Sub_Totales Trim456 - Financ y Seguros
    @a456nf = @a4m_nf + @a5m_nf + @a6m_nf

    # SubTotales Trim456 - Financ y Seguros
    @a456fn = @a4m_fn+@a5m_fn+@a6m_fn
    @a456fi = @a4m_fi+@a5m_fi+@a6m_fi
    @a456fs = @a4m_fs+@a5m_fs+@a6m_fs

    # *******  Contab 4  ******* /
    @a4m_cd = Movement.where(mov_type: 'D', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_cr = Movement.where(mov_type: 'C', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)

    @a4m_pr = Movement.where(mov_type: 'F¹', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_pg = Movement.where(mov_type: 'F²', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_pi = Movement.where(mov_type: 'F³', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)

    @a4m_im = Movement.where(mov_type: 'M', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_lg = Movement.where(mov_type: 'L', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_ot = Movement.where(mov_type: 'O', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)

    @a4m_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_ps = Movement.where(mov_type: 'P', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    # Neto 4 / 1a línea / subtotal 4_3
    @a4m_nc = ((@a4m_cd-@a4m_cr) + (@a4m_pr - (@a4m_pg+@a4m_pi))) - ((@a4m_im+@a4m_lg+ @a4m_ot) + (@a4m_hm+@a4m_ps+@a4m_ss))

    # SubTotales Trim456 - Contab, hm, ps
    @a456cd = @a4m_cd+@a5m_cd+@a6m_cd
    @a456cr = @a4m_cr+@a5m_cr+@a6m_cr
    @a456pr = @a4m_pr+@a5m_pr+@a6m_pr
    @a456pg = @a4m_pg+@a5m_pg+@a6m_pg
    @a456pi = @a4m_pi+@a5m_pi+@a6m_pi
    @a456im = @a4m_im+@a5m_im+@a6m_im
    @a456lg = @a4m_lg+@a5m_lg+@a6m_lg
    @a456ot = @a4m_ot+@a5m_ot+@a6m_ot
    @a456hm = @a4m_hm+@a5m_hm+@a6m_hm
    @a456ps = @a4m_ps+@a5m_ps+@a6m_ps
    @a456ss = @a4m_ss+@a5m_ss+@a6m_ss
    # Neto Contab 456
    @a456nc = @a4m_nc + @a5m_nc + @a6m_nc

    # **  Total semestre ***
    @a4m_tt = @a4m_nf + @a4m_nc
    @a456tt = @a4m_tt + @a5m_tt + @a6m_tt

    # Bancos
    @a4m_bd = Movement.where(mov_type: 'B¹',mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_br = Movement.where(mov_type: 'B²',mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_bc = Movement.where(mov_type: 'B³',mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)
    @a4m_bo = Movement.where(mov_type: 'B°',mov_date: (Date.new(2018, 3,16)..Date.new(2018, 4,15) )).sum(:price)

    # Bancos - Total Trim456
    @a456bd = @a4m_bd+@a5m_bd+@a6m_bd
    @a456br = @a4m_br+@a5m_br+@a6m_br
    @a456bc = @a4m_bc+@a5m_bc+@a6m_bc
    @a456bo = @a4m_bo+@a5m_bo+@a6m_bo

    # Total Abril
    @a4m_nb = (@a4m_bd -(@a4m_br+@a4m_bc+@a4m_bo) )
    @a456nb = (@a4m_nb + @a5m_nb + @a6m_nb)


    # ---  Trim123  --- /
    # def mes3_Fb13_Mz12
    @a3m_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)

    @a3m_an = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_dt = Movement.where(mov_type: 'A°', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_ea = @a3m_in - (@a3m_eg + @a3m_pj + @a3m_an + @a3m_dt)

    @a3m_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)

    @a3m_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    # @a3m_av = @a3m_in/28
    # Neto 3 / 1a línea / subtotal 3_1
    @a3m_na = (@a3m_in - (@a3m_eg+@a3m_pj + @a3m_an+@a3m_dt + @a3m_so+@a3m_to+@a3m_tx+@a3m_tm + @a3m_tr+@a3m_vr) )

    # Financiera / Invergran / Servicrédito
    @a3m_fn = Movement.where(mov_type: 'Fª', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_fi = Movement.where(mov_type: 'F°', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_fs = Movement.where(mov_type: 'F×', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    # Neto 3 / 1a línea / subtotal 3_2
    @a3m_nf = @a3m_na - (@a3m_fn + @a3m_fi + @a3m_fs)

    # *******  Contab 3  ******* /
    @a3m_cd = Movement.where(mov_type: 'D', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_cr = Movement.where(mov_type: 'C', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)

    @a3m_pr = Movement.where(mov_type: 'F¹', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_pg = Movement.where(mov_type: 'F²', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_pi = Movement.where(mov_type: 'F²', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)

    @a3m_im = Movement.where(mov_type: 'M', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_lg = Movement.where(mov_type: 'L', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_ot = Movement.where(mov_type: 'O', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)

    @a3m_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_ps = Movement.where(mov_type: 'P', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    # Neto 3 / 1a línea / subtotal 3_3
    @a3m_nc = ((@a3m_cd-@a3m_cr) + (@a3m_pr - (@a3m_pg+@a3m_pi))) - ((@a3m_im+@a3m_lg+ @a3m_ot) + (@a3m_hm+@a3m_ps+@a3m_ss))

    # Total 3 / 2a línea
    @a3m_tt = @a3m_nf +  @a3m_nc

    # Bancos
    @a3m_bd = Movement.where(mov_type: 'B¹',mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_br = Movement.where(mov_type: 'B²',mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_bc = Movement.where(mov_type: 'B³',mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    @a3m_bo = Movement.where(mov_type: 'B°',mov_date: (Date.new(2018, 2,13)..Date.new(2018, 3,15) )).sum(:price)
    # Neto / Marzo // Línea única
    @a3m_nb = (@a3m_bd - (@a3m_br+@a3m_bc+@a3m_bo) )

    # -------------- /
    # def mes2_En13_Fb12
    @a2m_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)

    @a2m_an = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_dt = Movement.where(mov_type: 'A°', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_ea  = @a2m_in -(@a2m_eg + @a2m_pj + @a2m_an + @a2m_dt)

    @a2m_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)

    @a2m_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    # @a2m_av = @a2m_in/31
    # Neto 2 / 1a línea
    @a2m_na = (@a2m_in - (@a2m_eg+@a2m_pj + @a2m_an+@a2m_dt + @a2m_so+@a2m_to+@a2m_tx+@a2m_tm + @a2m_tr+@a2m_vr) )

    # Financiera / Invergran / Servicrédito
    @a2m_fn = Movement.where(mov_type: 'Fª', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_fi = Movement.where(mov_type: 'F°', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_fs = Movement.where(mov_type: 'F×', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    # Neto 2 Financ / 1a línea / subtotal 3_2
    @a2m_nf = @a2m_na - (@a2m_fn + @a2m_fi + @a2m_fs)

    # *******  Contab 2 ******* /
    @a2m_cd = Movement.where(mov_type: 'D', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_cr = Movement.where(mov_type: 'C', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)

    @a2m_pr = Movement.where(mov_type: 'F¹', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_pg = Movement.where(mov_type: 'F²', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_pi = Movement.where(mov_type: 'F³', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)

    @a2m_im = Movement.where(mov_type: 'M', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_lg = Movement.where(mov_type: 'L', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_ot = Movement.where(mov_type: 'O', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)

    @a2m_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_ps = Movement.where(mov_type: 'P', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    # Neto 2 Contab / 1a línea / subtotal 3_3
    @a2m_nc = ((@a2m_cd-@a2m_cr) + (@a2m_pr - (@a2m_pg+@a2m_pi))) - ((@a2m_im+@a2m_lg+ @a2m_ot) + (@a2m_hm+@a2m_ps+@a2m_ss))
    # Total
    @a2m_tt = @a2m_nf +  @a2m_nc

    # Bancos
    @a2m_bd = Movement.where(mov_type: 'B¹',mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_br = Movement.where(mov_type: 'B²',mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_bc = Movement.where(mov_type: 'B³',mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    @a2m_bo = Movement.where(mov_type: 'B°',mov_date: (Date.new(2018, 1,13)..Date.new(2018, 2,12) )).sum(:price)
    # Neto / Febrero // Línea única
    @a2m_nb = (@a2m_bd - (@a2m_br+@a2m_bc+@a2m_bo) )

    # -------------- /
    # def mes1_Dc13_En12
    @a1m_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)

    @a1m_an = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_dt = Movement.where(mov_type: 'A°', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    # Neto¹ 123
    @a1m_ea = @a1m_in -(@a1m_eg + @a1m_pj + @a1m_an + @a1m_dt)
    @a123ea = @a1m_ea + @a2m_ea + @a3m_ea

    # subTotales Trim123
    @a123in = @a1m_in+@a2m_in+@a3m_in
    @a123eg = @a1m_eg+@a2m_eg+@a3m_eg
    @a123pj = @a1m_pj+@a2m_pj+@a3m_pj
    @a123an = @a1m_an+@a2m_an+@a3m_an
    @a123dt = @a1m_dt+@a2m_dt+@a3m_dt
    @a123av = @a123eg.nonzero? ? @a123in/@a123eg : 0


    @a1m_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)

    @a1m_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    # @a1m_av = @a1m_in/31
    # Neto 1_1 Enero / 1a línea / subtotal 3_1
    @a1m_na = (@a1m_in - (@a1m_eg+@a1m_pj + @a1m_an+@a1m_dt + @a1m_so+@a1m_to+@a1m_tx+@a1m_tm + @a1m_tr+@a1m_vr) )
    # Netos_123
    @a123na = @a1m_na + @a2m_na + @a3m_na

    # SubTotales Trim123
    @a123so = @a1m_so+@a2m_so+@a3m_so
    @a123to = @a1m_to+@a2m_to+@a3m_to
    @a123tx = @a1m_tx+@a2m_tx+@a3m_tx
    @a123tm = @a1m_tm+@a2m_tm+@a3m_tm

    @a123tr = @a1m_tr+@a2m_tr+@a3m_tr
    @a123vr = @a1m_vr+@a2m_vr+@a3m_vr

    # Financiera / Invergran / Servicrédito // Enero 2018
    @a1m_fn = Movement.where(mov_type: 'Fª', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_fi = Movement.where(mov_type: 'F°', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_fs = Movement.where(mov_type: 'F×', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    # Neto 1_2 Enero / 1a línea / subtotal 3_2
    @a1m_nf = @a1m_na -(@a1m_fn + @a1m_fi + @a1m_fs)
    # Sub_Totales Trim123 - Financ y Seguros
    @a123nf = @a1m_nf + @a2m_nf + @a3m_nf

    @a123fn = @a1m_fn+@a2m_fn+@a3m_fn
    @a123fi = @a1m_fi+@a2m_fi+@a3m_fi
    @a123fs = @a1m_fs+@a2m_fs+@a3m_fs


    # ***  Contab 1 *** /
    @a1m_cd = Movement.where(mov_type: 'D', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_cr = Movement.where(mov_type: 'C', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)

    @a1m_pr = Movement.where(mov_type: 'F¹', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_pg = Movement.where(mov_type: 'F²', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_pi = Movement.where(mov_type: 'F³', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)

    @a1m_im = Movement.where(mov_type: 'M', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_lg = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_ot = Movement.where(mov_type: 'O', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)

    @a1m_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_ps = Movement.where(mov_type: 'P', mov_date: (Date.new(2017,014,11)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2018,014,11)..Date.new(2018, 1,12) )).sum(:price)
    # Neto 1_3 Enero Contab / 1a línea / subtotal 3_3
    @a1m_nc = ((@a1m_cd-@a1m_cr) + (@a1m_pr - (@a1m_pg+@a1m_pi))) - ((@a1m_im+@a1m_lg+ @a1m_ot) + (@a1m_hm+@a1m_ps+@a1m_ss))
    # Neto Contab 123
    @a123nc = @a1m_nc + @a2m_nc + @a3m_nc

    # SubTotales Trim456 - Contab, hm, ps
    @a123cd = @a1m_cd+@a2m_cd+@a3m_cd
    @a123cr = @a1m_cr+@a2m_cr+@a3m_cr
    @a123pr = @a1m_pr+@a2m_pr+@a3m_pr
    @a123pg = @a1m_pg+@a2m_pg+@a3m_pg
    @a123pi = @a1m_pi+@a2m_pi+@a3m_pi
    @a123im = @a1m_im+@a2m_im+@a3m_im
    @a123lg = @a1m_lg+@a2m_lg+@a3m_lg
    @a123ot = @a1m_ot+@a2m_ot+@a3m_ot
    @a123hm = @a1m_hm+@a2m_hm+@a3m_hm
    @a123ps = @a1m_ps+@a2m_ps+@a3m_ps
    @a123ss = @a1m_ss+@a2m_ss+@a3m_ss

    # ***  Total  ***
    @a1m_tt = @a1m_nf +  @a1m_nc
    @a123tt = @a1m_tt + @a2m_tt + @a3m_tt

    # Bancos
    @a1m_bd = Movement.where(mov_type: 'B¹',mov_date: (Date.new(2017,014, 1)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_br = Movement.where(mov_type: 'B²',mov_date: (Date.new(2017,014, 1)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_bc = Movement.where(mov_type: 'B³',mov_date: (Date.new(2017,014, 1)..Date.new(2018, 1,12) )).sum(:price)
    @a1m_bo = Movement.where(mov_type: 'B°',mov_date: (Date.new(2017,014, 1)..Date.new(2018, 1,12) )).sum(:price)
    # Subtotal Trim123
    @a123bd = @a1m_bd+@a2m_bd+@a3m_bd
    @a123br = @a1m_br+@a2m_br+@a3m_br
    @a123bc = @a1m_bc+@a2m_bc+@a3m_bc
    @a123bo = @a1m_bo+@a2m_bo+@a3m_bo
    # Neto Febrero
    @a1m_nb = (@a1m_bd -(@a1m_br+@a1m_bc+@a1m_bo) )
    @a123nb = (@a1m_nb + @a2m_nb + @a3m_nb)


    # / ___________ /
    # Bancos
    @ad_bd = Movement.where(mov_type: 'B¹', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_bd = Movement.where(mov_type: 'B¹', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_bd = Movement.where(mov_type: 'B¹', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_bd = Movement.where(mov_type: 'B¹', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)

    @ad_br = Movement.where(mov_type: 'B²', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_br = Movement.where(mov_type: 'B²', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_br = Movement.where(mov_type: 'B²', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @ay_br = Movement.where(mov_type: 'B²', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)

    @ad_bc = Movement.where(mov_type: 'B³', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_bc = Movement.where(mov_type: 'B³', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_bc = Movement.where(mov_type: 'B³', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_bc = Movement.where(mov_type: 'B³', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)

    @ad_bo = Movement.where(mov_type: 'B°', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_bo = Movement.where(mov_type: 'B°', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_bo = Movement.where(mov_type: 'B°', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_bo = Movement.where(mov_type: 'B°', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)

    @ad_nb = @ad_bd - (@ad_br + @ad_bc + @ad_bo)
    @aw_nb = @aw_bd - (@aw_br + @aw_bc + @aw_bo)
    @am_nb = @am_bd - (@am_br + @am_bc + @am_bo)
    @ay_nb = @ay_bd - (@ay_br + @ay_bc + @ay_bo)

    # / _____________________________________________ /

    # Total meses: Ingr, egr, operac.. //STW313//
    @fb19_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    @en19_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)

    @dc18_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)
    @nv18_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)
    @oc18_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)
    @sp18_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)
    @ag18_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)
    @jl18_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)
    @jn18_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)
    @my18_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)
    @ab18_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)
    @mz18_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)
    @fb18_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)
    @en18_in= Movement.where(mov_type: 'I', mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)
    @m12_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)

    @fb19_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    @en19_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)

    @dc18_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)
    @nv18_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)
    @oc18_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)
    @sp18_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)
    @ag18_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)
    @jl18_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)
    @jn18_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)
    @my18_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)
    @ab18_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)
    @mz18_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)
    @fb18_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)
    @en18_eg= Movement.where(mov_type: 'E', mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)
    @m12_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)

    @fb19_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  2, 1)..Date.new(2019,  2,28) )).sum(:price)
    @en19_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2019,  1, 1)..Date.new(2019,  1,31) )).sum(:price)

    @dc18_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,014, 1)..Date.new(2018,014,31) )).sum(:price)
    @nv18_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,013, 1)..Date.new(2018,013,30) )).sum(:price)
    @oc18_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,012, 1)..Date.new(2018,012,31) )).sum(:price)
    @sp18_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,011, 1)..Date.new(2018,011,30) )).sum(:price)
    @ag18_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,010, 1)..Date.new(2018,010,31) )).sum(:price)
    @jl18_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  7, 1)..Date.new(2018,  7,31) )).sum(:price)
    @jn18_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  6, 1)..Date.new(2018,  6,30) )).sum(:price)
    @my18_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  5, 1)..Date.new(2018,  5,31) )).sum(:price)
    @ab18_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  4, 1)..Date.new(2018,  4,30) )).sum(:price)
    @mz18_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  3, 1)..Date.new(2018,  3,31) )).sum(:price)
    @fb18_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  2, 1)..Date.new(2018,  2,28) )).sum(:price)
    @en18_pj= Movement.where(mov_type: 'J', mov_date: (Date.new(2018,  1, 1)..Date.new(2018,  1,31) )).sum(:price)
    @m12_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,31) )).sum(:price)

    # Total movim STW313
    @tt_in3 = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_week )).sum(:price)
    @tt_eg3 = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_week )).sum(:price)
    @tt_pj3 = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_week )).sum(:price)


    #Total meses 2017 /STU379 - Ing, Egr, Oper
    @m12_i4 = Movement.where(mov_type: 'I×', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,14) )).sum(:price)
    @m12_i0 = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,10) )).sum(:price)
    @m12_i9 = @m12_i0+@m12_i4
    @m11_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,013, 1)..Date.new(2017,013,30) )).sum(:price)
    @m10_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012,31) )).sum(:price)
    @m9_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011,30) )).sum(:price)
    @m8_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,010, 1)..Date.new(2017,010,31) )).sum(:price)
    @m7_in  = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 07, 1)..Date.new(2017, 07,31) )).sum(:price)
    @m6_in  = Movement.where(mov_type: 'I', mov_date: (DateTime.new(2017,6,1)..DateTime.new(2017,6,30) )).sum(:price)

    @m12_e4 = Movement.where(mov_type: 'E×', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,14) )).sum(:price)
    @m12_e0 = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,10) )).sum(:price)
    @m12_e9 = @m12_e0+@m12_e4
    @m11_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,013, 1)..Date.new(2017,013,30) )).sum(:price)
    @m10_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012,31) )).sum(:price)
    @m9_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011,30) )).sum(:price)
    @m8_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,010, 1)..Date.new(2017,010,31) )).sum(:price)
    @m7_eg  = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 07, 1)..Date.new(2017, 07,31) )).sum(:price)
    @m6_eg  = Movement.where(mov_type: 'E', mov_date: (DateTime.new(2017,6,1)..DateTime.new(2017,6,30) )).sum(:price)

    @m12_g4 = Movement.where(mov_type: 'O×', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,14) )).sum(:price)
    @m12_g0 = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,10) )).sum(:price)
    @m12_g9 = @m12_g0+@m12_g4
    @m11_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,013, 1)..Date.new(2017,013,30) )).sum(:price)
    @m10_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012,31) )).sum(:price)
    @m09_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011,30) )).sum(:price)
    @m08_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,010, 1)..Date.new(2017,010,31) )).sum(:price)
    @m07_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017, 07, 1)..Date.new(2017, 07,31) )).sum(:price)
    @m06_pj = Movement.where(mov_type: 'J', mov_date: (DateTime.new(2017,6,1)..DateTime.new(2017,6,30) )).sum(:price)

    @m12_c4 = Movement.where(mov_type: 'L×', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,14) )).sum(:price)
    @m12_c0 = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,10) )).sum(:price)
    @m12_c9 = @m12_c0+@m12_c4
    @m11_ct = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,013, 1)..Date.new(2017,013,30) )).sum(:price)
    @m10_ct = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012,31) )).sum(:price)
    @m9_ct  = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011,30) )).sum(:price)
    @m8_ct  = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,010, 1)..Date.new(2017,010,31) )).sum(:price)
    @m7_ct  = Movement.where(mov_type: 'L', mov_date: (Date.new(2017, 07, 1)..Date.new(2017, 07,31) )).sum(:price)
    @m6_ct  = Movement.where(mov_type: 'L', mov_date: (DateTime.new(2017,6,1)..DateTime.new(2017,6,30) )).sum(:price)

    # Total ingresos, egresos, operac.. /STU379
    # Total general: STU379 + STW313
    @tt_i94 = Movement.where(mov_type: 'I×', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,14) )).sum(:price)
    @tt_i90 = Movement.where(mov_type: 'I', mov_date: (Date.new(2017, 06,02)..Date.new(2017,014,10) )).sum(:price)
    @tt_in9 = @tt_i90+@tt_i94
    @tt_in  = @tt_in3+@tt_in9

    @tt_e94 = Movement.where(mov_type: 'E×', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,14) )).sum(:price)
    @tt_e90 = Movement.where(mov_type: 'E', mov_date: (Date.new(2017, 06,02)..Date.new(2017,014,10) )).sum(:price)
    @tt_eg9 = @tt_e90+@tt_e94
    @tt_eg  = @tt_eg3+@tt_eg9

    @tt_pj94= Movement.where(mov_type: 'O×', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,14) )).sum(:price)
    @tt_pj90= Movement.where(mov_type: 'J', mov_date: (Date.new(2017, 06,02)..Date.new(2017,014,10) )).sum(:price)
    @tt_pj9 = @tt_pj90+@tt_pj94
    @tt_pj  = @tt_pj3+@tt_pj9

    @tt_ct4 = Movement.where(mov_type: 'L×', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,14) )).sum(:price)
    @tt_ct0 = Movement.where(mov_type: 'L', mov_date: (Date.new(2017, 06,02)..Date.new(2017,014,10) )).sum(:price)
    @tt_ct9 = @tt_ct0+@tt_ct4

  end


  def tr_flota
    @movements = Movement.where(mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day))

    # ----------------------------------------------
    # Estado Actual - // Día / Sem / Mes / Año //
    # ----------------------------------------------
    @ad_in = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_in = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_in = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @am_iv = @am_in/30
    @a17a_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_in=Movement.where(mov_type: 'I', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_eg = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_eg = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_eg = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @am_ev = @am_eg.nonzero? ? @am_in/@am_eg : 0
    @a17a_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_eg=Movement.where(mov_type: 'E', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_pj = Movement.where(mov_type: 'J', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_pj = Movement.where(mov_type: 'J', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_pj = Movement.where(mov_type: 'J', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_pj = Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @am_pv = @am_pj.nonzero? ? (@am_in*100)/@am_pj : 0
    @a17a_pj=Movement.where(mov_type: 'J', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_pj=Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_pj=Movement.where(mov_type: 'J', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_pj=Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_pj=Movement.where(mov_type: 'J', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    # Andaluz / Datos / Seguridad Social
    @ad_an = Movement.where(mov_type: 'Aª', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_an = Movement.where(mov_type: 'Aª', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_an = Movement.where(mov_type: 'Aª', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_an = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @am_av = @am_an.nonzero? ? (@am_in*100)/@am_an : 0
    @a17a_an=Movement.where(mov_type: 'Aª', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_an=Movement.where(mov_type: 'Aª', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_an=Movement.where(mov_type: 'Aª', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_an=Movement.where(mov_type: 'Aª', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_an=Movement.where(mov_type: 'Aª', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_dt = Movement.where(mov_type: 'A°', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_dt = Movement.where(mov_type: 'A°', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_dt = Movement.where(mov_type: 'A°', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_dt = Movement.where(mov_type: 'A°', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @am_dv = @am_dt.nonzero? ? (@am_in*100)/@am_dt : 0
    @a17a_dt=Movement.where(mov_type: 'A°', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_dt=Movement.where(mov_type: 'A°', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_dt=Movement.where(mov_type: 'A°', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_dt=Movement.where(mov_type: 'A°', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_dt=Movement.where(mov_type: 'A°', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)
    # Neto¹
    @ad_ea = @ad_in -(@ad_eg + @ad_pj + @ad_an+@ad_dt)
    @aw_ea = @aw_in -(@aw_eg + @aw_pj + @aw_an+@aw_dt)
    @am_ea = @am_in -(@am_eg + @am_pj + @am_an+@am_dt)
    @ay_ea = @ay_in -(@ay_eg + @ay_pj + @ay_an+@ay_dt)
    @ay_ev = @ay_in.nonzero? ? (@ay_in)/(@ay_eg + @ay_pj + @ay_an + @ay_dt) : 0

    @a17a_ea= @a17a_in-(@a17a_eg+@a17a_pj + @a17a_an+@a17a_dt)
    @a18a_ea= @a18a_in-(@a18a_eg+@a18a_pj + @a18a_an+@a18a_dt)
    @a18b_ea= @a18b_in-(@a18b_eg+@a18b_pj + @a18b_an+@a18b_dt)
    @a19a_ea= @a19a_in-(@a19a_eg+@a19a_pj + @a19a_an+@a19a_dt)
    @a19b_ea= @a19b_in-(@a19b_eg+@a19b_pj + @a19b_an+@a19b_dt)


    # Legales anuales / Soat, Taxímetro, Ténico_Mecánica
    @ad_so = Movement.where(mov_type: 'S°', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_so = Movement.where(mov_type: 'S°', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_so = Movement.where(mov_type: 'S°', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_so=Movement.where(mov_type: 'S°', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_so=Movement.where(mov_type: 'S°', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_so=Movement.where(mov_type: 'S°', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_so=Movement.where(mov_type: 'S°', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_so=Movement.where(mov_type: 'S°', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_to = Movement.where(mov_type: 'T°', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_to = Movement.where(mov_type: 'T°', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_to = Movement.where(mov_type: 'T°', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @am_tv = 0
    @a17a_to=Movement.where(mov_type: 'T°', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_to=Movement.where(mov_type: 'T°', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_to=Movement.where(mov_type: 'T°', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_to=Movement.where(mov_type: 'T°', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_to=Movement.where(mov_type: 'T°', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_tx = Movement.where(mov_type: 'T×', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_tx = Movement.where(mov_type: 'T×', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_tx = Movement.where(mov_type: 'T×', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_tx=Movement.where(mov_type: 'T×', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_tx=Movement.where(mov_type: 'T×', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_tx=Movement.where(mov_type: 'T×', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_tx=Movement.where(mov_type: 'T×', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_tx=Movement.where(mov_type: 'T×', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_tm = Movement.where(mov_type: 'T™', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_tm = Movement.where(mov_type: 'T™', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_tm = Movement.where(mov_type: 'T™', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @ad_nx = (@ad_so+@ad_to+@ad_tx+@ad_tm)
    @a17a_tm=Movement.where(mov_type: 'T™', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_tm=Movement.where(mov_type: 'T™', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_tm=Movement.where(mov_type: 'T™', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_tm=Movement.where(mov_type: 'T™', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_tm=Movement.where(mov_type: 'T™', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    # Taller
    @ad_tr = Movement.where(mov_type: 'T', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_tr = Movement.where(mov_type: 'T', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_tr = Movement.where(mov_type: 'T', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_tr=Movement.where(mov_type: 'T', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_tr=Movement.where(mov_type: 'T', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_tr=Movement.where(mov_type: 'T', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_tr=Movement.where(mov_type: 'T', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_tr=Movement.where(mov_type: 'T', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    # Gastos Varios Operación
    @ad_vr = Movement.where(mov_type: 'V', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_vr = Movement.where(mov_type: 'V', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_vr = Movement.where(mov_type: 'V', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_vr=Movement.where(mov_type: 'V', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_vr=Movement.where(mov_type: 'V', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_vr=Movement.where(mov_type: 'V', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_vr=Movement.where(mov_type: 'V', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_vr=Movement.where(mov_type: 'V', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)
    # Neto² actual Operación
    @ad_na = @ad_ea - (@ad_so+@ad_to+@ad_tx+@ad_tm+@ad_tr+@ad_vr)
    @aw_na = @aw_ea - (@aw_so+@aw_to+@aw_tx+@aw_tm+@aw_tr+@aw_vr)
    @am_na = @am_ea - (@am_so+@am_to+@am_tx+@am_tm+@am_tr+@am_vr)
    @ay_na = @ay_ea - (@ay_so+@ay_to+@ay_tx+@ay_tm+@ay_tr+@ay_vr)
    @nn_n  = 0
    @am_av = @am_eg.nonzero? ? @am_in/@am_eg : 0

    @a17a_na= @a17a_ea-(@a17a_so+@a17a_to+@a17a_tx+@a17a_tm + @a17a_tr+@a17a_vr)
    @a18a_na= @a18a_ea-(@a18a_so+@a18a_to+@a18a_tx+@a18a_tm + @a18a_tr+@a18a_vr)
    @a18b_na= @a18b_ea-(@a18b_so+@a18b_to+@a18b_tx+@a18b_tm + @a18b_tr+@a18b_vr)
    @a19a_na= @a19a_ea-(@a19a_so+@a19a_to+@a19a_tx+@a19a_tm + @a19a_tr+@a19a_vr)
    @a19b_na= @a19b_ea-(@a19b_so+@a19b_to+@a19b_tx+@a19b_tm + @a19b_tr+@a19b_vr)

    # Financiera
    @ad_fn = Movement.where(mov_type: 'Fª', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_fn = Movement.where(mov_type: 'Fª', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_fn = Movement.where(mov_type: 'Fª', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_fn = Movement.where(mov_type: 'Fª', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_fn=Movement.where(mov_type: 'Fª', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_fn=Movement.where(mov_type: 'Fª', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_fn=Movement.where(mov_type: 'Fª', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_fn=Movement.where(mov_type: 'Fª', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_fn=Movement.where(mov_type: 'Fª', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_ir = Movement.where(mov_type: 'F°', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_ir = Movement.where(mov_type: 'F°', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_ir = Movement.where(mov_type: 'F°', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_ir = Movement.where(mov_type: 'F°', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_ir=Movement.where(mov_type: 'F°', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_ir=Movement.where(mov_type: 'F°', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_ir=Movement.where(mov_type: 'F°', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_ir=Movement.where(mov_type: 'F°', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_ir=Movement.where(mov_type: 'F°', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_sg = Movement.where(mov_type: 'F×', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_sg = Movement.where(mov_type: 'F×', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_sg = Movement.where(mov_type: 'F×', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_sg = Movement.where(mov_type: 'F×', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_sg=Movement.where(mov_type: 'F×', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_sg=Movement.where(mov_type: 'F×', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_sg=Movement.where(mov_type: 'F×', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_sg=Movement.where(mov_type: 'F×', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_sg=Movement.where(mov_type: 'F×', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)
    # Neto³ = Operación - Financiera
    @ad_nf = @ad_na - (@ad_fn + @ad_ir + @ad_sg)
    @aw_nf = @aw_na - (@aw_fn + @aw_ir + @aw_sg)
    @am_nf = @am_na - (@am_fn + @am_ir + @am_sg)
    @ay_nf = @ay_na - (@ay_fn + @ay_ir + @ay_sg)

    @a17a_nf= @a17a_na-(@a17a_fn+@a17a_ir+@a17a_sg)
    @a18a_nf= @a18a_na-(@a18a_fn+@a18a_ir+@a18a_sg)
    @a18b_nf= @a18b_na-(@a18b_fn+@a18b_ir+@a18b_sg)
    @a19a_nf= @a19a_na-(@a19a_fn+@a19a_ir+@a19a_sg)
    @a19b_nf= @a19b_na-(@a19b_fn+@a19b_ir+@a19b_sg)


    # Contab personal general
    @ad_cd = Movement.where(mov_type: 'D', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_cd = Movement.where(mov_type: 'D', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_cd = Movement.where(mov_type: 'D', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_cd = Movement.where(mov_type: 'D', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_cd=Movement.where(mov_type: 'D', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_cd=Movement.where(mov_type: 'D', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_cd=Movement.where(mov_type: 'D', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_cd=Movement.where(mov_type: 'D', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_cd=Movement.where(mov_type: 'D', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_cc = Movement.where(mov_type: 'C', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_cc = Movement.where(mov_type: 'C', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_cc = Movement.where(mov_type: 'C', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_cc = Movement.where(mov_type: 'C', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_cc=Movement.where(mov_type: 'C', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_cc=Movement.where(mov_type: 'C', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_cc=Movement.where(mov_type: 'C', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_cc=Movement.where(mov_type: 'C', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_cc=Movement.where(mov_type: 'C', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    # Finanzas2 / Préstamos2, pagos, intereses
    @ad_fd = Movement.where(mov_type: 'F¹', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_fd = Movement.where(mov_type: 'F¹', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_fd = Movement.where(mov_type: 'F¹', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_fd = Movement.where(mov_type: 'F¹', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_fd=Movement.where(mov_type: 'F¹', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_fd=Movement.where(mov_type: 'F¹', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_fd=Movement.where(mov_type: 'F¹', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_fd=Movement.where(mov_type: 'F¹', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_fd=Movement.where(mov_type: 'F¹', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_fc = Movement.where(mov_type: 'F²', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_fc = Movement.where(mov_type: 'F²', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_fc = Movement.where(mov_type: 'F²', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_fc = Movement.where(mov_type: 'F²', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_fc=Movement.where(mov_type: 'F²', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_fc=Movement.where(mov_type: 'F²', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_fc=Movement.where(mov_type: 'F²', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_fc=Movement.where(mov_type: 'F²', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_fc=Movement.where(mov_type: 'F²', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    # Intereses // No utilizada //
    @ad_fi = Movement.where(mov_type: 'F³', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_fi = Movement.where(mov_type: 'F³', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_fi = Movement.where(mov_type: 'F³', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_fi = Movement.where(mov_type: 'F³', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_fi=Movement.where(mov_type: 'F³', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_fi=Movement.where(mov_type: 'F³', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_fi=Movement.where(mov_type: 'F³', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_fi=Movement.where(mov_type: 'F³', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_fi=Movement.where(mov_type: 'F³', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    # Otros
    @ad_ot = Movement.where(mov_type: 'O', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_ot = Movement.where(mov_type: 'O', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_ot = Movement.where(mov_type: 'O', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_ot = Movement.where(mov_type: 'O', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_ot=Movement.where(mov_type: 'O', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_ot=Movement.where(mov_type: 'O', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_ot=Movement.where(mov_type: 'O', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_ot=Movement.where(mov_type: 'O', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_ot=Movement.where(mov_type: 'O', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    # Impuestos
    @ad_im = Movement.where(mov_type: 'M', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_im = Movement.where(mov_type: 'M', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_im = Movement.where(mov_type: 'M', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_im = Movement.where(mov_type: 'M', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_im=Movement.where(mov_type: 'M', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_im=Movement.where(mov_type: 'M', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_im=Movement.where(mov_type: 'M', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_im=Movement.where(mov_type: 'M', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_im=Movement.where(mov_type: 'M', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    # Legal
    @ad_lg = Movement.where(mov_type: 'L', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_lg = Movement.where(mov_type: 'L', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_lg = Movement.where(mov_type: 'L', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_lg = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,014, 1)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_lg=Movement.where(mov_type: 'L', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_lg=Movement.where(mov_type: 'L', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_lg=Movement.where(mov_type: 'L', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_lg=Movement.where(mov_type: 'L', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_lg=Movement.where(mov_type: 'L', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    # Personal
    @ad_hm = Movement.where(mov_type: 'H', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_hm = Movement.where(mov_type: 'H', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_hm = Movement.where(mov_type: 'H', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_hm=Movement.where(mov_type: 'H', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_hm=Movement.where(mov_type: 'H', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_hm=Movement.where(mov_type: 'H', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_hm=Movement.where(mov_type: 'H', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_hm=Movement.where(mov_type: 'H', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_ps = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_ps = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_ps = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_ps = Movement.where(mov_type: 'P', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_ps=Movement.where(mov_type: 'P', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_ps=Movement.where(mov_type: 'P', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_ps=Movement.where(mov_type: 'P', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_ps=Movement.where(mov_type: 'P', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_ps=Movement.where(mov_type: 'P', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)

    @ad_ss = Movement.where(mov_type: 'S', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_ss = Movement.where(mov_type: 'S', mov_date: (Time.zone.now.beginning_of_week-1..Time.zone.now.end_of_week-1)).sum(:price)
    @am_ss = Movement.where(mov_type: 'S', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)
    @a17a_ss=Movement.where(mov_type: 'S', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
    @a18a_ss=Movement.where(mov_type: 'S', mov_date: (Date.new(2018, 1, 1)..Date.new(2018, 6,30))).sum(:price)
    @a18b_ss=Movement.where(mov_type: 'S', mov_date: (Date.new(2018, 7, 1)..Date.new(2018,12,31))).sum(:price)
    @a19a_ss=Movement.where(mov_type: 'S', mov_date: (Date.new(2019, 1, 1)..Date.new(2019, 6,30))).sum(:price)
    @a19b_ss=Movement.where(mov_type: 'S', mov_date: (Date.new(2019, 7, 1)..Date.new(2019,12,31))).sum(:price)
    # Subtotales Contab
    @ad_nc = (@ad_cd - @ad_cc) + (@ad_fd - (@ad_fc + @ad_fi + @ad_ot)) - (@ad_im + @ad_lg + @ad_hm + @ad_ps + @ad_ss)
    @aw_nc = (@aw_cd - @aw_cc) + (@aw_fd - (@aw_fc + @aw_fi + @aw_ot)) - (@aw_im + @aw_lg + @aw_hm + @aw_ps + @aw_ss)
    @am_nc = (@am_cd - @am_cc) + (@am_fd - (@am_fc + @am_fi + @am_ot)) - (@am_im + @am_lg + @am_hm + @am_ps + @am_ss)
    @ay_nc = (@ay_cd - @ay_cc) + (@ay_fd - (@ay_fc + @ay_fi + @ay_ot)) - (@ay_im + @ay_lg + @ay_hm + @ay_ps + @ay_ss)

    @a17a_nc = (@a17a_cd-@a17a_cc) + (@a17a_fd - (@a17a_fc + @a17a_fi + @a17a_ot)) - (@a17a_im + @a17a_lg + @a17a_hm + @a17a_ps + @a17a_ss)
    @a18a_nc = (@a18a_cd-@a18a_cc) + (@a18a_fd - (@a18a_fc + @a18a_fi + @a18a_ot)) - (@a18a_im + @a18a_lg + @a18a_hm + @a18a_ps + @a18a_ss)
    @a18b_nc = (@a18b_cd-@a18b_cc) + (@a18b_fd - (@a18b_fc + @a18b_fi + @a18b_ot)) - (@a18b_im + @a18b_lg + @a18b_hm + @a18b_ps + @a18b_ss)
    @a19a_nc = (@a19a_cd-@a19a_cc) + (@a19a_fd - (@a19a_fc + @a19a_fi + @a19a_ot)) - (@a19a_im + @a19a_lg + @a19a_hm + @a19a_ps + @a19a_ss)
    @a19b_nc = (@a19b_cd-@a19b_cc) + (@a19b_fd - (@a19b_fc + @a19b_fi + @a19b_ot)) - (@a19b_im + @a19b_lg + @a19b_hm + @a19b_ps + @a19b_ss)

    # Total Operación_Financiera + Contab
    @ad_tc = @ad_nf + @ad_nc
    @aw_tc = @aw_nf + @aw_nc
    @am_tc = @am_nf + @am_nc
    @ay_tc = @ay_nf + @ay_nc

    @a17a_tc = @a17a_nf + @a17a_nc
    @a18a_tc = @a18a_nf + @a18a_nc
    @a18b_tc = @a18b_nf + @a18b_nc
    @a19a_tc = @a19a_nf + @a19a_nc
    @a19b_tc = @a19b_nf + @a19b_nc


    # Diario / Semana actual
    if Time.zone.now.sunday?
      then
      # Si es Domingo... ¡muestre el movimiento!
      @wdm = Time.zone.now.beginning_of_week
      @wdm_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_nt = @wdm_in - (@wdm_eg + @wdm_pj)

      @wdm_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)

      @wdm_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_nx = (@wdm_so+@wdm_to+@wdm_tx+@wdm_tm)

      @wdm_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @wdm_tt = @wdm_nt - (@wdm_an + @wdm_dt + @wdm_nx + @wdm_tr + @wdm_vr)
    else
      # Si ya no es Domingo... ¡muestre los datos!
      @adm = Time.zone.now.beginning_of_week
      @adm_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price) or 0
      @adm_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_nt = @adm_in - (@adm_eg + @adm_pj)

      @adm_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)

      @adm_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_nx = (@adm_so+@adm_to+@adm_tx+@adm_tm)

      @adm_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week - 1.day).sum(:price)
      @adm_tt = @adm_nt - (@adm_an + @adm_dt + @adm_nx + @adm_tr + @adm_vr)
    end

    if Time.zone.now.monday?
      then
      # Si es lunes... ¡muestre elmovimiento!
      @wln = Time.zone.now.beginning_of_week
      @wln_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_nt = @wln_in - (@wln_eg + @wln_pj)

      @wln_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week).sum(:price)

      @wln_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_nx = (@wln_so+@wln_to+@wln_tx+@wln_tm)

      @wln_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @wln_tt = @wln_nt - (@wln_an + @wln_dt + @wln_nx + @wln_tr + @wln_vr)
    else
      # Si ya no es Lunes... ¡muestre los datos!
      @aln = Time.zone.now.beginning_of_week
      @aln_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_nt = @aln_in - (@aln_eg + @aln_pj)

      @aln_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week).sum(:price)

      @aln_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_nx = (@aln_so+@aln_to+@aln_tx+@aln_tm)

      @aln_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week).sum(:price)
      @aln_tt = @aln_nt - (@aln_an + @aln_dt + @aln_nx + @aln_tr + @aln_vr)
    end

    if Time.zone.now.tuesday?
      then
      @wma = Time.zone.now.beginning_of_week + 1.day
      @wma_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_nt = @wma_in - (@wma_eg + @wma_pj)

      @wma_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)

      @wma_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_nx = (@wma_so+@wma_to+@wma_tx+@wma_tm)

      @wma_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_tt = @wma_nt - (@wma_an + @wma_dt + @wma_nx + @wma_tr + @wma_vr)
    else
      @ama = Time.zone.now.beginning_of_week + 1.day
      @ama_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_nt = @ama_in - (@ama_eg + @ama_pj)

      @ama_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)

      @ama_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_nx = (@ama_so+@ama_to+@ama_tx+@ama_tm)

      @ama_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_tt = @ama_nt - (@ama_an + @ama_dt + @ama_nx + @ama_tr + @ama_vr)
    end

    if Time.zone.now.wednesday?
      then
      @wmi = Time.zone.now.beginning_of_week + 2.day
      @wmi_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_nt = @wmi_in - (@wmi_eg + @wmi_pj)

      @wmi_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)

      @wmi_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_nx = (@wmi_so+@wmi_to+@wmi_tx+@wmi_tm)

      @wmi_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_tt = @wmi_nt - (@wmi_an + @wmi_dt + @wmi_nx + @wmi_tr + @wmi_vr)
    else
      @ami = Time.zone.now.beginning_of_week + 2.day
      @ami_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_nt = @ami_in - (@ami_eg + @ami_pj)

      @ami_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)

      @ami_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_nx = (@ami_so+@ami_to+@ami_tx+@ami_tm)

      @ami_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_tt = @ami_nt - (@ami_an + @ami_dt + @ami_nx + @ami_tr + @ami_vr)
    end

    if Time.zone.now.thursday?
      then
      @wju = Time.zone.now.beginning_of_week + 3.day
      @wju_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_nt = @wju_in - (@wju_eg + @wju_pj)

      @wju_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)

      @wju_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_nx = (@wju_so+@wju_to+@wju_tx+@wju_tm)

      @wju_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_tt = @wju_nt - (@wju_an + @wju_dt + @wju_nx + @wju_tr + @wju_vr)
    else
      @aju = Time.zone.now.beginning_of_week + 3.day
      @aju_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_nt = @aju_in - (@aju_eg + @aju_pj)

      @aju_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)

      @aju_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_nx = (@aju_so+@aju_to+@aju_tx+@aju_tm)

      @aju_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_tt = @aju_nt - (@aju_an + @aju_dt + @aju_nx + @aju_tr + @aju_vr)
    end

    if Time.zone.now.friday?
      then
      @wvi = Time.zone.now.beginning_of_week + 4.day
      @wvi_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_nt = @wvi_in - (@wvi_eg + @wvi_pj)

      @wvi_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)

      @wvi_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_nx = (@wvi_so+@wvi_to+@wvi_tx+@wvi_tm)

      @wvi_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_tt = @wvi_nt - (@wvi_an + @wvi_dt + @wvi_nx + @wvi_tr + @wvi_vr)
    else
      @avi = Time.zone.now.beginning_of_week + 4.day
      @avi_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_nt = @avi_in - (@avi_eg + @avi_pj)

      @avi_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)

      @avi_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_nx = (@avi_so+@avi_to+@avi_tx+@avi_tm)

      @avi_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_tt = @avi_nt - (@avi_an + @avi_dt + @avi_nx + @avi_tr + @avi_vr)
    end

    if Time.zone.now.saturday?
      then
      @wsa = Time.zone.now.beginning_of_week + 5.day
      @wsa_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_nt = @wsa_in - (@wsa_eg + @wsa_pj)

      @wsa_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)

      @wsa_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_nx = (@wsa_so+@wsa_to+@wsa_tx+@wsa_tm)

      @wsa_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_tt = @wsa_nt - (@wsa_an + @wsa_dt + @wsa_nx + @wsa_tr + @wsa_vr)
    else
      @asa = Time.zone.now.beginning_of_week + 5.day
      @asa_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_nt = @asa_in - (@asa_eg + @asa_pj)

      @asa_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)

      @asa_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_nx = (@asa_so+@asa_to+@asa_tx+@asa_tm)

      @asa_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_tt = @asa_nt - (@asa_an + @asa_dt + @asa_nx + @asa_tr + @asa_vr)
    end

    # Total week mov: ing, eg, pj
    @wmv_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_pj = Movement.where(mov_type: 'J', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_nt = @wmv_in - (@wmv_eg + @wmv_pj)

    @wmv_an = Movement.where(mov_type: 'Aª', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_dt = Movement.where(mov_type: 'A°', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)

    @wmv_so = Movement.where(mov_type: 'S°', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_to = Movement.where(mov_type: 'T°', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_tx = Movement.where(mov_type: 'T×', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_tm = Movement.where(mov_type: 'T™', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_nx = (@wmv_so+@wmv_to+@wmv_tx+@wmv_tm)

    @wmv_tr = Movement.where(mov_type: 'T', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_vr = Movement.where(mov_type: 'V', mov_date: Time.zone.now.beginning_of_week - 1.day..Time.zone.now.end_of_week - 1.day).sum(:price)
    @wmv_tt = @wmv_nt - (@wmv_an + @wmv_dt + @wmv_nx + @wmv_tr + @wmv_vr)


  end

  def vx_andaluz
    @movements = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year))

  end

  def tr_taller
    @movements = Movement.where(mov_type: 'T', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_year))

  end

  def otros
    @movements = Movement.all

    # Estados - // Día / Semana / Mes / Año //
    @ad_in = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_in = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @ad_av = @aw_in/(7*1000)
    @am_in = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_in = Movement.where(mov_type: 'I', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_eg = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_eg = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @aw_av = @aw_eg.nonzero? ? @aw_in/@aw_eg : 0
    @am_eg = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_eg = Movement.where(mov_type: 'E', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_pj = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_pj = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_pj = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_pj = Movement.where(mov_type: 'P', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    # Andaluz / Datos / Seguridad Social
    @ad_an = Movement.where(mov_type: 'Aª', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_an = Movement.where(mov_type: 'Aª', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_an = Movement.where(mov_type: 'Aª', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_an = Movement.where(mov_type: 'Aª', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_me = Movement.where(mov_type: 'A°', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_me = Movement.where(mov_type: 'A°', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_me = Movement.where(mov_type: 'A°', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_me = Movement.where(mov_type: 'A°', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    # Legales anuales / Soat, Taxímetro, Ténico_Mecánica
    @ad_so = Movement.where(mov_type: 'S°', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_so = Movement.where(mov_type: 'S°', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_so = Movement.where(mov_type: 'S°', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_so = Movement.where(mov_type: 'S°', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_to = Movement.where(mov_type: 'T°', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_to = Movement.where(mov_type: 'T°', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_to = Movement.where(mov_type: 'T°', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_to = Movement.where(mov_type: 'T°', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_tx = Movement.where(mov_type: 'T×', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_tx = Movement.where(mov_type: 'T×', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_tx = Movement.where(mov_type: 'T×', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_tx = Movement.where(mov_type: 'T×', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_tm = Movement.where(mov_type: 'T™', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_tm = Movement.where(mov_type: 'T™', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_tm = Movement.where(mov_type: 'T™', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_tm = Movement.where(mov_type: 'T™', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    # Gastos varios
    @ad_tr = Movement.where(mov_type: 'T', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_tr = Movement.where(mov_type: 'T', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_tr = Movement.where(mov_type: 'T', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_vr = Movement.where(mov_type: 'V', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_vr = Movement.where(mov_type: 'V', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_vr = Movement.where(mov_type: 'V', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_vr = Movement.where(mov_type: 'V', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_ss = Movement.where(mov_type: 'S', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_ss = Movement.where(mov_type: 'S', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_ss = Movement.where(mov_type: 'S', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_na = @ad_in - (@ad_eg+@ad_pj + @ad_an+@ad_me+@ad_ss + @ad_so+@ad_tx+@ad_tm + @ad_tr+@ad_vr)
    @aw_na = @aw_in - (@aw_eg+@aw_pj + @aw_an+@aw_me+@aw_ss + @aw_so+@aw_tx+@aw_tm + @aw_tr+@aw_vr)
    @am_na = @am_in - (@am_eg+@am_pj + @am_an+@am_me+@am_ss + @am_so+@am_tx+@am_tm + @am_tr+@am_vr)
    @ay_na = @ay_in - (@ay_eg+@ay_pj + @ay_an+@ay_me+@ay_ss + @ay_so+@ay_tx+@ay_tm + @ay_tr+@ay_vr)
    @nn_n  = 0
    @am_av = @am_eg.nonzero? ? @am_in/@am_eg : 0

    # Financiera
    @ad_fn = Movement.where(mov_type: 'Fª', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_fn = Movement.where(mov_type: 'Fª', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_fn = Movement.where(mov_type: 'Fª', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_fn = Movement.where(mov_type: 'Fª', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_fr = Movement.where(mov_type: 'F°', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_fr = Movement.where(mov_type: 'F°', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_fr = Movement.where(mov_type: 'F°', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_fr = Movement.where(mov_type: 'F°', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_sg = Movement.where(mov_type: 'F×', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_sg = Movement.where(mov_type: 'F×', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_sg = Movement.where(mov_type: 'F×', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_sg = Movement.where(mov_type: 'F×', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_nf = @ad_na - (@ad_fn + @ad_sg)
    @aw_nf = @aw_na - (@aw_fn + @aw_sg)
    @am_nf = @am_na - (@am_fn + @am_sg)
    @ay_nf = @ay_na - (@ay_fn + @ay_sg)

    # Contab
    @ad_cd = Movement.where(mov_type: 'D', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_cd = Movement.where(mov_type: 'D', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_cd = Movement.where(mov_type: 'D', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_cd = Movement.where(mov_type: 'D', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_cc = Movement.where(mov_type: 'C', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_cc = Movement.where(mov_type: 'C', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_cc = Movement.where(mov_type: 'C', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_cc = Movement.where(mov_type: 'C', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_im = Movement.where(mov_type: 'M', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_im = Movement.where(mov_type: 'M', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_im = Movement.where(mov_type: 'M', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_im = Movement.where(mov_type: 'M', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_lg = Movement.where(mov_type: 'L', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_lg = Movement.where(mov_type: 'L', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_lg = Movement.where(mov_type: 'L', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_lg = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_ot = Movement.where(mov_type: 'O', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_ot = Movement.where(mov_type: 'O', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_ot = Movement.where(mov_type: 'O', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_ot = Movement.where(mov_type: 'O', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_cp = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_cp = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_cp = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_cp = Movement.where(mov_type: 'P', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)


    # Gastos personales
    @ad_hm = Movement.where(mov_type: 'H', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_hm = Movement.where(mov_type: 'H', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_hm = Movement.where(mov_type: 'H', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_ps = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_ps = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_ps = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_ps = Movement.where(mov_type: 'P', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_ss = Movement.where(mov_type: 'S', mov_date: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).sum(:price)
    @aw_ss = Movement.where(mov_type: 'S', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @am_ss = Movement.where(mov_type: 'S', mov_date: (Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)).sum(:price)
    @ay_ss = Movement.where(mov_type: 'S', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_month)).sum(:price)

    @ad_nc = @ad_cd - (@ad_cc+@ad_im+@ad_lg+@ad_cp+@ad_ot+@ad_hm+@ad_ps)
    @aw_nc = @aw_cd - (@aw_cc+@aw_im+@aw_lg+@aw_cp+@aw_ot+@aw_hm+@aw_ps)
    @am_nc = @am_cd - (@am_cc+@am_im+@am_lg+@am_cp+@am_ot+@am_hm+@am_ps)
    @ay_nc = @ay_cd - (@ay_cc+@ay_im+@ay_lg+@ay_cp+@ay_ot+@ay_hm+@ay_ps)


    # Diario / Semana actual
    if Time.zone.now.monday?
      then
      @wln = Time.zone.now.monday?
      @wln_in = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_week)).sum(:price)
      @wln_eg = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_week)).sum(:price)
      @wln_pj = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_week)).sum(:price)
    else
      # Si ya no es Lunes... ¡muestre los datos!
      @aln    = Time.zone.now.beginning_of_week
      @aln_in = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_week)).sum(:price)
      @aln_eg = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_week)).sum(:price) or 0
      @aln_pj = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_week)).sum(:price)
    end

    if Time.zone.now.tuesday?
      then
      @wma = Time.zone.now.beginning_of_week + 1.day
      @wma_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @wma_pj = Movement.where(mov_type: 'P', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
    else
      @ama = Time.zone.now.beginning_of_week + 1.day
      @ama_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
      @ama_pj = Movement.where(mov_type: 'P', mov_date: Time.zone.now.beginning_of_week + 1.day).sum(:price)
    end

    if Time.zone.now.wednesday?
      then
      @wmi = Time.zone.now.beginning_of_week + 2.day
      @wmi_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @wmi_pj = Movement.where(mov_type: 'P', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
    else
      @ami = Time.zone.now.beginning_of_week + 2.day
      @ami_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
      @ami_pj = Movement.where(mov_type: 'P', mov_date: Time.zone.now.beginning_of_week + 2.day).sum(:price)
    end

    if Time.zone.now.thursday?
      then
      @wju = Time.zone.now.beginning_of_week + 3.day
      @wju_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @wju_pj = Movement.where(mov_type: 'P', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
    else
      @aju = Time.zone.now.beginning_of_week + 3.day
      @aju_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
      @aju_pj = Movement.where(mov_type: 'P', mov_date: Time.zone.now.beginning_of_week + 3.day).sum(:price)
    end

    if Time.zone.now.friday?
      then
      @wvi = Time.zone.now.beginning_of_week + 4.day
      @wvi_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @wvi_pj = Movement.where(mov_type: 'P', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
    else
      @avi = Time.zone.now.beginning_of_week + 4.day
      @avi_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
      @avi_pj = Movement.where(mov_type: 'P', mov_date: Time.zone.now.beginning_of_week + 4.day).sum(:price)
    end

    if Time.zone.now.saturday?
      then
      @wsa = Time.zone.now.beginning_of_week + 5.day
      @wsa_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @wsa_pj = Movement.where(mov_type: 'P', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
    else
      @asa = Time.zone.now.beginning_of_week + 5.day
      @asa_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
      @asa_pj = Movement.where(mov_type: 'P', mov_date: Time.zone.now.beginning_of_week + 5.day).sum(:price)
    end

    if Time.zone.now.sunday?
      then
      @wdm = Time.zone.now.beginning_of_week + 6.day
      @wdm_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 6.day).sum(:price)
      @wdm_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 6.day).sum(:price)
      @wdm_pj = Movement.where(mov_type: 'P', mov_date: Time.zone.now.beginning_of_week + 6.day).sum(:price)
    else
      @adm = Time.zone.now.beginning_of_week + 6.day
      @adm_in = Movement.where(mov_type: 'I', mov_date: Time.zone.now.beginning_of_week + 6.day).sum(:price)
      @adm_eg = Movement.where(mov_type: 'E', mov_date: Time.zone.now.beginning_of_week + 6.day).sum(:price)
      @adm_pj = Movement.where(mov_type: 'P', mov_date: Time.zone.now.beginning_of_week + 6.day).sum(:price)
    end
    # Total semana actual: ingr, egr, operac.. /ok/
    @wmv_in  = Movement.where(mov_type: 'I', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @wmv_eg  = Movement.where(mov_type: 'E', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)
    @wmv_pj  = Movement.where(mov_type: 'P', mov_date: (Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)).sum(:price)



       # ----------------------------------------------------/

          # # Items no listados / Reserva sin asignacion
          # @mz18_lg = Movement.where(mov_type: 'L', mov_date: (Date.new(2018, 3, 1)..Date.new(2018,  3,31) )).sum(:price)
          # @fb18_lg = Movement.where(mov_type: 'L', mov_date: (Date.new(2018, 2, 1)..Date.new(2018,  2,28) )).sum(:price)
          # @en18_lg = Movement.where(mov_type: 'L', mov_date: (Date.new(2018, 1, 1)..Date.new(2018,  1,31) )).sum(:price)
          # @dc17_lg = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
          #
          # @mz18_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2018, 3, 1)..Date.new(2018,  3,31) )).sum(:price)
          # @fb18_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2018, 2, 1)..Date.new(2018,  2,28) )).sum(:price)
          # @en18_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2018, 1, 1)..Date.new(2018,  1,31) )).sum(:price)
          # @dc17_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
          #
          # @mz18_ot = Movement.where(mov_type: 'V', mov_date: (Date.new(2018, 3, 1)..Date.new(2018,  3,31) )).sum(:price)
          # @fb18_ot = Movement.where(mov_type: 'V', mov_date: (Date.new(2018, 2, 1)..Date.new(2018,  2,28) )).sum(:price)
          # @en18_ot = Movement.where(mov_type: 'V', mov_date: (Date.new(2018, 1, 1)..Date.new(2018,  1,31) )).sum(:price)
          # @dc17_ot = Movement.where(mov_type: 'V', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)
          #
          # @mz18_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2018, 3, 1)..Date.new(2018,  3,31) )).sum(:price)
          # @fb18_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2018, 2, 1)..Date.new(2018,  2,28) )).sum(:price)
          # @en18_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2018, 1, 1)..Date.new(2018,  1,31) )).sum(:price)
          # @dc17_hm = Movement.where(mov_type: 'H', mov_date: (Date.new(2017,014,11)..Date.new(2017,014,31) )).sum(:price)

          # # STW313 - Totales legal, taller, otros, home
          # @tt_ly3 = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_week )).sum(:price)
          # @tt_tr3 = Movement.where(mov_type: 'T', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_week )).sum(:price)
          # @tt_ot3 = Movement.where(mov_type: 'V', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_week )).sum(:price)
          # @tt_hm3 = Movement.where(mov_type: 'H', mov_date: (Date.new(2017,014,11)..Time.zone.now.end_of_week )).sum(:price)


        # Total x meses 2017 //STU379 _ en reserva
        # @m12_ly = Movement.where(mov_type: 'Y', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,14) )).sum(:price)

        # @m12_t9 = Movement.where(mov_type: 'S', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,14) )).sum(:price)
        # @m11_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2017,013, 1)..Date.new(2017,013,30) )).sum(:price)
        # @m10_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012,31) )).sum(:price)
        # @m09_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011,30) )).sum(:price)
        # @m08_tr = Movement.where(mov_type: 'T', mov_date: (Time.new(2017,010, 1)..Time.new(2017,010,31) )).sum(:price)
        # @m07_tr = Movement.where(mov_type: 'T', mov_date: (Date.new(2017, 07, 1)..Date.new(2017, 07,31) )).sum(:price)
        # @m06_tr = Movement.where(mov_type: 'T', mov_date: (Time.new(2017, 06, 1)..Time.new(2017, 06,30) )).sum(:price)
        #
        # @m12_ct = Movement.where(mov_type: 'U', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,14) )).sum(:price)
        # @ct_m11 = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,013, 1)..Date.new(2017,013,30) )).sum(:price)
        # @ct_m10 = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012,31) )).sum(:price)
        # @ct_m9  = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011,30) )).sum(:price)
        # @ct_m8  = Movement.where(mov_type: 'L', mov_date: (Date.new(2017,010, 1)..Date.new(2017,010,31) )).sum(:price)
        # @ct_m7  = Movement.where(mov_type: 'L', mov_date: (Date.new(2017, 07, 1)..Date.new(2017, 07,31) )).sum(:price)
        # @ct_m6  = Movement.where(mov_type: 'L', mov_date: (DateTime.new(2017,6,1)..DateTime.new(2017,6,30) )).sum(:price)
        #
        # @hm_m12 = Movement.where(mov_type: 'P', mov_date: (Date.new(2017,014, 1)..Date.new(2017,014,14) )).sum(:price)
        # @hm_m11 = Movement.where(mov_type: 'H', mov_date: (Date.new(2017,013, 1)..Date.new(2017,013,30) )).sum(:price)
        # @hm_m10 = Movement.where(mov_type: 'H', mov_date: (Date.new(2017,012, 1)..Date.new(2017,012,31) )).sum(:price)
        # @hm_m9  = Movement.where(mov_type: 'H', mov_date: (Date.new(2017,011, 1)..Date.new(2017,011,30) )).sum(:price)
        # @hm_m8  = Movement.where(mov_type: 'H', mov_date: (Time.new(2017,010, 1)..Time.new(2017,010,31) )).sum(:price)
        # @hm_m7  = Movement.where(mov_type: 'H', mov_date: (Date.new(2017, 07, 1)..Date.new(2017, 07,31) )).sum(:price)
        # @hm_m6  = Movement.where(mov_type: 'H', mov_date: (Time.new(2017, 06, 1)..Time.new(2017, 06,30) )).sum(:price)


  end


  # GET /movements/1
  # GET /movements/1.json
  def show
  end

  # GET /movements/new
  def new
    @movement = Movement.new
    @movement.mov_hour = Time.zone.now.strftime('%H:%M')
  end

  # GET /movements/1/edit
  def edit
  end

  # POST /movements
  # POST /movements.json
  def create
    @movement = Movement.new(movement_params)

    if @movement.save
      flash[:success] = 'Registro creado exitosamente.'
      redirect_to movements_path
    else
      flash[:danger] = 'Hubo un error, intenta nuevamente.'
      redirect_to movements_path
    end
  end

  # PATCH/PUT /movements/1
  # PATCH/PUT /movements/1.json
  def update
    if @movement.update(movement_params)
      flash[:success] = 'Registro actualizado exitosamente.'
      redirect_to movements_path
    else
      flash[:danger] = 'Hubo un error, intenta nuevamente.'
      redirect_to movements_path
    end
  end

  # DELETE /movements/1
  # DELETE /movements/1.json
  def destroy
    @movement.destroy
    respond_to do |format|
      format.html { redirect_to movements_url, notice: 'Movement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movement
      @movement = Movement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movement_params
      params.require(:movement).permit(:price, :description, :mov_date, :mov_hour).merge(mov_type: params[:mov_type])
    end
end
