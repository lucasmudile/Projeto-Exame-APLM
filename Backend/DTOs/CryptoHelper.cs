using System.Security.Cryptography;
using System.Text;

namespace WebApi.DTOs
{
    public class CryptoHelper
    {
        private static readonly byte[] key = Encoding.UTF8.GetBytes("1234567890123456"); // Mesmo valor do Flutter
        private static readonly byte[] iv = Encoding.UTF8.GetBytes("abcdefghijklmnop"); // Mesmo IV do Flutter

        public string DecryptData(string encryptedText)
        {
            byte[] encryptedBytes = Convert.FromBase64String(encryptedText);

            using (Aes aesAlg = Aes.Create())
            {
                aesAlg.Key = key;
                aesAlg.IV = iv;
                aesAlg.Mode = CipherMode.CBC;
                aesAlg.Padding = PaddingMode.PKCS7;

                using (MemoryStream msDecrypt = new MemoryStream(encryptedBytes))
                {
                    using (ICryptoTransform decryptor = aesAlg.CreateDecryptor(aesAlg.Key, aesAlg.IV))
                    using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
                    using (StreamReader srDecrypt = new StreamReader(csDecrypt))
                    {
                        return srDecrypt.ReadToEnd();
                    }
                }
            }
        }
    }
}
