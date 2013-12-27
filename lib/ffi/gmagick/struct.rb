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
      layout  :exception,   ExceptionInfo.by_ref,
              :colorspace,  :colorspace,
              :matte,       :uint,
              :pixel,       PixelPacket.by_ref,
              :count,       :ulong
    end

    class ImageInfo < FFI::Struct
      layout  :adjoin,             :uint,
              :antialias,          :uint,
              :background_color,   PixelPacket.ptr
    end
  end
end