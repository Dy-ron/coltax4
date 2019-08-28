require 'test_helper'

class CampaignsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @campaign = campaigns(:one)
  end

  test "should get index" do
    get campaigns_url
    assert_response :success
  end

  test "should get new" do
    get new_campaign_url
    assert_response :success
  end

  test "should create campaign" do
    assert_difference('Campaign.count') do
      post campaigns_url, params: { campaign: { background_image: @campaign.background_image, cities: @campaign.cities, color_buttons: @campaign.color_buttons, color_theme: @campaign.color_theme, coupon_mailer_description: @campaign.coupon_mailer_description, coupon_mailer_image: @campaign.coupon_mailer_image, coupon_mailer_subtitle: @campaign.coupon_mailer_subtitle, coupon_mailer_terms_and_conditions: @campaign.coupon_mailer_terms_and_conditions, coupon_mailer_title: @campaign.coupon_mailer_title, description_image: @campaign.description_image, slug: @campaign.slug, terms_and_conditions: @campaign.terms_and_conditions, title: @campaign.title } }
    end

    assert_redirected_to campaign_url(Campaign.last)
  end

  test "should show campaign" do
    get campaign_url(@campaign)
    assert_response :success
  end

  test "should get edit" do
    get edit_campaign_url(@campaign)
    assert_response :success
  end

  test "should update campaign" do
    patch campaign_url(@campaign), params: { campaign: { background_image: @campaign.background_image, cities: @campaign.cities, color_buttons: @campaign.color_buttons, color_theme: @campaign.color_theme, coupon_mailer_description: @campaign.coupon_mailer_description, coupon_mailer_image: @campaign.coupon_mailer_image, coupon_mailer_subtitle: @campaign.coupon_mailer_subtitle, coupon_mailer_terms_and_conditions: @campaign.coupon_mailer_terms_and_conditions, coupon_mailer_title: @campaign.coupon_mailer_title, description_image: @campaign.description_image, slug: @campaign.slug, terms_and_conditions: @campaign.terms_and_conditions, title: @campaign.title } }
    assert_redirected_to campaign_url(@campaign)
  end

  test "should destroy campaign" do
    assert_difference('Campaign.count', -1) do
      delete campaign_url(@campaign)
    end

    assert_redirected_to campaigns_url
  end
end
