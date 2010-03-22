#import <UIKit/UIKit.h>
#import "TaskCell.h"



@interface RootViewController : UITableViewController {
    UIAlertView *alertView;
    NSArray *rows;
    IBOutlet TaskCell *taskCell;
}

@property (nonatomic, retain) TaskCell *taskCell;

@end
