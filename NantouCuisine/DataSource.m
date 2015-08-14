
#import "DataSource.h"
#import "RestaurantCollection.h"
#import "CommunicatorNewWork.h"
#import "XMLReader.h"

@interface DataSource ()

@property(nonatomic, strong) CommunicatorNewWork *communicator;
@property(nonatomic, strong) NSMutableArray *nantouOpenDataArray;

@end

@implementation DataSource

static DataSource *_MySingleTon = nil;

//初始化Singleton物件
+(instancetype)shared{
    if (_MySingleTon == nil) {
        _MySingleTon = [DataSource new];
    }
    return _MySingleTon;
}

//getter->惰性初始化
-(NSMutableArray*) nantouOpenDataArray{
    if (!_nantouOpenDataArray) {
        _nantouOpenDataArray = [[NSMutableArray alloc] init];
    }
    return _nantouOpenDataArray;
}


//取得南投縣府的open data
-(void)getNantouOpendata{
    _communicator = [[CommunicatorNewWork alloc] init];
    [_communicator downloadDataWithCompletion:^(NSError *error, id result) {
        if (error) {
            NSLog(@"Fail");
        }else{
            NSError *parseError = nil;
            NSDictionary *tempDictionary = [XMLReader dictionaryForXMLData:result error:&parseError];
            self.nantouOpenDataArray = tempDictionary[@"XML_Head"][@"Infos"][@"Info"];
            [self getAllRestaurants];
        }
    }];
}

-(void)getAllRestaurants{
    RestaurantCollection *restaurants = [[RestaurantCollection alloc] init];
    int num = 0;
    for (num =0; num < self.nantouOpenDataArray.count; num++) {
        //餐廳初始化
        Restaurant *res = [[Restaurant alloc] init];
        //import RestaurantInformation to Object
        res.name = [self.nantouOpenDataArray[num] valueForKey:@"Name"];
        res.introduction = [self.nantouOpenDataArray[num] valueForKey:@"Description"];
        res.address = [self.nantouOpenDataArray[num] valueForKey:@"Add"];
        res.states = [self.nantouOpenDataArray[num] valueForKey:@"Zipcode"];
        res.phoneNumber = [self.nantouOpenDataArray[num] valueForKey:@"Tel"];
        res.webSite = [self.nantouOpenDataArray[num] valueForKey:@"Website"];
        res.imagePath = [self.nantouOpenDataArray[num] valueForKey:@"Picture1"];
        //經度
        res.longitude = [self.nantouOpenDataArray[num] valueForKey:@"Px"];
        //緯度
        res.latitude = [self.nantouOpenDataArray[num] valueForKey:@"Py"];
        res.collected = false;
        [restaurants addRestaurant:res];
    }
    _allRestaruants = restaurants.infoCollections;
}
    
@end