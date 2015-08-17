
#import <Foundation/Foundation.h>


@interface DataSource : NSObject

//SingleTon初始化
+(instancetype)shared;

-(void)getNantouRestaurants:(void(^)(BOOL completion))completion;
-(void) getALllMyLoveRestaurants:(void(^)(BOOL completion))completion;
-(void) saveMyLoveToPlsit:(NSString*)restaurantName choiceOfBool:(BOOL)choiceOfBool;

@property(nonatomic, strong) NSMutableArray *allRestaruants;
@property(nonatomic, strong) NSMutableArray *myLoveAllRestaurants;

@end