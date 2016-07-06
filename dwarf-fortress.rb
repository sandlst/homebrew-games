class DwarfFortress < Formula
  desc "Open-ended roguelike game"
  homepage "http://bay12games.com/dwarves/"
  url "http://www.bay12games.com/dwarves/df_43_05_osx.tar.bz2"
  version "0.43.05"
  sha256 "c9614c012c23dcef6197f83d02510d577e1257c5a0de948af5c8f76ae56c5fc8"

  bottle do
    cellar :any
    sha256 "45f05bdaacbb99f6ee8a0a2710e6a7a94d47e56c17d8ea40dd3699c495fd2846" => :el_capitan
    sha256 "0e1e1d9be44b67606e9bd7fe12ccc22a77c06f6570c1d69642ca12c425549f52" => :yosemite
    sha256 "76dd78aeeeb3f73b8db3a84ed2e773c35843ad92324653de3916e283466b8a42" => :mavericks
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
