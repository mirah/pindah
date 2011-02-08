# pindah

A tool for writing Android applications in [Mirah](http://mirah.org).

## Requirements

You must have the [Android SDK](http://d.android.com/sdk/) installed
with the <tt>tools/</tt> directory placed on your $PATH. Inside
<tt>tools/</tt>, the <tt>android</tt> program will allow you to
download "platform" packages corresponding with Android versions you
wish to develop against. You'll need to install "Android SDK Platform
tools" and at least one platform revision to get started. At the time
of this writing, Android 2.1 (revision 7)
[covers over 90% of the market](http://developer.android.com/resources/dashboard/platform-versions.html)
and is a reasonable target for new applications. Once the platform
tools are installed, place the SDK's <tt>platform-tools/</tt>
directory on your $PATH as well.

You'll also need [JRuby](http://jruby.org) installed with bin/ on your
$PATH. If your gem and rake are not from from JRuby, prefix the gem
and rake commands with jruby -S:

    $ gem install pindah

## Usage

See [Garrett](http://github.com/technomancy/Garrett) for an example of
basic usage.

    $ pindah org.example.hello_world # optional path and activity name arguments

    $ cd hello_world && tree
    .
    |-- AndroidManifest.xml
    |-- bin
    |-- libs
    |-- Rakefile
    |-- res
    |   |-- drawable-hdpi
    |   |   `-- ic_launcher.png
    |   |-- drawable-ldpi
    |   |   `-- ic_launcher.png
    |   |-- drawable-mdpi
    |   |   `-- ic_launcher.png
    |   |-- layout
    |   |   `-- main.xml
    |   `-- values
    |       `-- strings.xml
    `-- src
        `-- org
            `-- example
                `-- hello_world
                    `-- Start.mirah

    12 directories, 8 files

    $ rake -T
    
    rake clean      # Removes output files created by other targets.
    rake compile    # Compiles project's .mirah files into .class files
    rake debug      # Builds the application and signs it with a debug key.
    rake install    # Installs/reinstalls the debug package onto a running     ...
    rake javac      # Compiles R.java and other gen/ files.
    rake logcat     # Tail logs from a device or a device or emulator
    rake release    # Builds the application.
    rake spec       # Print the project spec
    rake uninstall  # Uninstalls the application from a running emulator or dev...

    $ rake debug
    
    # [...]
    
    $ ls -l bin/hello_world-debug.apk

    -rw-r--r--   1 user           user        13222 Feb  7 23:16 bin/hello_world-debug.apk

This .apk file may be installed on a connected device or emulator with
<tt>rake install</tt>. It may even distributed for users to install
themselves, though stable versions should use the <tt>release</tt>
task. The official documentation has
[more details on building](http://developer.android.com/guide/developing/other-ide.html#Building).

## See Also

If Mirah is just too low-level and you need something more dynamic,
you can try [Ruboto](https://github.com/ruboto/ruboto-core/), though
be warned there is a very significant overhead it brings with it from
JRuby's runtime.

## License

Released under the Apache 2.0 license.

Copyright (c) 2011 Phil Hagelberg, Nick Plante, J.D. Huntington
