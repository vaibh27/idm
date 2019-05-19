pragma solidity ^0.5.0;

contract Identity{

    struct Person{
            string name;
            string date_of_birth;
            address walletAddress;
            string idhash;//Id ipns address
            string password;//Id password
    }

    mapping (address =>uint ) public personIds;


    Person[] public persons;

    event newUserRegistered(uint id);
    event userUpdateEvent(uint id);

    modifier checkSenderIsRegistered{
        require (isRegistered());
        _;
    }

    constructor() public {
      addUser(address(0x000000000), " ", '0'," "," ");

    }
    function registerUser( string memory _name, string memory _dob, string memory _idhash, string memory _password) public
    returns(uint)
    {
      return addUser(msg.sender, _name, _dob, _idhash,_password);
    }

    function addUser( address _wAddr, string memory _name, string memory _dob, string memory _idhash, string memory _password) private
    returns(uint)
    {
      uint userId = personIds[_wAddr];
      require(userId == 0);

      personIds[_wAddr] = persons.length;
      uint newUserId = persons.length++;

      persons[newUserId] = Person({
        name:_name,
        date_of_birth : _dob,
        walletAddress : _wAddr,
        idhash : _idhash,
        password : _password
        });

        emit newUserRegistered(newUserId);

        return newUserId;
    }
    function updateUser(string memory _idhash, string memory _password) checkSenderIsRegistered public
    returns(uint){
      uint userId = personIds[msg.sender];
      Person storage person = persons[userId];

      person.idhash = _idhash;
      person.password = _password;

      emit userUpdateEvent(userId);

      return userId;
    }

    function getUserById(uint _id) public view
    returns(
      uint,
      string memory,
      string memory,
      address,
      string memory,
      string memory
      ){
        require((_id > 0 ) || (_id <= persons.length));

        Person memory i = persons[_id];

        return(
          _id,
          i.name,
          i.date_of_birth,
          i.walletAddress,
          i.idhash,
          i.password
          );
      }

      function getOwnProfile() checkSenderIsRegistered public view
        returns(
          uint,
          string memory,
          string memory,
          address,
          string memory,
          string memory
          ) {
            uint id = personIds[msg.sender];

            return getUserById(id);
          }

      function isRegistered() public view returns (bool){
        return (personIds[msg.sender] > 0);
      }

      function totalUsers() public view returns (uint){
        return persons.length - 1;
      }
}
