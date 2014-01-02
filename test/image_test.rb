require 'test_helper'

class ImageTest < MiniTest::Unit::TestCase
  def setup
    @image = FFI::GMagick::Image.new()
    @image.from_blob(BLOB)
  end

  def test_destroy
    assert @image.destroy!
    refute @image.valid?
  end

  def test_size
    assert_equal 2005, @image.size, "BLOBs are not equal"
  end

  def test_crop
    @image.crop(10,10)
    assert_equal 10, @image.width,  "invalid width"
    assert_equal 10, @image.height, "invalid height"
  end

  def test_crop_with_offset
    @image.crop(10,10, 5, 15)
    assert_equal 10, @image.width,  "invalid width"
    assert_equal 10, @image.height, "invalid height"
    # TODO: How do you test offsets??
  end

  def test_resize
    @image.resize(10,20)
    assert_equal 10, @image.width,  "invalid width"
    assert_equal 20, @image.height, "invalid height"
  end

  def test_resize_to_fill
    new_image = @image.resize_to_fill(100,200)
    assert_equal 100, new_image.width,  "invalid width"
    assert_equal 200, new_image.height, "invalid height"
  end

  def test_resize_to_fill_by_width
    new_image = @image.resize_to_fill(100)
    assert_equal 100, new_image.width,  "invalid width"
    assert_equal 100, new_image.height, "invalid height"
  end

  def test_resize_to_fit
    new_image = @image.resize_to_fit(100,200)
    assert_equal 100, new_image.width,  "invalid width"
    assert_equal 63,  new_image.height, "invalid height"
  end

  def test_resize_to_fit_by_width
    new_image = @image.resize_to_fit(100)
    assert_equal 100, new_image.width,  "invalid width"
    assert_equal 63,  new_image.height, "invalid height"
  end

  def test_colorspace
    assert_equal :RGBColorspace, @image.colorspace, "invalid color space"
  end

  def test_get_type
    assert_equal :TrueColorMatteType, @image.type, "invalid type"
  end

  def test_set_interlace
    @image.interlace = :PlaneInterlace
    assert_equal :PlaneInterlace, @image.interlace, "invalid interlace"
  end

  def test_get_depth
    assert_equal 8, @image.depth
  end

  def test_set_depth
    @image.depth = 2
    assert_equal 2, @image.depth
  end

  def test_set_type
    skip
    @image.type = :TrueColorType
    assert @image.valid?
    assert_equal :TrueColorType, @image.type, "invalid type"
  end

  def test_strip
    skip # not yet working
    old_size = @image.size
    @image.strip
    assert @image.valid?
    assert old_size > @image.size, "image is not smaller"
  end
end