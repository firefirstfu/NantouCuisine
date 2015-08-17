
#import "MapViewCon.h"
#import <MapKit/MapKit.h>
#import "CommunicatorNewWork.h"
#import "DataSource.h"
#import "LocationManager.h"

@interface MapViewCon ()<MKMapViewDelegate>




@property(nonatomic, strong) DataSource *nantouData;
@property(nonatomic, strong) Restaurant *tmpRestaurant;
@property (weak, nonatomic) IBOutlet UISwitch *choiceMyLove;
@property(nonatomic, strong) LocationManager *locationManager;
@property(nonatomic, strong) CLLocation *MyRestaurantLocation;
@property(nonatomic) BOOL isFirstLocationReceived;

@property (weak, nonatomic) IBOutlet MKMapView *restaurantMapView;

@end

@implementation MapViewCon

- (void)viewDidLoad {
    [super viewDidLoad];
    //SingleTon物件
    _nantouData = [DataSource shared];
    _tmpRestaurant = [[Restaurant alloc] init];
    _tmpRestaurant = _nantouData.allRestaruants[_restaurantNumber];
    
    //位置管理員
    _locationManager = [[LocationManager alloc] init];
    //餐廳經緯度轉CLLocation
    _MyRestaurantLocation = [[CLLocation alloc] initWithLatitude:[_tmpRestaurant.latitude doubleValue]
                                                       longitude:[_tmpRestaurant.longitude doubleValue]];
    
    //計算區域
    [_locationManager LocationZipCodeWithLatitude:_MyRestaurantLocation.coordinate.latitude
                                    withLongitude:_MyRestaurantLocation.coordinate.longitude withCompletion:^(CLPlacemark *placemark) {
                                        //創造大頭針物件
                                        MKPointAnnotation *myPoint = [[MKPointAnnotation alloc] init];
                                        //附加緯經度給-->大頭針座標
                                        myPoint.coordinate = _MyRestaurantLocation.coordinate;
                                        //地區取區域別
                                        myPoint.title = placemark.locality;
                                        //餐廳所在區域別
                                        myPoint.subtitle = _tmpRestaurant.name;
                                        //地圖附加大頭針
                                        [_restaurantMapView addAnnotation:myPoint];
                                    }];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


//MapKit-->Pin客制化---->屬於MapKit
-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //如果是系統的大頭針，則return nil
    if (annotation == _restaurantMapView.userLocation) {
        return nil;
    }
    
    //先到資源回收桶找有沒有不要使用的大頭針-->如果沒有則create一個新的大頭針
    MKPinAnnotationView *customPin = (MKPinAnnotationView*)[_restaurantMapView dequeueReusableAnnotationViewWithIdentifier:@"customPin"];
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
    theImageView.contentMode = UIViewContentModeScaleToFill;
    NSString *urlStr = _tmpRestaurant.imagePath;
    [CommunicatorNewWork fetchImage:urlStr withSetImageView:theImageView
               withPlaceHolderImage:nil withCompletionImage:^(id returnImage) {
                   theImageView.image = returnImage;
                   customPin.leftCalloutAccessoryView = theImageView;
               }];
    
    
    //導航功能加入
    //客制化大頭針-Add Right Callout Accessory View
    //UIButtonTypeDetailDisclosure-->就是旁邊的驚嘆號
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //用程式碼去實現Button的監聽
    //forControlEvents-->參數是事件的種類
    [rightButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    customPin.rightCalloutAccessoryView = rightButton;

    //地圖移動到指定位置-->沒有開啟追蹤時用
    if (_isFirstLocationReceived ==false) {
        //不用加星號，因為本質是c語言的strct。只一個資料儲存的東西(不是物件)
        //把資料讀出來
        //coordinate-->座標
        MKCoordinateRegion region = _restaurantMapView.region;
        region.center = _MyRestaurantLocation.coordinate;
        //控制地圖的縮放-->無段式縮放 -->1度約1公里
        region.span.latitudeDelta = 0.03;
        //控制地圖的縮放-->無段式縮放
        region.span.longitudeDelta = 0.03;
        //跳過去的位置和動畫
        [_restaurantMapView setRegion:region animated:NO];
        _isFirstLocationReceived = YES;
    }
    return customPin;
}

//自動顯示大頭針Annotation
-(void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[views lastObject];
    [_restaurantMapView selectAnnotation:pinView.annotation animated:YES];
}



//導航按鈕-->地址轉經緯度後，開始導航(結合—>轉經緯度+導航)
-(void)buttonPressed{
    //創造第1個MapItem—>導航用的專屬物件(屬於MapKit)-->出發地
//    MKPlacemark *sourcePlace = [[MKPlacemark alloc] initWithCoordinate:_locationManager.location.coordinate addressDictionary:nil];
    //地圖導航用的物件-->出發地
//    MKMapItem *sourceMapItem = [[MKMapItem alloc] initWithPlacemark:sourcePlace];
    
    //創造第2個MapItem—>導航用的專屬物件(屬於MapKit)-->目的地
    CLLocationCoordinate2D targetCoordinate =CLLocationCoordinate2DMake([_tmpRestaurant.latitude doubleValue],
                                                                        [_tmpRestaurant.longitude doubleValue]);
    MKPlacemark *targetPlace = [[MKPlacemark alloc] initWithCoordinate:targetCoordinate addressDictionary:nil];
    //地圖導航用的物件-->目的地
    MKMapItem *targetMapItem = [[MKMapItem alloc] initWithPlacemark:targetPlace];
    targetMapItem.name = _tmpRestaurant.name;
    targetMapItem.phoneNumber = _tmpRestaurant.phoneNumber;
    
    //呼叫Apple Map後，可以帶參數過去
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving};
    //原地和指定地點的導航(單一指定位置)
    [targetMapItem openInMapsWithLaunchOptions:options];
}


@end
