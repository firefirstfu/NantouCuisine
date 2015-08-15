
#import <UIKit/UIKit.h>

@interface MyImageViewWithInternet : UIImageView

//對外可以讓其他的類別呼叫
-(void) loadImageWithURL:(NSURL*)url;

@end
