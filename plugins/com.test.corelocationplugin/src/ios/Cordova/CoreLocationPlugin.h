#import "Cordova/CDVPlugin.h"

@interface CoreLocationPlugin : CDVPlugin
- (void)initial:(CDVInvokedUrlCommand *)command;
- (void)startAllManager:(CDVInvokedUrlCommand *)command;
@end
