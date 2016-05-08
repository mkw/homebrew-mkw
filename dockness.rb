require "timeout"

class Dockness < Formula
  desc "DNS for Docker machines"
  homepage "https://github.com/bamarni/dockness"
  url "https://github.com/bamarni/dockness/releases/download/v2.0.1/dockness-darwin-x64.tar.gz"
  sha1 "ad4692e40bd237af17af440a84b27268e0d6ede7"

  def install
    bin.install "dockness"
  end

  def caveats; <<-EOS.undent
    Note: When using launchctl the top level domain will be
    "docker" and the listening port will be 10053.

    To make a top level domain called "docker" resolve properly,
    add a file called /etc/resolver/docker as root with the
    following contents:

      nameserver 127.0.0.1
      port 10053

    The name of the top level domain and port can be changed by
    modifying changing the -tld and -port arguments in the
    launchctl plist file.
    EOS
  end

  plist_options :manual => "dockness -port 10053 -tld docker"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Disabled</key>
      <false/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>EnvironmentVariables</key>
      <dict>
        <key>PATH</key>
        <string>#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
      </dict>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/dockness</string>
        <string>-port</string>
        <string>10053</string>
        <string>-tld</string>
        <string>docker</string>
        <string>-debug</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    # pick random port
    server = TCPServer.new("127.0.0.1", 0)
    port = server.addr[1]

    pid = Process.spawn("#{bin}/dockness -port #{port}")
    begin
      Timeout.timeout(1) do
        Process.wait(pid)
        raise "dockness failed to start listening on port #{port}"
      end
    rescue Timeout::Error
      Process.kill("KILL", pid)
      # Timeout means success; lack of timeout means that it could not start
    end
  end
end
