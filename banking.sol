pragma solidity ^0.5.1;
contract banking{
    address payable[] addresses;
    string[] names;
    uint[] ids;
    uint k;
    uint[] balance;
    event invalid(string );
    address payable founder;
    constructor() public {
        k=0;
        founder=msg.sender;
    }
    modifier min_balance_in_an_account(){
        require (msg.value>=20000000000000000000);
        _;
    }
    //Minimun balance required is 20 ether
    //The returned uint value(hash) is your personal bank id(your id)
    function register_in_bank(string memory a) payable public min_balance_in_an_account returns(uint){
        names.push(a);
        addresses.push(msg.sender);
        balance.push(msg.value);
        k=k+1;
        uint m;
        uint p;
        m=k-1;
        p=uint((keccak256(abi.encodePacked(block.difficulty,now,a))));
        ids.push(p);
        return(p);
    }
    
    function balance_enquiry(uint your_id) public payable returns(uint){
        int c;
        c=-1;
        uint v;
        for (uint i=0; i<names.length; i++) {
            if(ids[i]==your_id && msg.sender==addresses[i]){
                c=int(i);
        }
        }
        if(c<0){
            emit invalid("INVALID ID");
        }
        else{
            v=uint(c);
             return(balance[v]);
        }
        }
        
    //minimum balance need to be maintained even after the withdrawal
    function withdraw(uint amt_wd, uint your_id) public {
        int c;
        c=-1;
        uint v;
        for (uint i=0; i<names.length; i++) {
            if(ids[i]==your_id && msg.sender==addresses[i]){
                c=int(i);
            }
        }
        if(c>=0){
            v=uint(c);
            require(balance[v]>=(20000000000000000000+amt_wd*1000000000000000000));
            msg.sender.transfer(amt_wd*1000000000000000000);
            balance[v]=balance[v]-(amt_wd*1000000000000000000);
        }
        else{
            emit invalid("INVALID ID");
        }
    }
    function credit_amt(uint amt_cd, uint your_id)payable public{
        int c;
        c=-1;
        uint v;
        for (uint i=0; i<names.length; i++) {
            if(ids[i]==your_id && msg.sender==addresses[i]){
                c=int(i);
            }}
            if(c>=0){
                v=uint(c);
                require(msg.value==amt_cd*1000000000000000000);
                balance[v]=balance[v]+(amt_cd*1000000000000000000);
            }
    }
    function deleteaccount(uint your_id) public{
        int c;
        c=-1;
        uint v;
        for (uint i=0; i<names.length; i++) {
            if(ids[i]==your_id && msg.sender==addresses[i]){
                c=int(i);
            }}
            if(c>=0){
                msg.sender.transfer(balance[v]);
                v=uint(c);
                balance[v]=0;
                names[v]="null";
                addresses[v]=founder;
            }
            else{
                emit invalid("INVALID ID");
            }
    }
}
