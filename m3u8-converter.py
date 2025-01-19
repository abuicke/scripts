import subprocess
import os
import sys
from urllib.parse import urlparse
import argparse

def is_url(string):
    """Check if the given string is a URL."""
    try:
        result = urlparse(string)
        return all([result.scheme, result.netloc])
    except ValueError:
        return False

def read_m3u8_content(filepath):
    """Read the M3U8 file to check if it's a local or remote stream."""
    try:
        with open(filepath, 'r') as f:
            content = f.read()
            return content
    except Exception as e:
        print(f"Error reading M3U8 file: {e}")
        return None

def convert_m3u8_to_mp4(input_path, output_path, overwrite=False):
    """
    Convert M3U8 to MP4 using ffmpeg.
    
    Args:
        input_path (str): Path to input M3U8 file or URL
        output_path (str): Path for output MP4 file
        overwrite (bool): Whether to overwrite existing output file
    """
    if not input_path.endswith('.m3u8'):
        raise ValueError("Input file must have .m3u8 extension")
        
    if not output_path.endswith('.mp4'):
        output_path += '.mp4'
        
    if os.path.exists(output_path) and not overwrite:
        raise FileExistsError(f"Output file {output_path} already exists. Use --overwrite to force conversion.")

    # Enhanced ffmpeg command for HLS streams
    cmd = [
        'ffmpeg',
        '-protocol_whitelist', 'file,http,https,tcp,tls,crypto',  # Allow various protocols
        '-i', input_path,
        '-c', 'copy',  # Copy streams without re-encoding
        '-bsf:a', 'aac_adtstoasc',  # Fix audio streams
        '-movflags', '+faststart',  # Enable fast start for web playback
        '-f', 'mp4',  # Force MP4 format
        '-y' if overwrite else '-n',  # Overwrite output if specified
        output_path
    ]

    try:
        print(f"Converting {input_path} to {output_path}")
        print("This may take a while depending on the file size...")
        
        # Start conversion with more detailed error output
        process = subprocess.Popen(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True
        )
        
        # Monitor the process and print progress
        while True:
            output = process.stderr.readline()
            if output == '' and process.poll() is not None:
                break
            if output:
                # Only print progress lines containing time or speed information
                if 'time=' in output or 'speed=' in output:
                    print(output.strip())
        
        # Get the return code
        returncode = process.poll()
        
        if returncode == 0:
            print(f"\nSuccessfully converted {input_path} to {output_path}")
        else:
            # Check if the input file exists and is readable
            if not os.path.exists(input_path):
                raise FileNotFoundError(f"Input file {input_path} not found")
            
            # Try to read the M3U8 content to provide more detailed error information
            content = read_m3u8_content(input_path)
            if content and not any(line.strip().endswith('.ts') for line in content.splitlines()):
                raise ValueError("The M3U8 file doesn't contain any .ts segments. It might be a master playlist or invalid.")
            
            raise subprocess.CalledProcessError(returncode, cmd)
            
    except subprocess.CalledProcessError as e:
        print(f"Error during conversion: {e}")
        print("\nThis might be because:")
        print("1. The M3U8 file might be a master playlist (contains multiple quality options)")
        print("2. The stream segments (.ts files) are not accessible")
        print("3. The M3U8 file might be corrupted or invalid")
        print("\nTry checking the content of your M3U8 file to ensure it's a valid stream.")
        raise
    except FileNotFoundError:
        print("ffmpeg not found. Please install ffmpeg and make sure it's in your system PATH.")
        raise
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        raise

def main():
    parser = argparse.ArgumentParser(description='Convert M3U8 to MP4')
    parser.add_argument('input', help='Input M3U8 file path or URL')
    parser.add_argument('output', help='Output MP4 file path')
    parser.add_argument('--overwrite', action='store_true', help='Overwrite output file if it exists')
    
    args = parser.parse_args()
    
    try:
        convert_m3u8_to_mp4(args.input, args.output, args.overwrite)
    except Exception as e:
        print(f"Conversion failed: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()