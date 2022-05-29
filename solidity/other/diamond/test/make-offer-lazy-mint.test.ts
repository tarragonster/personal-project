/* eslint-disable camelcase */
import {
  TestMakeOfferLazyMint721,
  TestMultipleAccept_MakeOfferLazyMint1155,
  TestSingleMakeOfferLazyMint1155,
} from "./make-offer-lazy-mint.func";

describe("Testing make-offer lazy-mint 1155 function", () => {
  const testLazy1155Single = [
    {
      note: "Normal Case",
      input: {
        supply: 100,
        orderQuantity: 20,
        offerPrice: 20,
        offerQuantity: 10,
        acceptQuantity: 10,
      },
    },
    {
      note: "Normal Case",
      input: {
        supply: 100,
        orderQuantity: 20,
        offerPrice: 20,
        offerQuantity: 10,
        acceptQuantity: 10,
      },
    },
    {
      note: "Normal Case",
      input: {
        supply: 100,
        orderQuantity: 20,
        offerPrice: 20,
        offerQuantity: 10,
        acceptQuantity: 10,
      },
    },
    {
      note: "Over Limit Case",
      input: {
        supply: 100,
        orderQuantity: 20,
        offerPrice: 20,
        offerQuantity: 10,
        acceptQuantity: 10,
      },
    },
  ];
  testLazy1155Single.forEach((input) => {
    it(`Test Single Lazy-Make-Offer 1155 (For ${input.note}): ${JSON.stringify(
      input.input
    )}`, async () => {
      await TestSingleMakeOfferLazyMint1155(input.input);
    });
  });

  const testMultipleAccept = [
    {
      note: "Normal Case",
      input: {
        supply: 100,
        orderQuantity: 20,
        offerPrice: 20,
        offerQuantity: 17,
        acceptQuantity: [10, 5],
      },
    },
    // {
    //   note: "Normal Case",
    //   input: {
    //     supply: 100,
    //     orderQuantity: 20,
    //     offerPrice: 20,
    //     offerQuantity: [3, 5],
    //   },
    // },
    // {
    //   note: "Normal Case",
    //   input: {
    //     supply: 100,
    //     orderQuantity: 20,
    //     offerPrice: 20,
    //     offerQuantity: [5, 5],
    //   },
    // },
    // {
    //   note: "Over Limit Case",
    //   input: {
    //     supply: 100,
    //     orderQuantity: 20,
    //     offerPrice: 20,
    //     offerQuantity: [6, 5],
    //   },
    // },
  ];

  testMultipleAccept.forEach((input) => {
    it(`Test Multiple Lazy-Make-Offer 1155:  (For ${
      input.note
    }): ${JSON.stringify(input.input)}`, async () => {
      await TestMultipleAccept_MakeOfferLazyMint1155(input.input);
    });
  });

  // const testLazy1155MultipleOrderBuy = [
  //   {
  //     note: "Normal Case",
  //     input: {
  //       buyAmount: [
  //         [4, 7],
  //         [4, 3],
  //       ],
  //       supply: 100,
  //       orderAmount: [20, 40],
  //     },
  //   },
  // ];
  //
  // testLazy1155MultipleOrderBuy.forEach((input) => {
  //   it(`Test Multiple Orders Lazy-buy 1155:  (For ${
  //     input.note
  //   }): ${JSON.stringify(input.input)}`, async () => {
  //     await TestMultiOrderInLazyMint1155(input.input);
  //   });
  // });
});

describe("Testing make-offer lazy-mint 721 function", () => {
  const testLazy721SingleBuy = [{ offerPrice: 10 }];

  testLazy721SingleBuy.forEach((input) => {
    it(`Test Single Buy Lazy-Make-Offer 721: ${JSON.stringify(
      input
    )}`, async () => {
      await TestMakeOfferLazyMint721(input);
    });
  });
});
