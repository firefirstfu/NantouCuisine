
#import "DataSource.h"
#import "RestaurantCollection.h"
#import "CommunicatorNewWork.h"
#import "XMLReader.h"
#import "PlistManager.h"

@interface DataSource ()

@property(nonatomic, strong) CommunicatorNewWork *communicator;
@property(nonatomic, strong) NSMutableArray *nantouOpenDataArray;

//Plist用
@property(nonatomic, strong) PlistManager *plistMananger;
@property(nonatomic, strong) NSMutableDictionary *saveDict;

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


//取得open data
-(void)getNantouRestaurants:(void(^)(BOOL completion))completion{
    _communicator = [[CommunicatorNewWork alloc] init];
    [_communicator fetchDataFromServer:^(NSError *error, id result) {
        if (error) {
             //這裡已經做Error的判斷了，所以這裡可以不用理會
            NSLog(@"%@", error.description);
        }else{
            NSError *parseError = nil;
            NSDictionary *tempDictionary = [XMLReader dictionaryForXMLData:result error:&parseError];
            self.nantouOpenDataArray = tempDictionary[@"XML_Head"][@"Infos"][@"Info"];
            [self getAllRestaurants];
            completion(YES);
        }
    }];
}


-(void)getAllRestaurants{
    _plistMananger = [[PlistManager alloc] init];
    _saveDict = [[NSMutableDictionary alloc] init];
    if ([_plistMananger getDataInPlist] == nil) {
        //如果是第一次下載Data-->裡面是空的->則存入Plist
        int num1 = 0;
        for (num1 =0; num1 < self.nantouOpenDataArray.count; num1++){
            NSMutableDictionary *plistTmp = [[NSMutableDictionary alloc] init];
            [plistTmp setObject:[self.nantouOpenDataArray[num1] valueForKey:@"Name"] forKey:@"name"];
            [plistTmp setObject:[self.nantouOpenDataArray[num1] valueForKey:@"Description"] forKey:@"introduction"];
            [plistTmp setObject:[self.nantouOpenDataArray[num1] valueForKey:@"Add"] forKey:@"address"];
            [plistTmp setObject:[self.nantouOpenDataArray[num1] valueForKey:@"Zipcode"] forKey:@"states"];
            [plistTmp setObject:[self.nantouOpenDataArray[num1] valueForKey:@"Tel"] forKey:@"phoneNumber"];
            [plistTmp setObject:[self.nantouOpenDataArray[num1] valueForKey:@"Website"] forKey:@"webSite"];
            [plistTmp setObject:[self.nantouOpenDataArray[num1] valueForKey:@"Picture1"] forKey:@"imagePath"];
            //經度
            [plistTmp setObject:[self.nantouOpenDataArray[num1] valueForKey:@"Px"] forKey:@"longitude"];
            //緯度
            [plistTmp setObject:[self.nantouOpenDataArray[num1] valueForKey:@"Py"] forKey:@"latitude"];
            //收藏(我的最愛)-->存布林值
            [plistTmp setValue:[NSNumber numberWithBool:NO] forKey:@"collected"];
            [_saveDict setObject:plistTmp forKey:[self.nantouOpenDataArray[num1] valueForKey:@"Name"]];
            
        }
        [_plistMananger updateDataInPlist:_saveDict];
        [self saveDataToModel];
        
    }else{
        //這裡要加上日期的時間的比較。我的設定是如果不超過20天，就不用更新data。因為政府的open data的更新資料的速度不快。
        //如果>20天的話，才需要從南投政府那邊再重新下載data，不然直接從plist檔撈資料
        //這裡資料的處理部份，還要再重構。邏輯太過繁複不好懂
        [self saveDataToModel];
    }
   
}




-(void) saveDataToModel{
    //存入Model
    RestaurantCollection *restaurants = [[RestaurantCollection alloc] init];
    NSMutableDictionary *returnPlistDict = [_plistMananger getDataInPlist];
    //取得所有的values-->餐廳的陣列
    NSArray *retaruaantsArray = [returnPlistDict allValues];
    int num = 0;
    for (num =0; num < [retaruaantsArray count]; num++) {
        //餐廳初始化
        Restaurant *res = [[Restaurant alloc] init];
        res.name = [[retaruaantsArray objectAtIndex:num] objectForKey:@"name"];
        res.introduction = [[retaruaantsArray objectAtIndex:num] objectForKey:@"introduction"];
        res.address = [[retaruaantsArray objectAtIndex:num] objectForKey:@"address"];;
        res.states = [[retaruaantsArray objectAtIndex:num] objectForKey:@"states"];
        res.phoneNumber = [[retaruaantsArray objectAtIndex:num] objectForKey:@"phoneNumber"];
        res.webSite = [[retaruaantsArray objectAtIndex:num] objectForKey:@"webSite"];
        res.imagePath = [[retaruaantsArray objectAtIndex:num] objectForKey:@"imagePath"];
        //經度
        res.longitude = [[retaruaantsArray objectAtIndex:num] objectForKey:@"longitude"];
        //緯度
        res.latitude = [[retaruaantsArray objectAtIndex:num] objectForKey:@"latitude"];
        res.collected = [[[retaruaantsArray objectAtIndex:num] objectForKey:@"collected"] boolValue];
        [restaurants addRestaurant:res];
    }
    //最後return給前端用的資料-->nsmutablearray
    //singleTon物件
     _allRestaruants = restaurants.infoCollections;
}



-(void) getALllMyLoveRestaurants:(void(^)(BOOL completion))completion{
    _myLoveAllRestaurants = [[NSMutableArray alloc] init];
    for (Restaurant *res in _allRestaruants) {
        if (res.collected == YES) {
            [_myLoveAllRestaurants addObject:res];
        }
    }
    completion(YES);
}





    
@end
