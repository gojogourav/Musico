import sys
import json
from ytmusicapi import YTMusic

try:
    if len(sys.argv) < 2:
        raise ValueError("A search query must be provided.")
        
    search_query = sys.argv[1]
    
    # Print the query to stderr for debugging
    print(f"Searching for: {search_query}", file=sys.stderr)
    
    # Use your browser.json for a more stable, authenticated request
    ytmusic = YTMusic("browser.json") 
    
    search_results = ytmusic.search(search_query, limit=5)
    search_results = search_results[:5]

    # This remains the ONLY print to standard output
    print(json.dumps(search_results))

except Exception as e:
    print(json.dumps({"error": str(e)}), file=sys.stderr)
    sys.exit(1)