# https://hub.docker.com/_/microsoft-dotnet-core
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /WebApi4

# copy csproj and restore as distinct layers
COPY WebApi4/*.csproj .
RUN dotnet restore

# copy and publish app and libraries  --no-restore
COPY . .
RUN dotnet publish -c release -o /app

# final stage/image
FROM mcr.microsoft.com/dotnet/core/runtime:3.1
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "WebApi4.dll"]
