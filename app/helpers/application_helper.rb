module ApplicationHelper
  def hash(str)
    Digest::SHA1.hexdigest(str)
  end

  def contrastColor(hex)
    if hex.nil?
      return "#000000"
    end
    
    hex = hex.gsub('#','')
    rgb = hex.scan(/../).map {|color| color.hex}
    brightness = Math.sqrt(
      rgb[0] * rgb[0] * 0.299 +
      rgb[1] * rgb[1] * 0.587 +
      rgb[2] * rgb[2] * 0.114
    )
    return brightness > 130 ? '#000' : '#fff'
  end
end
