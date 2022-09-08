# frozen_string_literal: true

class ReviewController < ApplicationController
  # POST /Review/:appID
  # Submits a review for an app
  # On success, redirects to the app page
  # On incomplete or invalid data, renders json with error message and status 400
  # On failure, renders json with error message and status 500
  def post
    # Get the appID from the URL
    app_id = params[:appID]
    # Get the review from the form
    comment = params[:comment]
    # Get the rating from the form
    rating = params[:rating]

    # Validate presence of all fields
    # If any field is missing, return an error
    return render json: { error: 'All fields are required' }, status: 400 if comment.nil? || rating.nil?

    # Create a new review
    review = Review.new(
      appID: app_id,
      ip: request.remote_ip,
      rating:,
      body: comment
    )
    if review.save
      # If the review was saved, redirect to the app detail page
      redirect_to app_detail_path(params[:appID])
    else
      # Else send 500 and render the error message
      render status: 500, json: { error: review.errors.full_messages }
    end
  end

  # GET /Review/:appID
  # Gets all reviews for an app
  # Exposes @reviews [Array<Review>]
  # @see Review
  def get
    @reviews = Review.where(appID: params[:appID]).order('date DESC, "reviewID" DESC')
  end
end
