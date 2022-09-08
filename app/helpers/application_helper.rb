# frozen_string_literal: true

module ApplicationHelper
  def hash(str)
    Digest::SHA1.hexdigest(str)
  end

  def contrast_color(hex)
    return '#000000' if hex.nil?

    hex = hex.gsub('#', '')
    rgb = hex.scan(/../).map(&:hex)
    brightness = Math.sqrt(
      (rgb[0] * rgb[0] * 0.299) +
      (rgb[1] * rgb[1] * 0.587) +
      (rgb[2] * rgb[2] * 0.114)
    )
    brightness > 130 ? '#000' : '#fff'
  end
end
