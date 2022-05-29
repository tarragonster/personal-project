const hre = require('hardhat')
const { expect } = require('chai')

describe('Referring', function () {
  before('get factories', async function () {
    this.Referral = await hre.ethers.getContractFactory('Referral');
    this.Referralv2 = await hre.ethers.getContractFactory('Referralv2');
    this.Referralv3 = await hre.ethers.getContractFactory('Referralv3');
  })

  it('deploy Referral and isAdmin', async function () {
    const textAdmin = await ethers.utils.keccak256(ethers.utils.toUtf8Bytes("ADMIN_ROLE")); // https://forum.openzeppelin.com/t/how-to-test-for-roles-in-accesscontrol/6603
    this.accounts = await hre.ethers.getSigners();
    this.referral = await hre.upgrades.deployProxy(
      this.Referral,
      [this.accounts[0].address],
      { kind: 'uups' }
    );

    await expect(await this.referral.hasRole(textAdmin, this.accounts[0].address)).to.be.true
  })

  it('Admin can set HuukMarket', async function () {
    await this.referral.setHuukMarket(this.accounts[1].address)
    const userReferral = await this.referral.huukMarket();

    await expect(userReferral).to.be.eq(this.accounts[1].address);
  })

  it('None_Admin_User set HuukMarket and fail', async function () {

    await expect(
      this.referral.connect(this.accounts[2]) // https://forum.openzeppelin.com/t/error-when-using-approve-function-in-a-erc20-contract/8710
      .setHuukMarket(this.accounts[1].address)
    ).to.be.revertedWith("must have admin role");
  })

  it('should set referral by admin', async function () {
    await this.referral
      .setReferral(this.accounts[3].address, this.accounts[4].address)

    await expect(
      await this.referral.getReferral(this.accounts[3].address)
    ).to.be.eq(this.accounts[4].address);
  })

  it('should set referral by admin 2nd time', async function () {
    await this.referral
      .setReferral(this.accounts[3].address, this.accounts[5].address)

    await expect(
      await this.referral.getReferral(this.accounts[3].address)
    ).to.be.eq(this.accounts[5].address);
  })

  it('None_Admin_User set referral and fail', async function () {

    await expect(
      this.referral.connect(this.accounts[2]) // https://forum.openzeppelin.com/t/error-when-using-approve-function-in-a-erc20-contract/8710
        .setReferral(this.accounts[4].address, this.accounts[5].address)
    ).to.be.revertedWith("must have admin role");
  })

  it('Referral contract is upgradeable', async function () {
    const textAdmin = await ethers.utils.keccak256(ethers.utils.toUtf8Bytes("ADMIN_ROLE")); // https://forum.openzeppelin.com/t/how-to-test-for-roles-in-accesscontrol/6603
    this.referralv2 = await hre.upgrades.upgradeProxy(this.referral, this.Referralv2);
    await expect(await this.referralv2.version()).to.be.eq('V2!');
    await expect(await this.referralv2.hasRole(textAdmin, this.accounts[0].address)).to.be.true
  })

  it('Referral contract is upgradeable with change in function', async function () {
    this.referralv3 = await hre.upgrades.upgradeProxy(this.referralv2, this.Referralv3);
    await expect(await this.referralv3.version()).to.be.eq('V3!');
  })
})
