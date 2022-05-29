/* eslint-disable camelcase */
import { TestSingleBuyLazyMint1155, TestLazyMint721, TestMultipleLazyMint1155, TestMultiOrderInLazyMint1155 } from "./buy-lazy-mint.func";

describe("Testing lazy-mint 1155 function", () => {
  const testLazy1155SingleBuy = [
    {
      note: "Under Limit Case",
      input: { buyAmount: 4, supply: 100, orderQuantity: 20 },
    },
    {
      note: "Under Limit Case",
      input: { buyAmount: 10, supply: 100, orderQuantity: 20 },
    },
    {
      note: "Under Limit Case",
      input: { buyAmount: 20, supply: 100, orderQuantity: 20 },
    },
    {
      note: "Over Limit Case",
      input: { buyAmount: 40, supply: 100, orderQuantity: 20 },
    },
  ];

  testLazy1155SingleBuy.forEach((input) => {
    it(`Test Single Lazy-buy 1155 (For ${input.note}): ${JSON.stringify(input.input)}`, async () => {
      await TestSingleBuyLazyMint1155(input.input);
    });
  });

  const testLazy1155MultipleBuy = [
    {
      note: "Normal Case",
      input: { buyAmount: [4, 7], supply: 100, orderQuantity: 20 },
    },
    {
      note: "Normal Case",
      input: { buyAmount: [4, 7, 4], supply: 100, orderQuantity: 20 },
    },
    {
      note: "Over Limit Case",
      input: { buyAmount: [4, 7, 4, 10], supply: 100, orderQuantity: 20 },
    },
  ];

  testLazy1155MultipleBuy.forEach((input) => {
    it(`Test Multiple Lazy-buy 1155:  (For ${input.note}): ${JSON.stringify(input.input)}`, async () => {
      await TestMultipleLazyMint1155(input.input);
    });
  });

  const testLazy1155MultipleOrderBuy = [
    {
      note: "Normal Case",
      input: {
        buyAmount: [
          [4, 7],
          [4, 3],
        ],
        supply: 100,
        orderQuantity: [20, 40],
      },
    },
  ];

  testLazy1155MultipleOrderBuy.forEach((input) => {
    it(`Test Multiple Orders Lazy-buy 1155:  (For ${input.note}): ${JSON.stringify(input.input)}`, async () => {
      await TestMultiOrderInLazyMint1155(input.input);
    });
  });
});

describe("Testing lazy-mint 721 function", () => {
  const testLazy721SingleBuy = [{}];

  testLazy721SingleBuy.forEach((input) => {
    it(`Test Single Buy Lazy-buy 721: ${JSON.stringify(input)}`, async () => {
      await TestLazyMint721(input);
    });
  });
});
