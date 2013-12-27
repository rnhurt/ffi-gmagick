module FFI
  module GMagick
    typedef :pointer, :wand
    typedef :pointer, :composite_wand
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
    typedef :uint,    :gray
    typedef :uint,    :dither
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
    typedef :double,  :gamma
    typedef :double,  :amount
    typedef :double,  :threshold
    typedef :double,  :x_resolution
    typedef :double,  :y_resolution
    typedef :size_t,  :length

    attach_function :NewMagickWand,                 [], :wand
    attach_function :DestroyMagickWand,             [ :wand ], :void
    attach_function :CloneMagickWand,               [ :wand ], :wand

    attach_function :MagickReadImage,               [ :wand, :filename      ], :magick_pass_fail
    attach_function :MagickReadImageBlob,           [ :wand, :blob, :length ], :magick_pass_fail
    attach_function :MagickWriteImage,              [ :wand, :filename ], :magick_pass_fail
    attach_function :MagickWriteImageBlob,          [ :wand, :pointer   ], :pointer

    attach_function :MagickGetImageFormat,          [ :wand ], :string
    attach_function :MagickSetImageFormat,          [ :wand, :format ], :uint
    attach_function :MagickGetImageHeight,          [ :wand ], :ulong
    attach_function :MagickGetImageWidth,           [ :wand ], :ulong
    attach_function :MagickGetImageType,            [ :wand ], :image_type
    attach_function :MagickSetImageType,            [ :wand, :image_type ], :magick_pass_fail
    attach_function :MagickGetImageSavedType,       [ :wand ], :image_type
    attach_function :MagickSetImageSavedType,       [ :wand, :image_type ], :magick_pass_fail
    attach_function :MagickGetImageAttribute,       [ :wand, :string ], :string
    attach_function :MagickGetImageColorspace,      [ :wand ], :colorspace
    attach_function :MagickSetImageColorspace,      [ :wand, :colorspace ], :magick_pass_fail
    attach_function :MagickGetImageDepth,           [ :wand ], :depth
    attach_function :MagickSetImageDepth,           [ :wand, :depth ], :magick_pass_fail
    attach_function :MagickGetImageSize,            [ :wand ], :ulong

    attach_function :MagickSetCompressionQuality,   [ :wand, :quality ], :magick_pass_fail
    attach_function :MagickStripImage,              [ :wand ], :magick_pass_fail
    attach_function :MagickUnsharpMaskImage,        [ :wand, :radius, :sigma, :amount, :threshold ], :magick_pass_fail
    attach_function :MagickQuantizeImage,           [ :wand, :number_colors, :colorspace, :tree_depth, :dither, :measure_error ], :magick_pass_fail
    attach_function :MagickNegateImageChannel,      [ :wand, :channel_type, :gray ], :magick_pass_fail
    attach_function :MagickGammaImageChannel,       [ :wand, :channel_type, :gamma ], :magick_pass_fail
    attach_function :MagickProfileImage,            [ :wand, :name, :profile, :length], :magick_pass_fail
    attach_function :MagickGetImageProfile,         [ :wand, :name, :profile ], :profile
    attach_function :MagickSetImageProfile,         [ :wand, :name, :profile, :ulong ], :magick_pass_fail
    attach_function :MagickGetImageInterlaceScheme, [ :wand ], :interlace_type
    attach_function :MagickSetImageInterlaceScheme, [ :wand, :interlace_type ], :magick_pass_fail
    attach_function :MagickSetInterlaceScheme,      [ :wand, :interlace_type ], :magick_pass_fail
    attach_function :MagickFlattenImages,           [ :wand ], :wand
    attach_function :MagickMapImage,                [ :wand, :wand, :dither ], :magick_pass_fail
    attach_function :MagickGetImageHistogram,       [ :wand, :pointer ], :pointer

    attach_function :MagickResizeImage,             [ :wand, :columns, :rows, :filter_type, :blur ], :magick_pass_fail
    attach_function :MagickResampleImage,           [ :wand, :x_resolution, :y_resolution, :filter_type, :blur ], :magick_pass_fail
    attach_function :MagickTransformImage,          [ :wand, :crop, :geometry ], :wand
    attach_function :MagickScaleImage,              [ :wand, :columns, :rows ], :magick_pass_fail
    attach_function :MagickCropImage,               [ :wand, :width, :height, :x, :y ], :magick_pass_fail
    attach_function :MagickCompositeImage,          [ :wand, :composite_wand, :composite_operator, :x, :y ], :magick_pass_fail

    attach_function :MagickGetConfigureInfo,        [ :wand, :string ], :string
    attach_function :MagickGetVersion,              [ :pointer ], :string
    attach_function :MagickGetCopyright,            [], :string

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

      # Free the memory allocated to this object
      def destroy!
        FFI::GMagick.DestroyMagickWand( @wand )
        @status = 0
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
        # FFI::GMagick.MagickGetImageSavedType( @wand )
      end

      # Set the image type to one of the valid
      # <a href="http://www.graphicsmagick.org/api/types.html#imagetype">image types</a>
      def type=(type)
        status = FFI::GMagick.MagickSetImageType( @wand, type )
        status += FFI::GMagick.MagickSetImageSavedType( @wand, type )
        raise "invalid image type" unless 2 == status
        @status = 1
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
        # Apparently, you have to set *both* of these for it stick.
        status = FFI::GMagick.MagickSetImageInterlaceScheme( @wand, interlace )
        status += FFI::GMagick.MagickSetInterlaceScheme( @wand, interlace )
        raise "invalid interlace type" unless 2 == status
        @status = 1
      end

      # Strip the image of extra data (comments, profiles, etc.)
      def strip
        @status = FFI::GMagick.MagickStripImage( @wand )
      end

      # Merge existing layers into a single flattened image
      def flatten
        local_wand = FFI::GMagick.MagickFlattenImages( @wand )
        return FFI::GMagick::Image.new(local_wand)
      end

      # Get a simplified histogram for this image.
      def get_histogram(web_safe=true)
        new_wand = FFI::GMagick.CloneMagickWand( @wand )

        # "WebSafe" colors are built around the original 216 colors defined by Netscape
        if web_safe
          netscape = FFI::GMagick.NewMagickWand
          FFI::GMagick.MagickReadImage(netscape, 'NETSCAPE:')
          FFI::GMagick.MagickMapImage( new_wand, netscape, 1 )
          FFI::GMagick.DestroyMagickWand( netscape )
        end

        histogram = {}
        total_color_count = 0.0
        FFI::MemoryPointer.new(:ulong, 1) do |max_colors|
          pointer   = FFI::GMagick.MagickGetImageHistogram( new_wand, max_colors )
          number_of_colors  = max_colors.read_int

          pixel_wands = pointer.read_array_of_pointer(number_of_colors)
          pixel_wands.each do |wand|
            pixel = FFI::GMagick::Pixel.new(wand)
            hex_color   = "#%02X%02X%02X" % pixel.get_color.split(",").map(&:to_i)
            color_count = pixel.get_color_count
            total_color_count   += color_count
            histogram[hex_color] = color_count
          end
        end
        FFI::GMagick.DestroyMagickWand( new_wand )

        # Convert distribution to %
        return histogram.map{|k,v| {k => v / total_color_count}}
      end

      # Change the quality (compression) of the image
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