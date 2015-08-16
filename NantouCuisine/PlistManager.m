
#import "PlistManager.h"

@interface PlistManager()

@property (nonatomic, strong) NSString *plistForDocumentsPath;

@end

@implementation PlistManager

-(id)init{
    self = [super init];
    if(self){
        //Documents路徑
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)[0];
        //Documents-->要copy過去的plist路徑
        _plistForDocumentsPath = [documentsPath stringByAppendingPathComponent:@"restaurantPlist.plist"];
        //Bundle路徑-->plist檔
        NSString *plistForBundlePath = [[NSBundle mainBundle] pathForResource:@"restaurantPlist" ofType:@"plist"];
        //檔案管理員
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        //檢查目的路徑的Property是否存在。如果不存在複製檔案-->從Bundle過去Documents(因為Bundle無法寫入)
        if (![fileManager fileExistsAtPath:_plistForDocumentsPath]) {
            [fileManager copyItemAtPath:plistForBundlePath toPath:_plistForDocumentsPath error:nil];
        }
        return self;
    }
    return nil;
}



//撈Plist Data
-(NSMutableDictionary*) getDataInPlist{
    //讀取Plist內的Data(dictionary)
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
    //取出data
    tmpDict = [[NSMutableDictionary alloc] initWithContentsOfFile:_plistForDocumentsPath];
    //如果沒有值，則return nil
    //這裡也要重構，因為店名隨時會倒
    if (tmpDict[@"有田日本料理"] == nil) {
        return nil;
    }else{
        return tmpDict;
    }
}


//寫入Plist Data
-(void) updateDataInPlist:(NSMutableDictionary*)plistDataDict{
    [plistDataDict writeToFile:_plistForDocumentsPath atomically:YES];
}







@end
