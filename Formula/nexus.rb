class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https://www.sonatype.org/"
  url "https://sonatype-download.global.ssl.fastly.net/nexus/oss/nexus-2.14.8-01-bundle.tar.gz"
  version "2.14.8-01"
  sha256 "dfe47d5e5b3c6667854d967eede2f778169c01c55ad930a17f79ee6a59c36903"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.bat"]
    # Put the sonatype-work directory in the var directory, to persist across version updates
    inreplace "nexus-#{version}/conf/nexus.properties",
      "nexus-work=${bundleBasedir}/../sonatype-work/nexus",
      "nexus-work=#{var}/nexus"
    libexec.install Dir["nexus-#{version}/*"]
    bin.install_symlink libexec/"bin/nexus"
  end

  plist_options :manual => "nexus start"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>com.sonatype.nexus</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/nexus</string>
          <string>start</string>
        </array>
        <key>RunAtLoad</key>
      <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    output = `#{bin}/nexus status`
    assert_match "Nexus OSS is", output
  end
end
