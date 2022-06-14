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


### References

[Github] Michael Guay - [nestjs repo](https://github.com/mguay22) \
[Github] Vladimir Agaev - [nestjs-jwts](https://github.com/vladwulf/nestjs-jwts) \