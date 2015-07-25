
#import "LocalCuisineTBViewCon.h"
#import "LocalCuisineTBViewCell.h"
#import "RestaurantCollection.h"
#import "DetailLocalCuisineTBViewCon.h"

//地理位置Library
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

//NetWorking Library
#import "NetWorkingManamger.h"
#import "UIImageView+AFNetworking.h"


@interface LocalCuisineTBViewCon ()<CLLocationManagerDelegate>

//南投縣全部的餐廳
@property(nonatomic, strong) RestaurantCollection *restaurants;
//宣告地理位置管理員
@property(nonatomic, strong) CLLocationManager *locationManager;
//現在經緯度座標
@property(nonatomic, assign) CLLocationCoordinate2D currentLocationCoordinate;

@end

@implementation LocalCuisineTBViewCon

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _restaurants = [[RestaurantCollection alloc] init];
    NSLog(@"%@", _restaurants.infoCollections.description);
    //觀察者模式-->收聽
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completion:)
                                                 name:DATAS_UPDATED_NOTIFICATION object:nil];
    
    
    //初始化地理位置管理員
    _locationManager = [[CLLocationManager alloc] init];
    //設定精確度-->先暫時不用
    //[_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //設定委託給viewController
    _locationManager.delegate = self;
    //判別是否有支援這個方法-->才用的手法-->因為此方法在ios8以後才支援
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        //此方法在ios8以後才支援
        [_locationManager requestAlwaysAuthorization];
    }
    //開始計算所在位地置的功能
    [_locationManager startUpdatingLocation];
    
    
//    //算出來的距離和AppleMap有很大的差距
//    //集集明新書院  23.827478,120.79964080000002
//    //距離測試-->以實際的經緯度測量，仍然是錯誤的，為何?
//    CLLocation *purposeLocation = [[CLLocation alloc] initWithLatitude:21.9918877 longitude:120.74656970000001];
//    CLLocationDistance distance = [_locationManager.location distanceFromLocation:purposeLocation];
//    NSLog(@"%@",[NSString stringWithFormat:@"%0.2f km",(distance/1000)]);
    
}

//觀察者收聽完成
-(void) completion:(NSNotification*)notification{
    [self.tableView reloadData];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_restaurants.infoCollections count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     LocalCuisineTBViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //餐廳區域
    [self returnMapZipcode:cell index:indexPath];
    //餐廳和User的距離
    [self calculateDistance:cell index:indexPath];
    
    //餐廳名稱
    //設定文字的斷點
    cell.restaurantNameLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    //設定文字的粗體和大小
    cell.restaurantNameLbl.font = [UIFont boldSystemFontOfSize:17.0f];
    //設定文字的粗體和大小
    cell.nantouStateLbl.font = [UIFont boldSystemFontOfSize:17.0f];

    cell.restaurantNameLbl.text = [_restaurants.infoCollections[indexPath.row] name];
    
    //餐廳圓形照片
    //圖片栽剪成圓形
    cell.storeImageView.layer.cornerRadius = cell.storeImageView.frame.size.width/2;
    cell.storeImageView.clipsToBounds = YES;
    //需要用其他的非同步的手法-->AFnetworking裡面有一個可以調整非同步的圖片
    //AfNetworking異步加載圖片
    //圖片網址有中文的字串要先編碼為UTF-8的格式
    NSString *urlStr = [[_restaurants.infoCollections[indexPath.row] imagePath]
                        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __weak LocalCuisineTBViewCell *weakCell = cell;
    [cell.storeImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"1.jpg"]
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                            weakCell.storeImageView.image = image;
                                            [weakCell setNeedsLayout];
                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                            cell.storeImageView.image = [UIImage imageNamed:@"1.jpg"];
                                        }];
    return cell;
}


//經緯度轉地址
-(void) returnMapZipcode:(LocalCuisineTBViewCell*)cell index:(NSIndexPath*)index{
    cell.nantouStateLbl.text = @"";
    double latitude = [[_restaurants.infoCollections[index.row] latitude] doubleValue];
    double longitude = [[_restaurants.infoCollections[index.row] longitude] doubleValue];
    CLLocation *locaiton = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    //創造一個地理編碼管理員在負責地址轉經緯度
    CLGeocoder *geoder = [CLGeocoder new];
    //開始把經緯度轉換成地址
    [geoder reverseGeocodeLocation:locaiton completionHandler:^(NSArray *placemarks, NSError *error)
    {
        CLPlacemark *placemark = placemarks[0];
        cell.nantouStateLbl.text = placemark.locality;
    }];
}


//計算user離餐廳距離
-(void) calculateDistance:(LocalCuisineTBViewCell*)cell index:(NSIndexPath*)index{
    //餐廳的經緯度
    double restaurantLongitude = [[_restaurants.infoCollections[index.row] longitude] doubleValue];
    double restaurantLatitude = [[_restaurants.infoCollections[index.row] latitude] doubleValue];
    //餐廳的坐標
    CLLocation *restaurantLocation=[[CLLocation alloc] initWithLatitude:restaurantLatitude longitude:restaurantLongitude];
    
    //user的緯經度
    double userLongitude = _currentLocationCoordinate.longitude;
    double userLatitude = _currentLocationCoordinate.latitude;
    //User的坐標
    CLLocation *userLocation=[[CLLocation alloc] initWithLatitude:userLatitude longitude:userLongitude];
    
    // 計算距離
    CLLocationDistance meters = [userLocation distanceFromLocation:restaurantLocation]/1000;
    
    //防呆機制
    if (meters > 6000) {
        cell.kmLbl.text = @"";
    }else{
        cell.kmLbl.text = [NSString stringWithFormat:@"%.0f公里", meters];
    }
}


//更新user經緯度
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //取user位置的最新一筆Coordinate(座標)
    _currentLocationCoordinate = [locations.lastObject coordinate];

}

#pragma mark - Navigation
//傳值到下一個ViewController
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"detailLocal"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        DetailLocalCuisineTBViewCon *targeView = segue.destinationViewController;
        targeView.restaurant = _restaurants.infoCollections[path.row];
    }
}


//切換Master(只能往回跳)—>Exit出口方法
-(IBAction) backToMaster:(UIStoryboardSegue*)segue{
}

@end
