class HomeScreen < PM::Screen
  include HomeStyles

  title "Home"

  def on_load
    set_attributes self.view, main_view_style
    
    @scroll = add UIScrollView.alloc.initWithFrame(self.view.bounds)
    
    add_to @scroll, UILabel.new, label_style
    add_to @scroll, Tile.new, { frame: CGRectMake( 20,  40, 130, 130) }
    add_to @scroll, Tile.new, { frame: CGRectMake(170,  40, 130, 130) }
    add_to @scroll, Tile.new, { frame: CGRectMake( 20, 190, 130, 130) }
    add_to @scroll, Tile.new, { frame: CGRectMake(170, 190, 130, 130) }
    add_to @scroll, Tile.new, { frame: CGRectMake( 20, 340, 130, 130) }
    add_to @scroll, Tile.new, { frame: CGRectMake(170, 340, 130, 130) }
  end
  
  def will_appear
    @scroll.frame = self.view.bounds
    @scroll.contentSize = CGSizeMake(@scroll.frame.size.width, content_height(@scroll) + 20)
  end
end
