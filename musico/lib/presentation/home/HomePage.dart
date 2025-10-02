import 'package:flutter/material.dart';
import 'package:musico/core/assets/app_vectors.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16,
            top: 16,
            bottom: 120,
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "👋 Hi Gourav,",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        _getGreeting(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),

                  Spacer(),
                  const Row(
                    children: [
                      Icon(
                        Icons.notifications,
                        size: 28,
                        color: Color.fromARGB(99, 255, 255, 255),
                      ),
                      SizedBox(width: 16),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 40.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              HorizontalButtons(),
              SizedBox(height: 20),
              Text("Featuring Today", style: TextStyle(fontSize: 28)),
              SizedBox(height: 20),
              const _HorizontalBanners(),
              SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Recently Played", style: TextStyle(fontSize: 28)),
                  Spacer(),
                  Text("See more", style: TextStyle(fontSize: 16)),
                ],
              ),

              SizedBox(height: 20),
              _HorizontalSongs(),
              SizedBox(height: 20),
              Text("Albums for you", style: TextStyle(fontSize: 28)),
              SizedBox(height: 20),

              _HorizontalMixes(),
              SizedBox(height: 20),
              Text("Todays Recommendations", style: TextStyle(fontSize: 28)),

              SizedBox(height: 20),
              SizedBox(width: double.infinity, child: ReccomendationsCard()),
            ],
          ),
        ),
      ),
    );
  }
}

class ReccomendationsCard extends StatefulWidget {
  const ReccomendationsCard({Key? key}) : super(key: key);

  @override
  State<ReccomendationsCard> createState() => _ReccomendationCardState();
}

class HorizontalButtons extends StatefulWidget {
  const HorizontalButtons({super.key});

  @override
  State<HorizontalButtons> createState() => _HorizontalButtonsState();
}

class _ReccomendationCardState extends State<ReccomendationsCard> {
  final List<Map<String, String>> _songs = List.generate(
    22,
    (index) => {'title': 'Song Title ${index + 1}', 'artist': 'Artist Name'},
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 450,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(52, 255, 255, 255),
            Color.fromARGB(59, 158, 158, 158),
            Color.fromARGB(0, 224, 224, 224),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    AppVectors.reccomendation1,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Peace",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "22 songs",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 28,
                          ),
                          const Spacer(),
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            child: const Icon(
                              Icons.play_arrow,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: _songs.length,
                itemBuilder: (context, index) {
                  final song = _songs[index];
                  return ListTile(
                    leading: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    title: Text(
                      song['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      song['artist']!,
                      style: const TextStyle(color: Colors.white54),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalButtonsState extends State<HorizontalButtons> {
  int _selectedIndex = 0;

  final List<String> categories = [
    'All',
    'Music',
    'Podcasts',
    'Gaming',
    'Sports',
    'News',
    'Live',
    'Comedy',
    'Technology',
    'Fashion',
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.0,

      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final bool isSelected = _selectedIndex == index;

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected
                  ? const Color.fromARGB(54, 158, 158, 158)
                  : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              elevation: 0,
            ),
            onPressed: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Text(
              categories[index],
              style: TextStyle(
                color: const Color.fromARGB(111, 255, 255, 255),
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HorizontalSongs extends StatefulWidget {
  const _HorizontalSongs({super.key});

  @override
  State<_HorizontalSongs> createState() => _HorizontalSongsState();
}

class _HorizontalSongsState extends State<_HorizontalSongs> {
  final List<_BannerItem> songs = const [
    _BannerItem(imageUrl: AppVectors.song1, title: "Inside Out"),
    _BannerItem(imageUrl: AppVectors.song2, title: "Young"),
    _BannerItem(imageUrl: AppVectors.song3, title: "Beach House"),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160, // increased height to fit image + text
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: songs.length,
        itemBuilder: (BuildContext context, int index) {
          final song = songs[index];
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image + Play button overlay
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        song.imageUrl,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 22,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Song title below image
                SizedBox(
                  width: 120,
                  child: Text(
                    song.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(206, 255, 255, 255),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HorizontalMixes extends StatefulWidget {
  const _HorizontalMixes({super.key});

  @override
  State<_HorizontalMixes> createState() => _HorizontalMixesState();
}

//FOR MIXES

class _HorizontalMixesState extends State<_HorizontalMixes> {
  final List<_BannerItem> songs = const [
    _BannerItem(imageUrl: AppVectors.album1, title: "Saiyaara"),
    _BannerItem(imageUrl: AppVectors.album2, title: "Love Aajkal"),
    _BannerItem(imageUrl: AppVectors.album3, title: "Lunch Break"),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160, // increased height to fit image + text
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: songs.length,
        itemBuilder: (BuildContext context, int index) {
          final song = songs[index];
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image + Play button overlay
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        song.imageUrl,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Song title below image
                SizedBox(
                  width: 120,
                  child: Row(
                    children: [
                      Icon(
                        Icons.explicit,
                        color: const Color.fromARGB(104, 255, 255, 255),
                      ),
                      SizedBox(width: 10),
                      Text(
                        song.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(206, 255, 255, 255),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BannerItem {
  final String imageUrl;
  final String title;
  final String? subtitle;
  final String? title2;

  const _BannerItem({
    required this.imageUrl,
    required this.title,
    this.title2,
    this.subtitle,
  });
}

class _HorizontalBanners extends StatefulWidget {
  const _HorizontalBanners({super.key});

  @override
  State<_HorizontalBanners> createState() => _HorizontalBannersState();
}

class _HorizontalBannersState extends State<_HorizontalBanners> {
  final List<_BannerItem> bannerImages = [
    const _BannerItem(
      imageUrl: AppVectors.banner1,
      subtitle: "New",
      title: "ENGLISH",
      title2: "SONGS",
    ),
    const _BannerItem(
      imageUrl: AppVectors.banner2,
      title: 'LIVE NOW',
      subtitle: 'Classib R&B',
    ),
    const _BannerItem(
      imageUrl: AppVectors.banner3,
      title: 'EDM ',
      title2: 'BANGERS',
      subtitle: 'This Week',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: bannerImages.length,
        itemBuilder: (BuildContext context, int index) {
          final item = bannerImages[index];

          return SizedBox(
            width: 300,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Image.asset(bannerImages[index].imageUrl, fit: BoxFit.cover),

                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (item.subtitle != null)
                          Text(
                            item.subtitle!,
                            style: textTheme.labelLarge?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        Text(
                          item.title,
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (item.title2 != null)
                          Text(
                            item.title2!,
                            style: textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
