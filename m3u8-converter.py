import subprocess
import os
import sys
from urllib.parse import urlparse
import argparse

def verify_ts_segments(m3u8_path):
    """Verify that all .ts segments referenced in the M3U8 file exist."""
    directory = os.path.dirname(m3u8_path)
    missing_segments = []
    
    with open(m3u8_path, 'r') as f:
        for line in f:
            if line.strip().endswith('.ts'):
                ts_path = os.path.join(directory, line.strip())
                if not os.path.exists(ts_path):
                    missing_segments.append(line.strip())
    
    return missing_segments

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

    # Check for missing .ts segments
    missing_segments = verify_ts_segments(input_path)
    if missing_segments:
        print("Warning: The following .ts segments are missing:")
        for segment in missing_segments:
            print(f"  - {segment}")
        print("\nPlease ensure all .ts files are in the same directory as the M3U8 file.")
        return

    # Basic ffmpeg command
    cmd = [
        'ffmpeg',
        '-allowed_extensions', 'ALL',  # Allow all extensions
        '-i', input_path,
        '-c', 'copy',  # Copy streams without re-encoding
        '-bsf:a', 'aac_adtstoasc',  # Fix audio streams
        '-movflags', '+faststart',  # Enable fast start for web playback
        '-y' if overwrite else '-n',  # Overwrite output if specified
        output_path
    ]

    try:
        print(f"Converting {input_path} to {output_path}")
        print("This may take a while depending on the file size...")
        
        # Start conversion
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
                print(output.strip())
        
        returncode = process.poll()
        
        if returncode == 0:
            print(f"\nSuccessfully converted {input_path} to {output_path}")
        else:
            raise subprocess.CalledProcessError(returncode, cmd)
            
    except subprocess.CalledProcessError as e:
        print(f"Error during conversion: {e}")
        print("\nThis might be because:")
        print("1. The .ts segments are not in the same directory as the M3U8 file")
        print("2. The .ts segments have different names than what's listed in the M3U8 file")
        print("3. There might be permission issues accessing the files")
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