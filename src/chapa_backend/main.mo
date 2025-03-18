import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import NFTActorClass "../NFT/nft";
import Cycles "mo:base/ExperimentalCycles";
import List "mo:base/List";
import Prelude "mo:base/Prelude";


actor Chapa {
  // Define el propietario principal del token con una dirección específica
  let owner : Principal = Principal.fromText("zsqst-kaz4z-cih4c-wcz32-c5sna-qtjje-d76zl-j3nma-ujppk-lemoq-fae");
  // Establece el suministro total de tokens
  let totalSuply : Nat = 1000000000;
  // Define el símbolo del token
  let _symbol : Text = "CHAPA";

  // Variable estable para almacenar los saldos durante las actualizaciones del canister
  private stable var balanceEntries: [(Principal, Nat)] = [];

  // HashMap para almacenar los saldos de cada usuario
  private var balances = HashMap.HashMap<Principal,Nat>(1, Principal.equal, Principal.hash);
  // Si el HashMap está vacío, asigna todo el suministro al propietario
  if(balances.size() < 1) {
    balances.put(owner, totalSuply);
  };


  // Obtiene el saldo del usuario
  public query func balanceOf(who: Principal): async Nat {
    let balance : Nat = switch (balances.get(who)) {
      // Si el usuario no existe en el HashMap balances, devuelve 0
      case null return 0;
      // Si el usuario existe, devuelve el valor
      case (?result) return result;
    };

    return balance;
  };

  // Faucet
  public shared(msg) func payOut(): async Text {
    Debug.print(debug_show(msg.caller));
    // Define la cantidad a pagar
    let amount = 10000;
    // Verifica si el usuario ya ha reclamado tokens
    if(balances.get(msg.caller) == null){
      // Si no ha reclamado, transfiere la cantidad al solicitante
      let result = await transfer(msg.caller, amount);

      return result;
    } else {
      // Si ya ha reclamado, devuelve un mensaje
      return "Already Claimed"
    };
  };

  public shared(msg) func transfer(to: Principal, amount: Nat): async Text {
    // Obtiene el saldo del remitente
    let fromBalance = await balanceOf(msg.caller);
    // Verifica si el remitente tiene suficientes fondos
    if(fromBalance > amount) {
      // Calcula el nuevo saldo del remitente
      let newFromBalance: Nat = fromBalance - amount;
      // Actualiza el saldo del remitente
      balances.put(msg.caller, newFromBalance);
      
      // Obtiene el saldo del destinatario
      let toBalance = await balanceOf(to);
      // Calcula el nuevo saldo del destinatario
      let newToBalance = toBalance + amount;
      // Actualiza el saldo del destinatario
      balances.put(to, newToBalance);

      return "Success";
    } else {
      return "Insufficient Funds";
    };
  };

  private type Listing = {
    itemOwner: Principal;
    itemPrice: Nat;
  };
  
  // HashMap para almacenar los NFTs creados
  var mapOfNFTs = HashMap.HashMap<Principal, NFTActorClass.NFT>(1, Principal.equal, Principal.hash);
  // HashMap para almacenar los NFTs que posee cada usuario
  var mapOfOwners = HashMap.HashMap<Principal, List.List<Principal>>(1, Principal.equal, Principal.hash);

  var mapOfListings = HashMap.HashMap<Principal, Listing>(1, Principal.equal, Principal.hash);


  public shared(msg) func mint(imgData: [Nat8], name: Text): async Principal {

    // Obtiene la identidad del creador del NFT
    let owner: Principal = msg.caller;

    // Añade ciclos para la creación del canister NFT
    Cycles.add<system>(100_500_000_000);

    // Crea un nuevo NFT con los datos proporcionados
    let newNFT = await NFTActorClass.NFT(name, owner, imgData);

    // Obtiene el ID del nuevo NFT
    let newNFTPrincipal = await newNFT.getCanisterId();

    // Almacena el NFT en el mapa de NFTs
    mapOfNFTs.put(newNFTPrincipal, newNFT);

    // Añade el NFT a la lista de NFTs del propietario
    addToOwnershipMap(owner, newNFTPrincipal);

    return newNFTPrincipal;
  };

  private func addToOwnershipMap(owner: Principal, nftId: Principal) {
    // Obtiene la lista de NFTs que posee el propietario
    var ownedNFTs : List.List<Principal> = switch (mapOfOwners.get(owner)){
      // Si no tiene NFTs, crea una lista vacía
      case null List.nil<Principal>();
      // Si tiene NFTs, obtiene la lista
      case (?result) result;
    };

    // Añade el nuevo NFT a la lista
    ownedNFTs := List.push(nftId, ownedNFTs);
    // Actualiza el mapa de propietarios
    mapOfOwners.put(owner, ownedNFTs);
  };

  public query func getOwnedNFTs(user: Principal): async [Principal] {
    // Obtiene la lista de NFTs que posee el propietario
    var userNFTs : List.List<Principal> = switch (mapOfOwners.get(user)) {
      case null List.nil<Principal>();
      case (?result) result;
    };

    return List.toArray(userNFTs);
  };

  public query func getListedNFTs(): async [Principal] {
    let ids = Iter.toArray(mapOfListings.keys());
    return ids;
  };

  //  Permite a los usuarios listar sus NFTs para la venta
  public shared(msg) func listItem(id: Principal, price: Nat): async Text {
    // Intenta obtener el NFT del mapa usando el ID proporcionado
    var item: NFTActorClass.NFT = switch (mapOfNFTs.get(id)) {
      // Si el NFT no existe, termina la función y devuelve un mensaje de error
      case null return "NFT does not exist";
      case (?result) result;
    };
    // Obtiene el propietario actual del NFT
    let owner = await item.getOwner();
    // Verifica si el llamante es el propietario del NFT
    if ( Principal.equal(owner, msg.caller)) {
      // Crea un nuevo objeto de listado con el propietario y precio
      let newListing : Listing = {
        itemOwner = owner;
        itemPrice = price
      };
      // Agrega el listado al mapa de listados usando el ID del NFT como clave
      mapOfListings.put(id, newListing);
      return "Success";
    } else {
      // Si el msg.caller no es el propietario, devuelve un mensaje de error
      return "You don't own the NFT."
    };    
  };

  public query func getChapaCanisterID(): async Principal {
    return Principal.fromActor(Chapa);
  };

  public query func isListed(id: Principal): async Bool {
    if(mapOfListings.get(id) == null) {
      return false;
    } else {
      return true;
    };
  };

  public query func getOriginalOwner(id: Principal): async Principal {
    var listing: Listing = switch (mapOfListings.get(id)) {
      case null return Principal.fromText("");
      case (?result) result;
    };

    return listing.itemOwner;
  };

  public query func getListedNFTPrice(id: Principal): async Nat {
    var listing : Listing = switch (mapOfListings.get(id)) {
      case null return 0;
      case (?result) result;
    };

    return listing.itemPrice
  };

  public shared(_msg) func completePurchase(id: Principal, ownerId: Principal, newOwnerId: Principal): async Text {
    var purchasedNFT : NFTActorClass.NFT = switch (mapOfNFTs.get(id)) {
      case null return "NFT does not exist";
      case (?result) result;
    };

    let transferResult = await purchasedNFT.transferOwnership(newOwnerId);
    if(transferResult == "Success"){
      mapOfListings.delete(id);
      var ownedNFTs : List.List<Principal> = switch (mapOfOwners.get(ownerId)) {
        case null List.nil<Principal>();
        case (?result) result;
      };
      ownedNFTs := List.filter(ownedNFTs, func (listItemId: Principal) : Bool {
        return listItemId != id;
      });

      addToOwnershipMap(newOwnerId, id);
      return "Success";
    } else {
      return transferResult;
    };

  };

  // Función que se ejecuta antes de actualizar el canister
  system func preupgrade() {
    // Convierte el HashMap de saldos a un array para persistencia
    balanceEntries := Iter.toArray(balances.entries());
  };

  // Función que se ejecuta después de actualizar el canister
  system func postupgrade() {
    // Reconstruye el HashMap de saldos desde el array persistente
    balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
    // Si el HashMap está vacío, asigna todo el suministro al propietario
    if(balances.size() < 1) {
      balances.put(owner, totalSuply);
    };
  };
};
