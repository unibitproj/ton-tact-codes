
// https://github.com/tact-lang/tact/blob/main/examples/multisig-3.tact

// https://github.com/tact-lang/tact/blob/main/examples/payouts.tact

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

    receive(msg: String) {
        // Check context
        let ctx: Context = context();
        require(ctx.value >= ton("1"), "Invalid value");

        // Parse message
        let data: Slice = msg.fromBase64();
        let amount: Int = data.loadCoins();
        let signature: Slice = data.loadBits(512);
        
        // Verify signature
        let dataToSign: Builder = beginCell();
        dataToSign = dataToSign.storeAddress(ctx.sender);
        dataToSign = dataToSign.storeCoins(amount);
        let hash: Int = dataToSign.asCell().hash();
        require(checkSignature(hash, signature, self.publicKey), "Invalid signature");

        // Request funds transfer
        let init: StateInit = initOf Beacon(myAddress(), ctx.sender);
        let address: Address = contractAddress(init);
        send(SendParameters{
            to: address, 
            value: 0, 
            mode: SendRemainingValue | SendIgnoreErrors,
            bounce: true, 
            body: CanPayout{amount: amount}.toCell()
        });
    }
}
