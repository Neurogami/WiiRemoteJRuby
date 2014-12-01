# WiiRemoteJRuby example

This is a simple demo program.  The goal is to show basic use of WiiRemoteJRuby.

The code is known to run on at least two installations of Ubuntu.  It should run on pretty much any instance of Ubuntu; the tricky part is likely to be the underlying Bluetooth stack and whether you have or can get the appropriate Bluetooth jars and binaries (e.g. `libbluecove_x64.so`) for your OS.

You should just try to build and run the program to see how far you get.  You need to be using [JRuby](jruby.org) and have [rawr](https://github.com/rawr/rawr) installed.   

The program is a [Monkeybars](https://github.com/monkeybars/monkeybars-core) app, and WiiRemoteJRuby was written with Monkeybars in mind.  All the needed Monkeybars libraries are included in the example code.

If you have trouble running the program you might start by looking the READE [here](https://github.com/micromu/WiiRemoteJ) to get an idea of how to get the Java libs to play nice.


# WiiRemoteJRuby basics


The `WiiRemoteJ` libs manage the connection via Bluetooth to a ["Wiimote"](http://en.wikipedia.org/wiki/Wii_Remote). The Wiimote sends assorted event data for things such as pitch, roll, acceleration, button presses, and so on.

`WiiRemoteJ` triggers various methods on these events.  Your code would need to implement these methods and then decide what to do based on the event details. 

The problem is that there are relatively few events for the myriad things that can be happening.  For example, there's a single event (`buttonInputReceived`) that is raised for all button events. You code needs to look at the event object and determine the specific button and whether it was just pressed, or held, or released.   Here's some [example Java code](https://github.com/kokuzawa/wiiremotej-example/blob/master/src/main/java/jp/co/baykraft/wiiremotej/Wii.java) showing one way to approach this.

This seems pretty tedious.  It also lacks clarity; burying code in a giant switch or if/then also buries the intent of the code.

`WiiRemoteJRuby` gets around this by allowing you to map code directly to specific Wiimote events.  This is done using a hash that associates events with procs.  For example:

    mappings = {
      :buttons => [
        { :buttons => :home,  :action => :was_released, :handler  => lambda {|e| exit_button_action_performed e } },
        { :buttons => :b,     :action => :was_pressed,  :handler  => lambda {|e| some_action_for_b e } },
        { :buttons => :b,     :action => :was_released, :handler  => lambda {|e| stuff_to_do_when_b_released e } },
        { :buttons => :up,    :action => :was_released, :handler  => lambda {|e| do_up e } },
        { :buttons => :down,  :action => :was_released, :handler  => lambda {|e| do_down e } },
    ],
    :motion_sensing_event => lambda{|e|  motion_sensing_event_action_performed e },
    }


`WiiRemoteJRuby` uses this multi-level hash table to compare with the details of each Wiimote event to find any matching procs to call.  You get to skip writing this look-up and compare code yourself.

`WiiRemoteJRuby` also provides a sample Swing GUI (via Monkeybars) to tell the user when to initiate a Wiimote connection.

# WiiRemoteJ vs WiiUseJ 

Neurogami's experiments with Wiimotes and JRuby started back around 2008. Two Java libraries stood out: [WiiUseJ](http://code.google.com/p/wiiusej/) and WiiRemoteJ.  Both worked well with JRuby (there is a JRuby wrapper [WiUseJRuby](https://github.com/Neurogami/WiiUseJRuby)). 

There were some differences though.  At the time, WiiRemoteJ had an ill-defined license.  It was also (and remains) closed-source.  WiiUseJ was open source and was released under the LGPL.  

WiiRemoteJ does not offer a method to get the Wiimote yaw.  WiiUseJ has a `getYaw` method but it always returns 0.0.  

WiiRemoteJ offers some audio support; WiiUseJ does not.

WiRemoteJ seems to offer more features, and the license was made more explicit before the original developer abandoned the project.

Although WiiUseJ is open source there does seem to have been any development since about 2009.

One big difference is that WiiUseJ does not correctly indicate when a button is released; WiiRemoteJ does.






