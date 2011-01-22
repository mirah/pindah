# pindah

A tool for writing Android applications in [Mirah](http://mirah.org).

## Requirements

You must have the [Android SDK](http://d.android.com/sdk/) installed
with the tools/ directory on your $PATH. You'll also need
[JRuby](http://jruby.org) installed with bin/ on your $PATH.

    $ jruby -S gem install pindah

## Usage

    $ pindah hello.world hello_world [HelloActivity]

    $ cd hello_world && tree

    [TODO: project skeleton listing]

    $ jruby -S rake -T
    
    rake clean      # Removes output files created by other targets
    rake compile    # Compile Mirah source to JVM bytecode
    rake dex        # Translate JVM bytecode to Dalvik bytecode
    rake install    # Install the application on a device or emulator
    rake logcat     # Tail logs from a device or a device or emulator
    rake package    # Create an .apk file for the application
    rake release    # Create a signed .apk for distribution
    rake resources  # Prepare resources
    rake spec       # Print the project spec

## See Also

If Mirah is just too low-level and you need something more dynamic,
you can try [Ruboto](https://github.com/ruboto/ruboto-core/), though
be warned there is a very significant overhead it brings with it from
JRuby's runtime.

## License

(The MIT-X11 License)

Copyright (c) 2011 Phil Hagelberg

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
