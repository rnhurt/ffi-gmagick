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
      attr_accessor   :wand, :status

      def initialize(old_wand=nil)
        if old_wand
          @wand = FFI::GMagick.CloneMagickWand( old_wand )
        else
          @wand ||= FFI::GMagick.NewMagickWand
        end
        @status = 1
      end

      # Read image data from a BLOB
      def from_blob(blob)
        @status = FFI::GMagick.MagickReadImageBlob( @wand, blob, blob.bytesize)

        # Note: PDF images don't report proper bytesize
        return blob.bytesize
      end

      # Write image data to a BLOB
      def to_blob
        output = nil
        FFI::MemoryPointer.new(:ulong, 64) do |length|
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
        @status = FFI::GMagick.MagickWriteImage( @wand, filename )
      end

      # Return the width of the image in pixels
      def width
        FFI::GMagick.MagickGetImageWidth( @wand ).to_f
      end
      alias_method :cols, :width

      # Return the height of the image in pixels
      def height
        FFI::GMagick.MagickGetImageHeight( @wand ).to_f
      end
      alias_method :rows, :height

      # Return the size of the image in bytes
      def size
        FFI::GMagick.MagickGetImageSize( @wand )
      end
      alias_method :length, :size

      # Return the image format
      def format
        FFI::GMagick.MagickGetImageFormat( @wand )
      end

      # Set the image format
      def format=(format)
        FFI::GMagick.MagickSetImageFormat( @wand, format )
      end

      # Negate the colors in the specified channel
      def negate_channel(channel, gray=0)
        @status = FFI::GMagick.MagickNegateImageChannel( @wand, channel, gray )
      end

      # Set the gamma value for the specified channel
      def gamma_channel(channel, gamma=0)
        @status = FFI::GMagick.MagickGammaImageChannel( @wand, channel, gamma )
      end

      # Return the value of the named attribute
      def attribute(name)
        FFI::GMagick.MagickGetImageAttribute( @wand, name )
      end

      # Return the image type
      def type
        FFI::GMagick.MagickGetImageType( @wand )
      end

      # Set the image type to one of the valid
      # <a href="http://www.graphicsmagick.org/api/types.html#imagetype">image types</a>
      def type=(type)
        @status = FFI::GMagick.MagickSetImageType( @wand, type )
      end

      # Return the colorspace
      def colorspace
        FFI::GMagick.MagickGetImageColorspace( @wand )
      end
      alias_method :colormodel, :colorspace

      # Set the image colorspace to one of the valid
      # <a href="http://www.graphicsmagick.org/api/types.html#colorspacetype">colorspace types</a>.
      def colorspace=(colorspace)
        FFI::GMagick.MagickSetImageColorspace( @wand, colorspace )
      end
      alias_method :colormodel=, :colorspace=

      # Return the information for a specific profile in the image
      def profile(name="ICC")
        output = nil
        FFI::MemoryPointer.new(:ulong, 64) do |length|
          blobout = FFI::GMagick.MagickGetImageProfile( @wand, name, length )
          output  = blobout.read_string(length.read_long)
        end
        return output
      end

      # Add a profile to this image
      def add_profile(name, profile)
        @status = FFI::GMagick.MagickProfileImage( @wand, name, profile, profile.size )
        raise "invalid profile" unless 1 == status
      end

      # Return the interlace information as one of the valid
      # <a href="http://www.graphicsmagick.org/api/types.html#interlacetype">interlace types</a>.
      def interlace
        FFI::GMagick.MagickGetImageInterlaceScheme( @wand )
      end

      # Set the interlace information to one of the valid
      # <a href="http://www.graphicsmagick.org/api/types.html#interlacetype">interlace types</a>.
      def interlace=(interlace)
        @status = FFI::GMagick.MagickSetImageInterlaceScheme( @wand, interlace )
        raise "invalid interlace type" unless 1 == status
      end

      # Strip the image of extra data (comments, profiles, etc.)
      def strip
        @status = FFI::GMagick.MagickStripImage( @wand )
      end

      def quality=(quality)
        @status = FFI::GMagick.MagickSetCompressionQuality( @wand, quality )
      end

      # Resize the image to the desired dimensions using various
      # <a href="http://www.graphicsmagick.org/api/types.html#filtertypes">filters</a>.
      def resize(width, height, filter=:BoxFilter, blur=1.0)
        @status = FFI::GMagick.MagickResizeImage( @wand, width, height, filter, blur )
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

        @status = FFI::GMagick.MagickCropImage( @wand, width, height, x, y )
      end

      # A convenience method. Resize the image to fit within the specified
      # dimensions while retaining the aspect ratio of the original image.
      # If necessary, crop the image in the larger dimension.
      #
      # Returns a new image object
      def resize_to_fill(new_width, new_height=nil)
        new_height  ||= new_width
        local_image = FFI::GMagick::Image.new(@wand)

        if new_width != local_image.width || new_height != local_image.height
          scale = [new_width/local_image.width.to_f, new_height/local_image.height.to_f].max
          local_image.resize(scale*width+0.5, scale*height+0.5)
        end

        if new_width != local_image.width || new_height != local_image.height
          local_image.crop(new_width, new_height)
        end

        return local_image
      end

      # A convenience method. Resize the image to fit within the
      # specified dimensions while retaining the original aspect
      # ratio. The image may be shorter or narrower than specified
      # in the smaller dimension but will not be larger than the
      # specified values.
      #
      # Returns a new image object
      def resize_to_fit(width, height=nil)
        height ||= width
        geometry = "#{width}x#{height}>"
        local_wand = FFI::GMagick.MagickTransformImage( @wand, "", geometry )
        return FFI::GMagick::Image.new(local_wand)
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
        @status = FFI::GMagick.MagickCompositeImage(@wand, image.wand, operator, x, y)
      end

      # Is this a valid image
      def valid?
        @status == 1
      end

      # Return the copywrite notification for GraphicsMagick
      def copywrite
        FFI::GMagick.MagickGetCopyright
      end
    end
  end
end