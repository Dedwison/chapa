import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";


actor Chapa {

  var owner : Principal = Principal.fromText("zsqst-kaz4z-cih4c-wcz32-c5sna-qtjje-d76zl-j3nma-ujppk-lemoq-fae");
  var totalSuply : Nat = 1000000000;
  var _symbol : Text = "CHAPA";

  var balances : HashMap.HashMap<Principal, Nat> = HashMap.HashMap<Principal,Nat>(1, Principal.equal, Principal.hash);
  balances.put(owner, totalSuply);

  public query func balanceOf(who: Principal): async Nat {
    let balance : Nat = switch (balances.get(who)) {
      case null return 0;
      case (?result) return result;
    };

    return balance;
  };

}
