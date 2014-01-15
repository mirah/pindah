# Pindah

A tool for writing Android applications in [Mirah](http://mirah.org).

<img src="https://github.com/mirah/pindah/raw/master/pindah.png" alt="Pindah logo" align="right" />

## Requirements
<a name="requirements"></a>

You must have the [Android SDK](http://d.android.com/sdk/) installed with the `tools/` directory placed on your $PATH.

Inside your `tools/` directory, the `android` program will allow you to download "platform" packages corresponding with the Android versions you wish to develop against. You'll need to install "Android SDK Platform Tools" and at least one platform revision to get started. At the time of this writing, Android 2.3.3 (revision 10) and above [covers 100% of the market](http://developer.android.com/resources/dashboard/platform-versions.html) and is a reasonable target for new applications.

Once the platform tools are installed, place the SDK's `platform-tools/` directory on your $PATH.

You will also need the following tools installed before you can develop with Pindah:

* [OpenJDK](http://openjdk.java.net) 6 or 7
* [JRuby](http://jruby.org) 1.7.3 (or above)
* [Mirah](http://github.com/mirah/mirah) 0.1.0 (or above)
* [rake](http://rake.rubyforge.org) 10.0.3 (or above)

### JRuby/Mirah compatability

Pindah has been successfully tested with the following JRuby and Mirah combinations:

| JRuby/Mirah | 0.1.0 | 0.1.1 | 0.1.2 |
| -----------:|:-----:|:-----:|:-----:|
|       1.7.3 | ✓     | x     | x     |
|       1.7.4 | ✓     | ✓     | ✓     |
|       1.7.5 | ✓     | ✓     | ✓     |
|       1.7.6 | ✓     | ✓     | ✓     |
|       1.7.7 | ✓     | ✓     | ✓     |
|       1.7.8 | ✓     | ✓     | ✓     |
|       1.7.9 | ✓     | ✓     | ✓     |
|      1.7.10 | ✓     | ✓     | ✓     |

### Ruby version management

While Linux users can obtain OpenJDK from their distribution, it is recommended that all users utilize something like [rbenv](https://github.com/sstepehenson/rbenv), [rvm](http://rvm.io), or [uru](https://bitbucket.org/jonforums/uru) to manage their Ruby installations and gems:

    # rbenv

    $ rbenv install jruby-1.7.4
    $ rbenv --global jruby-1.7.4
    $ gem install rake mirah

    # rvm

    $ rvm install jruby-1.7.4
    $ gem install rake mirah

## Installation

To install the latest stable version of Pindah, simply install the gem from the command line:

`gem install pindah`

If you want to play with the latest development version, clone the repo onto your local machine:

    $ git clone git://github.com/mirah/pindah
    $ cd pindah/
    $ gem build pindah.gemspec
    $ gem install pindah-0.1.4.dev.gem

## Usage

Similar to other Ruby projects like Rails or Ruboto, the `pindah` executable is responsible for creating and configuring your new Android project(s).  To get started with a simple project, call the `pindah` command like so:

`pindah create org.example.hello_world`

This will create an empty skeleton project with the package name `org.example.hello_world` in the current directory.

You can also configure your project with the following options:

* To create your project in a specific location, specify an optional path for your new project:
  `pindah create org.example.hello_world path_to_project`

* To create and configure a basic initial activity for your project, specify an activity name after the path:
  `pindah create org.example.hello_world path_to_project StartActivity`

All other project management tasks are handled by rake.  For a summary of all possible tasks you can run on your new project, run `rake -T` from your project directory:

    $ rake -T

    rake clean             # Removes output files created by other targets.
    rake compile           # Run compile
    rake debug             # Builds the application and signs it with a debug key.
    rake install           # Installs the newly build package.
    rake installd          # Installs (only) the debug package.
    rake installi          # Installs (only) the instrumented package.
    rake installr          # Installs (only) the release package.
    rake installt          # Installs (only) the test and tested packages.
    rake instrument        # Builds an instrumented packaged.
    rake javac             # Compiles R.java and other gen/ files.
    rake logcat            # Tail logs from a device or a device or emulator
    rake release           # Builds the application in release mode.
    rake release_unsigned  # Builds the application in release mode.
    rake spec              # Print the project spec
    rake test              # Runs tests from the package defined in test.package property
    rake uninstall         # Uninstalls the application from a running emulator or device.

### Directory structure

Pindah follows the default Android directory structure when creating new projects:

    $ pindah create org.example.hello_world hello_world/ StartActivity

    Created 'hello_world/src/org/example/hello_world'.
    Created 'hello_world/bin'.
    Created 'hello_world/libs'.
    Created 'hello_world/res'.
    Created 'hello_world/res/drawable-hdpi'.
    Created 'hello_world/res/drawable-ldpi'.
    Created 'hello_world/res/drawable-mdpi'.
    Created 'hello_world/res/layout'.
    Created 'hello_world/res/values'.
    Created project in hello_world.

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
                    `-- StartActivity.mirah

    12 directories, 8 files

Here are a few quick notes about the directory structure pictured above:

* The `AndroidManifest.xml` file describes the contents and metadata of your application.
* The `res/` directory contains application resources like icons, layout descriptions, and strings.
* The `src` directory contains the Java and Mirah source code for your project.

Other Android-specific directories may be created and used outside of this structure, as needed.  Please refer to the official Android documentation for more information about supported project file types and directory names.

### Compiling and running

To compile your new project in debug mode, simply run `rake debug` from your project directory:

    $ rake debug

    # [...]

    $ ls -l bin/hello_world-debug.apk

    -rw-r--r--   1 user           user        13222 Feb  7 23:16 bin/hello_world-debug.apk

This .apk file may be installed on a connected device or emulator with `rake installd`. It may even distributed for users to install themselves, though stable versions should be built with the `release` task.

The official documentation has [more details on building](http://developer.android.com/guide/developing/other-ide.html#Building). The main difference between Pindah and the standard Ant build is that the `Rakefile` replaces `build.xml` as well as all the properties files. The Android Developer page above also explains how to get an emulator running for testing your application.

See [Garrett](http://github.com/technomancy/Garrett) for an example of a basic project.

## Contributing

To contribute to Pindah, you need the [required environment](#requirements) setup. You can get tests with the following set of commands.

    $ git clone git@github.com:mirah/pindah.git
    $ bundle install
    $ rake test

## Community

Problems? Suggestions? Bring them up on the [Mirah mailing list](http://groups.google.com/group/mirah/) or the #mirah
IRC channel on freenode.

## See Also

If Mirah is just too low-level for your needs or you simply prefer something more dynamic, you can try [Ruboto](https://github.com/ruboto/ruboto/). Just be warned that it typically incurs a higher performance penalty and requires a larger app memory footprint due to JRuby's runtime.

## License

Released under the Apache 2.0 license.

Copyright (c) 2011 Phil Hagelberg, Nick Plante, J.D. Huntington

