# pindah

A tool for writing Android applications in [Mirah](http://mirah.org).

A work in progress. So far mostly just the rake tasks are wired in.

## Requirements

You must have the [Android SDK](http://d.android.com/sdk/) installed
with at least one Android Platform version installed and the tools/
and platform-tools/ directories on your $PATH. You'll also need
[JRuby](http://jruby.org) installed with bin/ on your $PATH.

If your gem and rake are not from from JRuby, prefix the commands with jruby -S

    $ gem install pindah

## Usage

TODO: project skeleton is not complete, only compilation-related rake
tasks are working

    $ pindah hello.world hello_world [HelloActivity]

    $ cd hello_world && tree

    [TODO: project skeleton listing]

    $ rake -T
    
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

Released under the Apache 2.0 license.

Copyright (c) 2011 Phil Hagelberg, Nick Plante, J.D. Huntington
