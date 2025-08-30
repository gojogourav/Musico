# Save this file as play_song_v2.py

import sys
import subprocess
from ytmusicapi import YTMusic
from urllib.parse import parse_qs, unquote
import shlex # Used for better debugging output

def get_best_audio_url(video_id: str):
    """
    Fetches song data and correctly assembles the playable URL
    by parsing the signatureCipher.
    """
    try:
        ytmusic = YTMusic("browser.json")
        song_details = ytmusic.get_song(videoId=video_id)
        
        audio_streams = [
            f for f in song_details['streamingData']['adaptiveFormats'] 
            if 'audio' in f['mimeType']
        ]

        if not audio_streams:
            raise ValueError("No audio streams were found in the response.")

        best_audio = max(audio_streams, key=lambda x: x['bitrate'])
        
        if 'signatureCipher' in best_audio:
            cipher_params = parse_qs(best_audio['signatureCipher'])
            url = unquote(cipher_params['url'][0])
            signature = cipher_params['s'][0]
            sp = cipher_params.get('sp', ['sig'])[0]
            final_url = f"{url}&{sp}={signature}"
            return final_url
        else:
            raise ValueError("Could not find a 'signatureCipher' for the best audio stream.")

    except Exception as e:
        print(f"An error occurred while getting the URL: {e}", file=sys.stderr)
        return None

def play_audio(video_id: str, audio_url: str):
    """
    Plays the audio from a given URL using ffplay, adding multiple
    browser headers to avoid 403 Forbidden errors.
    """
    if not audio_url:
        print("No audio URL was provided. Cannot play.", file=sys.stderr)
        return
        
    print("\nStreaming audio...")
    
    try:
        # We now add both User-Agent and Referer to be more convincing
        user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        # The Referer should be the page the media is "on"
        referer = f"https://music.youtube.com/watch?v={video_id}"

        # Combine headers for ffplay's -headers flag
        # The '\r\n' is important for separating headers
        headers = f"User-Agent: {user_agent}\r\nReferer: {referer}\r\n"

        command = [
            "ffplay",
            "-nodisp",
            "-autoexit",
            "-loglevel", "error",
            "-headers", headers,  # Use the -headers flag for multiple headers
            audio_url
        ]

        # --- DEBUGGING ---
        # Print the exact command being run so you can inspect it.
        # shlex.join is the proper way to format a command for display.
        print("\n--- Running Command ---")
        print(shlex.join(command))
        print("-----------------------\n")
        # -----------------
        
        subprocess.run(command, check=True)

    except FileNotFoundError:
        print("\n--- ERROR ---", file=sys.stderr)
        print("Command 'ffplay' not found.", file=sys.stderr)
        print("Please ensure FFmpeg is installed and in your system's PATH.", file=sys.stderr)
    except subprocess.CalledProcessError as e:
        print(f"\n--- FFPLAY ERROR ---", file=sys.stderr)
        print(f"ffplay exited with an error: {e}", file=sys.stderr)
        print("This means the server rejected the request. Please ensure browser.json is new.", file=sys.stderr)

### Main Execution Block ###
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python play_song_v2.py <videoId>", file=sys.stderr)
        sys.exit(1)
        
    video_id_to_play = sys.argv[1]
    
    print(f"Fetching audio link for video ID: {video_id_to_play}...")
    final_audio_link = get_best_audio_url(video_id_to_play)
    
    if final_audio_link:
        play_audio(video_id_to_play, final_audio_link)