# escape=`
FROM sixeyed/dotnet:3.0-master-stretch-arm64

WORKDIR /src/whoami
COPY src/whoami/whoami.csproj .
RUN dotnet restore

COPY src /src
RUN dotnet publish -c Release -o /app whoami.csproj

EXPOSE 80
ENTRYPOINT ["dotnet", "/app/whoami.dll"]