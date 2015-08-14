
#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

//0.餐廳名稱
@property(nonatomic, strong) NSString *name;
//1.餐廳敘述
@property(nonatomic, strong) NSString *introduction;
//2.餐廳地址
@property(nonatomic, strong) NSString *address;
//3.餐廳所在區域
@property(nonatomic, strong) NSString *states;
//4.餐廳電話
@property(nonatomic, strong) NSString *phoneNumber;
//5.餐廳網址
@property(nonatomic, strong) NSString *webSite;
//6.餐廳圖片位址
@property(nonatomic, strong) NSString *imagePath;
//7.餐廳距離公里數
@property(nonatomic, strong) NSString *km;
//8.餐廳是否加入我的收藏-->預設是NO
@property(nonatomic, assign) BOOL *collected;
//9.緯度
@property(nonatomic, strong) NSString *latitude;
//10.緯度
@property(nonatomic, strong) NSString *longitude;
@end



