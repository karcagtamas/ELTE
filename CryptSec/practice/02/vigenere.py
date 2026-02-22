import random
from string import ascii_lowercase, ascii_uppercase


class VigenereCipher:
    def __init__(self):
        self._key = None

    def generate_key(self, l):
        self._key = ''.join(random.choices(ascii_lowercase, k=l))

    def encrypt(self, plaintext):
        c = ''
        key = self._repeat_to_length(self._key, len(plaintext))
        for k, char in zip(key, plaintext):
            k_i = ascii_lowercase.find(k)
            char_i = ascii_lowercase.find(char)
            c += ascii_uppercase[(k_i + char_i) % 26]
        return c

    def decrypt(self, ciphertext):
        p = ''
        key = self._repeat_to_length(self._key, len(ciphertext))
        for k, char in zip(key, ciphertext):
            k_i = ascii_lowercase.find(k)
            char_i = ascii_uppercase.find(char)
            p += ascii_lowercase[(char_i - k_i) % 26]
        return p

    def _repeat_to_length(self, s, length):
        return (s * (length // len(s) + 1))[:length]


if __name__ == "__main__":
    cipher = VigenereCipher()
    cipher.key = "asdf"
    print(cipher.decrypt(cipher.encrypt("ezsembiztonsagos")))
