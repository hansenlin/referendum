pragma solidity >=0.5.0 <0.6.0;

import "@aztec/protocol/contracts/ACE/ACE.sol";
import "@aztec/protocol/contracts/ACE/validators/joinSplit/JoinSplit.sol";
import "@aztec/protocol/contracts/ACE/validators/privateRange/PrivateRange.sol";

import "@aztec/protocol/contracts/libs/NoteUtils.sol";

contract Referendum {

  using NoteUtils for bytes;

  uint24 constant PRIVATE_RANGE_PROOF = 66562;
  uint24 constant JOIN_SPLIT_PROOF = 65793;
  ACE ace;

  struct Policy {
    string description;
    bool expired;
    bytes32[] noteHashes;
    mapping(address => bool) votes;
    mapping(bytes32 => bool) aztecVotes;
  }

  Policy[] public proposals;
  address public owner;
  mapping(address => bool) public voters;
  uint public votersCount;


  constructor(address _ace) public {
    ace = ACE(_ace);
    owner = msg.sender;
  }

  function register() public {
    voters[msg.sender] = true;
    votersCount++;
  }

  function proposePolicy(string memory description) public {
    Policy memory proposal = Policy({
      description: description,
      expired: false,
      noteHashes: new bytes32[](0)
    });

    proposals.push(proposal);
  }

  function vote(uint index, bytes memory _proofdata) public {
    require(voters[msg.sender], 'sender is not a registered');
    Policy storage policy = proposals[index];
    require(!policy.votes[msg.sender], 'you already voted');

    bytes memory proofOutputs = ace.validateProof(PRIVATE_RANGE_PROOF, msg.sender, _proofdata);
    (bytes memory inputNotes, , ,) = proofOutputs.get(0).extractProofOutput();

    (address noteOwner, bytes32 noteHash,) = inputNotes.get(0).extractNote();
    require(noteOwner == owner , 'owner does not have visibility');

    policy.noteHashes.push(noteHash);
    policy.aztecVotes[noteHash] = true;
    
    policy.votes[msg.sender] = true;
  }

  function compileResult(uint index, bytes memory _proofdata) public {
    Policy storage policy = proposals[index];
    //require(!policy.expired);

    bytes memory proofOutputs = ace.validateProof(JOIN_SPLIT_PROOF, msg.sender, _proofdata);
    (bytes memory inputNotes, bytes memory outputNotes, ,) = proofOutputs.get(0).extractProofOutput();

    require(inputNotes.getLength() == policy.noteHashes.length);
    for (uint i = 0; i < inputNotes.getLength(); i++) {
      (, bytes32 noteHash, ) = inputNotes.get(i).extractNote();
      require(policy.aztecVotes[noteHash], "note hashes are different");
    }

    require(outputNotes.getLength() == 1);

    //emit Poll
  }
}
