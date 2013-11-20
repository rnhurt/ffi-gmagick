require "ffi"

module FFI
  module GMagick
    extend  FFI::Library
    ffi_lib "GraphicsMagickWand"

    enum :filter_type, [:UndefinedFilter, :PointFilter, :BoxFilter, :TriangleFilter,
                        :HermiteFilter, :HanningFilter, :HammingFilter, :BlackmanFilter,
                        :GaussianFilter, :QuadraticFilter, :CubicFilter, :CatromFilter,
                        :MitchellFilter, :LanczosFilter, :BesselFilter, :SincFilter]

    typedef :pointer, :wand
    typedef :string,  :filename
    typedef :string,  :format
    typedef :uint,    :magick_pass_fail
    typedef :ulong,   :columns
    typedef :ulong,   :rows
    typedef :double,  :blur

    require_relative "gmagick/struct"

    attach_function :NewMagickWand,     [], :wand

    attach_function :MagickReadImage,   [ :wand, :filename ], :magick_pass_fail
    attach_function :MagickWriteImage,  [ :wand, :filename ], :magick_pass_fail

    attach_function :MagickGetConfigureInfo,  [ :wand, :string ], :string
    attach_function :MagickGetVersion,        [ :pointer ], :string
    attach_function :MagickGetCopyright,      [], :string

    attach_function :MagickGetImageAttribute, [ :wand, :string ], :string

    attach_function :MagickGetImageFormat,  [ :wand ], :string
    attach_function :MagickSetImageFormat,  [ :wand, :format ], :uint
    attach_function :MagickGetImageHeight,  [ :wand ], :long

    attach_function :MagickResizeImage,   [ :wand, :columns, :rows, :filter_type, :blur ], :long

  end
end
