require 'test/unit'
require 'tempfile'
require 'fileutils'
require 'rubygems'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'pindah_cli'))

class PindahCLITest < Test::Unit::TestCase
  def setup
    $local_pwd ||= File.expand_path(File.dirname(__FILE__))
    @project_path = File.expand_path(Tempfile.new('pindah').path + ".d")
    FileUtils.mkdir_p @project_path
    Dir.chdir @project_path
  end

  def teardown
    FileUtils.rm_rf @project_path
  end

  def test_create_should_create_basic_project_structure
    PindahCLI.create('tld.pindah.testapp', '.')
    assert File.directory?(File.join(@project_path, 'src', 'tld', 'pindah', 'testapp'))
  end

  def test_create_should_create_pindah_spec_file
    PindahCLI.create('tld.pindah.testapp', '.')
    assert File.exists?(File.join(@project_path, 'Pindah.spec'))

    expected = File.read(File.join($local_pwd,
                                  'fixtures',
                                  'Pindah.spec'))
    actual   = File.read(File.join(@project_path,
                                  'Pindah.spec'))
    assert_equal expected, actual
  end

  def test_create_should_create_an_activity_if_desired
    PindahCLI.create('tld.pindah.testapp', '.', 'HelloWorld')

    expected = File.read(File.join($local_pwd,
                                   'fixtures',
                                   'HelloWorld.mirah'))
    actual   = File.read(File.join(@project_path,
                                   'src',
                                   'tld',
                                   'pindah',
                                   'testapp',
                                   'HelloWorld.mirah'))
    assert_equal expected, actual
  end
end
