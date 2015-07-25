#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>

//MapView
@property (weak, nonatomic) IBOutlet MKMapView *nantouCuisineMap;
//地理位置管理員
@property (strong, nonatomic) CLLocationManager *locationManager;


@end

@implementation MapViewController

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
}



//接收新的地理座標(緯度+經度+高度)
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //追蹤user緯/經度位置(無方向)
    _nantouCuisineMap.userTrackingMode = MKUserTrackingModeFollow;
    
    //在地圖上插上大頭針
    //大頭針目標的座標(ex:有田日本料理店)-->取自user位置的最新一筆Coordinate(座標)
    CLLocationCoordinate2D purposeCoordinate = [locations.lastObject coordinate];
    //緯度
    purposeCoordinate.latitude += 0.005;
    //經度
    purposeCoordinate.longitude += 0.005;
    //創造大頭針物件
    MKPointAnnotation *myPoint = [[MKPointAnnotation alloc] init];
    //附加大頭針座標
    myPoint.coordinate = purposeCoordinate;
    myPoint.title = @"埔里";
    myPoint.subtitle = @"有田日本料理";
    //地圖附加大頭針
    [_nantouCuisineMap addAnnotation:myPoint];
}



//MapKit-->Pin客制化
-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if (annotation == _nantouCuisineMap.userLocation) {
        return nil;
    }
    
    //先到資源回收桶找有沒有不要使用的大頭針-->如果沒有則create一個新的大頭針
    MKPinAnnotationView *customPin = (MKPinAnnotationView*)[_nantouCuisineMap dequeueReusableAnnotationViewWithIdentifier:@"customPin"];
    if (customPin == nil) {
        customPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"customPin"];
    }else{
        customPin.annotation = annotation;
    }
    customPin.canShowCallout = YES;
    customPin.animatesDrop = YES;
    
    //Pin附加Accessory
    UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //圖片栽剪成圓形
    theImageView.layer.cornerRadius = theImageView.frame.size.width/2;
    theImageView.clipsToBounds = YES;
    theImageView.image = [UIImage imageNamed:@"7.jpg"];
    //附加餐廳圖片
    customPin.rightCalloutAccessoryView = theImageView;
    return customPin;
}








/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
