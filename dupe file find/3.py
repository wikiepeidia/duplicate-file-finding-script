import sys
import os
import hashlib
from collections import defaultdict

def group_files_by_extension(directory):
    grouped_files = defaultdict(list)
    for filename in os.listdir(directory):
        file_path = os.path.join(directory, filename)
        if os.path.isfile(file_path):
            try:
                decoded_path = file_path.decode('utf-8')  # Try decoding the path
                file_extension = decoded_path.split('.')[-1]
                grouped_files[file_extension].append(decoded_path)
            except UnicodeDecodeError:
                print(f"Error decoding file path: {file_path}")

    return grouped_files

def get_file_size(file_path):
    return os.path.getsize(file_path)

def get_file_content_hash(file_path):
    hasher = hashlib.sha256()
    with open(file_path, 'rb') as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hasher.update(chunk)
    return hasher.hexdigest()

def find_duplicates(directory):
    grouped_files = group_files_by_extension(directory)
    duplicates = []

    for extension, files in grouped_files.items():
        size_groups = defaultdict(list)

        for file_path in files:
            size = get_file_size(file_path)
            size_groups[size].append(file_path)

        for size, files_with_same_size in size_groups.items():
            if len(files_with_same_size) > 1:
                content_hashes = defaultdict(list)

                for file_path in files_with_same_size:
                    content_hash = get_file_content_hash(file_path)
                    content_hashes[content_hash].append(file_path)

                for hash_value, duplicate_files in content_hashes.items():
                    if len(duplicate_files) > 1:
                        duplicates.append(duplicate_files)

    return duplicates

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py /path/to/your/files")
        sys.exit(1)

    directory_path = sys.argv[1]
    if not os.path.isdir(directory_path):
        print("Invalid directory path.")
        sys.exit(1)

    duplicate_groups = find_duplicates(directory_path)

    if duplicate_groups:
        print("Duplicate Files:")
        for group in duplicate_groups:
            print(group)
    else:
        print("No duplicate files found.")
