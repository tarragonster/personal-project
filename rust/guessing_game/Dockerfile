FROM rust:1.49 as build

# create a new empty shell project
RUN USER=root cargo new --bin work
WORKDIR /work

# copy over your manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# copy your source tree
COPY ./src ./src

# build for release
RUN rm ./target/release/deps/guessing_game*
RUN cargo build --release

# our final base
FROM rust:1.49-slim-buster as runtime

# copy the build artifact from the build stage
COPY --from=build /work/target/release/guessing_game .

# set the startup command to run your binary
CMD ["./guessing_game"]