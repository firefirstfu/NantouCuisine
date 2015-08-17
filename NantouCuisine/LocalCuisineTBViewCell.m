
#import "LocalCuisineTBViewCell.h"

@implementation LocalCuisineTBViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


//TableViewCell的重用
-(void)prepareForReuse
{
    //在重用之前，先清除之前cell的資料
    _storeImageView.image = nil;
    _nantouStateLbl.text = nil;
    _restaurantNameLbl.text = nil;
    _kmLbl.text = nil;
}
@end
