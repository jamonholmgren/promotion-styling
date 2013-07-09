class Tile < UIView
  include PM::Styling
  
  def self.new
    tile = alloc.initWithFrame(CGRectMake(30, 60, 130, 130))
    tile
  end
  
  def initWithFrame(frame)
    super
    set_attributes self, {
      background_color: hex_color("F6F6F6"),
      layer: {
        shadow_radius: 4.0,
        shadow_opacity: 0.4,
        shadow_color: UIColor.blackColor.CGColor
      }
    }
  end
end
