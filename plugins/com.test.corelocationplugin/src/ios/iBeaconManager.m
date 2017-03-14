#import "iBeaconManager.h"


@interface iBeaconManager(){
    CLLocationManager *locationManager;
    BOOL managerStarted;
    CBCentralManager *centralManager;

    int nextPValue;
    NSString* lastRecKey;
}
@property (nonatomic, strong) NSMutableArray* beaconRegions;


@end

@implementation iBeaconManager

+ (instancetype)shared
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (id)init {
    if (self = [super init]) {
        managerStarted = NO;
        _beaconRegions = [[NSMutableArray alloc] init];
        nextPValue = -1;
    }
    return self;
}

- (void)start {
    if (!centralManager) {
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:[NSNumber numberWithBool:YES]}];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [locationManager requestAlwaysAuthorization];
        }
        [self self_start];
    }
}

- (void)stop {
    if (locationManager) {
        [self self_stop];
        locationManager.delegate = nil;
        locationManager = nil;
    }
}

- (void)self_stop {
    if (managerStarted) {
        managerStarted = NO;
        for (CLBeaconRegion* region in self.beaconRegions) {
            [self stopMonitoringForRegion:region];
            [self stopRangingBeaconsInRegion:region];
        }
        [self.beaconRegions removeAllObjects];
    }
}

- (void)self_start {
    NSArray *uuids = @[@"b7d1027d-6788-416e-994f-ea11075f1765", @"6a4ddc43-3ec8-42ea-a2df-a1cbb5cdea45", @"5ae7fccf-89c3-4be5-9828-f586b6f3c2c1", @"b3094c9c-0cfa-48f5-bad0-04b175582b66",
                       @"f5a5e2f6-db5f-4ccd-b83b-cfff64d32a8f", @"6f4cdedb-9b61-42fe-9991-ea9b3cb0c7cc", @"3f49618f-268b-46f8-b44b-20f36ee3aa90", @"cd02e378-1957-402a-9a9f-daeccb002aa4",
                       @"e18e79a6-8cd7-44a0-b2d1-18be95c326c9", @"8ac60db6-7d39-436d-967a-ffee43c69b5c", @"19bca05d-cba6-497d-8c6a-1367feb40a57", @"dbe11f9d-b685-4299-bbb8-5a6608d96367"];
    if (!managerStarted) {
        for (NSString *uuidString in uuids) {
            CLBeaconRegion* region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuidString] identifier:uuidString];
            [region setNotifyEntryStateOnDisplay:YES];
            [self startMonitoringForRegion:region];
            [self startRangingBeaconsInRegion:region];
            [self.beaconRegions addObject:region];

        }

        managerStarted = YES;
    }
}

- (void)startMonitoringForRegion:(CLRegion *)region {
    [locationManager startMonitoringForRegion:region];
}

- (void)stopMonitoringForRegion:(CLRegion *)region {
    [locationManager stopMonitoringForRegion:region];
}

- (void)startRangingBeaconsInRegion:(CLBeaconRegion *)region {
    [locationManager startRangingBeaconsInRegion:region];
}

- (void)stopRangingBeaconsInRegion:(CLBeaconRegion *)region {
    [locationManager stopRangingBeaconsInRegion:region];
}

- (void)centralManagerDidUpdateState:(CBCentralManager*)central
{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            //            ERROR(PMPProximityManagerErrorType_BeaconOtherError);
            break;
        case CBCentralManagerStateUnsupported:
            //            ERROR(PMPProximityManagerErrorType_BLENotSupported);
            break;
        case CBCentralManagerStateUnauthorized:
            //            ERROR(PMPProximityManagerErrorType_BluetoothNotAllowed);
            break;
        case CBCentralManagerStateResetting:
            //            ERROR(PMPProximityManagerErrorType_BeaconOtherError);
            break;
        case CBCentralManagerStatePoweredOff:
            //            ERROR(kBluetoothNotEnabled);
            //            [self onProximityBluetoothOnOff:NO];
            [self self_stop];
            break;
        case CBCentralManagerStatePoweredOn:
            [self self_start];
            //            [self onProximityBluetoothOnOff:YES];
            break;
        default:
            break;
    }
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager*)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        // Bluetooth is on

        // Update our status label
        //        self.statusLabel.text = @"Broadcasting...";

        // Start broadcasting
        //        [self.peripheralManager startAdvertising:self.myBeaconData];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        // Update our status label
        //        self.statusLabel.text = @"Stopped";

        // Bluetooth isn't on. Stop broadcasting
        //        [self.peripheralManager stopAdvertising];
    }
    else if (peripheral.state == CBPeripheralManagerStateUnsupported)
    {
        //        self.statusLabel.text = @"Unsupported";
    }
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    NSLog(@"(void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region");
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    NSLog(@"(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region");
}

-(void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region
{
    // Beacon found!
    //    self.statusLabel.text = @"Beacon found!";

    NSLog(@"locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region");
}

@end
