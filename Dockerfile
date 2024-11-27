# Use the Dart official image as the base image
FROM dart:stable AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Dart project files to the container
COPY pubspec.* ./

# Get dependencies
RUN dart pub get

# Step 5: Check for outdated dependencies
# This step will print a summary of outdated dependencies in the logs
# Don't fail the build if outdated dependencies are found
RUN dart pub outdated || true

COPY . .

# Ensure all dependencies are resolved and downloaded
RUN dart pub get --offline

# Compile the CLI application to a native executable (optional)
RUN dart compile exe bin/candle_setup_finder.dart -o bin/candle_setup_finder

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/candle_setup_finder /app/bin/

# Expose the application entry point
ENTRYPOINT ["/app/bin/candle_setup_finder"]
