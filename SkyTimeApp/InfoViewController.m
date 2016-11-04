//
//  InfoViewController.m
//  skytime
//


#import "InfoViewController.h"

@implementation InfoViewController
@synthesize textDescription;

int message = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)selectMessage: (int) note
{
     message = note;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        textDescription.font =  [UIFont fontWithName:@"Futura" size:22]; 
    
    switch (message) 
    {
        case 1:    
        
        textDescription.text = @"Julian Date\n\nThe Julian Date is commonly used by astronomers as a way of expressing the date and time as a single number, counting the days (and fractions of days) since January 1st, 4713 BC.\n\nUsing a single number makes it simpler to refer with accuracy and without confusion to events in the past and future. Unlike 'regular' time, the Julian Date is the same at a given instant no matter where in the world you might be.";
   
            break;
            
        case 2:
        
         textDescription.text = @"Modified Julian Date\n\nAs the Julian Date can be rather cumbersome, the Smithsonian Astrophysical Observatory introduced the concept of the Modified Julian Date, in 1957. The Modified Julian Date is effectively the Julian Date, but counted from midnight November 17th, 1858.\n\nTo convert from Julian Date to Modified Julian Date, subtract 2400000.5.";
            
            break;
        
        case 3:
        
        textDescription.text = @"Local Sidereal Time\n\nA day in Sidereal Time lasts about 23 hours, 56 minutes, 4.091 seconds - it is the time taken for the Earth to rotate on its axis in relation to the stars, rather than in relation to the Sun.\n\nSidereal  time is therefore used to track the motion of stars: a star will be in the same location in the sky at the same Sidereal Time every day.";
        
        break;
        
        case 4:
        
        textDescription.text = @"Universal Time\n\nUniversal Time is time measured with relation to the Sun's rotation with respect to the Earth. \n\nIt is effectively the same as Greenwich Mean Time. Universal Time is the same all over the Earth, and is not altered by time zones or daylight saving times. That is, when the Universal Time is 09:00 in London, it's also 09:00 in New York.\n\nHowever, as stars appear to move in Sidereal Time, this time is more useful to regular people than to astronomers!";
        
        break;
        
        case 5:
        
        textDescription.text = @"Difference from GMT\n\nThis is a measure as to the difference between the time where you are right now (as detected by your device's location awareness abilities) and the Greenwich Mean Time. This difference will take into account any times zones and daylight savings time.\n\nIt should be the difference between Universal Time and your local time. ";
        
        break;
        
        case 6:
        
        textDescription.text = @"If you are interested in Astronomy, please take a moment to look for Pocket Universe in the App Store. Pocket Universe renders a real-time 3D view of the night sky, allowing you to quickly put a name to every object you can see. It's pretty cool!";
        
        break;

            
            
    }
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

- (IBAction)tapInfoPanel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
