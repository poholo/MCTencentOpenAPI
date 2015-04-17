//
//  weiyunFileIdListViewController.h
//  sdkDemo
//
//  Created by xiaolongzhang on 13-7-2.
//  Copyright (c) 2013年 xiaolongzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum WeiyunListType
{
    kWeiyunListPic,
    kWeiyunListVideo,
    kWeiyunListAudio,
    kWeiyunListRecord,
}WeiyunListType;

typedef enum WeiyunOperationType
{
    kWeiyunDownload,
    kWeiyunDelete,
    kWeiyunDownloadThumb,
    kWeiyunGetRecord,
    kWeiyunDelRecord,
}WeiyunOperationType;

@class weiyunFileIdListViewController;

@protocol weiyunFileIdListDelegate <NSObject>

@required

- (void)weiyunFileIdSelectedFileId:(weiyunFileIdListViewController *)viewController fileInfo:(NSDictionary *)fileInfo;

@end

@interface weiyunFileIdListViewController : UITableViewController

@property (nonatomic, retain)NSArray *arrFileInfo;
@property (nonatomic, assign)WeiyunListType contentType;
@property (nonatomic, assign)WeiyunOperationType operateType;
@property (nonatomic, assign)id<weiyunFileIdListDelegate> delegate;

@end
