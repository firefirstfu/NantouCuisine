
#import "LocalCuisineTBViewCon.h"
#import "LocalCuisineTBViewCell.h"
#import "DetailLocalCuisineTBViewCon.h"

//地理位置Library
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "DataSource.h"
#import "MBProgressHUD.h"
#import "CommunicatorNewWork.h"
#import "RestaurantCollection.h"


@interface LocalCuisineTBViewCon ()<CLLocationManagerDelegate>

//宣告地理位置管理員
@property(nonatomic, strong) CLLocationManager *locationManager;
//現在經緯度座標
@property(nonatomic, assign) CLLocationCoordinate2D currentLocationCoordinate;
@property(nonatomic, strong) DataSource *nantouData;

@end

@implementation LocalCuisineTBViewCon

- (void)viewDidLoad {
    [super viewDidLoad];
    _nantouData = [DataSource shared];
    //開始轉
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_nantouData getNantouRestaurants:^(BOOL completion) {
        if (completion) {
            [self.tableView reloadData];
            //停止轉
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];

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
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_nantouData.allRestaruants count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     LocalCuisineTBViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //餐廳區域
    [self returnMapZipcode:cell index:indexPath];
    //餐廳和User的距離
    [self calculateDistance:cell index:indexPath];
    
    //設定文字的斷點
    cell.restaurantNameLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    //設定文字的粗體和大小
    cell.restaurantNameLbl.font = [UIFont boldSystemFontOfSize:17.0f];
    //設定文字的粗體和大小
    cell.nantouStateLbl.font = [UIFont boldSystemFontOfSize:17.0f];
    //餐廳名稱
    cell.restaurantNameLbl.text = [_nantouData.allRestaruants[indexPath.row] name];
    
    //圖片栽剪成圓形
    cell.storeImageView.layer.cornerRadius = cell.storeImageView.frame.size.width/2;
    cell.storeImageView.clipsToBounds = YES;
    
    //非同步遠端下載image
    NSString *urlStr = [_nantouData.allRestaruants[indexPath.row] imagePath];
    [CommunicatorNewWork fetchImage:urlStr withSetImageView:cell.storeImageView
               withPlaceHolderImage:nil withCompletionImage:^(id returnImage) {
                   cell.storeImageView.image = returnImage;
               }];

    return cell;
}


//經緯度轉地址
-(void) returnMapZipcode:(LocalCuisineTBViewCell*)cell index:(NSIndexPath*)index{
    cell.nantouStateLbl.text = @"";
    double latitude = [[_nantouData.allRestaruants[index.row] latitude] doubleValue];
    double longitude = [[_nantouData.allRestaruants[index.row] longitude] doubleValue];
    CLLocation *locaiton = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    //創造一個地理編碼管理員在負責地址轉經緯度
    CLGeocoder *geoder = [CLGeocoder new];
    //開始把經緯度轉換成地址
    [geoder reverseGeocodeLocation:locaiton completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *placemark = placemarks[0];
        cell.nantouStateLbl.text = placemark.locality;
    }];
}


//計算user離餐廳距離
-(void) calculateDistance:(LocalCuisineTBViewCell*)cell index:(NSIndexPath*)index{
    //餐廳的經緯度
    double restaurantLongitude = [[_nantouData.allRestaruants[index.row] longitude] doubleValue];
    double restaurantLatitude = [[_nantouData.allRestaruants[index.row] latitude] doubleValue];
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
        //選擇的row
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        DetailLocalCuisineTBViewCon *targeView = segue.destinationViewController;
        targeView.restaurantNumber = path.row;
    }
}


//切換Master(只能往回跳)—>Exit出口方法
-(IBAction) backToMaster:(UIStoryboardSegue*)segue{
}

//更新資料
- (IBAction)refresh:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_nantouData getNantouRestaurants:^(BOOL completion) {
        if (completion) {
            [self.tableView reloadData];
            //停止轉
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

@end
