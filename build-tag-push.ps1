param(    
    [string] $imageVersion='',
    [string] $registryUser='sixeyed',    
    [string] $localRegistry='',    
    [string] $buildArgs='',    
    [bool] $ignoreTestFailures=$false,
    [object[]] $dockerConfig
)

$ErrorActionPreference = 'SilentlyContinue'

# builds and pushes Docker images
# expectations:
#   - directory structure is: {app}/{os}/{arch}, e.g. dotnet/debian/arm64
#   - Dockerfile and context are in the {arch} directory
#   - this command is executed from the {arch} directory
# input:
#   - imageVersion - version of the image being built
#   - registryUser - registry username or organization
#   - localRegistry - registry push destination, in addition to Docker Hub
#   - buildArgs - comma separated values to pass as `build-arg` in Docker build
# output:
#   - image built and pushed with multiple tags using the format {user}/{app}:{version}-{os}-{arch},
#   - e.g. 
#   -  sixeyed/dotnet:3.0-debian-arm64
#   -  sixeyed/dotnet:debian-arm64
#   -  sixeyed/dotnet:arm64

$path = $(pwd).ToString().Split('\')
$count = $path.Length

if (($imageVersion -eq '') -and (Test-Path ..\..\imageVersion.txt)) {
    $imageVersion = Get-Content ..\..\imageVersion.txt
}

$branchName = $path[$count-1]
$osName = $path[$count-2]
$imageName = $path[$count-3]
$fullTag = "$($registryUser)/$($imageName):$($imageVersion)-$($osName)-$($branchName)"

if ($buildArgs.Length -gt 0) {
    $buildArg=@()
    $buildArgsExpanded=$buildArgs.Split(',')
    foreach ($arg in $buildArgsExpanded){
        $buildArg += "--build-arg", $arg
    }
}

Write-Host "* Building image: $fullTag, with args: $buildArg"
& docker $dockerConfig image build $buildArg -t $fullTag .

if (Test-Path ..\..\test.ps1) {
    Write-Host '** Executing test script'
    ..\..\test.ps1 -imageTag $fullTag -dockerConfig $dockerConfig
    if (($LastExitCode -ne 0) -and ($ignoreTestFailures -eq $false)) {
        exit 1
    }
}

Write-Host "* Pushing image tags for: $fullTag"
$tags = @($fullTag,
          "$($registryUser)/$($imageName):$($osName)-$($branchName)",
          "$($registryUser)/$($imageName):$($branchName)")

$registries = @('')
if ($localRegistry -ne '') {
    $registries += "$($localRegistry)/"
}

foreach ($tag in $tags) {        
    Write-Host "** Processing $tag"
    foreach ($registry in $registries){
        $registryTag = "$($registry)$tag"
        Write-Host "** Pushing $registryTag"
        & docker $dockerConfig image tag $fullTag $registryTag
        & docker $dockerConfig image push $registryTag
    }
}