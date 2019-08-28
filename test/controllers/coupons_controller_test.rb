require 'test_helper'

class CouponsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coupon = coupons(:one)
  end

  test "should get index" do
    get coupons_url
    assert_response :success
  end

  test "should get new" do
    get new_coupon_url
    assert_response :success
  end

  test "should create coupon" do
    assert_difference('Coupon.count') do
      post coupons_url, params: { coupon: { bill_value: @coupon.bill_value, birthday: @coupon.birthday, campaign_id: @coupon.campaign_id, city_id: @coupon.city_id, code: @coupon.code, email: @coupon.email, identification: @coupon.identification, name: @coupon.name, phone: @coupon.phone, redeemed: @coupon.redeemed, redemption_date: @coupon.redemption_date, referred_code: @coupon.referred_code, shop_id: @coupon.shop_id, user_id: @coupon.user_id } }
    end

    assert_redirected_to coupon_url(Coupon.last)
  end

  test "should show coupon" do
    get coupon_url(@coupon)
    assert_response :success
  end

  test "should get edit" do
    get edit_coupon_url(@coupon)
    assert_response :success
  end

  test "should update coupon" do
    patch coupon_url(@coupon), params: { coupon: { bill_value: @coupon.bill_value, birthday: @coupon.birthday, campaign_id: @coupon.campaign_id, city_id: @coupon.city_id, code: @coupon.code, email: @coupon.email, identification: @coupon.identification, name: @coupon.name, phone: @coupon.phone, redeemed: @coupon.redeemed, redemption_date: @coupon.redemption_date, referred_code: @coupon.referred_code, shop_id: @coupon.shop_id, user_id: @coupon.user_id } }
    assert_redirected_to coupon_url(@coupon)
  end

  test "should destroy coupon" do
    assert_difference('Coupon.count', -1) do
      delete coupon_url(@coupon)
    end

    assert_redirected_to coupons_url
  end
end
