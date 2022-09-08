# frozen_string_literal: true

require 'test_helper'

class AppDetailControllerTest < ActionDispatch::IntegrationTest
  # Status codes
  test 'get method should return 404 if app is not found' do
    get app_detail_url(appID: '999')
    assert_response :not_found
  end
  test 'get method should return 200 if app is found' do
    get app_detail_url(appID: '1')
    assert_response :success
  end

  # Exposed variables
  test 'should expose app' do
    get app_detail_url(appID: '1')
    assert_not_nil assigns(:app)
  end
  test 'should expose app with the correct appID' do
    get app_detail_url(appID: '1')
    assert_equal assigns(:app).appID, 1
  end
  test 'should expose search and set it to the app name' do
    get app_detail_url(appID: '1')
    assert_not_nil assigns(:search)
    assert_equal assigns(:search), assigns(:app).name
  end
  test 'should expose reviews and its metrics' do
    get app_detail_url(appID: '1')
    assert_not_nil assigns(:reviews)
    assert_not_nil assigns(:reviews_metrics)
  end
  test 'should expose reviews with the correct appID' do
    get app_detail_url(appID: '1')
    assert_equal assigns(:reviews).first.appID, 1
  end
  test 'should expose similar apps' do
    get app_detail_url(appID: '1')
    assert_not_nil assigns(:similar_apps)
  end
end
