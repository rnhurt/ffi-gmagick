module FFI
  module GMagick
    class PixelPacket < FFI::Struct
      layout  :red,      :uint,
              :green,    :uint,
              :blue,     :uint,
              :opacity,  :uint
    end

    class ImageInfo < FFI::Struct
      layout  :adjoin,             :uint,
              :antialias,          :uint,
              :background_color,   PixelPacket.ptr
    end
  end
end