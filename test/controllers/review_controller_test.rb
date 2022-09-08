# frozen_string_literal: true

require 'test_helper'

class ReviewControllerTest < ActionDispatch::IntegrationTest
  # GET /Reviews/:appID
  test 'should get status 200' do
    get reviews_url(1)
    assert_response :success
  end
  # Exposes @reviews [Array<Review>]
  test 'should expose reviews' do
    get reviews_url(1)
    assert_not_nil assigns(:reviews)
  end

  # POST /Review/:appID
  test 'should redirect on valid input' do
    post review_url(1), params: { comment: 'test', rating: 5 }
    assert_redirected_to app_detail_path(1)
  end
  test 'should post status 400 on invalid input' do
    post review_url(1), params: { comment: 'test' }
    assert_response 400
    post review_url(1), params: { rating: 5 }
    assert_response 400
    post review_url(1), params: {}
    assert_response 400
    post review_url(1)
    assert_response 400
  end
end
