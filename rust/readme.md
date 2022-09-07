# Rust

### 1. Upgrade cargo

```shell
rustc --version
rustup update stable
```

### 2. Cargo cli-command

```shell
cargo build
cargo run
cargo test <fuc_name>
```

### 3. Composition

1. What is composite pattern
    - Partitioning design pattern
    - A group of objects that are treated the same way as a single instance of the same type of object
    - The intent of a composite is to "compose" objects into tree structures to represent part-whole hierarchies
    - Ref: Christian Ivicevic [28 Days of Rust — Part 2: Composition over Inheritance](https://medium.com/comsystoreply/28-days-of-rust-part-2-composition-over-inheritance-cab1b106534a) \

2. From and Into
   - Implementation of `Into<B>` for A for every `From<A>` for B. Said implementation exposes an `A::into()` method that automatically calls `B::from()` that we implement ourselves.
   - Ref: [From and Into](https://doc.rust-lang.org/rust-by-example/conversion/from_into.html) \
   
### 4. Get under the hood of Rust Language with Assembly
- Ref: [Get under the hood of Rust Language with Assembly](https://www.youtube.com/watch?v=lRV_5IBUTes&ab_channel=ChrisHay)

### Reference

[Blog] Roger Torres - [First steps with Docker + Rust](https://dev.to/rogertorres/first-steps-with-docker-rust-30oi) \
[Log] Rust-unofficial - [awesome-rust](https://github.com/rust-unofficial/awesome-rust#audio-and-music) \
[Docs] [Rust by example](https://doc.rust-lang.org/rust-by-example/hello.html) \
[Docs] [Rust design pattern](https://rust-unofficial.github.io/patterns/intro.html) \
[Vid] Baremetal - [Rust Runs on EVERYTHING, Including the Raspberry Pi](https://www.youtube.com/watch?v=jZT8APrzvc4&ab_channel=LowLevelLearning) \
[Vid] Chris Hay - [webassembly system interface (wasi)](https://www.youtube.com/watch?v=MONlkYotR5s&ab_channel=ChrisHay) \
[Vid] Chris Hay - [with tokio by creating an async tcp echo server](https://www.youtube.com/watch?v=DJzgUmH30h8&ab_channel=ChrisHay) \