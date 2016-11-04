//
//  ViewController.h
//  SkyTimeApp
//


#import <UIKit/UIKit.h>
#import "Universe.h"
#import <CoreLocation/CoreLocation.h>
#import "InfoViewController.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *Hour1;
@property (weak, nonatomic) IBOutlet UIImageView *Min1;
@property (weak, nonatomic) IBOutlet UIImageView *Min2;
@property (weak, nonatomic) IBOutlet UIImageView *Hour2;
@property (weak, nonatomic) IBOutlet UIImageView *Sec1;
@property (weak, nonatomic) IBOutlet UIImageView *Sec2;

@property (weak, nonatomic) IBOutlet UILabel *labelGMTDelta;
@property (weak, nonatomic) IBOutlet UILabel *labelAMPM;
@property (weak, nonatomic) IBOutlet UILabel *labelModifiedJulianDate;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelLST;
@property (weak, nonatomic) IBOutlet UILabel *labelJulianDate;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelLocationGeo;
@property (weak, nonatomic) IBOutlet UILabel *labelUT;


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollectionValidLocation;



- (IBAction)tapInfo:(id)sender;

-(void) displayTimes;



@end
