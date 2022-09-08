# frozen_string_literal: true

require 'test_helper'

class AuthorControllerTest < ActionDispatch::IntegrationTest
  # Status codes
  test 'get method should return 404 if author is not found' do
    get author_url(authorID: '999')
    assert_response :not_found
  end
  test 'get method should return 200 if author is found' do
    get author_url(authorID: '1')
    assert_response :success
  end

  # Exposed variables
  test 'should expose author' do
    get author_url(authorID: '1')
    assert_not_nil assigns(:author)
  end
  test 'should expose author with the correct authorID' do
    get author_url(authorID: '1')
    assert_equal assigns(:author).authorID, 1
  end
  test 'should expose search and set it to the author name' do
    get author_url(authorID: '1')
    assert_not_nil assigns(:search)
    assert_equal assigns(:search), assigns(:author).name
  end
  test 'should expose apps' do
    get author_url(authorID: '1')
    assert_not_nil assigns(:apps)
  end
  test 'should expose apps with the correct authorID' do
    get author_url(authorID: '1')
    assert_equal assigns(:apps).first.authorID, 1
  end
  test 'should expose apps_metrics' do
    get author_url(authorID: '1')
    assert_not_nil assigns(:apps_metrics)
  end
  test 'should expose apps_metrics with the correct appID' do
    get author_url(authorID: '1')
    assert assigns(:apps_metrics).key?(assigns(:apps).first.appID)
  end
end
