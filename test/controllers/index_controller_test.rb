# frozen_string_literal: true

require 'test_helper'

class IndexControllerTest < ActionDispatch::IntegrationTest
  # Status codes
  test 'should get index' do
    get index_url
    assert_response :success
  end

  # Exposed variables
  test 'should expose app of the day' do
    get index_url
    assert_not_nil assigns(:app_otd)
  end
  test 'should expose promoted apps and its metrics' do
    get index_url
    assert_not_nil assigns(:promoted_apps)
    assert_not_nil assigns(:promoted_apps_metrics)
  end
  test 'should expose popular apps and its metrics' do
    get index_url
    assert_not_nil assigns(:popular_apps)
    assert_not_nil assigns(:popular_apps_metrics)
  end

  # Exposed variables content
  test 'should expose app of the day with correct attributes' do
    get index_url
    assert_includes assigns(:app_otd).attributes.keys, 'date'
  end
  test 'should expose promoted apps with correct attributes' do
    get index_url
    assigns(:promoted_apps).each do |app|
      assert_includes app.attributes.keys, 'promoted'
    end
  end
  test 'should expose popular apps with correct attributes' do
    get index_url
    assigns(:popular_apps).each do |app|
      assert_includes app.attributes.keys, 'reviewAverage'
    end
  end
end
