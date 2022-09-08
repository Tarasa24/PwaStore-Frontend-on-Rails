# frozen_string_literal: true

class AuthorController < ApplicationController
  def get
    @author = Author.where(authorID: params[:authorID]).first
    return render status: 404 if @author.nil?

    @apps = App.where(authorID: params[:authorID]).order('name ASC')
    apps_ids = @apps.map(&:appID)
    apps_metrics = Review.where(appID: apps_ids)
                         .group('appID')
                         .select('"appID", avg(rating) AS average, count("appID") AS total')
    @apps_metrics = apps_metrics.to_h { |m| [m.appID, m] }
  end
end
