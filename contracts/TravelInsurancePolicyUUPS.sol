// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract TravelInsurancePolicyUUPS is Initializable, OwnableUpgradeable, UUPSUpgradeable {

    struct policyInfo {
        uint256 policyEffectiveDate;
        uint256 policyExpirationDate;
        uint8 typeOfTraveller;
        uint256 cost;
    }

    // Mapping from address to policyInfo
    mapping(address => policyInfo) public policies;

    event PolicySet(address indexed holder, uint256 effectiveDate, uint256 expirationDate, uint8 typeOfTraveller, uint256 cost);

    function initialize() initializer public {
        __Ownable_init();
        __UUPSUpgradeable_init();
    }
    
    function setPolicy(address _user, uint256 _effectiveDate, uint256 _expirationDate, uint8 _typeOfTraveller, uint256 _cost) external onlyOwner {
        policies[_user] = policyInfo({
            policyEffectiveDate: _effectiveDate,
            policyExpirationDate: _expirationDate,
            typeOfTraveller: _typeOfTraveller,
            cost: _cost
        });

        emit PolicySet(_user, _effectiveDate, _expirationDate, _typeOfTraveller, _cost);
    }

    function getPolicy(address _user) external view returns(policyInfo memory) {
        return policies[_user];
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}
}
