//Based on code by OpenZeppelin
//https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/test/SafeMath.js
const assertJump = require('../helpers/assertJump');

var SafeMathMock = artifacts.require('../contracts/helpers/SafeMathMock.sol');

contract('SafeMath', function(accounts) {

  let safeMath;

  before(async function() {
    safeMath = await SafeMathMock.new();
  });

  it("multiplies correctly", async function() {
    let a = 5678;
    let b = 1234;
    let result = await safeMath.mul(a, b);
    assert.equal(result, a*b);
  });
  it("handles a zero product correctly", async function() {
    let a = 0;
    let b = 1234;
    let result = await safeMath.mul(a, b);
    assert.equal(result, a*b);
  });

  it("adds correctly", async function() {
    let a = 5678;
    let b = 1234;
    let result = await safeMath.add(a, b);

    assert.equal(result, a+b);
  });

  it("subtracts correctly", async function() {
    let a = 5678;
    let b = 1234;
    let result = await safeMath.sub(a, b);

    assert.equal(result, a-b);
  });

  it("should throw an error if subtraction result would be negative", async function () {
    let a = 1234;
    let b = 5678;
    try {
      let subtract = await safeMath.sub(a, b);
      assert.fail('should have thrown before');
    } catch(error) {
      assertJump(error);
    }
  });

  it("should throw an error on addition overflow", async function() {
    let a = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
    let b = 1;
    try {
      let add = await safeMath.add(a, b);
      assert.fail('should have thrown before');
    } catch(error) {
      assertJump(error);
    }
  });

  it("should throw an error on multiplication overflow", async function() {
    let a = 115792089237316195423570985008687907853269984665640564039457584007913129639933;
    let b = 2;
    try {
      let multiply = await safeMath.mul(a, b);
      assert.fail('should have thrown before');
    } catch(error) {
      assertJump(error);
    }
  });

  it('divides correctly', async function () {
      let a = 5678;
      let b = 5678;

      const result = await safeMath.div(a, b);
      assert.equal(result, 1 );
    });

  it("division correctly", async function() {
    let a = 5678;
    let b = 1234;
    let result = await safeMath.div(a, b);
// (val - val % by) / by
    assert.equal(result, (a - a % b) / b );
  });

  it("should return 0  a < b division", async function() {
    let a = 5678;
    let b = 12340;
    let result = await safeMath.div(a, b);
    assert.equal(result, 0);
  });

  it("should throw an error division 0", async function () {
    let a = 1234;
    let b = 0;
    try {
      let subtract = await safeMath.div(a, b);
      assert.fail('should have thrown before');
    } catch(error) {
      assertJump(error);
    }
  });

});


