//
//  WindowController.m
//  Debase
//
//  Created by Joss Manger on 4/25/20.
//  Copyright © 2020 Joss Manger. All rights reserved.
//

#import "WindowController.h"

@interface WindowController ()

@end

@implementation WindowController

- (void)windowDidLoad {
  [super windowDidLoad];
  
  NSLog(@"loaded window");
  NSLog(@"%@",[[self window] contentViewController]);
  [[self window] setTitle:@"Debase"];
  
  AppDelegate *delegate = (AppDelegate *)[[NSApplication sharedApplication]delegate];
  NSManagedObjectContext *context = [[delegate persistentContainer] viewContext];
  
  //the below are not there when view did load
  NSWindow *window = [self window];
  NSWindowController *controller = [window windowController];
  NSLog(@"%@ %@ %@ %@",delegate, context, window,controller);
  
  // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)windowWillLoad{
  NSLog(@"will load window");
}

@end
