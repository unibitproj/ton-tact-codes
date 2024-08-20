import { mnemonicNew, mnemonicToWalletKey, mnemonicValidate } from '@ton/crypto';
import { WalletContractV4, contractAddress } from "@ton/ton";

async function generateWallets(count) {
    const wallets = [];

    for (let i = 0; i < count; i++) {
        // 生成助记词
        const mnemonic = await mnemonicNew();
        
        // 验证助记词（可选）
        const isValid = await mnemonicValidate(mnemonic);
        if (!isValid) {
            throw new Error('Invalid mnemonic generated');
        }

        // 使用助记词生成钱包密钥
        const keyPair = await mnemonicToWalletKey(mnemonic);

        // 创建钱包合约的源
        const wallet = WalletContractV4.create({
            workchain: 0,
            publicKey: keyPair.publicKey
        });
        const walletAddress = wallet.address.toString({ testOnly: false });

        wallets.push({
            mnemonic: mnemonic.join(' '),
            walletAddress: walletAddress.toString(),
            publicKey: keyPair.publicKey.toString('hex'),
            privateKey: keyPair.secretKey.toString('hex'),
        });
    }

    return wallets;
}

// 使用示例：批量生成10个钱包
generateWallets(10).then(wallets => {
    wallets.forEach((wallet, index) => {
        console.log(`Wallet ${index + 1}:`);
        console.log(`Mnemonic: ${wallet.mnemonic}`);
        console.log(`Address: ${wallet.walletAddress}`);
        console.log('-----------------------------------');
    });
}).catch(console.error);
