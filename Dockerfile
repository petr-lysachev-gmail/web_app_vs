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

#deploy to app engine
#FROM gcr.io/cloud-builders/gcloud
#RUN gcloud app deploy app/bin/Debug/netcoreapp3.1/publish/app.yaml 

FROM gcr.io/cloud-builders/gcloud
##RUN gcloud config set account 84196235246@cloudbuild.gserviceaccount.com
##RUN gcloud auth activate-service-account 84196235246@cloudbuild.gserviceaccount.com
RUN gcloud auth login
RUN gcloud app deploy --image-url=gcr.io/travelauthorizationpoc/web_app_vs:4d5fb2f664097926010525b5a807c27340fbae64
