require 'test/unit'
require 'find'
require 'rubygems'
require 'fileutils'
require File.expand_path(File.join(File.dirname(__FILE__), '..',
                                   'lib', 'pindah'))

def Pindah.ant
  @ant
end

class PindahBuildTest < Test::Unit::TestCase
  def setup
    @garrett_path = File.expand_path(File.join(File.dirname(__FILE__), "garrett"))
    unless File.exists? @garrett_path
      system "git clone git://github.com/technomancy/Garrett.git #{@garrett_path}"
    end
    system "cd #{@garrett_path}; git pull"
  end

  def test_build
    cmd = "cd #{@garrett_path}; rake debug"
    assert system(cmd), "command failed: '#{cmd}'"

    ["Garrett-debug-unaligned.apk",
     "Garrett-debug.apk", "classes.dex"].each do |f|
      assert File.exists?("#{@garrett_path}/bin/#{f}"), "#{@garrett_path}/bin/#{f} didn't exist"
    end
    ["Garrett", "GarrettView", "R", "R$attr", "R$drawable",
     "R$layout", "R$string"].each do |c|
      assert File.exists? "#{@garrett_path}/bin/classes/garrett/p/serviss/#{c}.class"
    end
  end
end
