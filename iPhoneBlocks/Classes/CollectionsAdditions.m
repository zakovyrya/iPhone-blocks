#import "CollectionsAdditions.h"

NSDictionary* _dictof(const struct _dictpair* pairs, size_t count) {
    id objects[count];
    id keys[count];
    size_t n = 0;
    for (size_t i = 0; i < count; i++, pairs++) {
        if (pairs->value) {
            objects[n] = pairs->value;
            keys[n] = pairs->key;
            n++;
        }
    }
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys count:n];
}


NSMutableDictionary* _mdictof(const struct _dictpair* pairs, size_t count) {
    id objects[count];
    id keys[count];
    size_t n = 0;
    for (size_t i = 0; i < count; i++, pairs++) {
        if (pairs->value) {
            objects[n] = pairs->value;
            keys[n] = pairs->key;
            n++;
        }
    }
    return [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys count:n];
}


@implementation NSArray (CollectionsAdditions)

- (void)do:(void(^)(id obj))block {
    for (id obj in self) {
        block(obj);
    }
}
- (NSArray *)select:(BOOL(^)(id obj))block {
    NSMutableArray *arr = [NSMutableArray array];
    [self do:[[^(id obj) {
        if (block(obj)) {
            [arr addObject:obj];
        }
    } copy] autorelease]];

    return arr;
}
- (NSArray *)map:(id(^)(id obj))block {
    NSMutableArray *arr = [NSMutableArray array];
    [self do:[[^(id obj) {
        [arr addObject:block(obj)];
    } copy] autorelease]];
    return arr;
}


@end
