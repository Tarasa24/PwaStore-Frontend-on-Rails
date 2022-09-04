class SearchController < ApplicationController
  def get
    if params[:s].nil? || params[:s].empty?
      redirect_to index_path
    else
      @search = params[:s]
      sanitazedSearch = ActiveRecord::Base::sanitize_sql(params[:s])
      @apps = App.select('app.score, app."appID", app.name, app.description, app."iconURL", review.average AS "reviewAverage"')
                 .from('(SELECT "appID", name, description, "iconURL", ts_rank_cd(app.tsv_search, to_tsquery(\'' + sanitazedSearch.split(" ").join("|") + '\')) AS score FROM core."App" app) app')
                 .joins('LEFT JOIN (SELECT "appID", avg(rating) AS average FROM core."Review" GROUP BY "appID") review ON app."appID" = review."appID"')
                 .where('score > 0')
                 .order('score DESC')
                 .limit(300)
      appsIDs = @apps.map { |app| app.appID }
      appsMetrics = Review.where(appID: appsIDs).group('appID').select('"appID", avg(rating) AS average, count("appID") AS total')
      @appsMetrics = appsMetrics.map { |m| [m.appID, m] }.to_h
    end
  end
end
