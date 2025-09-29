from Cryptodome.Cipher import AES

with open('D:/College/GP/aes-coprocessor-uvm/inputs.txt', 'r') as file:
    data_hex = file.readline().strip()  # Read the data hex string
    key_hex = file.readline().strip()  # Read the key hex string
    
data = bytes.fromhex(data_hex)
key = bytes.fromhex(key_hex)

cipher = AES.new(key, AES.MODE_ECB)

ciphertext = cipher.encrypt(data)

with open('D:/College/GP/aes-coprocessor-uvm/output.txt', 'w') as file:
    file.write(ciphertext.hex())
