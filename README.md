Neurogami::WiiRemoteJRuby
===================

by James Britt / Neurogami

http://www.neurogami.com


DESCRIPTION:
-------------------

A set of Ruby libs to make calling into the WiiRemoteJ Java jar a little nicer.  

Intended for use with JRuby


FEATURES/PROBLEMS:
-------------------

Gives a more Ruby-ish API to the underlying Java classes.

SYNOPSIS
------------

Install the gem from gems.neurogami.com

In the root of your project, run 

     wiiremotejruby
  

This will copy over the lib files under lib/ruby/wiitemotejruby



REQUIREMENTS
-------------------

You need to be using JRuby, and have WiiRemoteJ as part of your project.



WiiRemoteJ may not work well, or at all, on certain operating systems.  Such issues seem to depend on the underlying Bluetooth stack.

You will need to grab the WiiRemoteJ jar and any required Bluetooth libraries.  Please check the [WiiRemoteJ project page](https://github.com/micromu/WiiRemoteJ) for details.  

Note that WiiRemoteJ was never released as open-source, and the original developer seems to have abandoned the project.  It has been taken up by others, but since there's no source code for the main jar there have been no updates to the core code.

WiiRemoteJRuby assumes you have already set up you project with the required WiiRemoteJ files.

The code more or less assumes you are creating a [Monkeybars](https://github.com/monkeybars/monkeybars-core) app. If you wish to use the code in some other way it should not be too hard to pull out the Monkeybars stuff (just follow the errors :) ).


INSTALL
-------------------

(sudo) gem install WiiRemoteJRuby --source http://gems/neurogami.com

Or finagle an installation from the git repo.

LICENSE
--------------

(The MIT License)

Copyright (c) 2015 James Britt

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


Feed your head.

Hack your world.

Live curious.
