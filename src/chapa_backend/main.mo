import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";


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

  public shared(msg) func payOut(): async Text {
    Debug.print(debug_show(msg.caller));
    let amount = 10000;
    if(balances.get(msg.caller) == null){
      let result = await transfer(msg.caller, amount);

      return result;
    } else {
      return "Already Claimed"
    };
  };

  public shared(msg) func transfer(to: Principal, amount: Nat): async Text {
    let fromBalance = await balanceOf(msg.caller);
    if(fromBalance > amount) {
      let newFromBalance: Nat = fromBalance - amount;
      balances.put(msg.caller, newFromBalance);
      
      let toBalance = await balanceOf(to);
      let newToBalance = toBalance + amount;
      balances.put(to, newToBalance);

      return "Success";
    } else {
      return "Insufficient Funds";
    };
  };
};
