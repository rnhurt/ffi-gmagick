module FFI
  module GMagick

    class Image
      attr_accessor   :wand

      def initialize()
        @wand ||= FFI::GMagick.NewMagickWand

      end
    end
  end
end