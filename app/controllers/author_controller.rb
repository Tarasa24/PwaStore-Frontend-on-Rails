# frozen_string_literal: true

class AuthorController < ApplicationController
  include AppsMetrics

  # GET /Author/:authorID
  def get
    @author = Author.where(authorID: params[:authorID]).first
    return render status: 404 if @author.nil?

    @apps = App.where(authorID: params[:authorID]).order('name ASC')
    @apps_metrics = apps_metrics(@apps.map(&:appID))
  end
end
