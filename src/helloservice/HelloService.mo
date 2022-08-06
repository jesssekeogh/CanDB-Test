import CA "mo:candb/CanisterActions";
import CanDB "mo:candb/CanDB";

shared ({ caller = owner }) actor class HelloService({
  // the partition key of this canister
  partitionKey: Text;
  // the scaling options that determine when to auto-scale out this canister storage partition
  scalingOptions: CanDB.ScalingOptions;
  // (optional) allows the developer to specify additional owners (i.e. for allowing admin or backfill access to specific endpoints)
  owners: ?[Principal];
}) {
  /// @required (may wrap, but must be present in some form in the canister)
  stable let db = CanDB.init({
    pk = partitionKey;
    scalingOptions = scalingOptions;
  });

  /// @recommended (not required) public API
  public query func getPK(): async Text { db.pk };

  /// @required public API (Do not delete or change)
  public query func skExists(sk: Text): async Bool { 
    CanDB.skExists(db, sk);
  };

  /// @required public API (Do not delete or change)
  public shared({ caller = caller }) func transferCycles(): async () {
    if (caller == owner) {
      return await CA.transferCycles(caller);
    };
  };

  public func putUser(name: Text, zipCode: Text): async () {
    if (name == "" or zipCode == "") { return }; // guard clause
    
    await CanDB.put(db, {
      sk = name; // sort key is name -> sortkey determines order data is stored
      attribute = [
        ("name", #text(name)), // using variant? should return ("name", {text=name})?
        ("zipCode", #text(zipCode))
      ]
    })
  }

}