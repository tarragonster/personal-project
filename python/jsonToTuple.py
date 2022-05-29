import json
# f = open('data.json')
# data = json.load(f)
# f.close()

#           "owner": '0xFF08483293718b26a098f662EA3B232332DFe02E',
#           "token": '0x7057B47d965707a6d0b70BeE1F157A12bba5Bb49',
#           "id": 0,
#           "uri": 'test',
#           "initialSupply": 1,
#           "maxSupply": 1,
#           "royaltyFee": 10,
#           "nonce": 239,
#           "isERC721": "true",
#           "signature": '0xa65a6911aa645eb1754bbaf2c1b66accec5ad687a579d15f2d2571b92726122f7108de02ef12f54bd984418f1f0aee1c4beb6dd551255feb61c0b1860e6b07361b'
#         },


data={
        "token": {
        "id": 0,
        "quantity": 1,
        "price": '1000000000000000000',
        "paymentToken": '0xA9389B343559E4c201d22BC573edfE17D81Da7D1',
        "nonce": 239,
        "signature": '0x9cca2ddf0c007effe2f1afb75d3bb3ae72de1cf646653af8abc58a84b0c5f4365d6314c95c9e80d8edbe3e0f727c0b22e9ab8a89b492326011685f37c4b28d211b'
      }
}
print([tuple(data.items())])