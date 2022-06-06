import CA "./CanisterActions";
import CanDB "./CanDB";

shared ({ caller = owner }) actor class {{actor_class_name}}({
  primaryKey: Text;
  scalingOptions: CanDB.ScalingOptions;
}) {

  stable let db = CanDB.init({
    pk = primaryKey;
    scalingOptions = scalingOptions;
  });

  public query func getPK(): async Text { db.pk };

  public query func skExists(sk: Text): async Bool { 
    CanDB.skExists(db, sk);
  };

  public shared({ caller = caller }) func transferCycles(): async () {
    if (caller == owner) {
      return await CA.transferCycles(caller);
    };
  };
}