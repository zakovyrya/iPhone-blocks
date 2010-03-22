#import <Foundation/Foundation.h>

#define $arr(OBJS...) ({id objs[]={OBJS}; \
    [NSArray arrayWithObjects:objs count:sizeof(objs)/sizeof(id)];})
#define $marr(OBJS...) ({id objs[]={OBJS}; \
    [NSMutableArray arrayWithObjects:objs count:sizeof(objs)/sizeof(id)];})

#define $dict(PAIRS...) ({struct _dictpair pairs[] = {PAIRS}; \
    _dictof(pairs,sizeof(pairs)/sizeof(struct _dictpair));})
#define $mdict(PAIRS...) ({struct _dictpair pairs[] = {PAIRS}; \
    _mdictof(pairs,sizeof(pairs)/sizeof(struct _dictpair));}) 

struct _dictpair { id key; id value; };
NSDictionary* _dictof(const struct _dictpair*, size_t count);
NSMutableDictionary* _mdictof(const struct _dictpair*, size_t count);

@interface NSArray (CollectionsAdditions)

- (void)do:(void(^)(id obj))block;
- (NSArray *)select:(BOOL(^)(id obj))block;
- (NSArray *)map:(id(^)(id obj))block;

@end
