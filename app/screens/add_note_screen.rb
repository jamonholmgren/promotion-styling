class AddNoteScreen < PM::Screen
  include HomeStyles
  
  title "Add Note"
  
  def on_load
    set_attributes self.view, main_view_style
  end
end
