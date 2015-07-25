#import "NetWorkingManamger.h"
#import <AFNetworking.h>
#import <XMLReader.h>
#import "Restaurant.h"

@interface NetWorkingManamger()

@end


@implementation NetWorkingManamger

//初始化建構子
-(id) init{
    self = [super init];
    if (self) {
        //get array from openData
        [self getRestaurantDataFromXmlToDic];
        return self;
    }
    return nil;
}


//使用Afnetworking取得南投縣政府open data
-(void) getRestaurantDataFromXmlToDic{
    NSString *urlStrnig = @"http://data.nantou.gov.tw/dataset/e24c90f1-5677-482e-a507-454a50f46951/resource/604b568c-b07c-4e89-9c87-b9d7329f36c8/download/foodc.xml";
    //    創造網路管理員
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //由於寫server的人的沒有寫好，所以加上這段(如果是Json的話，用另外的字串(如果出現的話，X-Code的Debug視窗會提醒)
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    //加上以下這2行就可以處理xml的問題(如果不是Xml是Json的話就不用加了)
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //start get json from target website
    [manager GET:urlStrnig parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSError *parseError = nil;
        NSDictionary *tempDictionary = [XMLReader dictionaryForXMLData:responseObject error:&parseError];
        //南投縣政府OpenData to Json
        self.nantouOpenDataArray = tempDictionary[@"XML_Head"][@"Infos"][@"Info"];
        NSLog(@"成功");
        
        //使用通知中心的方式來更新Data(ios的觀察者模式)
        //postNotificationName是發送者(通知者)的名字
        //object-->要傳輸的物件(可以是任何的資料結構)
        [[NSNotificationCenter defaultCenter] postNotificationName:DATAS_UPDATED_NOTIFICATION object:self.nantouOpenDataArray];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
        NSLog(@"失敗");
    }];
    
}

//getter
-(NSMutableArray*) nantouOpenDataArray{
    if (!_nantouOpenDataArray) {
        _nantouOpenDataArray = [[NSMutableArray alloc] init];
    }
    return _nantouOpenDataArray;
}




@end
