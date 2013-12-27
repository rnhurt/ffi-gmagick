module FFI
  module GMagick

    enum :interlace_type,     [:UndefinedInterlace, :NoInterlace, :LineInterlace, :PlaneInterlace, :PartitionInterlace]

    enum :filter_type,        [:UndefinedFilter, :PointFilter, :BoxFilter, :TriangleFilter,
                              :HermiteFilter, :HanningFilter, :HammingFilter, :BlackmanFilter,
                              :GaussianFilter, :QuadraticFilter, :CubicFilter, :CatromFilter,
                              :MitchellFilter, :LanczosFilter, :BesselFilter, :SincFilter]
    enum :channel_type,       [:UndefinedChannel, :RedChannel, :CyanChannel, :GreenChannel, :MagentaChannel,
                              :BlueChannel, :YellowChannel, :OpacityChannel, :BlackChannel, :MatteChannel,
                              :AllChannels, :GrayChannel]

    enum :image_type,         [:UndefinedType, :BilevelType, :GrayscaleType, :PaletteType, :PaletteMatteType,
                              :TrueColorType, :TrueColorMatteType, :ColorSeparationType]

    enum :colorspace,         [:UndefinedColorspace, :RGBColorspace, :GRAYColorspace,
                              :TransparentColorspace, :OHTAColorspace, :XYZColorspace, :YCCColorspace,
                              :YIQColorspace, :YPbPrColorspace, :YUVColorspace, :CMYKColorspace,
                              :sRGBColorspace, :HSLColorspace, :HWBColorspace, :LABColorspace,
                              :CineonLogRGBColorspace, :Rec601LumaColorspace, :Rec601YCbCrColorspace,
                              :Rec709LumaColorspace, :Rec709YCbCrColorspace]

    enum :gravity_type,       [:ForgetGravity, :NorthWestGravity, :NorthGravity, :NorthEastGravity,
                              :WestGravity, :CenterGravity, :EastGravity, :SouthWestGravity,
                              :SouthGravity, :SouthEastGravity]

    enum :composite_operator, [:UndefinedCompositeOp, :OverCompositeOp, :InCompositeOp, :OutCompositeOp,
                              :AtopCompositeOp, :XorCompositeOp, :PlusCompositeOp, :MinusCompositeOp,
                              :AddCompositeOp, :SubtractCompositeOp, :DifferenceCompositeOp, :BumpmapCompositeOp,
                              :CopyCompositeOp, :CopyRedCompositeOp, :CopyGreenCompositeOp, :CopyBlueCompositeOp,
                              :CopyOpacityCompositeOp, :ClearCompositeOp, :DissolveCompositeOp, :DisplaceCompositeOp,
                              :ModulateCompositeOp, :ThresholdCompositeOp, :NoCompositeOp, :DarkenCompositeOp,
                              :LightenCompositeOp, :HueCompositeOp, :SaturateCompositeOp, :ColorizeCompositeOp,
                              :LuminizeCompositeOp, :ScreenCompositeOp, :OverlayCompositeOp, :CopyCyanCompositeOp,
                              :CopyMagentaCompositeOp, :CopyYellowCompositeOp, :CopyBlackCompositeOp, :DivideCompositeOp]

    enum :exception_type,
          [:UndefinedException,          300,
           :WarningException,            300,
           :ResourceLimitWarning,        300,
           :TypeWarning,                 305,
           :OptionWarning,               310,
           :DelegateWarning,             315,
           :MissingDelegateWarning,      320,
           :CorruptImageWarning,         325,
           :FileOpenWarning,             330,
           :BlobWarning,                 335,
           :StreamWarning,               340,
           :CacheWarning,                345,
           :CoderWarning,                350,
           :ModuleWarning,               355,
           :DrawWarning,                 360,
           :ImageWarning,                365,
           :XServerWarning,              380,
           :MonitorWarning,              385,
           :RegistryWarning,             390,
           :ConfigureWarning,            395,
           :ErrorException,              400,
           :ResourceLimitError,          400,
           :TypeError,                   405,
           :OptionError,                 410,
           :DelegateError,               415,
           :MissingDelegateError,        420,
           :CorruptImageError,           425,
           :FileOpenError,               430,
           :BlobError,                   435,
           :StreamError,                 440,
           :CacheError,                  445,
           :CoderError,                  450,
           :ModuleError,                 455,
           :DrawError,                   460,
           :ImageError,                  465,
           :XServerError,                480,
           :MonitorError,                485,
           :RegistryError,               490,
           :ConfigureError,              495,
           :FatalErrorException,         700,
           :ResourceLimitFatalError,     700,
           :TypeFatalError,              705,
           :OptionFatalError,            710,
           :DelegateFatalError,          715,
           :MissingDelegateFatalError,   720,
           :CorruptImageFatalError,      725,
           :FileOpenFatalError,          730,
           :BlobFatalError,              735,
           :StreamFatalError,            740,
           :CacheFatalError,             745,
           :CoderFatalError,             750,
           :ModuleFatalError,            755,
           :DrawFatalError,              760,
           :ImageFatalError,             765,
           :XServerFatalError,           780,
           :MonitorFatalError,           785,
           :RegistryFatalError,          790,
           :ConfigureFatalError,         795]

  end
end