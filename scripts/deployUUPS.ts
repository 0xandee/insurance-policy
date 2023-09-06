import { ethers, upgrades } from "hardhat";

async function main() {
    // Get the Contract Factory
    const insuranceContract = await ethers.getContractFactory("InsuranceUUPS");

    // Deploy the contract proxy
    const insuranceContractProxy = await upgrades.deployProxy(insuranceContract, [], { initializer: 'initialize' });
    await insuranceContractProxy.waitForDeployment();

    console.log("InsuranceUUPS deployed to:", insuranceContractProxy.target);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
