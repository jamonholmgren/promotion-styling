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
    
    set_nav_bar_button :right, system_icon: :add, action: :add_note
    
    button =  UIButton.buttonWithType(UIButtonTypeCustom)
    button.setImage(UIImage.imageNamed("logo"), forState:UIControlStateNormal)
    button.addTarget(self, action: :tapped_logo, forControlEvents:UIControlEventTouchUpInside)
    button.setFrame CGRectMake(0, 0, 32, 32)
    set_nav_bar_button :left, button: UIBarButtonItem.alloc.initWithCustomView(button)
  end
  
  def will_appear
    @scroll.frame = self.view.bounds
    @scroll.contentSize = CGSizeMake(@scroll.frame.size.width, content_height(@scroll) + 20)
  end
  
  def add_note
    open AddNoteScreen
  end
  
  def tapped_log
    PM.logger.info "Tapped logo!"
  end
end
