require "ffi"
require "ffi/gmagick/version"

module FFI
  # FFI::GMagick is an FFI binding for the GraphicsMagick MagickWand image library.
  # Basic usage is as following:
  #
  # require 'ffi/gmagick'
  #
  # wand = FFI::GMagick.NewMagickWand
  # FFI::GMagick.MagickReadImage( wand, "./test.jpg")
  #
  # FFI::GMagick.MagickSetImageFormat( wand, "PNG" )
  #
  # FFI::GMagick.MagickResizeImage( wand, 500, 500, :UndefinedFilter, 0.0)
  # FFI::GMagick.MagickWriteImage( wand, "./test-out.jpg" )
  #
  # For more information on commands and syntax see http://www.graphicsmagick.org/wand/magick_wand.html
  #
  module GMagick
    extend  FFI::Library
    ffi_lib "GraphicsMagickWand"      if RUBY_PLATFORM =~ /darwin/
    ffi_lib "GraphicsMagickWand.so.2" if RUBY_PLATFORM =~ /linux/

    require "ffi/gmagick/struct"
    require "ffi/gmagick/image"
    require "ffi/gmagick/pixel"
  end
end
