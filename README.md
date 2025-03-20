# Deploy the Canister
1. Start the local simulated ICP:
```
dfx start
```

2. In a new terminal window, run the deploy:
```
dfx deploy
```

# Charge the Canister
1. Check canister id:
```
dfx canister id chapa_backend
```

2. Save canister ID into a command line variable:
```
CANISTER_PUBLIC_KEY="principal \"$( \dfx canister id chapa_backend )\""
```

3. Check caniester ID has been successfully saved:
```
echo $CANISTER_PUBLIC_KEY
```

4. Transfer half a billion CHAPA tokens to the canister Principal ID:
```
dfx canister call chapa_backend transfer "($CANISTER_PUBLIC_KEY, 500_000_000)"
```

# Check your Balance

1. Find out your principal id:

```
dfx identity get-principal
```

2. Save it somewere.
e.g. My principal id is: xxx-yyy

3. Format and store it in a command line variable:
```
OWNER_PUBLIC_KEY="principal \"$( \dfx identity get-principal)\""
```

4. Check that step 3 worked by printing it out:
```
echo $OWNER_PUBLIC_KEY
```

5. Check the owner's balance:
```
dfx canister call chapa_backend balanceOf "( $OWNER_PUBLIC_KEY )"
```

# Minting a New NFT from the Command Line
```
dfx deploy --argument='("Fruits #tomato001", principal "zsqst-kaz4z-cih4c-wcz32-c5sna-qtjje-d76zl-j3nma-ujppk-lemoq-fae", (vec {255; 216; 255; 224; 0; 16; 74; 70; 73; 70; 0; 1; 1; 0; 0; 100; 0; 100; 0; 0; 255; 219; 0; 67; 0; 2; 1; 1; 2; 1; 1; 2; 2; 2; 2; 2; 2; 2; 2; 3; 5; 16; 160; 33; 120; 217; 1; 10; 0; 128; 150; 122; 148; 3; 1; 1; 44; 245; 40; 6; 2; 2; 23; 140; 97; 1; 10; 0; 128; 97; 0; 198; 16; 4; 1; 0; 64; 68; 207; 52; 4; 72; 8; 152; 54; 64; 69; 129; 232; 16; 4; 1; 0; 64; 68; 193; 178; 2; 36; 0; 117; 8; 9; 136; 2; 2; 54; 244; 8; 120; 143; 168; 122; 16; 4; 1; 0; 64; 16; 4; 1; 0; 64; 16; 4; 7; 255; 217}))' nft
```