
#import <Foundation/Foundation.h>

//使用通知的方式來更新Data
#define DATAS_UPDATED_NOTIFICATION @"DATAS_UPDATED_NOTIFICATION"


@interface NetWorkingManamger : NSObject

//南投縣OpenData to dictionary
@property (nonatomic, strong) NSMutableArray *nantouOpenDataArray;


@end






