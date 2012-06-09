#!/usr/bin/env python
# encoding: utf-8

# File        : encrypt.py
# Author      : Ben Wu
# Contact     : benwu@fnal.gov
# Date        : 2012 Jun 06
#
# Description : This python script will encrypt the password of your email
# accounts and save them seperate in a binary file


def decrypt():
    #global private_key
    global enc_data
    from Crypto.PublicKey import RSA
    generate()
    f = open("private.pem", 'r')
    private_key = f.read()

    key = RSA.importKey(private_key)
    print key.decrypt(open("Baylor", 'rb').read())


def generate():
    from Crypto.PublicKey import RSA
    from Crypto import Random
    random_generator = Random.new().read

    private = RSA.generate(2048, random_generator)
    public = private.publickey()
    f = open("private.pem", 'w')
    f.write(private.exportKey("PEM"))
    f.close()
    #f = open("public.pem", 'w')
    #f.write(public.exportKey("PEM"))
    #f.close()

    open('Baylor', 'wb').write(public.encrypt('baylor_password', 8)[0])
    open('Gmail', 'wb').write(public.encrypt('gmail_password', 8)[0])

    #print enc_data
    return private.exportKey()


if __name__ == "__main__":
    generate()
    decrypt()
