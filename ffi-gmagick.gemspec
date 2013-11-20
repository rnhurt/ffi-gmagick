# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ffi/gmagick/version'

Gem::Specification.new do |spec|
  spec.name          = "ffi-gmagick"
  spec.version       = FFI::GMagick::VERSION
  spec.authors       = ["Richard Hurt"]
  spec.email         = ["rnhurt@gmail.com"]
  spec.summary       = "Use the C GraphicsMagick bindings to provide a Ruby interface"
  spec.description   = "This is not a simple 'Ruby'-like implementation.  It is more of a
                        raw 'C' implementation.  As such, it may be a bit more difficult to
                        work with than something like rmagick, but it should perform just as
                        well."
  spec.homepage      = "http://www.github.com/rnhurt/ffi-gmagick"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.requirements << 'libGraphicsMagick, v1.3.18'

  spec.add_runtime_dependency 'ffi', '~> 1.9'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
