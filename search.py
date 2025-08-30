from ytmusicapi import YTMusic

# Initialize with your authentication file
ytmusic = YTMusic("browser.json")

# Create a new playlist
playlist_id = ytmusic.create_playlist(
    title="My Awesome Mix",
    description="A playlist created with Python!"
)
print(f"Successfully created playlist with ID: {playlist_id}")

# Find a song and add it to the new playlist
search_results = ytmusic.search("Daft Punk Get Lucky")
ytmusic.add_playlist_items(playlist_id, [search_results[0]['videoId']])
print("Added a song to the new playlist!")