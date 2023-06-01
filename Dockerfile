FROM rust:1.69.0 as builder

WORKDIR /usr/app
RUN USER=root cargo new --bin hello
WORKDIR /usr/app/hello

# 2. Copy the files in your machine to the Docker image
COPY ./Cargo.toml  ./Cargo.toml

RUN cargo build --release
RUN rm src/*.rs
COPY ./src ./src

# 5. Build for release.
RUN rm ./target/release/deps/hello*
RUN cargo build --release
#--------

FROM debian:buster-slim
# RUN apt-get update && apt-get install -y extra-runtime-dependencies && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/app/hello/target/release/hello /usr/local/bin/hello
CMD ["hello"]
