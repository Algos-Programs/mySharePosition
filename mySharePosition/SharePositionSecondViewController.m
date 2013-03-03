//
//  SharePositionSecondViewController.m
//  mySharePosition
//
//  Created by Marco Velluto on 01/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "SharePositionSecondViewController.h"
@interface SharePositionSecondViewController ()

@end

@implementation SharePositionSecondViewController
@synthesize switchEmail;
@synthesize switchSMS;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initVariables];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_with_label.png"]]];
}

/*
- (id)init {
    
    self = [super init];
    [self initVariables];
    return self;
}
*/
- (void)initVariables {
    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[MFile dictionaryWithString:nil]];
    if ([[dic allKeys] count] == 0) {
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
        [mDic setObject:[NSString stringWithFormat:@"%i", [switchSMS isOn]] forKey:KEY_SMS];
        [mDic setObject:[NSString stringWithFormat:@"%i", [switchEmail isOn]] forKey:KEY_EMAIL];
        [MFile writeDictionary:mDic];
    }
    
    else {
        
        [switchEmail setOn:[self boolValueFromString:[dic objectForKey:KEY_EMAIL]]];
        [switchSMS setOn:[self boolValueFromString:[dic objectForKey:KEY_SMS]]];\
        
    }
    

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeSwitchEmail:(id)sender {
}

- (IBAction)changeSwitchSMS:(id)sender {
}

- (IBAction)pressButtonSave:(id)sender {
   
    
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    [mDic setObject:[NSString stringWithFormat:@"%i", [switchSMS isOn]] forKey:KEY_SMS];
    [mDic setObject:[NSString stringWithFormat:@"%i", [switchEmail isOn]] forKey:KEY_EMAIL];
    [MFile writeDictionary:mDic];
     
    
    
}

//*******************************
#pragma mark - Metodi di Comodo
//*******************************

/**
 Viene passata una stringa che contenga YES o NO (in maiuscolo).
 Il metodo restituisce il valore BOOL corrispondente.
 */
- (BOOL)boolValueFromString:(NSString *)str {
    
    if ([str isEqualToString:@"YES"] || [str isEqualToString:@"TRUE"] || [str isEqualToString:@"1"])
        return YES;
    
    else
        return NO;
}

@end
