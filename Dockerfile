# Use the Dart official image as the base image
FROM dart:stable AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Dart project files to the container
COPY pubspec.yaml pubspec.lock ./
COPY bin/ ./bin/
COPY lib/ ./lib/
COPY analysis_options.yaml ./
COPY test/ ./test/

# Get dependencies
RUN dart pub get

COPY . .

# Ensure all dependencies are resolved and downloaded
RUN dart pub get --offline

# Compile the CLI application to a native executable (optional)
RUN dart compile exe bin/candle_setup_finder.dart -o /app/bin/candle_setup_finder

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/candle_setup_finder /app/bin

#FROM debian:buster-slim

#WORKDIR /app

#COPY --from=build /app/bin/candle_setup_finder /app/candle_setup_finder

# Expose the application entry point
ENTRYPOINT ["/app/bin/candle_setup_finder"]
