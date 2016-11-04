//
//  InterfaceController.m
//  SkyTimeAppWatch Extension
//


#import "InterfaceController.h"
#import "Universe.h"

@interface InterfaceController()

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *labelJulian;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *labelJulianModifed;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *labelUniversal;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *labelLST;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *labelUniversalHeader;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *labelLSTHeader;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *labelLocation;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *labelJulianModifiedHeader;


@end


@implementation InterfaceController

NSTimer *tickTock = nil;
bool locationValid = false;
CLLocationManager *locationManagerObject;
double lat = 50, lon = 0;
BOOL locationObjectExists = FALSE;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    
    [Universe calculateTime];
    
    [self displayTimes];
    
    
    tickTock = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(displayTimes) userInfo:nil repeats:YES];
    
    [self createLocationManager];
    
    if (![self locationAvailable])
    {
        locationValid = FALSE;
    }
    else
    {
        
        if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            [locationManagerObject requestLocation];
        }
        else
        {
            [locationManagerObject requestWhenInUseAuthorization];
        }
        
        
        if (![self valid])
            return;
    }
    
    [self startUpdatingLocation];
    
}


-(void) displayTimes
{
    
    [Universe calculateTime];
    
    _labelJulian.text = [Universe getJulian];
    
    if (locationValid)
    {
        _labelLST.hidden = false; _labelLSTHeader.hidden = false;
        _labelLST.text = [Universe getLST];
        _labelUniversal.hidden = false; _labelUniversalHeader.hidden = false;
        _labelUniversal.text = [Universe getUT];
    }
    else
    {
        _labelJulianModifed.text = [Universe getModifiedJulian];
        _labelJulianModifed.hidden = false; _labelJulianModifiedHeader.hidden = false;
        _labelLST.hidden = true;_labelLSTHeader.hidden = true;
        _labelUniversal.hidden = true;_labelUniversalHeader.hidden = true;
        
    }
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    if (tickTock == nil)
    {
        tickTock = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(displayTimes) userInfo:nil repeats:YES];
        
    }
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    
    if (tickTock!=nil)
    {
        [tickTock invalidate];
        tickTock = nil;
    }
    
}

#pragma mark - Location

-(void) createLocationManager
{
    
    if (locationObjectExists)
    {
        return;
    }
    
    locationObjectExists = TRUE;
    
    locationManagerObject = [[CLLocationManager alloc] init] ;
    locationManagerObject.delegate = self;
    locationManagerObject.distanceFilter = kCLLocationAccuracyThreeKilometers;
    locationManagerObject.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManagerObject startUpdatingLocation];
}

-(BOOL) locationAvailable
{
    return [CLLocationManager locationServicesEnabled];
}


-(void) stopUpdatingLocation
{
    if (!locationObjectExists) return;
    [locationManagerObject stopUpdatingLocation];
}

-(void) startUpdatingLocation
{
    if (!locationObjectExists) return;
    [locationManagerObject startUpdatingLocation];
}


-(BOOL) valid
{
    // Is compass/location object valid?
    
    if (!locationObjectExists) return FALSE;
    
    if (locationManagerObject==nil)
        return FALSE;
    else
        return TRUE;
    
    
}


- (void)locationManager:(CLLocationManager *)manager  didFailWithError:(NSError *)error
{
    [self stopUpdatingLocation];
    locationValid = FALSE;
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self stopUpdatingLocation];
    
    if (manager.location != nil)
    {
        CLLocation *newLocation = [locations lastObject];
        {
            [self stopUpdatingLocation];
            lon =newLocation.coordinate.longitude;
            lat = newLocation.coordinate.latitude;
            locationValid = TRUE;
            
            [Universe setLocation:lat :lon];
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            CLLocation *location = [[CLLocation alloc] initWithLatitude: lat longitude:lon];
            
            [geocoder reverseGeocodeLocation:location completionHandler: ^(NSArray *placemarks, NSError *error)
             {
                 if(placemarks && placemarks.count > 0)
                 {
                     CLPlacemark *topResult = [placemarks objectAtIndex:0];
                     
                     _labelLocation.text = [NSString stringWithFormat:@"%@, %@",[topResult locality], [topResult country]];
                     
                 }
                 else
                 {
                     _labelLocation.text = @"";
                 }
                 
             }];
        }
    }
}

@end






