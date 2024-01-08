function Get-FileContentHash($filePath) {
    $hasher = Get-FileHash -Path $filePath -Algorithm SHA256
    return $hasher.Hash
}

function Find-Duplicates($directory) {
    $groupedFiles = Get-ChildItem -File -Recurse $directory | Group-Object Extension

    $duplicates = @()
    $processedFiles = @{}

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

                    foreach ($firstFile in $duplicateFiles) {
                        if (-not $processedFiles.ContainsKey($firstFile)) {
                            foreach ($duplicateFile in $duplicateFiles) {
                                if ($firstFile -ne $duplicateFile) {
                                    Write-Host "$firstFile is a duplicate of $duplicateFile"
                                }
                            }
                            $processedFiles[$firstFile] = $true
                        }
                    }
                }
            }
        }
    }

    return $duplicates
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

$duplicateGroups = Find-Duplicates -directory $directoryPath

if ($duplicateGroups.Count -gt 0) {
    Write-Host "Duplicate Files:"
    # No need to print here since it's done within the function
} else {
    Write-Host "No duplicate files found."
}
