class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      tag:      "v0.9.3",
      revision: "959cea60eab1f12f0872ed3ee5344c647ec56c7b"
  license "MPL-2.0"
  head "https://github.com/hashicorp/serf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c716a0e85a67699c6c83e3cb178ece969d94ec7aec6f36ec60e4b65e6093258d" => :catalina
    sha256 "e56b01a8475e3c056233631945ad4d3710dc746c048c09679835f795cbf371f2" => :mojave
    sha256 "fd50cd7495843099f7895ad8f0ed25537cbc853a03555a4c2bf375b2c1b53df9" => :high_sierra
    sha256 "b1bf71423e797f3f0e99a0a7a7cc35233391679d65d22778d0a37dc71bbc7c52" => :x86_64_linux
  end

  depends_on "go" => :build

  uses_from_macos "zip" => :build

  def install
    ldflags = %W[
      -X github.com/hashicorp/serf/version.Version=#{version}
      -X github.com/hashicorp/serf/version.VersionPrerelease=
    ].join(" ")

    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/serf"
  end

  test do
    pid = fork do
      exec "#{bin}/serf", "agent"
    end
    sleep 1
    assert_match /:7946.*alive$/, shell_output("#{bin}/serf members")
  ensure
    system "#{bin}/serf", "leave"
    Process.kill "SIGINT", pid
    Process.wait pid
  end
end
