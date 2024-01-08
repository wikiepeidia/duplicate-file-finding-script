function Get-FileContentHash($filePath) {
    $hasher = Get-FileHash -Path $filePath -Algorithm SHA256
    return $hasher.Hash
}

function Find-Duplicates($directory) {
    $groupedFiles = Get-ChildItem -File -Recurse $directory | Group-Object Extension

    $duplicates = @()
    $processedFiles = @{}
    $duplicatesFound = $false

    foreach ($group in $groupedFiles) {
        $sizeGroups = $group.Group | Group-Object Length

        foreach ($sizeGroup in $sizeGroups) {
            if ($sizeGroup.Count -gt 1) {
                $contentHashes = @{}

                foreach ($file in $sizeGroup.Group) {
                    $contentHash = Get-FileContentHash $file.FullName

                    if (-not $contentHashes.ContainsKey($contentHash)) {
                        $contentHashes[$contentHash] = @()
                    }

                    $contentHashes[$contentHash] += $file.FullName
                }

                foreach ($hashValue in $contentHashes.Keys) {
                    $duplicateFiles = $contentHashes[$hashValue]

                    $duplicateGroup = @()
                    foreach ($firstFile in $duplicateFiles) {
                        if (-not $processedFiles.ContainsKey($firstFile)) {
                            foreach ($duplicateFile in $duplicateFiles) {
                                if ($firstFile -ne $duplicateFile) {
                                    $duplicateGroup += $duplicateFile
                                    $processedFiles[$duplicateFile] = $true
                                }
                            }
                            Write-Host "$firstFile is a duplicate of $($duplicateGroup -join ' and ')"
                            $duplicatesFound = $true
                        }
                    }
                }
            }
        }
    }

    return $duplicatesFound
}

if ($args.Count -ne 1) {
    Write-Host "Usage: script.ps1 'C:\path\to\your\files'"
    exit 1
}

$directoryPath = $args[0]

if (-not (Test-Path $directoryPath -PathType Container)) {
    Write-Host "Invalid directory path."
    exit 1
}

$duplicatesFound = Find-Duplicates -directory $directoryPath

if (-not $duplicatesFound) {
    Write-Host "No duplicate files found."
}