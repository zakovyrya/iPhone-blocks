#import "AlertViewAdditions.h"

@interface UIAlertViewAdditionsDelegate : NSObject<UIAlertViewDelegate> {
    void(^onTapBlock)(NSInteger buttonIndex);
}

- (id)initWithOnTapBlock:(void(^)(NSInteger buttonIndex))onTapBlock;

@end


@implementation UIAlertViewAdditionsDelegate

- (id)initWithOnTapBlock:(void(^)(NSInteger buttonIndex))initOnTapBlock {
    if (self = [super init]) {
        onTapBlock = [initOnTapBlock retain];
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    onTapBlock(buttonIndex);
    alertView.delegate = nil;
    [self release];
}

- (void)dealloc {
    [onTapBlock release];
    [super dealloc];
}

@end


@implementation UIAlertView(BlockAdditions)

- (void)showOnTapDo:(void(^)(NSInteger buttonIndex))onTapBlock {
    self.delegate = [[UIAlertViewAdditionsDelegate alloc] initWithOnTapBlock:onTapBlock];
    [self show];
}

@end

