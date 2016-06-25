class DwarfFortress < Formula
  desc "Open-ended roguelike game"
  homepage "http://bay12games.com/dwarves/"
  url "http://www.bay12games.com/dwarves/df_43_04_osx.tar.bz2"
  version "0.43.04"
  sha256 "a807aca43c5928e8e28e0b94bb6d11bc724acf8144beec1ac828723da2df07f8"

  bottle do
    cellar :any
    sha256 "41a0201d11434d85c463a1bca29a5ad2ebc6fcab73f81cd4331bea4b6f3ede97" => :el_capitan
    sha256 "2a2ea33a322d0af8a6a90393302ba5ae238999b830217875916d1b25fcf3ad21" => :yosemite
    sha256 "e71d1e5b1ad819f7cf93e48208a3ee62927b7e2c2c119744b5a8ab27c91a5b3d" => :mavericks
  end

  depends_on :arch => :intel
  depends_on :x11

  def install
    # Dwarf Fortress uses freetype from X11, but hardcodes a path that
    # isn't installed by modern XQuartz. Point it at wherever XQuartz
    # happens to be on the user's system.
    system "install_name_tool", "-change",
                                "/usr/X11/lib/libfreetype.6.dylib",
                                "#{MacOS::XQuartz.prefix}/lib/libfreetype.6.dylib",
                                "libs/SDL_ttf.framework/SDL_ttf"

    (bin/"dwarffortress").write <<-EOS.undent
      #!/bin/sh
      exec #{libexec}/df
    EOS
    rm_rf "sdl" # only contains a readme
    libexec.install Dir["*"]
  end

  def caveats; <<-EOS.undent
      If you're using a retina display, the PRINT_MODE should
      be changed to STANDARD in #{libexec}/data/init/init.txt
    EOS
  end
end

