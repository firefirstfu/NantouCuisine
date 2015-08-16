
#import <Foundation/Foundation.h>

@interface PlistManager : NSObject


//撈Plist Data
-(NSMutableDictionary*) getDataInPlist;

//寫入Plist Data
-(void) updateDataInPlist:(NSMutableDictionary*)plistDataDict;


@end
