# frozen_string_literal: true

class AppDetailController < ApplicationController
  include AppsMetrics

  # Fetches the keywords of an app with the given app_id
  # @param app_id [String] the app_id of the app
  # @return [Array<String>] the keywords of the app
  # @example
  #   fetch_keywords('1234')
  #  # => ['keyword1', 'keyword2']
  def fetch_keywords(app_id)
    keywords_sql = "
     SELECT word
     FROM ts_stat('SELECT tsv_search FROM core.\"App\"
     WHERE \"appID\" = #{app_id}')"
    keywords = ActiveRecord::Base.connection.execute(keywords_sql)
    # remove duplicates take first 3 and transform to array
    keywords.to_a.uniq.take(3).map { |k| k['word'] }
  end

  # Fetches the similar apps of an app with the given app_id
  # based on its keywords and order them by the similarity score
  # @param app_id [String] the app_id of the app
  # @return [Array<App>] array of App objects extended with the similarity score
  # @example
  #  fetch_similar_apps('1234')
  # # => [#<App:0x00007f9b0b0b0e00 @score=0.65>, #<App:0x00007f9b0b0b0e00 @score=0.20>]
  # @see https://www.postgresql.org/docs/9.5/textsearch-controls.html
  # @see App
  def fetch_similar_apps(app_id)
    app_id = ActiveRecord::Base.sanitize_sql(app_id)
    sanitized_keywords = fetch_keywords(app_id).map { |k| ActiveRecord::Base.sanitize_sql(k) }
    similar_apps_sql = "
     SELECT score, *
     FROM
     	(SELECT *,ts_rank_cd(a.tsv_search, to_tsquery('#{sanitized_keywords.join('|')}')) AS score
     	FROM core.\"App\" a
     	WHERE a.\"appID\" != #{app_id}) app
     WHERE app.score > 0
     ORDER BY score DESC
     LIMIT 15"

    # Caches the result of the query as this is a very expensive operation and the output changes very rarely.
    # Moreover precomputing on the database side would take too long.
    Rails.cache.fetch(similar_apps_sql, expires_in: 1.day) do
      ActiveRecord::Base.connection.execute(similar_apps_sql).to_a
    end
  end

  # GET /AppDetail/:appID
  # @param :appID [String] the app_id of the app
  def get
    @app = App.left_joins(:Author)
              .select('"App".*, "Author".name AS "authorName"')
              .find_by(appID: params[:appID])
    return render status: 404 if @app.nil?

    # Set the @search variable to be displayed in the search bar
    # @see app/views/layouts/application.html.erb
    @search = @app.name

    @reviews_metrics = app_metics(@app.appID)
    @reviews = Review.where(appID: params[:appID]).order('date DESC, "reviewID" DESC').limit(3)
    @similar_apps = fetch_similar_apps(@app.appID)
  end
end
