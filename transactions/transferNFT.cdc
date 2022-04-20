import xGStudios from 0x91d21b0c6bbecfae
import NonFungibleToken from 0x91d21b0c6bbecfae

// This transaction transfers a template to a recipient
// This transaction is how a  user would transfer an NFT
// from their account to another account
// The recipient must have a TroonAtomicStandard Collection object stored
// and a public TransferInterface capability stored at
// `/public/TemplateCollection`

// Parameters:
//
// recipient: The Flow address of the account to receive the NFT.
// withdrawID: The id of the NFT to be transferred

transaction(recipient:Address, withdrawID:UInt64) {
    // local variable for storing the transferred token
    let transferToken: @NonFungibleToken.NFT
    
    prepare(acct: AuthAccount) {
        let collectionRef =  acct.borrow<&xGStudios.Collection>(from: xGStudios.CollectionStoragePath)
        ??panic("could not borrow a reference to the the stored nft Collection")
        self.transferToken <- collectionRef.withdraw(withdrawID: withdrawID)
    }

    execute {
        // get the recipient's public account object
        let recipient = getAccount(recipient)
        let receiverRef = recipient.getCapability<&{xGStudios.xGStudiosCollectionPublic}>(xGStudios.CollectionPublicPath)
            .borrow()
            ?? panic("Could not borrow receiver reference")
        // deposit the NFT in the receivers collection
        receiverRef.deposit(token: <-self.transferToken)
    }
}