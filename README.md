# This demo app has been deprecated.

---

# Demo app for ProMotion styling

![screen shot 2013-07-12 at 2 30 36 pm](https://f.cloud.github.com/assets/1479215/791144/50cfbb38-eb3a-11e2-9c8e-3e7d2d322904.png)

## UIKit Styling

Styling UIKit elements is a huge topic. It would be virtually impossible for me to teach you everything you need to know. Instead, I'll walk you through styling an app, utilizing best practices, and point you in the right direction from there.

## PM::Styling

This module provides the main styling helpers for your screens and custom views. Just include it in any class to take advantage. It's already included in `PM::Screen` and its subclasses (table, map, and web screens), so you don't have to include it again there.

For the purposes of this guide, we will be creating a view that looks a little like the Evernote app:

![mzl lwevecka 320x480-75](https://f.cloud.github.com/assets/1479215/759888/b402ccfe-e79d-11e2-887f-1da425d9df71.jpg)

### Setup

This assumes you've [set up a basic ProMotion app](https://github.com/clearsightstudio/ProMotion/wiki/Guide:-Getting-Started). Create a new PM::Screen and follow along. For the purposes of this app I'll assume your screen is called `HomeScreen`.

### Styling the background

Available in every `PM::Screen` is a UIView located at `self.view`. You can apply a background image, color, or any other UIView property to it fairly easily.

In previous versions of ProMotion I didn't recommend setting up your view in `on_load`. In PM 1.0 it is now safe (and recommended) to do so. This method has changed in ProMotion 1.0 to be called right after your view has been initialized and sized properly.

```ruby
  def on_load
    set_attributes self.view, {
      background_color: hex_color("DBDBDB")
    }
  end
```

Here, `hex_color(str)` is a helper method that converts your hex code into a UIColor. You can also use `rgb_color(r, g, b)` or `rgba_color(r, g, b, a)`.

This gives us a nice background. Note that we're using `background_color` rather than `backgroundColor`. `set_attributes` will automatically convert snake_case to camelCase where necessary.

### Styling the navigation bar

Let's put a navigation bar across the top and style it. Navigation bars can be styled globally, so go to your AppDelegate and make it look something like this:

```ruby
class AppDelegate < PM::Delegate
  include PM::Styling
  status_bar true, animation: :none

  def on_load(app, options)
    set_appearance_defaults
    open HomeScreen.new(nav_bar: true)
  end
  
  def set_appearance_defaults
    UINavigationBar.appearance.barTintColor = hex_color("61B637")
  end
end
```

First, we include the ProMotion::Styling module which gives us the hex_color method. Next, we make sure we call the `set_appearance_defaults` method (you can name it anything you want). We ensure our screen is being opened with a navigation bar and style the `UINavigationBar` appearance default with a green tint color.

Re-running our app gives us this:

![screen shot 2013-07-08 at 12 13 22 am](https://f.cloud.github.com/assets/1479215/759901/eb1afc70-e79d-11e2-9758-f86744a08da4.png)

### Adding a subview

Let's put the name of the month at the top. Since we're focusing on styling, I'm just going to fake all the data in.

Back in your screen, modify your `on_load` to look like this:

```ruby
  def on_load
    set_attributes self.view, {
      background_color: hex_color("DBDBDB")
    }
    
    add UILabel.new, {
      text: "August",
      text_color: hex_color("8F8F8D"),
      background_color: UIColor.clearColor,
      shadow_color: UIColor.blackColor,
      text_alignment: UITextAlignmentCenter,
      font: UIFont.systemFontOfSize(15.0),
      resize: [ :left, :right, :bottom ], # ProMotion sugar here
      frame: CGRectMake(10, 0, 300, 35)
    }
  end
```

The `add` method adds a subview to the current view and applies a hash of attributes to it. It uses `set_attributes` behind the scenes, so the same rules apply to it.

"This looks like CSS!" Yeah, that's kind of what we're shooting for. It's not CSS, though. What's happening? ProMotion loops through the hash and tries to assign the value to a method with the same name as the key.

For example, `shadow_color` results in this call:

```ruby
label.shadowColor = UIColor.blackColor
```

### Moving styles into a module

The `add` and `set_attributes` methods are convenient, but it feels a little like inline CSS styling. These styles should probably go into a stylesheet.

While a full-blown stylesheet system like Teacup or Pixate is what we recommend for more complex apps, you can happily recreate a stylesheet feel by using a module.

Create a file in `app/styles` called `home_styles.rb`.

```ruby
module HomeStyles
  def main_view_style
    {
      background_color: hex_color("DBDBDB")
    }
  end
  
  def label_style
    {
      text: "August",
      text_color: hex_color("8F8F8D"),
      background_color: UIColor.clearColor,
      shadow_color: UIColor.blackColor,
      text_alignment: UITextAlignmentCenter,
      font: UIFont.systemFontOfSize(15.0),
      resize: [ :left, :right, :bottom ], # ProMotion sugar here
      frame: CGRectMake(10, 0, 300, 35)
    }
  end
end
```

Go back to your screen and include the new module. Then go replace the styling hashes with your new methods as symbols.

```ruby
class HomeScreen < PM::Screen
  include HomeStyles

  title "Home"

  def on_load
    # with a symbol (usually preferred)
    set_attributes self.view, :main_view_style
    # with a method call
    set_attributes self.view, main_view_style
    add UILabel.new, label_style
  end
end
```

Awesome...that's a **lot** cleaner. You can even combine several styles by merging their hashes like this:

```ruby
# You have to use a real method call to merge, not a symbol
add UILabel.new, global_label_style.merge(specific_label_style)
```

Or do it in the module like this:

```ruby
  def global_label_style
    {
      background_color: hex_color("DBDBDB")
    }
  end
  
  def specific_label_style
    global_label_style.merge({
      text: "Specific",
      text_color: hex_color("8F8F8D")
    })
  end
```

### Subclassing views

The next thing we want to add are those tiles. Since we'll be repeating the same tile over and over, it probably makes sense to make a custom view for that.

Create a file in `app/views/` called `tile.rb`.

```ruby
class Tile < UIView
  include PM::Styling
  
  def self.new
    tile = alloc.initWithFrame(CGRectZero)
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
    self
  end
end
```

By overriding `self.new` we're able to allocate and initialize the tile instance with our own defaults. We call `super` in the `initWithFrame` and then apply our styles. Lastly, we return `self`.

Note that we're nesting a `layer:` hash. This effectively calls `self.layer.shadowRadius = 4.0` and so on. You can nest as many hashes as you need to.

In this case, we need to provide a `CGColor` (rather than a `UIColor`) to the layer's `shadowColor` property. Forgetting to do this will probably bite you in the butt at some point. Don't say I didn't warn you.

Now go back to your screen and add these lines to your `on_load`:

```ruby
add Tile.new, { frame: [[  20,  40 ], [ 130, 130 ]] }
add Tile.new, { frame: [[ 170,  40 ], [ 130, 130 ]] }
add Tile.new, { frame: [[  20, 190 ], [ 130, 130 ]] }
add Tile.new, { frame: [[ 170, 190 ], [ 130, 130 ]] }
add Tile.new, { frame: [[  20, 340 ], [ 130, 130 ]] }
add Tile.new, { frame: [[ 170, 340 ], [ 130, 130 ]] }
```

Running your app gives you this:

![screen shot 2013-07-08 at 12 56 36 am](https://f.cloud.github.com/assets/1479215/760062/f415351a-e7a3-11e2-869f-7d7a8870cd44.png)

The Evernote team isn't feeling particularly threatened right now. Oh well.

### Adding a scrollable area

Let's make that scrollable. We need a UIScrollView for that, so let's adjust our `on_load` to something like the following:

```ruby
  def on_load
    set_attributes self.view, main_view_style
    
    @scroll = add UIScrollView.alloc.initWithFrame(self.view.bounds)
    
    add_to @scroll, UILabel.new, :label_style
    add_to @scroll, Tile.new, { frame: [[  20,  40 ], [ 130, 130 ]] }
    add_to @scroll, Tile.new, { frame: [[ 170,  40 ], [ 130, 130 ]] }
    add_to @scroll, Tile.new, { frame: [[  20, 190 ], [ 130, 130 ]] }
    add_to @scroll, Tile.new, { frame: [[ 170, 190 ], [ 130, 130 ]] }
    add_to @scroll, Tile.new, { frame: [[  20, 340 ], [ 130, 130 ]] }
    add_to @scroll, Tile.new, { frame: [[ 170, 340 ], [ 130, 130 ]] }
  end
  
  def will_appear
    @scroll.frame = self.view.bounds
    @scroll.contentSize = [ @scroll.frame.size.width, content_height(@scroll) + 20 ]
  end
```

First we add a UIScrollView and set its frame to the view's bounds. Easy enough. Next, we change our `add` methods to `add_to` and reference the `scroll` instance we created. This adds the tiles as a subview of `scroll`.

Lastly, we recalculate the contentSize (not the frame or bounds) of `scroll` with the ProMotion view helper `content_height`. This helper method finds the maximum height that will contain all the included elements. We do this in the `will_appear` method since the view may change between the `on_load` and `will_appear` (get shorter, for example, if there's a nav_bar or tab_bar`). And we add 20 points to give it a bit of a margin.

Re-running the app, you'll see that the content now scrolls properly.

### Nav bar buttons

This one's easy. We need to add that + icon to the right of the nav bar with a custom logo to the left. I'm not going to use Evernote's logo here -- just a custom image.

Nav bar buttons are added with the `set_nav_bar_button` method in your screen.

```ruby
def on_load
  # ...
  
  set_nav_bar_button :right, system_icon: :add, action: :add_note
end

def add_note
  open AddNoteScreen
end
```

We need to create a simple (non-functional) `AddNoteScreen`, so put this in `app/screens/add_note_screen.rb`:

```ruby
class AddNoteScreen < PM::Screen
  include HomeStyles
  
  title "Add Note"
  
  def on_load
    set_attributes self.view, :main_view_style
  end
end
```

We're re-using the HomeStyles we built earlier and styling the main view the same as the home screen.

For the logo, I'll use this little white ClearSight icon. Just drop it in your `/resources` folder.

[Download logo.png](https://f.cloud.github.com/assets/1479215/790870/ebd46f2e-eb31-11e2-92ae-8aadfdbd6311.png)

Using a custom view for the left bar button item is a little more involved. Here's the code that you put in your `on_load` -- you can figure out what it does yourself.

```ruby
    button =  UIButton.buttonWithType(UIButtonTypeCustom)
    button.setImage(UIImage.imageNamed("logo"), forState:UIControlStateNormal)
    button.addTarget(self, action: :tapped_logo, forControlEvents:UIControlEventTouchUpInside)
    button.setFrame [[ 0, 0 ], [ 32, 32 ]]
    set_nav_bar_button :left, button: UIBarButtonItem.alloc.initWithCustomView(button)
```

Also provide a `tapped_logo` method, then run the app -- you'll get this:

![screen shot 2013-07-12 at 2 30 36 pm](https://f.cloud.github.com/assets/1479215/791144/50cfbb38-eb3a-11e2-9c8e-3e7d2d322904.png)

### What's Next?

Don't let ProMotion's easy DSL and quick setup fool you. **Styling is time-consuming.** However, there are a lot of tools and best practices available to make it as painless as possible.

I highly recommend you take a look at [Teacup](https://github.com/rubymotion/teacup). It's an official RubyMotion gem and *very* actively developed. It also works very well with ProMotion. I plan to create a **ProMotion & Teacup** guide soon.

#### Can't wait to see what you create!
