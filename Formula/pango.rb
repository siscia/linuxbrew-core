class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pango/1.46/pango-1.46.0.tar.xz"
  sha256 "9a81572ebb946187fbdd69d5ffc57e2f7a1f768cd8d2fd89dbb03fb9002a99b5"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/pango.git"

  bottle do
    sha256 "56e6c57459d6c984905aa61a7d585b6e48c52e787a365bfb52e962337a96e1f0" => :catalina
    sha256 "ba5b72bea65bbf6b81aa010b7090c644c9a0ecf4e76720829bd1adf510de3d26" => :mojave
    sha256 "b32c45c7c62c11153070ff91c226430a4b3341fced4d8b1ef4db687366ce4bc4" => :high_sierra
    sha256 "5987725d9ef43754332da86d4a8c6687deac9e22ac3da9cffa1d71b521ac6c67" => :x86_64_linux
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "glib"
  depends_on "harfbuzz"

  def install
    mkdir "build" do
      system "meson", *std_meson_args,
                      "-Ddefault_library=both",
                      "-Dintrospection=true",
                      "-Duse_fontconfig=true",
                      ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/pango-view", "--version"
    (testpath/"test.c").write <<~EOS
      #include <pango/pangocairo.h>

      int main(int argc, char *argv[]) {
        PangoFontMap *fontmap;
        int n_families;
        PangoFontFamily **families;
        fontmap = pango_cairo_font_map_get_default();
        pango_font_map_list_families (fontmap, &families, &n_families);
        g_free(families);
        return 0;
      }
    EOS
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/pango-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{cairo.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lcairo
      -lglib-2.0
      -lgobject-2.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
