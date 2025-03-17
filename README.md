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