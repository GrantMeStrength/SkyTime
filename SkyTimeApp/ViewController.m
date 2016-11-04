//
//  ViewController.m
//  SkyTimeApp
//



#import "ViewController.h"


@implementation ViewController



BOOL firstTime = TRUE;
BOOL locationValid = FALSE;
BOOL locationObjectExists = FALSE;
NSTimer *tickTock = nil;
CLLocationManager *locationManagerObject;
double lat = 50, lon = 0;

#define TIMEDELAY 1


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // 24 hour?
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSRange range = [[formatter dateFormat] rangeOfString:@"a"];
    BOOL is24HourFormat = range.location == NSNotFound && range.length == 0;
    
    [Universe set24Hour: is24HourFormat];

    [self displayTimes];
    
    // Find the user
    
    [self createLocationManager];
    
    if (![self locationAvailable])
    {
        NSLog(@"Warning - Location setting turned off");
        locationValid = FALSE;
        return;
        
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
    
    
    
    tickTock = [NSTimer scheduledTimerWithTimeInterval:TIMEDELAY target:self selector:@selector(displayTimes) userInfo:nil repeats:YES];
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if (tickTock == nil)
    {
        
        tickTock = [NSTimer scheduledTimerWithTimeInterval:TIMEDELAY target:self selector:@selector(displayTimes) userInfo:nil repeats:YES];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    if (tickTock!=nil)
    {
        [tickTock invalidate];
        tickTock = nil;
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}


-(void) displayTimes
{
    
    [Universe calculateTime];
    
    
    
    int h1 = [Universe getHourD];
    
    int h2;
    
    if (h1>=20) {h2 = h1 - 20; h1 = 2;}
    else
        if (h1>=10) {h2 = h1 - 10; h1 = 1;}
        else {h2 = h1; h1 = 0;}
    
    
    int s2 = [Universe getSecondD] % 10;
    int s1 = ([Universe getSecondD] - s2) / 10;
    
    if (s2 == 0) s2 = 10;
    if (s2 == 1) _Sec2.frame = CGRectMake(32,  -64*(0), 32, 48);
    
    if (s1 == 0) s1 = 10;
    if ([Universe getSecondD] == 10) _Sec1.frame = CGRectMake(0,  -64*(0), 32, 48);
    
    
    int m2 = [Universe getMinuteD] % 10;
    int m1 = ([Universe getMinuteD] - m2) / 10;
    
    
    
    
    [UIView beginAnimations:@"showinfo" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    
    
    
    
    
    _Hour1.frame = CGRectMake(0, 12 -128*(h1), 64, 96);
    _Hour2.frame = CGRectMake(64, 12 -128*(h2), 64, 96);
    
    _Min1.frame = CGRectMake(134, 12 -128*(m1), 64, 96);
    _Min2.frame = CGRectMake(194, 12 -128*(m2), 64, 96);
    
    _Sec1.frame = CGRectMake(0,  -64*(s1), 32, 48);
    _Sec2.frame = CGRectMake(32,  -64*(s2), 32, 48);
    
    
    
    
    
    
    
    _labelAMPM.text = [Universe getAMPM];
    
    _labelDate.text = [Universe getDate];
    
    _labelJulianDate.text = [Universe getJulian];
    _labelModifiedJulianDate.text = [Universe getModifiedJulian];
    
    
    for (UILabel *label in _labelCollectionValidLocation) {
        if (locationValid)
            label.alpha = 1.0;
        else
            label.alpha = 0.5;
    }
    
    
    if (locationValid)
    {
        
        _labelLST.text = [Universe getLST];
        _labelUT.text = [Universe getUT];
        _labelLocation.text = [Universe getLocation];
        _labelGMTDelta.text = [Universe getGMTDelta];
        
        
    }
    
    
    {
        
        [UIView commitAnimations];
        firstTime = FALSE;
    }
    
    
    
}




- (IBAction)tapInfo:(id)sender {
    
    
    InfoViewController *info = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
    info.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [info selectMessage:(int)[sender tag]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        
        info.modalPresentationStyle = UIModalPresentationFormSheet;
        
    }
    
    [self presentViewController:info animated:YES completion:nil];
    
    
    
}





- (void)locationManager:(CLLocationManager *)manager  didFailWithError:(NSError *)error
{
    
    [self stopUpdatingLocation];
    
    NSLog(@"Unable to get location");
    
    locationValid = FALSE;
    _labelLocationGeo.text = @"Unknown";
    
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
                     
                     _labelLocationGeo.text = [NSString stringWithFormat:@"%@ in %@",[topResult locality], [topResult country]];
                     
                     
                 }
                 else
                 {
                     _labelLocationGeo.text = @"";
                     
                     
                     
                 }
                 
             }];
            
            
        }
    }
}





@end
