-- CreateTable
CREATE TABLE "public"."Track" (
    "youtubeId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "artistName" TEXT NOT NULL,
    "albumName" TEXT NOT NULL,
    "durationSeconds" TEXT NOT NULL,
    "streamUrl" TEXT NOT NULL,

    CONSTRAINT "Track_pkey" PRIMARY KEY ("youtubeId")
);

-- CreateTable
CREATE TABLE "public"."User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Playlist" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "Playlist_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."LikedSong" (
    "userId" TEXT NOT NULL,
    "trackYoutubeId" TEXT NOT NULL,
    "likedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LikedSong_pkey" PRIMARY KEY ("userId","trackYoutubeId")
);

-- CreateTable
CREATE TABLE "public"."PlaylistTrack" (
    "playlistId" TEXT NOT NULL,
    "trackYoutubeId" TEXT NOT NULL,
    "addedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PlaylistTrack_pkey" PRIMARY KEY ("playlistId","trackYoutubeId")
);

-- CreateIndex
CREATE UNIQUE INDEX "Track_streamUrl_key" ON "public"."Track"("streamUrl");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "public"."User"("email");

-- AddForeignKey
ALTER TABLE "public"."Playlist" ADD CONSTRAINT "Playlist_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."LikedSong" ADD CONSTRAINT "LikedSong_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."LikedSong" ADD CONSTRAINT "LikedSong_trackYoutubeId_fkey" FOREIGN KEY ("trackYoutubeId") REFERENCES "public"."Track"("youtubeId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PlaylistTrack" ADD CONSTRAINT "PlaylistTrack_playlistId_fkey" FOREIGN KEY ("playlistId") REFERENCES "public"."Playlist"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PlaylistTrack" ADD CONSTRAINT "PlaylistTrack_trackYoutubeId_fkey" FOREIGN KEY ("trackYoutubeId") REFERENCES "public"."Track"("youtubeId") ON DELETE RESTRICT ON UPDATE CASCADE;
