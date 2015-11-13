//
//  ViewController.m
//  acronym
//
//  Created by Michael Oh on 11/12/15.
//  Copyright (c) 2015 Michael Oh. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"

@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inoutField;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inoutField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (IBAction)searchBtnPressed:(id)sender {
    if (self.inoutField.text.length < 1) {
        return;
    }
    
    [self searchAPI];
}

#pragma mark - API

-(void)searchAPI {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [[APIManager sharedInstance] searchAcronym:self.inoutField.text completion:^(NSURLResponse *result, NSError *error) {
        if(error || result == nil){
            [weakSelf apiFailed];
        } else {
            if([result isKindOfClass:NSArray.class]){
                NSArray *array=[result copy];
                [weakSelf displayAPIResult:array];
            } else {
                [weakSelf apiFailed];
            }
        }
    }];    
}

-(void)displayAPIResult:(NSArray *)resultArray {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSArray *array = resultArray.firstObject[@"lfs"];
    if ([array isKindOfClass:NSArray.class]){
        NSDictionary* dic = array.firstObject;
        self.resultTextView.text = dic[@"lf"] ? dic[@"lf"] : @"..";
    } else {
        self.resultTextView.text = @"..";
    }
}

-(void)apiFailed {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.resultTextView.text = @"Sorry, there is an error! please try again.";
}


#pragma mark - UITextField Delegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
}

@end
