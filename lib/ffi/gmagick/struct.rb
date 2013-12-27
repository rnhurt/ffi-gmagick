module FFI
  module GMagick
    require "ffi/gmagick/enum"

    class ExceptionInfo < FFI::Struct
      layout  :reason,      :string,
              :description, :string,
              :severity,    :exception_type,
              :signature,   :ulong
    end

    class PixelPacket < FFI::Struct
      layout  :red,      :uint,
              :green,    :uint,
              :blue,     :uint,
              :opacity,  :uint
    end

    class PixelWand < FFI::Struct
      layout  :exception,   ExceptionInfo.ptr,
              :colorspace,  :colorspace,
              :matte,       :uint,
              :pixel,       PixelPacket.ptr,
              :count,       :ulong
    end

    class ImageInfo < FFI::Struct
      layout  :adjoin,             :uint,
              :antialias,          :uint,
              :background_color,   PixelPacket.ptr
    end
  end
end