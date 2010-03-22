#import "BlocksAdditions.h"

@interface NSObject (BlockAdditions)

- (void)_callBlock;
- (void)_callBlockWithObject:(id)obj;

@end


@implementation NSObject (BlockAdditions)

- (void)_callBlock {
    void (^block)() = (id)self;
    block();
}

- (void)_callBlockWithObject:(id)obj {
    void (^block)(id obj) = (id)self;
    block(obj);
}

@end


void InBackground(BasicBlock block) {
    [NSThread detachNewThreadSelector:@selector(_callBlock) toTarget:[[block copy] autorelease] withObject:nil];
}
void OnMainThread(BOOL shouldWait, BasicBlock block) {
    [[[block copy] autorelease] performSelectorOnMainThread:@selector(_callBlock) withObject:nil waitUntilDone:shouldWait];
}
void OnThread(NSThread *thread, BOOL shouldWait, BasicBlock block) {
    [[[block copy] autorelease] performSelector:@selector(_callBlock) onThread:thread withObject:nil waitUntilDone:shouldWait];
}
void AfterDelay(NSTimeInterval delay, BasicBlock block) {
    [[[block copy] autorelease] performSelector:@selector(_callBlock) withObject:nil afterDelay:delay];
}
void WithAutoreleasePool(BasicBlock block) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    block();
    [pool release];
}
void Parallelized(int count, void (^block)(int i)) {
    for (int i = 0; i < count; i++) {
        InBackground(^{
            block(i);
        });
    }
}


@implementation NSLock (BlocksAdditions)

- (void)whileLocked:(BasicBlock)block {
    [self lock];
    @try {
        block();
    }
    @finally {
        [self unlock];
    }
}

@end


@implementation NSNotificationCenter (BlocksAdditions)

- (void)addObserverBlock:(void (^)(NSNotification *))block forName:(NSString *)name {
    [self addObserver:[block copy] selector:@selector(_callBlock) name:name object:nil];
}

@end


@implementation NSURLConnection (BlocksAdditions)

+ (void)sendAsynchronousRequest:(NSURLRequest *)request onCompletionDo:(void (^)(NSData *data, NSURLResponse *response, NSError *err))block {
    NSThread *originalThread = [NSThread currentThread];
    InBackground(^{
        WithAutoreleasePool(^{
            NSURLResponse *response = nil;
            NSError *error;
            NSData *data = [self sendSynchronousRequest:request returningResponse:&response error:&error];
            OnThread(originalThread, NO, ^{
                block(data, response, error);
            });
        });
    });
}

@end
