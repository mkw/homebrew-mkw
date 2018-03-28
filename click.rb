class Click < Formula
  desc "The 'Command Line Interactive Controller for Kubernetes'"
  homepage "https://github.com/databricks/click"
  url "https://static.crates.io/crates/click/click-0.3.1.crate"
  sha256 "926ecb72095b88d10d4022d39d599724e854434e868919d183c78c7bfc1062c9"
  head "https://github.com/databricks/click.git"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/click"
  end

  test do
    system bin/"click", "-V"
  end
end
