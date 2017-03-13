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
    NSArray *uuids = @[@"156c86fd-9b3e-4909-9f49-765f05392291", @"B7D1027D-6788-416E-994F-EA11075F1765"];
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
