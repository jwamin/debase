//
//  ImageViewWithDragging.m
//  Debase
//
//  Created by Joss Manger on 5/3/20.
//  Copyright © 2020 Joss Manger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageViewWithDragging.h"

@implementation ImageViewWithDragging

#pragma mark - Private instance variables
NSOperationQueue *queue;
NSFilePromiseProvider *provider;
NSDictionary *dataDict;

-(NSOperationQueue*)queue {
  return queue;
}

#pragma mark - Lifecycle

- (void)awakeFromNib{
  
  //Create dragging serial queue
  queue = [[NSOperationQueue alloc] init];
  [queue setName:@"com.jossy.debase.background queue"];
  [queue setQualityOfService:NSQualityOfServiceDefault];
  
  //set provider and delegate
  provider = [[NSFilePromiseProvider alloc] initWithFileType:(NSString*)kUTTypeJPEG delegate:self];
  [provider setDelegate:self];
  
}

#pragma mark - Custom Methods

- (void)setProviderData:(NSDictionary *)dict {
  dataDict = dict;
  [provider setUserInfo:[dict objectForKey:@"imgData"]];
}

#pragma mark - File Promise Provider

- (NSOperationQueue *)operationQueueForFilePromiseProvider:(NSFilePromiseProvider *)filePromiseProvider{
  return [self queue];
}

- (NSString *)filePromiseProvider:(NSFilePromiseProvider *)filePromiseProvider fileNameForType:(NSString *)fileType{
  NSString *str = [dataDict objectForKey:@"imgName"];
  return [str stringByAppendingString:@".jpg"];
}

- (void)filePromiseProvider:(NSFilePromiseProvider *)filePromiseProvider writePromiseToURL:(NSURL *)url completionHandler:(void (^)(NSError * _Nullable))completionHandler{
  NSData *data = filePromiseProvider.userInfo;
  
  NSImage *image = [[NSImage alloc] initWithData:data];
  
  if (image == nil){
    NSError *error;
    completionHandler(error);
  } else {
    [data writeToURL:url atomically:YES];
    completionHandler(nil);
  }
  
}

#pragma mark - Mouse Events

- (void)mouseDown:(NSEvent *)event{
  
  NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
  
  CGFloat dragThreshold = 3.0;
  
  [[self window] trackEventsMatchingMask: NSEventMaskLeftMouseUp | NSEventMaskLeftMouseDragged timeout:10 mode:NSEventTrackingRunLoopMode handler:^(NSEvent * _Nullable event, BOOL * _Nonnull stop) {
    
    if (event == nil) {
      return;
    }
    
    if ([event type] == NSEventTypeLeftMouseUp){
      *stop = YES;
      NSLog(@"up");
    } else {
      NSLog(@"drag");
      NSPoint movedLocation = [self convertPoint:[event locationInWindow] fromView:nil];
      if (fabs(movedLocation.x - location.x) > dragThreshold || fabs(movedLocation.y - location.y) > dragThreshold) {
        *stop = YES;
        NSDraggingItem *item = [[NSDraggingItem alloc] initWithPasteboardWriter:provider];
        [item setDraggingFrame:CGRectMake(location.x - self.image.size.width/2, location.y-self.image.size.height/2, self.image.size.width, self.image.size.height) contents:self.image];
        [self beginDraggingSessionWithItems:@[item] event:event source:self];
      }
    }
    
  }
   ];
  
}

#pragma mark - NSDragOperation

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context{
  return (context == NSDraggingContextOutsideApplication) ? NSDragOperationCopy : NSDragOperationNone;
}


@end
