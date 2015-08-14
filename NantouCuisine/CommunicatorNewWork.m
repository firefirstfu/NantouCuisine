#import "CommunicatorNewWork.h"
#import <AFNetworking.h>
#import <XMLReader.h>

@interface CommunicatorNewWork()

@end

@implementation CommunicatorNewWork

//初始化建構子
-(id) init{
    self = [super init];
    if (self) {
        return self;
    }
    return nil;
}


#pragma mark - Public Methods
//從南投縣府伺服器撈Data-->關鍵Method
-(void) downloadDataWithCompletion: (void(^)(NSError *error, id result))completion{
     NSString *urlStrnig = @"http://data.nantou.gov.tw/dataset/e24c90f1-5677-482e-a507-454a50f46951/resource/604b568c-b07c-4e89-9c87-b9d7329f36c8/download/foodc.xml";
    [self doRequestFromNet:urlStrnig parameters:nil success:^(id result){
        completion(nil, result);
    } fail:^(NSError *error) {
        completion(error, nil);
    }];
}


#pragma mark - Private Methods
//專門用來做Get動作的Method//實作Afnetworking真正的下載功能//最底層的呼叫的API
-(void) doRequestFromNet:(NSString*)url parameters:(NSDictionary*)parameters
       success:(void(^)(id result)) successBlock
          fail:(void(^)(NSError *error)) failBlock{
    
    //開始實作Afnetworking框架/Afnetworking自已的SingleTon物件(管理員)
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //由於寫server的人的沒有寫好，所以加上這段(如果是Json的話，用另外的字串(如果出現的話，X-Code的Debug視窗會提醒)
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    
    //加上以下這2行就可以處理xml的問題(如果不是Xml是Json的話就不用加了)
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              successBlock(responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failBlock(error);
          }];
}

@end














