# adapted from https://raw.githubusercontent.com/dotnet/dotnet-docker/master/2.2/sdk/bionic/arm32v7/Dockerfile
FROM debian:9.7-slim

# Install .NET CLI dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu57 \
        liblttng-ust0 \
        libssl1.0.2 \
        libstdc++6 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Install .NET Core SDK
ENV DOTNET_SDK_VERSION="3.0-master"

RUN curl -SL -o dotnet.tar.gz https://dotnetcli.blob.core.windows.net/dotnet/Sdk/master/dotnet-sdk-latest-linux-arm64.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \    
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && rm dotnet.tar.gz

# Add NuGet cache (ARM SDK doesn't include it)
# -- doesn't seem necessary for arm64
#RUN curl -SL --output /usr/share/dotnet/sdk/$DOTNET_SDK_VERSION/nuGetPackagesArchive.lzma https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/nuGetPackagesArchive.lzma \
#    && lzma_sha512='d2a0a35d981feefc0ca154e03cfddab379a839226330db6bb8b18b05abbb51d524475bbdb5407064faee609aa616bf5db44ab18d8aad4d4a3625bbdf0f7b824c' \
#    && echo "$lzma_sha512 /usr/share/dotnet/sdk/$DOTNET_SDK_VERSION/nuGetPackagesArchive.lzma" | sha512sum -c -

# Configure web servers to bind to port 80 when present
ENV ASPNETCORE_URLS=http://+:80 \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip

# Trigger first run experience by running arbitrary cmd to populate local package cache
RUN dotnet help