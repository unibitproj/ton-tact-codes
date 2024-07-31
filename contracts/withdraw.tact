import "@stdlib/ownable";
import "@stdlib/deploy";

/// 合约中ton提现

contract TokenWithdraw with OwnableTransferable, Deployable {
    owner: Address;

    init(owner: Address) {
        self.owner = owner;
    }

   receive("Withdraw") {
        let ctx: Context = context();
        require(ctx.sender == self.owner, "Invalid sender");
        let value: Int = myBalance();
        send(SendParameters{
                to: self.owner,
                value: value, 
                mode: SendRemainingBalance, 
                bounce: true
            });
    }
}
