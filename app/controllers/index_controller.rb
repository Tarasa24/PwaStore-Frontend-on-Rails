# frozen_string_literal: true

class IndexController < ApplicationController
  def fetch_promoted_apps_metrics(promoted_apps_ids)
    promoted_apps_metrics = Review.where(appID: promoted_apps_ids)
                                  .group('appID')
                                  .select('"appID", avg(rating) AS average, count("appID") AS total')
    promoted_apps_metrics.to_h { |m| [m.appID, m] }
  end

  def fetch_popular_apps_metrics(popular_apps_ids)
    popular_apps_metrics = Review.where(appID: popular_apps_ids)
                                 .group('appID')
                                 .select('"appID", avg(rating) AS average, count("appID") AS total')
    popular_apps_metrics.to_h { |m| [m.appID, m] }
  end

  def get
    @app_otd = App
               .select('CURRENT_DATE as date, "App".*')
               .offset('MOD(ABS(hashtextextended(CAST(CURRENT_DATE AS TEXT), 0)),
                        CAST((SELECT count("appID") FROM core."App") AS BIGINT))')
               .limit(1)[0]

    @promoted_apps = App.where(promoted: true)
    @promoted_apps_metrics = fetch_promoted_apps_metrics(@promoted_apps.map(&:appID))

    @popular_apps = App.select('app."appID", app.name, app.description,
                                app."iconURL", review.average AS "reviewAverage"')
                       .from('core."App" AS app')
                       .joins('LEFT JOIN
                                (SELECT "appID", avg(rating) AS average FROM core."Review" GROUP BY "appID") review
                              ON app."appID" = review."appID"')
                       .order('"reviewAverage" DESC NULLS LAST')
                       .limit(15)
    @popular_apps_metrics = fetch_popular_apps_metrics(@popular_apps.map(&:appID))
  end
end
