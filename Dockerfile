FROM quay.imanuel.dev/dockerhub/library---dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/influx_alerter.dart -o bin/influx_alerter

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/influx_alerter /bin/

# Start server.
CMD ["/bin/influx_alerter"]