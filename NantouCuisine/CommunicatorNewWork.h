
#import <Foundation/Foundation.h>


//使用通知的方式來更新Data
//#define DATAS_UPDATED_NOTIFICATION @"DATAS_UPDATED_NOTIFICATION"

@interface CommunicatorNewWork : NSObject

//撈資料
-(void) fetchDataFromServer: (void(^)(NSError *error, id result))completion;

@end






