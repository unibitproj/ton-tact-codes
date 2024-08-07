
// https://github.com/tact-lang/tact/blob/main/examples/multisig-3.tact

contract MultisigContract {

  receive(msg: Execute) {
        // Check all signatures
        let op_hash: Int = msg.operation.toCell().hash();
        let ok1: Bool = checkSignature(op_hash, msg.signature1, self.user1_key);
        let ok2: Bool = checkSignature(op_hash, msg.signature2, self.user2_key);
        let ok3: Bool = checkSignature(op_hash, msg.signature3, self.user3_key);
        require(msg.operation.seqno == self.seqno, "Invalid seqno");
        require(ok1 && ok2 && ok3, "Invalid signature");

        // Send messages
        self.execute(msg.operation);
    }
}
