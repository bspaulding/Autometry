#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RefuelStore, NSObject)

RCT_EXTERN_METHOD(getAll:(RCTResponseSenderBlock)fn)
RCT_EXTERN_METHOD(listen:(RCTResponseSenderBlock)fn)

@end