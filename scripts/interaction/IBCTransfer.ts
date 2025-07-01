import { ethers } from "hardhat";

async function main() {
  const amt = ethers.parseEther("0.000000000000003000");
  const receiver = "noble143h7yhvp595g905u49w8r34x6fc0x9tsvczknj";
  const precompile = await ethers.getContractAt(
    "ICS20I",
    "0x0000000000000000000000000000000000000802"
  );

  const signers = await ethers.getSigners();
  console.log("signers", signers[0].address);
  const tx = await precompile.transfer(
    "transfer",
    "channel-0",
    "uusdx",
    amt,
    signers[0].address,
    receiver,
    { revisionNumber: 1, revisionHeight: 10000000000 },
    0,
    ""
  );
  const receipt = await tx.wait(1);

  console.log(
    `Transferred ${ethers.formatEther(amt)} EVMOS via IBC to ${receiver}`
  );
  console.log("The transaction details are");
  console.log(receipt);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
