
#import "MapTBViewCon.h"
#import "DetailMapTBViewCell.h"
#import "DetailLocalCuisineTBViewCon.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <UIImageView+AFNetworking.h>

@interface MapTBViewCon ()<MKMapViewDelegate, CLLocationManagerDelegate>

//宣告地理位置管理員
@property(nonatomic, strong) CLLocationManager *locationManager;
//地理位置用
@property(nonatomic, assign) BOOL isFirstLocationReceived;

//座標轉地址編碼時用
@property(nonatomic, strong) CLLocation *restaurantLocation;

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
    
    

    //創造地理位置編碼員
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    //餐廳經緯度轉CLLocation
    _restaurantLocation = [[CLLocation alloc] initWithLatitude:[_restaurant.latitude doubleValue]
                                                     longitude:[_restaurant.longitude doubleValue]];
    //經緯度轉地址
    [geoCoder reverseGeocodeLocation:_restaurantLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        //創造大頭針物件
        MKPointAnnotation *myPoint = [[MKPointAnnotation alloc] init];
        //附加緯經度給-->大頭針座標
        myPoint.coordinate = _restaurantLocation.coordinate;
        //地區取區域別
        CLPlacemark *placemark = placemarks[0];
        myPoint.title = placemark.locality;
        //餐廳所在區域別
        myPoint.subtitle = _restaurant.name;
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
    //圖片網址有中文的字串要先編碼為UTF-8的格式
    NSString *urlStr = [_restaurant.imagePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __weak DetailMapTBViewCell *weakCell = _cell;
    [ _cell.storeImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"1.jpg"]
                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                      _cell.storeImageView.contentMode = UIViewContentModeScaleToFill;
                                      weakCell.storeImageView.image = image;
                                      [weakCell setNeedsLayout];
                                  }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                      _cell.storeImageView.image = [UIImage imageNamed:@"1.jpg"];
                                  }];
    
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
    //沒有segue方式的傳值
    DetailLocalCuisineTBViewCon *viewCtrl2 = [self.storyboard instantiateViewControllerWithIdentifier:@"detail_1"];
    //跳轉到目地的storyBoard
    viewCtrl2.restaurant = _restaurant;
    [self.navigationController pushViewController:viewCtrl2 animated:NO];
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
    
    //餐廳照片
    _cell.storeImageView.contentMode = UIViewContentModeScaleToFill;
    //圖片網址有中文的字串要先編碼為UTF-8的格式
    NSString *urlStr = [_restaurant.imagePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [theImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"1.jpg"]
                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                      //大頭針圖片
                                      theImageView.image = image;
                                      //大頭針附加餐廳圖片
                                      customPin.leftCalloutAccessoryView = theImageView;
                                  }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                      theImageView.image = [UIImage imageNamed:@"1.jpg"];
                                  }];
    
    
    //導航功能加入
    //客制化大頭針-Add Right Callout Accessory View
    //UIButtonTypeDetailDisclosure-->就是旁邊的驚嘆號
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //用程式碼去實現Button的監聽
    //forControlEvents-->參數是事件的種類
    //@selector-->把方法的名稱包裝成一個物件
    [rightButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    customPin.rightCalloutAccessoryView = rightButton;

    //地圖移動到指定位置-->沒有開啟追蹤時用
    if (_isFirstLocationReceived ==false) {
        //不用加星號，因為本質是c語言的strct。只一個資料儲存的東西(不是物件)
        //把資料讀出來
        //coordinate-->座標
        MKCoordinateRegion region = _cell.restaurantMapView.region;
        region.center = _restaurantLocation.coordinate;
        //控制地圖的縮放-->無段式縮放 -->1度約1公里
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



//導航按鈕-->地址轉經緯度後，開始導航(結合—>轉經緯度+導航)
-(void)buttonPressed{
    //創造第1個MapItem—>導航用的專屬物件(屬於MapKit)-->出發地
//    MKPlacemark *sourcePlace = [[MKPlacemark alloc] initWithCoordinate:_locationManager.location.coordinate addressDictionary:nil];
    //地圖導航用的物件-->出發地
//    MKMapItem *sourceMapItem = [[MKMapItem alloc] initWithPlacemark:sourcePlace];
    

    //創造第2個MapItem—>導航用的專屬物件(屬於MapKit)-->目的地
    CLLocationCoordinate2D targetCoordinate =CLLocationCoordinate2DMake([_restaurant.latitude doubleValue],
                                                                        [_restaurant.longitude doubleValue]);
    MKPlacemark *targetPlace = [[MKPlacemark alloc] initWithCoordinate:targetCoordinate addressDictionary:nil];
    //地圖導航用的物件-->目的地
    MKMapItem *targetMapItem = [[MKMapItem alloc] initWithPlacemark:targetPlace];
    targetMapItem.name = _restaurant.name;
    targetMapItem.phoneNumber = _restaurant.phoneNumber;
    
    //呼叫Apple Map後，可以帶參數過去
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving};
    //原地和指定地點的導航(單一指定位置)
    [targetMapItem openInMapsWithLaunchOptions:options];
    
    //現在位置導航到目的地
//    [MKMapItem openMapsWithItems:@[sourceMapItem, targetMapItem] launchOptions:options];

}

@end
