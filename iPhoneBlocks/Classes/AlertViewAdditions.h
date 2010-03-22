#import <UIKit/UIKit.h>


@interface UIAlertView (BlockAdditions)

- (void)showOnTapDo:(void(^)(NSInteger buttonIndex))onTapBlock;

@end
