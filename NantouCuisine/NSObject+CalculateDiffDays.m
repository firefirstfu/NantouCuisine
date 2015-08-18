

#import "NSObject+CalculateDiffDays.h"

@implementation NSObject (CalculateDiffDays)

+(int)calculateDiffDay:(NSString*)focusDateString{
    
    //获得当前时间：
    NSDate *now=[NSDate date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date =[dateFormatter dateFromString:focusDateString];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date  toDate:now  options:0];
    int days = [comps day];
    return days;
}

@end
