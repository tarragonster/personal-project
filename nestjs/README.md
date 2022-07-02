# Nestjs

### My problems and understanding

- Service and repository class instance will be instantiated on compilation.
- service/repo can be then injected as dependency injection, these service/repo
  would not be allowed to create new instance (Singleton enforced).
- These class will be registered in app.module.
- create instance of app.module in main.ts -> get instance of register service/repo/controller
using app.get: Example:

```javascript
const configService = app.get(ConfigService);
```
- configService will be then used as an instance and injected into other class
  through constructor/method
  
### What is Injectable?

- @Injectable() is how you tell Nest this is a class that can have dependencies that should be instantiated by Nest and its DI system
- Class will be instantiated at compile time
### Interceptor

- Ref: [Cast entity to dto](https://stackoverflow.com/questions/53378667/cast-entity-to-dto) \
- [Cast entity to dto](https://stackoverflow.com/questions/53378667/cast-entity-to-dto)

### class-transformer

- map type to transform ex: string->number (@query)
- map type conditional - [more-than-one-type-option](https://github.com/typestack/class-transformer#providing-more-than-one-type-option)
- dynamic dto - [Using a dynamic DTO property in a NestJS API](https://www.darraghoriordan.com/2021/10/26/nestjs-multiple-dynamic-models/)
- transform a nested json object in Dto - [Nestjs - What is the correct way to create a DTO file to transform a nested json object?](https://stackoverflow.com/questions/61860550/nestjs-what-is-the-correct-way-to-create-a-dto-file-to-transform-a-nested-json)

### Transaction mongoose

[Blog] wanago.io - [Transactions in MongoDB and Mongoose](https://wanago.io/2021/09/06/api-nestjs-transactions-mongodb-mongoose/)

### Mongoose pagination
- app library
[Github] aravindnc - [mongoose-paginate-v2](https://github.com/aravindnc/mongoose-paginate-v2/tree/d0f24bf5a3cae7492142999b8ec5831ae6665b1f)

### class-validator (validate dto)

- Ref: [class-validator](https://github.com/typestack/class-validator)

### Nested schema with decorators

```javascript
// Nested Schema
@Schema()
export class BodyApi extends Document {
  @Prop({ required: true })
  type: string;

  @Prop()
  content: string;
}
export const BodySchema = SchemaFactory.createForClass(BodyApi);

// Parent Schema
@Schema()
export class ChaptersApi extends Document {
  // Array example
  @Prop({ type: [BodySchema], default: [] })
  body: BodyContentInterface[];

  // Single example
  @Prop({ type: BodySchema })
  body: BodyContentInterface;
}
export const ChaptersSchema = SchemaFactory.createForClass(ChaptersApi);
```

- Ref: austinthedeveloper/Azamat Abdullaev - [NestJS - How to create nested schema with decorators](https://stackoverflow.com/questions/62762492/nestjs-how-to-create-nested-schema-with-decorators)

###nestjs-jwts

- Ref: vladwulf - [nestjs-jwts](https://github.com/vladwulf/nestjs-jwts)

###Global module in NestJs

- Ref: Juan Rambal - [How to use Global module in NestJs](https://stackoverflow.com/questions/64114712/how-to-use-global-module-in-nestjs)

### References

[Github] Michael Guay - [nestjs repo](https://github.com/mguay22) \
[Github] Vladimir Agaev - [nestjs-jwts](https://github.com/vladwulf/nestjs-jwts) \
[QA] [Nestjs Dependency Injection - Inject service into service](https://stackoverflow.com/questions/61953178/nestjs-dependency-injection-inject-service-into-service) \
`If you are needing the AService in another module, you should add the AService to the AModule's exports array, and add AModule to the new module's imports array.`
[Blog] [What is Injectable in NestJS?](https://stackoverflow.com/questions/64349628/what-is-injectable-in-nestjs) \
[Docs] [Nestjs Mongo](https://docs.nestjs.com/techniques/mongodb#async-configuration) \