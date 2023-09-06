// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract InsuranceUUPS is Initializable, OwnableUpgradeable, UUPSUpgradeable {

    enum PolicyStatus {
        Active,
        Expired
    }

    // If claim request status we have submitted, review, under validation, approved, rejected, in appeal
    // enum ClaimStatus {
    //     Submitted,
    //     Review,
    //     UnderValidation,
    //     Approved,
    //     Rejected,
    //     InAppeal
    // }

    struct PolicyInfo {
        uint256 policyEffectiveDate;
        uint256 policyExpirationDate;
        uint8 typeOfTraveller;
        uint256 cost;
    }

    PolicyStatus public policyStatus;
    uint256 public poolFund;
    mapping(string policyId => PolicyInfo policyInfo) public policyInfoList;

    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    function paid() public {
        policyStatus = PolicyStatus.Active;
    }

    function buyPolicy(
        string calldata _policyId,
        uint256 _policyEffectiveDate,
        uint256 _policyExpirationDate,
        uint8 _typeOfTraveller,
        uint256 _cost
    ) public onlyOwner {
        PolicyInfo storage info = policyInfoList[_policyId];
        info.policyEffectiveDate = _policyEffectiveDate;
        info.policyExpirationDate = _policyExpirationDate;
        info.typeOfTraveller = _typeOfTraveller;
        info.cost = _cost;
    }

    function buyPolicyList(
        string[] calldata _policyId,
        uint256[] calldata _policyEffectiveDate,
        uint256[] calldata _policyExpirationDate,
        uint8[] calldata _typeOfTraveller,
        uint256[] calldata _cost
    ) external onlyOwner {
        require(_policyId.length == _policyEffectiveDate.length, "The Length Does Not Same");
        require(_policyEffectiveDate.length == _policyExpirationDate.length, "The Length Does Not Same");
        require(_policyExpirationDate.length == _typeOfTraveller.length, "The Length Does Not Same");
        require(_typeOfTraveller.length == _policyEffectiveDate.length, "The Length Does Not Same");
        for (uint256 i = 0; i < _policyId.length; i++) {
            buyPolicy(_policyId[i], _policyEffectiveDate[i], _policyExpirationDate[i], _typeOfTraveller[i], _cost[i]);
            poolFund += _cost[i];
        }
    }

    function subCost(uint256 _cost) internal {
        poolFund = poolFund - _cost;
    }

    function addCost(uint256 _cost) internal {
        poolFund = poolFund + _cost;
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}
}
