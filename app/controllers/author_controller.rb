class AuthorController < ApplicationController
  def get 
    @author = Author.where(authorID: params[:authorID]).first

    if @author.nil?
      render status: 404
    else
      @apps = App.where(authorID: params[:authorID]).order('name ASC')
      appsIDs = @apps.map { |app| app.appID }
      appsMetrics = Review.where(appID: appsIDs).group('appID').select('"appID", avg(rating) AS average, count("appID") AS total')
      @appsMetrics = appsMetrics.map { |m| [m.appID, m] }.to_h
    end
  end 
end
