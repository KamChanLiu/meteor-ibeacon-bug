#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface iBeaconManager : NSObject<CBPeripheralManagerDelegate, CLLocationManagerDelegate, CBCentralManagerDelegate>

+ (nullable instancetype)shared;
- (void)start;

@end
