//
//  ViewController.h
//  Debase
//
//  Created by Joss Manger on 4/25/20.
//  Copyright © 2020 Joss Manger. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSTextDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *textInputArea;
@property (weak) IBOutlet NSImageView *imageView;

@property NSString *value;

@end

