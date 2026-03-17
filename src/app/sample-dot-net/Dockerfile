FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

# Stage 1: Build environment setup (highly cacheable)
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env

RUN printf '#!/bin/bash \n $(which apt-get) update && $(which apt-get) install -qq -y --no-install-recommends --no-install-suggests --no-upgrade $@ && $(which apt-get) autoremove -y && apt-get clean' > /usr/bin/apt-install
RUN chmod +x /usr/bin/apt-install

# package management
## Add Tini. https://github.com/krallin/tini
RUN set -eux; \
    apt-install apt-transport-https apt-utils ca-certificates openssh-client \
    procps \
    tini \
    ; \
    rm -rf /var/lib/apt/lists/*

WORKDIR /src

# Stage 2: Restore dependencies (cached when .csproj files don't change)
FROM build-env AS restore

# Copy nuget.config first for package sources
COPY nuget.config .

# Restore packages (this layer will be cached when project files don't change)
RUN dotnet restore "<project>.csproj"

# Stage 3: Build application (cached when source code doesn't change)
FROM restore AS build

ARG BUILD_CONFIGURATION=Release

RUN dotnet build "<project>.csproj" -c $BUILD_CONFIGURATION --no-restore

# Stage 4: Publish application (separate layer for publish artifacts)
FROM build AS publish

ARG BUILD_CONFIGURATION=Release

RUN dotnet publish "<project>.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false --no-restore --no-build

FROM base AS final
WORKDIR /app

# Secure, non-root user for the container
RUN addgroup --system workspacegroup; \
    adduser --system --ingroup workspacegroup basil; \
    chown -R basil:workspacegroup /app; \
    chmod -R 755 /app

COPY --from=publish /app/publish .

# run the container as non-root.
USER basil
ENTRYPOINT ["tini", "-g", "--"]
CMD ["dotnet", "<project>.dll"]