# FFI::GMagick

This Gem provides an FFI wrapper for the GraphicsMagick image processing library.  All of the
other *Magick Gems I found either only worked with ImageMagick or were simply wrappers around
the command line interfaces.  These are great Gems but I needed to work with images in RAM
and not hit the hard drive at all.  So, I created this Gem to allow me to work with images
completely in RAM without touching the file system at all.

[![Build Status](https://travis-ci.org/[rnhurt]/[ffi-gmagick].png)](https://travis-ci.org/[rnhurt]/[ffi-gmagick])

## Installation

Add this line to your application's Gemfile:

    gem 'ffi-gmagick'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ffi-gmagick

You also must have a recent version of GraphicsMagick installed and the library in your
systems load path.  Don't worry about the load path, most installers do that for you.

## Usage

Basic usage is as following:

    require 'ffi/gmagick'

    WATERMARK = FFI::GMagick::Image.new
    WATERMARK.from_blob(File.open("watermark.png").read)

    image = FFI::GMagick::Image.new
    image.from_blob(File.open("./my_picture.jpg").read)

    new_thumbnail = image.thumbnail(100, 100, true)
    new_thumbnail.compose(WATERMARK)

    new_thumbnail.to_file("./my_thumb.jpg")


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
