require "language/node"

class Graphqurl < Formula
  desc "A curl like CLI for GraphQL"
  homepage "https://github.com/hasura/graphqurl"
  url "https://github.com/hasura/graphqurl/archive/v0.3.3.tar.gz"
  sha256 "337b3faf5c2eb28bac9721be9c919bffe94fb1c427f39add703b6b1c1ae5ff8b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "node@10" => :build
  # depends_on "yarn" => :build

  def install
    # system "yarn"
    # system "npm", "run", "build"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/gq --version").chomp
  end
end
