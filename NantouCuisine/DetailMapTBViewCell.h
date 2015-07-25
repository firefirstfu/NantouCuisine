
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface DetailMapTBViewCell : UITableViewCell

//餐廳照片
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
//Segmented選單
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectInformationMenu;
//餐廳地圖
@property (weak, nonatomic) IBOutlet MKMapView *restaurantMapView;

@end
