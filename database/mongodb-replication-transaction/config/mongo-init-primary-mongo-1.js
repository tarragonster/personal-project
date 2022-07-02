// https://www.tutorialkart.com/mongodb/mongo-script/

// db.createUser(
//   {
//     user: "tung",
//     pwd: "pass",
//     roles: [
//       {
//         role: "readWrite",
//         db: "dummydb"
//       }
//     ]
//   }
// );

async function main() {
  let initDb = await db.getSiblingDB('dummydb')

  await print(initDb.getCollectionNames())

  const res = await Promise.all([
    initDb.dummycollection.drop(),
    initDb.dummycollection.createIndex({ myfield: 1 }, { unique: true }),
    initDb.dummycollection.createIndex({ thatfield: 1 }),
    initDb.dummycollection.createIndex({ thatfield: 1 }),
    initDb.dummycollection.insert({ myfield: 'hello', thatfield: 'testing' }),
    initDb.dummycollection.insert({ myfield: 'hello2', thatfield: 'testing' }),
    initDb.dummycollection.insert({ myfield: 'hello3', thatfield: 'testing' }),
    initDb.dummycollection.insert({ myfield: 'hello4', thatfield: 'testing' })
  ])

  console.log(res)
}

main()