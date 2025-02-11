import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;

String baseUrl = "https://bm4vzmb7-44334.uks1.devtunnels.ms/api/";

String baseUrlImage = "https://bm4vzmb7-44334.uks1.devtunnels.ms/Uploads/";

void main() {
  //Mecanismo de implementação
  /*final key =
      encrypt.Key.fromUtf8('1234567890123456'); // Chave de 16 bytes (AES-128)

  final iv = encrypt.IV.fromUtf8('abcdefghijklmnop'); // IV de 16 bytes

  String plainText = "Lurio";

  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final encrypted = encrypter.encrypt(plainText, iv: iv);
  String ec =
      base64.encode(encrypted.bytes); // Retorna a string codificada em Base64
  print("****************************************");
  print(ec);*/
}
