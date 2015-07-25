
#import "MapTBViewCon.h"
#import "DetailMapTBViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapTBViewCon ()<MKMapViewDelegate, CLLocationManagerDelegate>

//宣告地理位置管理員
@property(nonatomic, strong) CLLocationManager *locationManager;
//地理位置用
@property(nonatomic, assign) BOOL isFirstLocationReceived;
 //現在位置
@property(nonatomic, strong) CLLocation *currentLocation;
//地址轉座標編碼時用
@property(nonatomic,strong) CLPlacemark *placeMark;

//tableViewcell
@property(nonatomic, strong) DetailMapTBViewCell *cell;
//tableViewCell高度
@property(nonatomic, assign) CGFloat imageHeight;

@end



@implementation MapTBViewCon

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化地理位置管理員
    _locationManager = [[CLLocationManager alloc] init];
    //設定委託給viewController
    _locationManager.delegate = self;
    //判別是否有支援這個方法-->才用的手法-->因為此方法在ios8以後才支援
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        //此方法在ios8以後才支援
        [_locationManager requestAlwaysAuthorization];
    }
    //開始計算所在位地置的功能
    [_locationManager startUpdatingLocation];
    
    //地址轉換緯經度
    //創造地理位置編碼員
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    NSString *address = @"南投縣埔里鎮仁愛路490號";
    //開始編碼
    [geoCoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error){
        _placeMark = placemarks.lastObject;
        NSLog(@"%f", _placeMark.location.coordinate.latitude);
        NSLog(@"%f", _placeMark.location.coordinate.longitude);
        
        //創造大頭針物件
        MKPointAnnotation *myPoint = [[MKPointAnnotation alloc] init];
        //附加緯經度給-->大頭針座標
        myPoint.coordinate = _placeMark.location.coordinate;
        myPoint.title = @"埔里";
        myPoint.subtitle = @"有田日本料理";
        //地圖附加大頭針
        [_cell.restaurantMapView addAnnotation:myPoint];
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //取得各別的Cell的Identifier
    NSString *identifier = [NSString stringWithFormat:@"cell%ld", indexPath.row];
    //和cell取得關聯
    _cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    //餐廳照片
    _cell.storeImageView.contentMode = UIViewContentModeScaleToFill;
    _cell.storeImageView.image = [UIImage imageNamed:@"7.jpg"];
    //segmented選單增加Method
    [_cell.selectInformationMenu addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    //segmented預設值index設為地圖
    _cell.selectInformationMenu.selectedSegmentIndex = 1;
    return _cell;
}


//segmented的Method
-(void) segmentedAction:(id) sender{
    switch ([sender selectedSegmentIndex]) {
        case 0:
            //StoryBoard跳轉
            [self gotAnother];
            break;
        case 2:
            break;
        default:
            break;
    }
}

//StoryBoard跳轉
-(void)gotAnother{
    //創造要跳轉的viewController物件
    UITableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"detail_1"];
    //跳轉到目地的storyBoard
    [self.navigationController pushViewController:vc animated:NO];
}

//自訂TableViewCell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (_imageHeight <= 10) {
            _imageHeight = _cell.storeImageView.frame.size.height - 1.0;
            return _imageHeight;
        }
    }
    if (indexPath.row == 1) {
        return 35.0f;
    }else{
         return 300.0f;
    }
}


//MapKit-->Pin客制化---->屬於MapKit
-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //如果是系統的大頭針，則return nil
    if (annotation == _cell.restaurantMapView.userLocation) {
        return nil;
    }
    
    //先到資源回收桶找有沒有不要使用的大頭針-->如果沒有則create一個新的大頭針
    MKPinAnnotationView *customPin = (MKPinAnnotationView*)[_cell.restaurantMapView dequeueReusableAnnotationViewWithIdentifier:@"customPin"];
    if (customPin == nil) {
        customPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"customPin"];
    }else{
        customPin.annotation = annotation;
    }
    customPin.canShowCallout = YES;
    customPin.animatesDrop = NO;
    
    //Pin附加Accessory
    UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //圖片栽剪成圓形
    theImageView.layer.cornerRadius = theImageView.frame.size.width/2;
    theImageView.clipsToBounds = YES;
    theImageView.image = [UIImage imageNamed:@"7.jpg"];
    //附加餐廳圖片
    customPin.rightCalloutAccessoryView = theImageView;
    
    //地圖移動到指定位置-->沒有開啟追蹤時用
    if (_isFirstLocationReceived ==false) {
        //不用加星號，因為本質是c語言的strct。只一個資料儲存的東西(不是物件)
        //把資料讀出來
        //coordinate-->座標
        MKCoordinateRegion region = _cell.restaurantMapView.region;
        region.center = _placeMark.location.coordinate;
        //控制地圖的縮放-->無段式縮放
        //1度約1公里
        region.span.latitudeDelta = 0.03;
        //控制地圖的縮放-->無段式縮放
        region.span.longitudeDelta = 0.03;
        //跳過去的位置和動畫
        [_cell.restaurantMapView setRegion:region animated:NO];
        _isFirstLocationReceived = YES;
    }
    return customPin;
}

//自動顯示大頭針Annotation
-(void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[views lastObject];
    [_cell.restaurantMapView selectAnnotation:pinView.annotation animated:YES];
}












/*
 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
