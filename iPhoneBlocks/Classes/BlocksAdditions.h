#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void (^BasicBlock)(void);

void InBackground(BasicBlock block);
void OnMainThread(BOOL shouldWait, BasicBlock block);
void OnThread(NSThread *thread, BOOL shouldWait, BasicBlock block);
void AfterDelay(NSTimeInterval delay, BasicBlock block);
void WithAutoreleasePool(BasicBlock block);
void Parallelized(int count, void (^block)(int i));

@interface NSLock (BlocksAdditions)

- (void)whileLocked:(BasicBlock)block;

@end

@interface NSNotificationCenter (BlocksAdditions)

- (void)addObserverBlock:(void (^)(NSNotification *note))block forName:(NSString *)name;

@end

@interface NSURLConnection (BlocksAdditions)

+ (void)sendAsynchronousRequest:(NSURLRequest *)request onCompletionDo:(void(^)(NSData *data, NSURLResponse *response, NSError *error))block;

@end