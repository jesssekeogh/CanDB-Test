import CanisterMap "./CanisterMap";

shared ({caller = owner}) actor class {{name}}() = this {
  stable var pkToCanisterMap = CanisterMap.init();

  /// @required method (Do not delete or change)
  ///
  /// Get all canisters for an specific PK
  ///
  /// This method is called often by the candb-client query & update methods. 
  public shared query({caller = caller}) func getCanistersByPK(pk: Text): async [Text] {
    getCanisterIdsIfExists(pk);
  };

  /// @required method (Do not delete or change)
  ///
  /// Helper method acting as an interface for returning an empty array if no canisters
  /// exist for the given PK
  func getCanisterIdsIfExists(pk: Text): [Text] {
    switch(CanisterMap.get(pkToCanisterMap, pk)) {
      case null { [] };
      case (?canisterIdsBuffer) { Buffer.toArray(canisterIdsBuffer) } 
    }
  };

  /// @modify and @required (Do not delete, but must change/modify for your given application actor and data model)
  ///
  /// This is method is called by CanDB for AutoScaling. It is up to the developer to specify which
  /// PK prefixes should spin up which canister actor.
  ///
  /// If the developer does not utilize this method, auto-scaling will NOT work
  public shared({caller = caller}) func createAdditionalCanisterForPK(pk: Text): async Text {
    if (Text.startsWith(pk, #text("<your_pk_prefix>"))) {
      // await create<YourActorType>Canister(pk, ...your args);
      "to fill in";
    } else if (Text.startsWith(pk, #text("<different_pk_prefix>"))) {
      // await create<DifferentActorType>Canister(pk, ...your args);
      "to fill in";
    } else {
      throw Error.reject("creation of additional canister case not covered");
    };
  }
}