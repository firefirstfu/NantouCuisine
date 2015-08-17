#import "NetConnectCheck.h"
#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface NetConnectCheck()

//網路監器物件
@property(nonatomic, strong) Reachability *serverReach;

@end

@implementation NetConnectCheck


-(void) networkConnectCheck:(id)name breakConnect:(void(^)())breakConnect
              revertConnect:(void(^)())revertConnect {
    //實時網路狀態檢查
    //Prepare Reachability
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification object:nil queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      NetworkStatus status = [_serverReach currentReachabilityStatus];
                                                      if (status == NotReachable) {
                                                          breakConnect();
                                                      }else{
                                                          revertConnect();
                                                      }
                                                  }];
    _serverReach = [Reachability reachabilityWithHostName:@"udn.com"];
    [_serverReach startNotifier];
    
}
@end
