Neurogami::SwingSet
===================

by James Britt / Neurogami

http://www.neurogami.com


DESCRIPTION:
-------------------

Wraps some basic Java Swing components in a nicer Ruby API.


FEATURES/PROBLEMS:
-------------------

Very few.  There is a file that defines assorted basic Swing components (Frame, Panel, TextField)
using simple Ruby.  It makes it easier, and perhaps more 'Rubyish' to define Swing items.


SYNOPSIS
------------

Install the gem.

In the root of your project, run 

     swingset
  

This will copy over the swingset.rb files under lib/ruby

At the moment there are not options for other paths. 

You can then create a UI class like so:

      # foo_ui.rb
      require 'swingset'

      include  Neurogami::SwingSet::Core

      class FooFrame < Frame   

        FRAME_WIDTH = 500
        FRAME_HEIGHT =300 

        LABEL_HEIGHT = 20
        LABEL_WIDTH = 200

        attr_accessor :search_label, :search_value

        def initialize *args
          super
          self.minimum_width  = FRAME_WIDTH
          self.minimum_height = FRAME_HEIGHT
          base_font = Font.new("Lucida Grande", 0, 14)
          TextField.default_font = base_font 
          Label.default_font     = base_font 
          set_up_components
        end

        def set_up_components
          component_panel = Panel.new
          component_panel.background_color(255, 255, 255)
          component_panel.size(FRAME_WIDTH, FRAME_HEIGHT)
          
          # Assumes you have the MiG layout jar ...
          component_panel.layout = Java::net::miginfocom::swing::MigLayout.new("wrap 2")

          @search_label = Label.new do |l|
            l.minimum_dimensions(LABEL_WIDTH, LABEL_HEIGHT)
            l.text = "Search phrase 1"
          end

          @search_value = TextField.new do |t|
            t.minimum_dimensions(LABEL_WIDTH, LABEL_HEIGHT)
            t.text = "Neurogami"
          end

          component_panel.add @search_label, 'grow x'
          component_panel.add @search_value, "gap unrelated"


          add component_panel

        end

      end


REQUIREMENTS
-------------------

This code came out of changes to the Monkeybars library, such that one could define the View Swing
class using plain Ruby in place of a compiled Java class.

Writing rawr Java/Swing code can get tedious, so these wrapper classes were created.


INSTALL
-------------------

sudo gem install Neurogami-swingset

LICENSE
--------------

(The MIT License)

Copyright (c) 2009 James Britt

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
