#import "CoreLocationPlugin.h"
#import "iBeaconManager.h"

@interface CoreLocationPlugin(){

}

@end

@interface CoreLocationPlugin ()

@end

@implementation CoreLocationPlugin

- (void)pluginInitialize {
    [super pluginInitialize];
}

- (void)initial:(CDVInvokedUrlCommand *)command {
//    static BOOL once = false;
    NSString *callbackId = command.callbackId;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)startAllManager:(CDVInvokedUrlCommand *)command {
    NSString *callbackId = command.callbackId;
    [self startAllManager];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)startAllManager{
    [[iBeaconManager shared] start];
}

@end
