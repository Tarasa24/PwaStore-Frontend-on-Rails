# frozen_string_literal: true

class SearchController < ApplicationController
  include AppsMetrics
  before_action :set_search_field, only: [:get]

  # Sets the search field to the search string
  # @see app/views/layouts/application.html.erb
  def set_search_field
    @search = params[:s]
  end

  def fetch_apps(search_string)
    App.select('app.score, app."appID", app.name, app.description,
                         app."iconURL", review.average AS "reviewAverage"')
       .from("(SELECT \"appID\", name, description, \"iconURL\",
                         ts_rank_cd(app.tsv_search, to_tsquery('#{search_string.split.join('|')}'))
                       AS score FROM core.\"App\" app) app")
       .joins('LEFT JOIN
                         (SELECT "appID", avg(rating) AS average FROM core."Review" GROUP BY "appID") review
                       ON app."appID" = review."appID"')
       .where('score > 0')
       .order('score DESC')
       .limit(300)
  end

  # GET /Search?s=:search_string
  # Searches for apps
  # Exposes following instance variables:
  # @apps [Array<App>] the apps that match the search string
  # @apps_metrics [Hash] the metrics of said apps
  # @see App
  # @see AppsMetrics
  def get
    return redirect_to index_path if params[:s].nil? || params[:s].empty?

    sanitized_search = ActiveRecord::Base.sanitize_sql(params[:s]) || ''
    if sanitized_search.split('|').nil?
      @apps = []
      @apps_metrics = {}
      return
    end
    @apps = fetch_apps(sanitized_search)
    @apps_metrics = apps_metrics(@apps.map(&:appID))
  end
end
