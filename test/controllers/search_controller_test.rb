# frozen_string_literal: true

require 'test_helper'

class SearchControllerTest < ActionDispatch::IntegrationTest
  # Test back redirects
  test 'should redirect to index page if search string is empty' do
    get search_path, params: { s: '' }
    assert_redirected_to index_path
  end
  test 'should redirect to index page if search string is nil' do
    get search_path, params: { s: nil }
    assert_redirected_to index_path
  end

  # Test valid search
  test 'should get search page' do
    get search_path, params: { s: 'test' }
    assert_response :success
  end

  # Exposed variables
  test 'should expose apps and its metrics' do
    get search_path, params: { s: 'test' }
    assert_not_nil assigns(:apps)
    assert_not_nil assigns(:apps_metrics)
  end
end
