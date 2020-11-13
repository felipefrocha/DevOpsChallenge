FROM mcr.microsoft.com/dotnet/sdk:3.1 AS builder
WORKDIR /app
COPY ./src ./
RUN dotnet restore && \
  dotnet build --configuration Release --no-restore

FROM builder as tester
WORKDIR /app
RUN dotnet test

FROM builder as releaser
RUN dotnet publish -c Release -o ./out/

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS prd
WORKDIR /app
HEALTHCHECK --interval=1m --timeout=5s \
  CMD curl --fail http://localhost:5000/healthPrd || exit
ENV DOTNET_ENVIRONMENT ''
COPY --from=releaser /app/out .
CMD ["dotnet","/app/MyWebApp.dll"]

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS dev
WORKDIR /app
HEALTHCHECK --interval=15s --timeout=5s \
  CMD curl --fail http://localhost:5000/healthDev || exit
ENV DOTNET_ENVIRONMENT development
COPY --from=releaser /app/out .
CMD ["dotnet","/app/MyWebApp.dll"]
