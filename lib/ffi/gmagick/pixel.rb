module FFI
  module GMagick
    # Define types used in Pixel Wand
    typedef :pointer, :wand
    typedef :ulong,   :number_colors
    typedef :uint,    :magick_pass_fail

    # Define C functions in the Pixel Wand library
    attach_function :NewPixelWand,                  [], PixelWand.ptr
    attach_function :NewPixelWands,                 [ :number_colors ], PixelWand.ptr
    attach_function :ClonePixelWand,                [ :wand ], PixelWand.ptr
    attach_function :DestroyPixelWand,              [ PixelWand.ptr ], :magick_pass_fail
    attach_function :PixelGetColorAsString,         [ :wand ], :string
    attach_function :PixelGetColorCount,            [ :wand ], :ulong

    class Pixel
      attr_accessor   :wand, :status

      def initialize(old_wand=nil)
        if old_wand
          @wand = FFI::GMagick.ClonePixelWand( old_wand )
        else
          @wand ||= FFI::GMagick.NewPixelWand
        end
        @status = 1
      end

      # Free the memory allocated to this object
      def destroy!
        FFI::GMagick.DestroyPixelWand( @wand )
        @status = 0
      end

      def get_color
        return FFI::GMagick.PixelGetColorAsString( @wand )
      end

      def get_color_count
        return FFI::GMagick.PixelGetColorCount( @wand )
      end
    end
  end
end