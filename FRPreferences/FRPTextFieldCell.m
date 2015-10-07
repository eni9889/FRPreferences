//
//  FRPSwitchCell.m
//  FRPreferences
//
//  Created by Fouad Raheb on 7/2/15.
//  Copyright (c) 2015 F0u4d. All rights reserved.
//

#import "FRPTextFieldCell.h"

@interface FRPTextFieldCell ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation FRPTextFieldCell

+ (instancetype)cellWithTitle:(NSString *)title setting:(FRPSettings *)setting placeholder:(NSString *)placeholder postNotification:(NSString *)notification changeBlock:(FRPValueChanged)block {
    return [[self alloc] cellWithTitle:title setting:setting placeholder:placeholder postNotification:notification changeBlock:block];
}

- (instancetype)cellWithTitle:(NSString *)title setting:(FRPSettings *)setting placeholder:(NSString *)placeholder postNotification:(NSString *)notification changeBlock:(FRPValueChanged)block {
    FRPTextFieldCell *cell = [super initWithTitle:title setting:setting];
    cell.setting = setting;
    cell.postNotification = notification;
    cell.valueChanged = ^(id sender) {
        if (block) block(sender);
    };
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 190, 30)];
    [self.textField setDelegate:self];
    [self.textField setTextAlignment:NSTextAlignmentRight];
    [self.textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.textField setText:setting.value];
    [self.textField setPlaceholder:placeholder];
    [self.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.textField.returnKeyType = UIReturnKeyDone;
    cell.accessoryView = self.textField;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 35.0f)];
    toolbar.barStyle=UIBarStyleBlackOpaque;
    
    // Create a flexible space to align buttons to the right
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    // Create a cancel button to dismiss the keyboard
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    // Add buttons to the toolbar
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, barButtonItem, nil]];
    
    // Set the toolbar as accessory view of an UITextField object
    self.textField.inputAccessoryView = toolbar;

    return cell;
}

-(void)done {
    [self.textField resignFirstResponder];
    self.valueChanged(self.textField);
}

-(void)textFieldChanged:(UITextField *)textField {
    self.setting.value = [textField text];
    self.valueChanged(textField);
    [[NSNotificationCenter defaultCenter] postNotificationName:self.postNotification object:textField];
}

- (BOOL)textFieldShouldReturn:(id)textField {
    [textField resignFirstResponder];
    self.valueChanged(textField);
    return NO;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.textField.tintColor = self.tintUIColor;
}
@end
