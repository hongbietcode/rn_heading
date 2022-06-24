#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTEventDispatcher.h>
#import <Corelocation/CoreLocation.h>

@interface CompassHeadingModule : RCTEventEmitter <RCTBridgeModule, CLLocationManagerDelegate>

@end
