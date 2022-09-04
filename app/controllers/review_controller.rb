class ReviewController < ApplicationController
  def post
    # Get the appID from the URL
    appID = params[:appID]
    # Get the review from the form
    comment = params[:comment]
    # Get the rating from the form
    rating = params[:rating]

    # Create a new review
    review = Review.new(
      appID: appID,
      ip: request.remote_ip,
      rating: rating,
      body: comment
      )
    if review.save
      # If the review was saved, redirect to the app detail page
      redirect_to app_detail_path(params[:appID])
    else
      # Else send 500 and render the error message
      render :status => 500, :json => { :error => review.errors.full_messages }
    end
  end

  def get
    @reviews = Review.where(appID: params[:appID]).order('date DESC, "reviewID" DESC')
  end
end
