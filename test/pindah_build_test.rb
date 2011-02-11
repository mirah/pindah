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
    @garrett = File.expand_path(File.join(File.dirname(__FILE__), "garrett"))
    unless File.exists? @garrett
      system "git clone git://github.com/zapnap/Garrett.git #{@garrett}"
    end
    system "cd #{@garrett}; git pull"
  end

  def test_build
    system "cd #{@garrett}; jrake debug"

    ["Garrett-debug-unaligned.apk",
     "Garrett-debug.apk", "classes.dex"].each do |f|
      assert File.exists? "#{@garrett}/bin/#{f}"
    end
    ["Garrett", "GarrettView", "R", "R$attr", "R$drawable",
     "R$layout", "R$string"].each do |c|
      assert File.exists? "#{@garrett}/bin/classes/garrett/p/serviss/#{c}.class"
    end
  end
end
