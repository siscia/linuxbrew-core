class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.40.0.tar.gz"
  sha256 "ba77e99736c569f7b8d04508ab1b619d25982f571229e4501dabd2924efb2a0c"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8409c1bfd8fe3ef7c1c63f3f9373205d285e9fadb09e28cfb36055f52b3c1a3d" => :catalina
    sha256 "4aada6f6a0e7673d491dd45785cb6e6c3d1a7e8b7c40c77b2fbfa9282ecef723" => :mojave
    sha256 "1e3126937046e8749c8018282a99a2647ab86e6ae9549233ba0e46ddcebd108a" => :high_sierra
  end

  depends_on "rust" => :build
  unless OS.mac?
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
