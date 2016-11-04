//
//  InfoViewController.h
//  skytime
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface InfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textDescription;
- (IBAction)tapInfoPanel:(id)sender;
-(void)selectMessage: (int) note;

@end
