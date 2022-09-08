# frozen_string_literal: true

module ApplicationHelper
  # Calculates sha1 hash of a string
  # @param [String] str
  # @return [String] sha1 hash of str
  # @example
  # sha1('hello') #=> 'aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d'
  def hash(str)
    Digest::SHA1.hexdigest(str)
  end

  # Calculates contrasting color for a given color (hex)
  # @param [String] hex
  # @return [String] contrasting color for hex
  # @example
  #  contrasting_color('#000000') #=> '#ffffff'
  #  contrasting_color('#ffffff') #=> '#000000'
  #  contrasting_color('#ff0000') #=> '#ffffff'
  #  contrasting_color('#00ff00') #=> '#000000'
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
