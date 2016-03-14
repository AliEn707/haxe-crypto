package com.hurlant.tests.crypto;

import com.hurlant.crypto.encoding.binary.BinaryEncodings;
import com.hurlant.util.Hex;
import com.hurlant.crypto.Crypto;
import com.hurlant.tests.BaseTestCase;

class CryptoTest extends BaseTestCase {
    public function test_hash() {
        function calc(algo:String, hex:String = '') {
            return Hex.fromArray(Crypto.getHash(algo).hash(Hex.toArray(hex)));
        }

        assertEquals('8350e5a3e24c153df2275c9f80692773', calc('md2'));
        assertEquals('d41d8cd98f00b204e9800998ecf8427e', calc('md5'));
        assertEquals('da39a3ee5e6b4b0d3255bfef95601890afd80709', calc('sha1'));
        assertEquals('d14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f', calc('sha224'));
        assertEquals('e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', calc('sha256'));
    }

    public function test_hmac_size() {
        function calc(name:String) { return Crypto.getHMAC(name).getHashSize(); }

        assertEquals(20, calc('sha1'));
        assertEquals(8, calc('md5-64'));
        assertEquals(12, calc('hmac-md5-96'));
        assertEquals(16, calc('hmac-sha1-128'));
        assertEquals(24, calc('hmac-sha256-192'));
    }

    public function test_hmac_data() {
        var key = Hex.toArray('ffffffffffffffffffffffffffffffffffffffffffffffff');
        var data = Hex.toArray('ffffffffffffffffffffffffffffffffffffffffffffffff');
        function calc(name:String) { return Hex.fromArray(Crypto.getHMAC(name).compute(key, data)); }

        // @TODO: CHECK!
        assertEquals('f06332351572a494aa20c1e72cd1f14b8414891a', calc('sha1'));
        assertEquals('fbf75d0a9cfcd387', calc('md5-64'));
        assertEquals('fbf75d0a9cfcd3879b290272', calc('hmac-md5-96'));
        assertEquals('f06332351572a494aa20c1e72cd1f14b', calc('hmac-sha1-128'));
        assertEquals('7e2267257711cc4277b4357bcedf501a69cf9232d3c5a4b0', calc('hmac-sha256-192'));
    }

    public function test_charset_and_binary_encoding() {
        assertEquals('68656c6c6f20776f726c64', BinaryEncodings.HEX.encode(Crypto.getCharset('utf-8').encode('hello world')));
        assertEquals('aGVsbG8gd29ybGQ=', BinaryEncodings.BASE64.encode(Crypto.getCharset('utf-8').encode('hello world')));
    }
}