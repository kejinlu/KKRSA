//
//  KKRSATests.m
//  KKRSATests
//
//  Created by Luke on 4/9/14.
//  Copyright (c) 2014 geeklu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+RSA.h"

@interface KKRSATests : XCTestCase
@property (nonatomic,copy) NSString *rawPubKey;
@end

@implementation KKRSATests

- (void)setUp
{
    [super setUp];
    
    self.rawPubKey = @"111429663282299900149207513970932878918312632330678513360539654455343651305432379906709736785745684771846128421003011223840599542539173914766422083241505455693029968874309402166548534134802357433430174042316445853241468485647937106784813594624912661735286574847409748380304529917473043544867526598656280403059\n3";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSString *testString = @"哈哈哈";
    NSString *result = [testString encryptedWithRawPubKey:self.rawPubKey];
}

@end
