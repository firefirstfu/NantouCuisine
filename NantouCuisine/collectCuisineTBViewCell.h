
#import <UIKit/UIKit.h>

@interface collectCuisineTBViewCell : UITableViewCell

//餐廳照片
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
//餐廳所在區
@property (weak, nonatomic) IBOutlet UILabel *nantouStateLbl;
//餐廳名稱
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLbl;
//餐廳距離公里數
@property (weak, nonatomic) IBOutlet UILabel *kmLbl;



@end
