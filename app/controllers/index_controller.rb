# frozen_string_literal: true

class IndexController < ApplicationController
  include AppsMetrics

  # GET /
  #
  # Exposes follwing instance variables:
  # @app_otd [App] the app of the day
  # @promoted_apps [Array<App>] the promoted apps
  # @promoted_apps_metrics [Hash] the metrics of said promoted apps
  # @popular_apps [Array<App>] the popular apps
  # @popular_apps_metrics [Hash] the metrics of said popular apps
  def get
    @app_otd = App
               .select('CURRENT_DATE as date, "App".*')
               .offset('MOD(ABS(hashtextextended(CAST(CURRENT_DATE AS TEXT), 0)),
                        CAST((SELECT count("appID") FROM core."App") AS BIGINT))')
               .limit(1)[0]

    @promoted_apps = App.where(promoted: true)
    @promoted_apps_metrics = apps_metrics(@promoted_apps.map(&:appID))

    @popular_apps = App.select('app."appID", app.name, app.description,
                                app."iconURL", review.average AS "reviewAverage"')
                       .from('core."App" AS app')
                       .joins('LEFT JOIN
                                (SELECT "appID", avg(rating) AS average FROM core."Review" GROUP BY "appID") review
                              ON app."appID" = review."appID"')
                       .order('"reviewAverage" DESC NULLS LAST')
                       .limit(15)
    @popular_apps_metrics = apps_metrics(@popular_apps.map(&:appID))
  end
end
