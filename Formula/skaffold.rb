class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.13.1",
      revision: "1d10bd4779e3d5e991fcced067367c2c993f3e6e"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6457b194932c191e44ec511cd731cffba1de1c8032603c47da24f72cd76c2cd3" => :catalina
    sha256 "837c5a5fd6d4e26b5d096468dc784175ac766b1cc98e8bace56b406a42dcff2c" => :mojave
    sha256 "e1251ac6eef7f7fda6582eecdf12aca95e84a01a037a297328d2c65e31e17340" => :high_sierra
    sha256 "8667d3b52f2cd28d3b5f89d2c89b734f6399852104a02eb888a43d387b5098ef" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "bash")
    (bash_completion/"skaffold").write output
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "zsh")
    (zsh_completion/"_skaffold").write output
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"dockerfiles":["Dockerfile"]}', output
  end
end
