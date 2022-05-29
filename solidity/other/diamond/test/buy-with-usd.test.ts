/* eslint-disable camelcase */
import { TestBuy2TimeWithUSD1155, TestBuyWithUSD1155, TestNotAuthorizedBuyWithUSD1155 } from "./buy-with-usd.func";

describe("Testing buy with USD function", () => {
  const testData = [
    {
      note: "Normal Case",
      input: { totalAmount: 15, orderQuantity: 10, normalAmount: 3 },
    },
  ];

  testData.forEach((input) => {
    it(`Test buy with USD 1155 (For ${input.note}): ${JSON.stringify(input.input)}`, async () => {
      await TestBuyWithUSD1155(input.input);
    });
  });
  testData.forEach((input) => {
    it(`Test buy with USD 1155 (For ${input.note}): ${JSON.stringify(input.input)}`, async () => {
      await TestBuy2TimeWithUSD1155(input.input);
    });
  });
  const testFailData = [
    {
      note: "Fail Case",
      input: { totalAmount: 15, orderQuantity: 10, normalAmount: 3 },
    },
  ];

  testFailData.forEach((input) => {
    it(`Test buy with USD 1155 FAIL (For ${input.note}): ${JSON.stringify(input.input)}`, async () => {
      await TestNotAuthorizedBuyWithUSD1155(input.input);
    });
  });
});
//
// describe("Testing lazy-mint 721 function", () => {
//   const testLazy721SingleBuy = [{}];
//
//   testLazy721SingleBuy.forEach((input) => {
//     it(`Test Single Buy Lazy-buy 721: ${JSON.stringify(input)}`, async () => {
//       await TestLazyMint721(input);
//     });
//   });
// });
