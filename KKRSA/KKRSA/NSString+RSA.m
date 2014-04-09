//
//  NSString+RSA.m
//  KKRSA
//
//  Created by Luke on 4/9/14.
//  Copyright (c) 2014 geeklu. All rights reserved.
//

#import "NSString+RSA.h"
#import "rsa.h"
#import "bn.h"

@implementation NSString (RSA)

- (NSString *)encryptedWithRawPubKey:(NSString *)rawPubKey {
    NSString *encryptedString = nil;
    
    //modulus(n) 和 exponent(e) 使用 '\n' 分隔
	NSArray *pubKeyArray = [rawPubKey componentsSeparatedByString:@"\n"];
	if ([pubKeyArray count] >= 2) {
        NSString *nString = [pubKeyArray objectAtIndex:0];
        const char *nCString = [nString cStringUsingEncoding:NSASCIIStringEncoding];
        
        NSString *eString = [pubKeyArray objectAtIndex:1];
        const char *eCString = [eString cStringUsingEncoding:NSASCIIStringEncoding];
        
        unsigned char *inCString = (unsigned char *)[self cStringUsingEncoding:NSUTF8StringEncoding];
        size_t inLenght = strlen((char *)inCString);
        
        unsigned int eInt = 3;
        if (eCString) {
            eInt = atoi(eCString);
        }
        
        
        //构造RSA结构体
        BIGNUM *bne = BN_new();
        BIGNUM *bnn = BN_new();
        
        BN_set_word(bne,eInt);
        BN_dec2bn(&bnn, nCString);
        
        RSA *r = RSA_new();
        r->n = bnn;
        r->e = bne;
        
        //使用RSA_NO_PADDING的模式进行加密
        int rsaSize = RSA_size(r);
        int outOffset = 0;
        int blockCount = inLenght / rsaSize + (inLenght % rsaSize ? 1 : 0);
        unsigned char *outBytes = malloc(sizeof(char) * (blockCount * rsaSize));
        memset(outBytes, '\0', sizeof(char) * blockCount * rsaSize);
        
        for (int index = 0; index < blockCount; index ++) {
            const unsigned char *from = inCString + (rsaSize * index);
            unsigned char *to = outBytes + outOffset;
            int ret = RSA_public_encrypt(rsaSize, from, to, r, RSA_NO_PADDING);
            outOffset += ret;
        }
        
        //将加密后的结果转换成字符串
        NSMutableString *resultString = [NSMutableString string];
        for (int i=0; i < outOffset; i++) {
            [resultString appendFormat:@"%02x",outBytes[i]];
        }
        
        encryptedString = [resultString copy];
        
        //RSA_free也会释放其成员,所以不需要再释放bnn和bne了
        RSA_free(r);
        
        free(outBytes);
        
    }
    
    return encryptedString;
}

@end
