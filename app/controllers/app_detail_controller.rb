# frozen_string_literal: true

class AppDetailController < ApplicationController
  def fetch_keywords(app_id)
    keywords_sql = "
     SELECT word
     FROM ts_stat('SELECT tsv_search FROM core.\"App\"
     WHERE \"appID\" = #{app_id}')"
    keywords = ActiveRecord::Base.connection.execute(keywords_sql)
    # remove duplicates take first 3 and transform to array
    keywords.to_a.uniq.take(3).map { |k| k['word'] }
  end

  def fetch_similar_apps(app_id)
    app_id = ActiveRecord::Base.sanitize_sql(app_id)
    sanitized_keywords = fetch_keywords(app_id).map { |k| ActiveRecord::Base.sanitize_sql(k) }
    similar_apps_sql = "
     SELECT score, \"appID\", name, \"iconURL\"
     FROM
     	(SELECT
         \"appID\", name, \"iconURL\",
         ts_rank_cd(a.tsv_search, to_tsquery('#{sanitized_keywords.join('|')}')) AS score
     	FROM core.\"App\" a
     	WHERE a.\"appID\" != #{app_id}) app
     WHERE app.score > 0
     ORDER BY score DESC
     LIMIT 15"
    Rails.cache.fetch(similar_apps_sql, expires_in: 1.hour) do
      ActiveRecord::Base.connection.execute(similar_apps_sql).to_a
    end
  end

  def fetch_reviews_metrics(app_id)
    reviews_metrics = Review.select('avg(rating) AS average, count("appID") AS total')
                            .group('appID').find_by(appID: app_id)
    if reviews_metrics.nil?
      { average: 0, total: 0 }
    else
      reviews_metrics
    end
  end

  def get
    @app = App.left_joins(:Author)
              .select('"App".*, "Author".name AS "authorName"')
              .find_by(appID: params[:appID])
    return render status: 404 if @app.nil?

    @search = @app.name

    @reviews_metrics = fetch_reviews_metrics(params[:appID])
    @reviews = Review.where(appID: params[:appID]).order('date DESC, "reviewID" DESC').limit(3)
    @similar_apps = fetch_similar_apps(params[:appID])
  end
end
