class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success, :danger, :info
  before_action :authenticate_user!, only: [:home_admin]

  def home
  end

  def home_admin
    @traffic = Visit.joins(:campaign)
                    .where('campaigns.active = true and visits.campaign_id = campaigns.id').order(:register_date)
    @generated_coupons = Coupon.joins(:campaign).select("coupons.created_at")
                               .where('campaigns.id = coupons.campaign_id and campaigns.active = true').order(:created_at)
    @invalid_coupons = Coupon.where(bounced: true).count
    if current_user.super?
      @redeemed_coupons = Coupon.joins(:campaign)
                                .where('campaigns.id = coupons.campaign_id and campaigns.active = true and coupons.redeemed = true').order(:created_at)
      @bill_value = Coupon.joins(:campaign)
                          .where('campaigns.id = coupons.campaign_id and campaigns.active = true and coupons.redeemed = true').order(:created_at)
    else
      @redeemed_coupons = Coupon.joins(:campaign)
                                .where('campaigns.id = coupons.campaign_id and campaigns.active = true and coupons.redeemed = true and coupons.shop_id = :shop_id',
                                        { shop_id: current_user.shop_id }).order(:created_at)
      @bill_value = Coupon.joins(:campaign)
                          .where('campaigns.id = coupons.campaign_id and campaigns.active = true and coupons.redeemed = true and coupons.shop_id = :shop_id',
                                  { shop_id: current_user.shop_id }).order(:created_at)
    end
  end

  def shops_info
    @campaign = Campaign.where(slug: params[:slug]).first
    @shops = Shop.all
    @cities = City.all.order(:name)
  end

  def thank_you
    @campaign = Campaign.find_by(active: true)
  end

  private
    def save_visit
      visit = Visit.find_by(register_date: Date.current, campaign_id: @campaign.id)
      if visit.nil?
        Visit.create(campaign_id: @campaign.id, register_date: Date.current, counter: 1)
      else
        visit.counter += 1
        visit.save
      end
    end

  protected
    def after_sign_in_path_for(resource)
      movements_path
    end
end
