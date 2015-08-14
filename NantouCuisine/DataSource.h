
#import <Foundation/Foundation.h>


@interface DataSource : NSObject

//SingleTon初始化
+(instancetype)shared;

-(void)getNantouOpendata;

@property(nonatomic, strong) NSMutableArray *allRestaruants;

@end
