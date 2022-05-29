/* eslint-disable camelcase */
import {
    TestMigration,
} from "./migration.func";

describe("Testing migration function", () => {
    const migrationData = [
        {
            note: "Normal Case",
            input: { buyAmount: 4, supply: 100, orderAmount: 20 },
        },
        {
            note: "Normal Case",
            input: { buyAmount: 10, supply: 100, orderAmount: 20 },
        },
    ];

    migrationData.forEach((input) => {
        it(`Test migration (For ${input.note}): ${JSON.stringify(
            input.input
        )}`, async () => {
            await TestMigration(input.input);
        });
    });
});