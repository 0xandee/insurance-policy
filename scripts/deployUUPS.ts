import { ethers, upgrades } from "hardhat";

async function main() {
    // Get the Contract Factory
    const TravelInsurancePolicy = await ethers.getContractFactory("TravelInsurancePolicyUUPS");

    // Deploy the contract proxy
    const travelInsurancePolicy = await upgrades.deployProxy(TravelInsurancePolicy, [], { initializer: 'initialize' });
    await travelInsurancePolicy.waitForDeployment();

    console.log("TravelInsurancePolicy deployed to:", travelInsurancePolicy.target);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
