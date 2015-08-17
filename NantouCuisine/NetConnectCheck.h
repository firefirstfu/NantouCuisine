
#import <Foundation/Foundation.h>

@interface NetConnectCheck : NSObject

-(void) networkConnectCheck:(id)name breakConnect:(void(^)())breakConnect
              revertConnect:(void(^)())revertConnect;
@end
