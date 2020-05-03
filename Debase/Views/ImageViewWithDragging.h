//
//  ImageViewWithDragging.h
//  Debase
//
//  Created by Joss Manger on 5/3/20.
//  Copyright © 2020 Joss Manger. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageViewWithDragging : NSImageView <NSFilePromiseProviderDelegate, NSDraggingSource>

-(void) setProviderData:(NSData*)data;

@end

NS_ASSUME_NONNULL_END
