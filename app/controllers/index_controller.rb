class IndexController < ApplicationController
  def get
    @appOTD = App
      .select('CURRENT_DATE as date, "App".*')
      .offset('MOD(ABS(hashtextextended(CAST(CURRENT_DATE AS TEXT), 0)), CAST((SELECT count("appID") FROM core."App") AS BIGINT))')
      .limit(1)[0]

    @promotedApps = App.where(promoted: true)
    promotedAppsIDs = @promotedApps.map { |app| app.appID }
    promotedAppsMetrics = Review.where(appID: promotedAppsIDs).group('appID').select('"appID", avg(rating) AS average, count("appID") AS total')
    @promotedAppsMetrics = promotedAppsMetrics.map { |m| [m.appID, m] }.to_h

    @popularApps = App.select('app."appID", app.name, app.description, app."iconURL", review.average AS "reviewAverage"')
                      .from('core."App" AS app')
                      .joins('LEFT JOIN (SELECT "appID", avg(rating) AS average FROM core."Review" GROUP BY "appID") review ON app."appID" = review."appID"')
                      .order('"reviewAverage" DESC NULLS LAST')
                      .limit(15)
    popularAppsIDs = @popularApps.map { |app| app.appID }
    popularAppsMetrics = Review.where(appID: popularAppsIDs).group('appID').select('"appID", avg(rating) AS average, count("appID") AS total')
    @popularAppsMetrics = popularAppsMetrics.map { |m| [m.appID, m] }.to_h
  end
end
