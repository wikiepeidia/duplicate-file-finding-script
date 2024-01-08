# duplicate files finding script

This script is designed quickly to find any duplicate files in a large batch.

## Table of Contents
- [Usage](#Usage)
- [Benefits](#Benefits)
- [How to Use](#How-to-Use)
- [Contributing](#Sources)
- [Release](#Releases)
- [Notices](#Notices)

## Usage
- The script is capable of identifying duplicating files within a large batch.
- It can detect multiple instances of duplicate files with various extensions.
- The output will specify which file is a duplicate of another, for example: `1.mp3 is a duplicate of 2.mp3 and 3.mp3 and 4.mp3`, etc.
- (FUTURE) You will have the option to choose what action to take with the duplicate files (delete, move, or copy). You will also be able to specify which file extensions to exclude from the check.

## Benefits
- This script is very useful for identifying and managing duplicate files within a large batch, thereby saving HDD space.

## How to Use
- This is a PowerShell script. To ensure it runs consistently, you need to execute `Set-ExecutionPolicy -ExecutionPolicy bypass`. If you encounter an "access denied" message, please check permissions and the current user.
- Similar to the [file shuffle script](https://github.com/wikiepeidia/files-shuffle-script/), you just need to specify the location of the PS1 file and indicate the location to be checked. PowerShell is required. If the directory is in the same location as your PS script, the following command should work: `& '.\file.ps1' "PATH TO FOLDER"`.

## Sources
- Chat GPT (8/1/2024)
- GitHub Copilot (8/1/2024)

## Releases
[Download Latest Release](https://github.com/wikiepeidia/duplicate-file-finding-script/releases)

### V1
- Build 8 - ChatGPT - 8/1/2024
  - Issues:
    - Prints "no duplicate found" even when duplicates exist.
    does not group together multiple duplicates of a single file (e.g., 1.mp3 is a duplicate of 2.mp3, 2.mp3 is a duplicate of 3.mp3).
    - Trouble handling special characters (brackets, etc.).

### V1.1
- Build 9 - ChatGPT - 8/1/2024
  - Successfully groups duplicates to reduce the output lines, but other issues from V1 still persist.

### V1.2
- Build 11 - GitHub Copilot - 8/1/2024
  - Rewritten with assistance from Copilot to address the "no duplicate found" issue. Special character handling remains unresolved.

### V1.3
- Build 18 - ChatGPT + Copilot - 8/1/2024
  - All addressed issues have been fixed, but further issues require examination.

### V1.4
- Build 19 - Copilot - 8/1/2024
  - The ability to handle 1000+ files has been upgraded, as well as most bugs are gone.

## Beta Releases
### V1 Python Development
- Build 1-3, Chat GPT, 8/1/2024
  - Abandoned due to inconvenience (requires Python and an annoying technique to run it). None of these builds actually work.

### V1 PowerShell Development
- Build 4-8, Chat GPT, 8/1/2024
  - Addressed issues: runs in the command line instead of needing script edits, improved printings.

### V1.2 Development
- Build 10, Copilot, 8/1/2024
  - Utilizes Copilot to fix printing issues, but does not work.

### V1.3 Development
- Build 12-17, ChatGPT + Copilot, 8/1/2024
  - Uses ChatGPT + Copilot to address issues in handling characters, but does not return any hash. Debug builds are 16-17.

## Notices
- This script is safe to use.
- **REMEMBER**: this script is not smart enough to detect files that might be different in codecs and others, e.g., 1.mp3, 2.ogg has the same content converted by some software or 2.mp3 (190kbps) and 3.mp3 (128kbps) or a text file that just has a space at the end...The main purpose is to quickly check for 100% duplicates.
- PowerShell is required, and running `Set-ExecutionPolicy -ExecutionPolicy bypass` is necessary for successful execution of scripts.
- Using [beta](#beta-releases) versions may result in data loss or errors.
- To reduce the number of files in the release section, only certain files will be uploaded to the main branch.
