module FFI
  module GMagick
    class Image
      # This is a convenience class that takes care of most of the messy work
      # of dealing with the raw FFI::GMagick interface.
      #
      # Basic usage is as following:
      #
      #     require 'ffi/gmagick'
      #
      #     WATERMARK = FFI::GMagick::Image.new
      #     WATERMARK.from_blob(File.open("watermark.png").read)
      #
      #     image = FFI::GMagick::Image.new
      #     image.from_blob(File.open("./my_picture.jpg").read)
      #
      #     new_thumbnail = image.thumbnail(100, 100, true)
      #     new_thumbnail.compose(WATERMARK)
      #
      #     new_thumbnail.to_file("./my_thumb.jpg")
      #
      # This will open two images, a picture and a watermark, create a square
      # thumbnail and apply the watermark in the center of the image.
      attr_accessor   :wand

      def initialize(old_wand=nil)
        if old_wand
          @wand = FFI::GMagick.CloneMagickWand( old_wand )
        else
          @wand ||= FFI::GMagick.NewMagickWand
        end
      end

      # Return the width of the image in pixels
      def width
        FFI::GMagick.MagickGetImageWidth( @wand ).to_f
      end

      # Return the height of the image in pixels
      def height
        FFI::GMagick.MagickGetImageHeight( @wand ).to_f
      end

      # Return the size of the image in bytes
      def size
        FFI::GMagick.MagickGetImageSize( @wand )
      end
      alias_method :length, :size

      # Read image data from a BLOB
      def from_blob(blob)
        status = FFI::GMagick.MagickReadImageBlob( @wand, blob, blob.bytesize)
        raise "invalid image" unless 1 == status
        return blob.bytesize
      end

      # Write image data to a BLOB
      def to_blob
        output = nil
        FFI::MemoryPointer.new(:ulong, 2) do |length|
          blobout = FFI::GMagick.MagickWriteImageBlob( @wand, length )
          output = blobout.read_string(length.read_long)
        end
        return output
      end

      # Read image data from a filename
      def from_file(filename)
        blob = File.open(filename).read
        self.from_blob(blob)
      end

      # Write image data to a filename
      def to_file(filename)
        status = FFI::GMagick.MagickWriteImage( @wand, filename )
      end

      # Resize the image to the desired dimensions using various
      # <a href="http://www.graphicsmagick.org/api/types.html#filtertypes">filters</a>.
      def resize(width, height, filter=:BoxFilter, blur=1.0)
        FFI::GMagick.MagickResizeImage( @wand, width, height, filter, blur )
      end


      # Crop the image to the desired dimensions.  If you don't provide an
      # X,Y offset the crop will be centered.
      def crop(width, height, x=nil, y=nil)
        if x.nil? || y.nil?
          old_width   = self.width
          old_height  = self.height

          x = (old_width / 2) - (width / 2)
          y = (old_height / 2) - (height / 2)
        end

        FFI::GMagick.MagickCropImage( @wand, width, height, x, y )
      end

      # Creates a thumbnail of the image to the specified height & width.
      # Optionally, it will create a square thumbnail based on the given width.
      #
      # Returns a new image object
      def thumbnail(new_width, new_height, square=false)
        local_wand = FFI::GMagick::Image.new(@wand)

        width       = local_wand.width
        height      = local_wand.height
        new_width   = new_width.to_f
        new_height  = new_height.to_f

        p "existing width(#{width}) & height(#{height})"
        p "     new width(#{new_width}) & height(#{new_height})"
        if square
          if new_width != width || new_height != height
            scale = [new_width/width, new_height/height].max
            local_wand.resize(scale*width+0.5, scale*height+0.5)
          end

          width  = local_wand.width
          height = local_wand.height
          new_height = new_width
          p "  square width(#{width}) & height(#{height})"
          p "     new_width(#{new_width}) & new_height(#{new_height})"
          if new_width != width || new_height != height
            local_wand.crop(new_width, new_height)
          end
        else
          p "  non-square width(#{width}) & height(#{height})"
          p "         new width(#{new_width}) & height(#{new_height})"
          if new_width != width || new_height != height
            scale = [new_width/width, new_height/height].max
            local_wand.resize(scale*width, scale*height)
          end
        end

        return local_wand
      end

      # Composites an Image (such as a watermark) with this one using various
      # <a href="http://www.graphicsmagick.org/api/types.html#compositeoperator">composite operators</a>.
      #
      # If you don't provide an X,Y offset then the operation with be centered on the base image.
      def compose(image, operator=:OverCompositeOp, x=nil, y=nil)
        if x.nil? || y.nil?
          width   = self.width
          height  = self.height
          new_width   = image.width
          new_height  = image.height

          x = (width / 2) - (new_width / 2)
          y = (height / 2) - (new_height / 2)
        end
        status = FFI::GMagick.MagickCompositeImage(@wand, image.wand, operator, x, y)
      end

      # Return the copywrite notification for GraphicsMagick
      def copywrite
        FFI::GMagick.MagickGetCopyright
      end
    end
  end
end