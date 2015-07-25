
#import "RestaurantCollection.h"
#import "Restaurant.h"
#import "NetWorkingManamger.h"


@interface RestaurantCollection()

//Afnetworking->Get XML
@property(nonatomic,strong) NetWorkingManamger *netManager;
//openData暫存匣
@property(nonatomic, strong) NSMutableArray *nantouOpenDataArray;

@end



@implementation RestaurantCollection
//初始化建構子
-(id) init{
    self = [super init];
    if (self) {
        //NetWorking管理員
        _netManager = [[NetWorkingManamger alloc] init];
        //觀察者模式-->收聽
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completion:) name:DATAS_UPDATED_NOTIFICATION object:nil];
        return self;
    }
    return nil;
}

//觀察者模式Method-->收聽完成
-(void) completion:(NSNotification*)notification{
    
    self.nantouOpenDataArray = (NSMutableArray*)notification.object;
    //parse xml to dictionary
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
        [self addRestaurant:res];
    }
}



//getter->infoCollections惰性初始化
-(NSMutableArray*) nantouOpenDataArray{
    if (!_nantouOpenDataArray) {
        _nantouOpenDataArray = [[NSMutableArray alloc] init];
    }
    return _nantouOpenDataArray;
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




















//-(id)init{
//    self = [super init];
//    if(self){
//        //創造資料庫物件
//        WordDataDataBase *dataBaseObject = [WordDataDataBase new];
//        //取得plist路徑
//        dataBaseObject.plistPath =  [NSString stringWithFormat:@"%@/Documents/Property List.plist", NSHomeDirectory()];
//        NSMutableDictionary *dataDict = [dataBaseObject getDataInPlist];
//        
//        NSArray *englishWordArray = [dataDict allKeys];
//        NSArray *chineseWordArray = [dataDict allValues];
//        

//        //抽取Plist全部的單字卡
//        for (NSInteger count = 0; count < [englishWordArray count]; count++) {
//            WordCard *wordCard = [[WordCard alloc] init];
//            wordCard.englishWord = englishWordArray[count];
//            wordCard.chineseWord = chineseWordArray[count];
//            wordCard.random4ChineseWord = [WordCardDeck createRandom4ChineseWord:chineseWordArray
//                                                                    withWordCard:wordCard];
//            [self addCard:wordCard];
//        }
//        return self;
//    }
//    return  nil;
//}






