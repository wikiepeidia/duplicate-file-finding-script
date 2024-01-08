function Get-FileContentHash($filePath) {
    $hasher = Get-FileHash -Path $filePath -Algorithm SHA256
    return $hasher.Hash
}

function Find-Duplicates($directory) {
    $groupedFiles = Get-ChildItem -File -Recurse $directory | Group-Object Extension

    $duplicates = @()

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

                    if ($duplicateFiles.Count -gt 1) {
                        $duplicates += $duplicateFiles
                    }
                }
            }
        }
    }

    return $duplicates
}

$directoryPath = Read-Host "Enter the directory path"

if (-not (Test-Path $directoryPath -PathType Container)) {
    Write-Host "Invalid directory path."
    exit 1
}

$duplicateGroups = Find-Duplicates -directory $directoryPath

if ($duplicateGroups.Count -gt 0) {
    Write-Host "Duplicate Files:"
    foreach ($group in $duplicateGroups) {
        Write-Host $group
    }
} else {
    Write-Host "No duplicate files found."
}
