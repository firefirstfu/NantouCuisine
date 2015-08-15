
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//使用通知的方式來更新Data
//#define DATAS_UPDATED_NOTIFICATION @"DATAS_UPDATED_NOTIFICATION"

@interface CommunicatorNewWork : NSObject

//撈資料
-(void) fetchDataFromServer: (void(^)(NSError *error, id result))completion;

//fretch UIiimage
+(void) fetchImage:(NSString*)imageStirng
  withSetImageView:(UIImageView*)setImageView
withPlaceHolderImage:(UIImage*)placeHolderImage withCompletionImage:(void(^)(id returnImage))completionImage;

@end






