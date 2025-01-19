import subprocess
import os
import sys
from urllib.parse import urlparse
import argparse
from tqdm import tqdm
import time

def is_url(string):
    """Check if the given string is a URL."""
    try:
        result = urlparse(string)
        return all([result.scheme, result.netloc])
    except ValueError:
        return False

def get_duration(input_path):
    """Get the duration of the video stream."""
    cmd = [
        'ffprobe',
        '-v', 'error',
        '-show_entries', 'format=duration',
        '-of', 'default=noprint_wrappers=1:nokey=1',
        input_path
    ]
    
    try:
        output = subprocess.check_output(cmd).decode().strip()
        return float(output)
    except:
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

    # Basic ffmpeg command
    cmd = [
        'ffmpeg',
        '-i', input_path,
        '-c', 'copy',  # Copy streams without re-encoding
        '-bsf:a', 'aac_adtstoasc',  # Fix audio streams
        '-movflags', '+faststart',  # Enable fast start for web playback
        '-y' if overwrite else '-n',  # Overwrite output if specified
        output_path
    ]

    # If input is a URL, add HTTP options
    if is_url(input_path):
        cmd[1:1] = [
            '-protocol_whitelist', 'file,http,https,tcp,tls,crypto',
            '-reconnect', '1',
            '-reconnect_streamed', '1',
            '-reconnect_delay_max', '20'
        ]

    try:
        # Start conversion
        process = subprocess.Popen(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True
        )

        # Get video duration for progress bar
        duration = get_duration(input_path)
        if duration:
            print(f"Video duration: {duration:.2f} seconds")
            pbar = tqdm(total=100, desc="Converting", unit="%")
            
            # Monitor progress
            last_progress = 0
            while True:
                output = process.stderr.readline()
                if output == '' and process.poll() is not None:
                    break
                    
                if 'time=' in output:
                    time_str = output.split('time=')[1].split()[0]
                    hours, minutes, seconds = map(float, time_str.split(':'))
                    current_time = hours * 3600 + minutes * 60 + seconds
                    progress = min(100, int(100 * current_time / duration))
                    
                    if progress > last_progress:
                        pbar.update(progress - last_progress)
                        last_progress = progress
            
            pbar.close()
        
        # Wait for completion
        process.communicate()
        
        if process.returncode == 0:
            print(f"\nSuccessfully converted {input_path} to {output_path}")
        else:
            raise subprocess.CalledProcessError(process.returncode, cmd)
            
    except subprocess.CalledProcessError as e:
        print(f"Error during conversion: {e}")
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
