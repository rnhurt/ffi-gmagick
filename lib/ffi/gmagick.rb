require "ffi"
require "ffi/gmagick/version"

module FFI
  ##
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
    ffi_lib "GraphicsMagickWand"

    enum :filter_type, [:UndefinedFilter, :PointFilter, :BoxFilter, :TriangleFilter,
                        :HermiteFilter, :HanningFilter, :HammingFilter, :BlackmanFilter,
                        :GaussianFilter, :QuadraticFilter, :CubicFilter, :CatromFilter,
                        :MitchellFilter, :LanczosFilter, :BesselFilter, :SincFilter]

    enum :colorspace,  [:UndefinedColorspace, :RGBColorspace, :GRAYColorspace,
                        :TransparentColorspace, :OHTAColorspace, :XYZColorspace, :YCCColorspace,
                        :YIQColorspace, :YPbPrColorspace, :YUVColorspace, :CMYKColorspace,
                        :sRGBColorspace, :HSLColorspace, :HWBColorspace, :LABColorspace,
                        :CineonLogRGBColorspace, :Rec601LumaColorspace, :Rec601YCbCrColorspace,
                        :Rec709LumaColorspace, :Rec709YCbCrColorspace]
    enum :gravity_type, [:ForgetGravity, :NorthWestGravity, :NorthGravity, :NorthEastGravity,
                        :WestGravity, :CenterGravity, :EastGravity, :SouthWestGravity,
                        :SouthGravity, :SouthEastGravity]

    typedef :pointer, :wand
    typedef :pointer, :blob
    typedef :pointer, :profile
    typedef :string,  :name
    typedef :string,  :filename
    typedef :string,  :format
    typedef :string,  :geometry
    typedef :string,  :crop
    typedef :uint,    :magick_pass_fail
    typedef :uint,    :dither
    typedef :uint,    :measure_error
    typedef :ulong,   :columns
    typedef :ulong,   :rows
    typedef :ulong,   :depth
    typedef :ulong,   :quality
    typedef :ulong,   :width
    typedef :ulong,   :height
    typedef :ulong,   :number_colors
    typedef :ulong,   :tree_depth
    typedef :long,    :x
    typedef :long,    :y
    typedef :double,  :blur
    typedef :double,  :radius
    typedef :double,  :sigma
    typedef :double,  :amount
    typedef :double,  :threshold
    typedef :double,  :x_resolution
    typedef :double,  :y_resolution
    typedef :size_t,  :length


    require_relative "gmagick/struct"


    attach_function :NewMagickWand,               [], :wand
    attach_function :CloneMagickWand,             [ :wand ], :wand

    attach_function :MagickReadImage,             [ :wand, :filename      ], :magick_pass_fail
    attach_function :MagickReadImageBlob,         [ :wand, :blob, :length ], :magick_pass_fail
    attach_function :MagickWriteImage,            [ :wand, :filename ], :magick_pass_fail
    attach_function :MagickWriteImageBlob,        [ :wand, :pointer   ], :pointer

    attach_function :MagickGetImageFormat,        [ :wand ], :string
    attach_function :MagickSetImageFormat,        [ :wand, :format ], :uint
    attach_function :MagickGetImageHeight,        [ :wand ], :ulong
    attach_function :MagickGetImageWidth,         [ :wand ], :ulong
    attach_function :MagickGetImageAttribute,     [ :wand, :string ], :string
    attach_function :MagickGetImageColorspace,    [ :wand ], :colorspace
    attach_function :MagickGetImageDepth,         [ :wand ], :depth
    attach_function :MagickSetImageDepth,         [ :wand, :depth ], :magick_pass_fail

    attach_function :MagickSetCompressionQuality, [ :wand, :quality ], :magick_pass_fail
    attach_function :MagickStripImage,            [ :wand ], :magick_pass_fail
    attach_function :MagickUnsharpMaskImage,      [ :wand, :radius, :sigma, :amount, :threshold ], :magick_pass_fail
    attach_function :MagickQuantizeImage,         [ :wand, :number_colors, :colorspace, :tree_depth, :dither, :measure_error ], :magick_pass_fail

    attach_function :MagickProfileImage,          [ :wand, :name, :profile, :length], :magick_pass_fail
    attach_function :MagickGetImageProfile,       [ :wand, :name, :profile ], :profile
    attach_function :MagickSetImageProfile,       [ :wand, :name, :profile, :ulong ], :magick_pass_fail

    attach_function :MagickResizeImage,           [ :wand, :columns, :rows, :filter_type, :blur ], :magick_pass_fail
    attach_function :MagickResampleImage,         [ :wand, :x_resolution, :y_resolution, :filter_type, :blur ], :magick_pass_fail
    attach_function :MagickTransformImage,        [ :wand, :crop, :geometry ], :wand
    # attach_function :MagickSetImageGravity,       [ :wand, :gravity_type ], :magick_pass_fail
    attach_function :MagickScaleImage,            [ :wand, :columns, :rows ], :magick_pass_fail
    attach_function :MagickCropImage,             [ :wand, :width, :height, :x, :y ], :magick_pass_fail

    attach_function :MagickGetConfigureInfo,      [ :wand, :string ], :string
    attach_function :MagickGetVersion,            [ :pointer ], :string
    attach_function :MagickGetCopyright,          [], :string
  end
end
