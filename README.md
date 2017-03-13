Reproduction project of Meteor CLLocationManager Beacon Ranging issue.

Meteor Version: 1.4.3.1

## CoreLocationPlugin
This Cordova plugin is a minimal plugin to replicate beacon ranging functionality. It consists of an iBeaconManager class which ranges for beacons using the CLLocationManager  matching UUID "b7d1027d-6788-416e-994f-ea11075f1765". These UUIDs can be modified to range additional beacons in _NSArray *uuids_ under the _self_start_ method.

This class is initialised from the AppDelegate's _didFinishLaunchingWithOptions_ method, starting the beacon ranging.

## Reproduction Steps
A physical device is required to reproduce this issue along with a device which can emit the iBeacon signal (an iPhone, a newer Android device or a bluetooth beacon).

1. On the beacon device, setup the beacon signal and start broadcasting as described below.
2. Clone the repository and run for ios `meteor run ios-device`.
3. Connect the other device to the development machine (ensuring Bluetooth is enabled).
4. Start the application on the device through XCode (you may need to select a Team for code signing).
5. App hangs on splash screen.

### Beacon device setup
For iOS, use the app [BeaconBits](https://itunes.apple.com/de/app/beacon-bits/id908415047?l=en&mt=8):

* Install the app
* Ensure Bluetooth is switched on
* Launch the app and select "BROADCAST"
* Click the settings icon in the top right and ensure the UUID matches the ones being ranged in the plugin. (Default: "b7d1027d-6788-416e-994f-ea11075f1765")
* Click Save and leave on to ensure signal is emitted

For Android, use the app [Locate Beacon](https://play.google.com/store/apps/details?id=com.radiusnetworks.locate&hl=en):

* Install the app
* Ensure Bluetooth is switched on
* Launch the app and select "Beacon Transmitter"
* Set ID1 to match the UUIDs being ranged in the plugin. (Default: "b7d1027d-6788-416e-994f-ea11075f1765")
* Turn on the beacon transmitter
