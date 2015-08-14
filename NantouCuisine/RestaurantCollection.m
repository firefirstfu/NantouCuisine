#import "RestaurantCollection.h"
#import "Restaurant.h"

@interface RestaurantCollection()

@end

@implementation RestaurantCollection

//初始化
-(id) init{
    self = [super init];
    if (self) {
        return self;
    }
    return nil;
}


//getter->infoCollections惰性初始化
-(NSMutableArray*) infoCollections{
    if (!_infoCollections) {
        _infoCollections = [[NSMutableArray alloc] init];
    }
    return _infoCollections;
}

//增加餐廳名單
-(void) addRestaurant:(Restaurant*)restaurant{
    [self.infoCollections addObject:restaurant];
}

@end






















