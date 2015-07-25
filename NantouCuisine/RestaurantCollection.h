
#import <Foundation/Foundation.h>
#import "Restaurant.h"


@interface RestaurantCollection : NSObject

//餐廳資訊集合
@property(nonatomic, strong) NSMutableArray *infoCollections;

//加入餐廳
-(void) addRestaurant:(Restaurant*)restaurant;


@end


