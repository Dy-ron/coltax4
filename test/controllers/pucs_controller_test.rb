require 'test_helper'

class PucsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @puc = pucs(:one)
  end

  test "should get index" do
    get pucs_url
    assert_response :success
  end

  test "should get new" do
    get new_puc_url
    assert_response :success
  end

  test "should create puc" do
    assert_difference('Puc.count') do
      post pucs_url, params: { puc: { category: @puc.category, code: @puc.code, detail: @puc.detail, name: @puc.name, puc_class: @puc.puc_class, puc_type: @puc.puc_type } }
    end

    assert_redirected_to puc_url(Puc.last)
  end

  test "should show puc" do
    get puc_url(@puc)
    assert_response :success
  end

  test "should get edit" do
    get edit_puc_url(@puc)
    assert_response :success
  end

  test "should update puc" do
    patch puc_url(@puc), params: { puc: { category: @puc.category, code: @puc.code, detail: @puc.detail, name: @puc.name, puc_class: @puc.puc_class, puc_type: @puc.puc_type } }
    assert_redirected_to puc_url(@puc)
  end

  test "should destroy puc" do
    assert_difference('Puc.count', -1) do
      delete puc_url(@puc)
    end

    assert_redirected_to pucs_url
  end
end
