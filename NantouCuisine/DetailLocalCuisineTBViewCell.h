
#import <UIKit/UIKit.h>

@interface DetailLocalCuisineTBViewCell : UITableViewCell

//餐廳照片
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
//餐廳名稱
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLbl;
//餐廳地址
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
//餐廳電話
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLbl;
//餐廳網站
@property (weak, nonatomic) IBOutlet UILabel *webSiteLbl;
//餐廳簡介
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
//Segmented選單
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectInformationMenu;


@end
