# 基底映像：執行階段 
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

# 建構階段 
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build 
WORKDIR /src

# 複製 .csproj 並還原套件
COPY ["MvcK8sTest.csproj", "./"]
RUN dotnet restore "MvcK8sTest.csproj"

# 複製所有檔案並建置
COPY . .
RUN dotnet publish "MvcK8sTest.csproj" -c Release -o /app/publish

# 部署階段
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MvcK8sTest.dll"]