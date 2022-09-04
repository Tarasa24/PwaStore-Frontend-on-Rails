class AppDetailController < ApplicationController
  def get
    @app = App
      .left_joins(:Author)
      .select('"App".*, "Author".name AS "authorName"')
      .find_by(appID: params[:appID])

    if @app.nil?
      render :status => 404
    else
      @search = @app.name

      @reviewsMetrics = Review.select('avg(rating) AS average, count("appID") AS total').group('appID').find_by(appID: params[:appID])
      if @reviewsMetrics.nil?
        @reviewsMetrics = {average: 0, total: 0}
      end
      @reviews = Review.where(appID: params[:appID]).order('date DESC, "reviewID" DESC').limit(3)
    
      sanitazedAppID = ActiveRecord::Base::sanitize_sql(params[:appID])
      keywordsSQL = "
      SELECT word
      FROM ts_stat('SELECT tsv_search FROM core.\"App\"
      WHERE \"appID\" = #{sanitazedAppID}')"
      keywords = ActiveRecord::Base.connection.execute(keywordsSQL)
      # remove duplicates take first 3 and transform to array
      keywords = keywords.to_a.uniq.take(3).map { |k| k['word'] }
    
      sanitazedKeywords = keywords.map { |k| ActiveRecord::Base::sanitize_sql(k) }
      similarAppsSQL = "
      SELECT score, \"appID\", name, \"iconURL\"
      FROM 
      	(SELECT 
          \"appID\", name, \"iconURL\",
          ts_rank_cd(a.tsv_search, to_tsquery('#{sanitazedKeywords.join('|')}')) AS score
      	FROM core.\"App\" a
      	WHERE a.\"appID\" != #{sanitazedAppID}) app
      WHERE app.score > 0
      ORDER BY score DESC
      LIMIT 15"
      @similarApps = Rails.cache.fetch(similarAppsSQL, expires_in: 1.hour) do
        ActiveRecord::Base.connection.execute(similarAppsSQL).to_a
      end
    end  
  end
end
