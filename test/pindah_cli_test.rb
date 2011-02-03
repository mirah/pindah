require 'test/unit'
require 'tmpdir'
require 'fileutils'
require 'rubygems'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'pindah_cli'))

class PindahCLITest < Test::Unit::TestCase
  PWD = File.expand_path(File.dirname(__FILE__))

  def fixture(name)
    File.read(File.join(PWD, 'fixtures', name))
  end

  def setup
    @temp = Dir.mktmpdir("pindah-")
    @project_path = "#{@temp}/testapp"
    FileUtils.mkdir_p File.dirname(@temp)
    Dir.chdir File.dirname(@temp)
  end

  def teardown
    FileUtils.rm_rf @temp
  end

  def test_create_should_create_basic_project_structure
    PindahCLI.create('tld.pindah.testapp', @project_path)
    assert File.directory?(File.join(@project_path, 'src', 'tld', 'pindah', 'testapp'))
  end

  def test_create_should_create_rakefile
    PindahCLI.create('tld.pindah.testapp', @project_path)
    rake_path = File.join(@project_path, 'Rakefile')

    assert File.exists?(rake_path)
    assert_equal fixture("Rakefile"), File.read(rake_path)
  end

  def test_create_should_create_an_activity_if_desired
    PindahCLI.create('tld.pindah.testapp', @project_path, 'HelloWorld')

    actual = File.read(File.join(@project_path, 'src',
                                 'tld', 'pindah',
                                 'testapp', 'HelloWorld.mirah'))
    assert_equal fixture('HelloWorld.mirah'), actual
  end
end
