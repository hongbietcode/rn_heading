#import "CompassHeading.h"

#define kHeadingUpdated @"HeadingUpdated"

@implementation CompassHeadingModule {
  CLLocationManager *locationManager;
  BOOL isObserving;
}

RCT_EXPORT_MODULE();

+ (BOOL)requiresMainQueueSetup {
    return NO;
}

- (instancetype)init {
    if (self = [super init]) {
        isObserving = NO;
        
        if ([CLLocationManager headingAvailable]) {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
        }
        else {
            locationManager = nil;
        }
    }

    return self;
}

#pragma mark - RCTEventEmitter

- (NSArray<NSString *> *)supportedEvents {
  return @[kHeadingUpdated];;
}

- (void)startObserving {
    isObserving = YES;
}

- (void)stopObserving {
    isObserving = NO;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 0) {
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSInteger heading = newHeading.trueHeading;
        

        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
          
        if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
            heading = (heading + 270) % 360;
        }
        else if(interfaceOrientation == UIInterfaceOrientationLandscapeRight){
            heading = (heading + 90) % 360;
        }
        else if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
            heading = (heading + 180) % 360;
        }
        
        if(isObserving){
            [self sendEventWithName:kHeadingUpdated body:@{
                @"heading": @(heading),
                @"accuracy": @(newHeading.headingAccuracy)
            }];
        }
    });
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    CLLocationDirection accuracy = [[manager heading] headingAccuracy];
    return accuracy <= 0.0f || (accuracy > locationManager.headingFilter);
}

RCT_EXPORT_METHOD(start: (NSInteger) headingFilter resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    @try{
        locationManager.headingFilter = headingFilter;
        [locationManager startUpdatingHeading];
        resolve(@(YES));
    }
    @catch (NSException *exception) {
        reject(@"failed_start", exception.name, nil);
    }
}

RCT_EXPORT_METHOD(stop) {
    [locationManager stopUpdatingHeading];
}

RCT_EXPORT_METHOD(hasCompass:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    BOOL result = locationManager != nil ? YES : NO;
    resolve(@(result));
}

@end
