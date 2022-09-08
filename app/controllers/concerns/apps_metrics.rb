# Helper module for fetching matrics for either singular appID or multiple
module AppsMetrics
  extend ActiveSupport::Concern

  included do
    helper_method :apps_metrics, :app_metrics
  end

  # Fetches the metrics for the given apps. The metrics are the average rating and the total number of reviews.
  # @param apps_ids [Array<String>] the apps ids
  # @return [Hash] the metrics of the reviews of the apps
  # @example
  # apps_metrics(['1234', '5678'])
  # # => {"1234"=>{"average"=>4.5, "total"=>2}, "5678"=>{"average"=>4.5, "total"=>2}}
  # @see Review
  def apps_metrics(apps_ids)
    apps_metrics = Review.where(appID: apps_ids)
                         .group('appID')
                         .select('"appID", avg(rating) AS average, count("appID") AS total')
    apps_metrics.to_h { |m| [m.appID, m] }
  end

  # Fetches the metrics of the reviews of an app with the given app_id
  # @param app_id [String] the app_id of the app
  # @return [Hash] the metrics of the reviews of the app
  # @example
  # fetch_reviews_metrics('1234')
  # # => {"average"=>4.5, "total"=>2}
  # @see Review
  def app_metics(app_id)
    apps_metrics([app_id])[app_id]
  end
end
