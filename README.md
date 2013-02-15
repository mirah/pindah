# Pindah

A tool for writing Android applications in [Mirah](http://mirah.org).

<img src="https://github.com/mirah/pindah/raw/master/pindah.png" alt="Pindah logo" align="right" />

<a name="requirements"></a>
## Requirements

You must have the [Android SDK](http://d.android.com/sdk/) installed
with the <tt>tools/</tt> directory placed on your $PATH. Inside
<tt>tools/</tt>, the <tt>android</tt> program will allow you to
download "platform" packages corresponding with Android versions you
wish to develop against. You'll need to install "Android SDK Platform
tools" and at least one platform revision to get started. At the time
of this writing, Android 2.3.3 (revision 10)
[covers about 90% of the market](http://developer.android.com/resources/dashboard/platform-versions.html)
and is a reasonable target for new applications. Once the platform
tools are installed, place the SDK's <tt>platform-tools/</tt>
directory on your $PATH as well.

Additionally, you will need:
* [OpenJDK](http://openjdk.java.net) 6 or 7.
* [JRuby](http://jruby.org) 1.6.8.
* [rake](http://rake.rubyforge.org) 10.0.3.
* [mirah](http://github.com/mirah/mirah) 0.0.12.

(NB: There is rudimentary support for running JRuby 1.7.2 against mirah
master. See #37, [follow these instructions](https://gist.github.com/abscondment/4963649),
and beware: Here be dragons!)

While you can get OpenJDK from your distribution, it is recommended
that you use something like
[rbenv](https://github.com/sstepehenson/rbenv) to manage your Ruby
things:

    $ rbenv install jruby-1.6.8
    $ rbenv --global jruby-1.6.8
    $ gem install rake
    $ gem install mirah

Finally, to install pindah:

    $ git clone git://github.com/mirah/pindah
    $ cd pindah/
    $ gem build pindah.gemspec
    $ gem install pindah-0.1.3.dev.gem

(`gem install pindah` currently installs an outdated version)
    
This also works with bundler; i.e. in a Gemfile like so:

    source :rubygems
    
    gem 'mirah', '0.0.12'
    gem 'pindah', :git => 'git://github.com/mirah/pindah'

## Usage

The <tt>pindah</tt> executable will create a new project starting
point given a package name. A package is a namespace for your code
that is often derived from a domain name you own, but can be any
hierarchical identifier as long as it's unique.

    $ pindah create org.example.hello_world # optional path and activity name arguments

    $ cd hello_world && tree
    .
    |-- AndroidManifest.xml
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

The <tt>res/</tt> directory contains application resources like icons,
layout descriptions, and strings. The <tt>AndroidManifest.xml</tt>
describes the contents and metadata of your application. The
<tt>src</tt> directory contains the source code inside your package
directory.

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
task. 

The official documentation has
[more details on building](http://developer.android.com/guide/developing/other-ide.html#Building). The
main difference between Pindah and the standard Ant build is that the
Rakefile replaces build.xml as well as all the properties files. The
page above also explains how to get an emulator running for testing
your application.

See [Garrett](http://github.com/technomancy/Garrett) for an example of
a basic project.

## Contributing

To contribute to Pindah, you need the [required environment](#requirements) setup.
You can get tests with the following set of commands.

    $ git clone git@github.com:mirah/pindah.git
    $ bundle install
    $ rake test

## Community

Problems? Suggestions? Bring them up on the
[Mirah mailing list](http://groups.google.com/group/mirah/) or the #mirah
IRC channel on freenode.

## See Also

If Mirah is just too low-level and you need something more dynamic,
you can try [Ruboto](https://github.com/ruboto/ruboto-core/), though
be warned there is a very significant overhead it brings with it from
JRuby's runtime.

## License

Released under the Apache 2.0 license.

Copyright (c) 2011 Phil Hagelberg, Nick Plante, J.D. Huntington
