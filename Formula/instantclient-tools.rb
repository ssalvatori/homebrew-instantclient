require File.expand_path("../Strategies/cache_wo_download", __dir__)

# A formula that installs the Instant Client Tools package.
class InstantclientTools < Formula
  desc "Oracle Instant Client Tools x64"
  homepage "https://www.oracle.com/technetwork/topics/intel-macsoft-096467.html"
  hp = homepage

  url "https://download.oracle.com/otn/mac/instantclient/121020/instantclient-tools-macos.x64-12.1.0.2.0.zip",
      :using => (Class.new(CacheWoDownloadStrategy) do
                   define_method :homepage do
                     hp
                   end
                 end)
  sha256 "8b23c0343b1f6ae971b70af989770628483f40db689409ca3aad849ee587e181"

  option "with-basiclite", "Depend on instantclient-basiclite instead of instantclient-basic."

  depends_on "instantclient-basic" if build.without?("basiclite")
  depends_on "instantclient-basiclite" if build.with?("basiclite")

  def install
    if HOMEBREW_PREFIX.to_s != "/usr/local"
      system DevelopmentTools.locate("install_name_tool"), "-add_rpath", HOMEBREW_PREFIX/"lib", "tools"
    end
    lib.install Dir["*.dylib"]
    bin.install %w[impdp expdp exp imp wrc sqlldr]
  end
end
