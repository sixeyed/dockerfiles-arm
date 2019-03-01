param(    
    [string] $os='stretch',
    [string] $arch='arm64',
    [bool] $ignoreTestFailures=$false,
    [object[]] $dockerConfig
)

$osArch="$os\$arch\"
$startPath=$(pwd)

$dockerfiles = Get-ChildItem -Filter Dockerfile -recurse | where {
$_.FullName.Contains($osArch) }

Write-Host "* Building $($dockerfiles.Length) Dockerfiles for $osArch"

try {
    $dockerfiles | foreach {
        Write-Host "** Building $($_.FullName)"
        $path = $_.DirectoryName
        cd $path
        ..\..\..\build-tag-push.ps1 -ignoreTestFailures $ignoreTestFailures
    }
}
finally {
    cd $startPath
}