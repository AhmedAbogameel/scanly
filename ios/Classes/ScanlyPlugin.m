#import "ScanlyPlugin.h"
#if __has_include(<scanly/scanly-Swift.h>)
#import <scanly/scanly-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "scanly-Swift.h"
#endif

@implementation ScanlyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftScanlyPlugin registerWithRegistrar:registrar];
}
@end
