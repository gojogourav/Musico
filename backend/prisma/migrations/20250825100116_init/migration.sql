/*
  Warnings:

  - The primary key for the `LikedSong` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `trackYoutubeId` on the `LikedSong` table. All the data in the column will be lost.
  - The primary key for the `PlaylistTrack` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `trackYoutubeId` on the `PlaylistTrack` table. All the data in the column will be lost.
  - You are about to drop the `Track` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[username]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `uploadedTrackId` to the `LikedSong` table without a default value. This is not possible if the table is not empty.
  - Added the required column `uploadedTrackId` to the `PlaylistTrack` table without a default value. This is not possible if the table is not empty.
  - Added the required column `name` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `username` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "public"."LikedSong" DROP CONSTRAINT "LikedSong_trackYoutubeId_fkey";

-- DropForeignKey
ALTER TABLE "public"."PlaylistTrack" DROP CONSTRAINT "PlaylistTrack_trackYoutubeId_fkey";

-- AlterTable
ALTER TABLE "public"."LikedSong" DROP CONSTRAINT "LikedSong_pkey",
DROP COLUMN "trackYoutubeId",
ADD COLUMN     "uploadedTrackId" TEXT NOT NULL,
ADD CONSTRAINT "LikedSong_pkey" PRIMARY KEY ("userId", "uploadedTrackId");

-- AlterTable
ALTER TABLE "public"."PlaylistTrack" DROP CONSTRAINT "PlaylistTrack_pkey",
DROP COLUMN "trackYoutubeId",
ADD COLUMN     "uploadedTrackId" TEXT NOT NULL,
ADD CONSTRAINT "PlaylistTrack_pkey" PRIMARY KEY ("playlistId", "uploadedTrackId");

-- AlterTable
ALTER TABLE "public"."User" ADD COLUMN     "name" TEXT NOT NULL,
ADD COLUMN     "username" TEXT NOT NULL;

-- DropTable
DROP TABLE "public"."Track";

-- CreateTable
CREATE TABLE "public"."UploadedTrack" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "artistName" TEXT NOT NULL,
    "albumName" TEXT,
    "durationSeconds" INTEGER NOT NULL,
    "fileUrl" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" TEXT NOT NULL,

    CONSTRAINT "UploadedTrack_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "UploadedTrack_fileUrl_key" ON "public"."UploadedTrack"("fileUrl");

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "public"."User"("username");

-- AddForeignKey
ALTER TABLE "public"."UploadedTrack" ADD CONSTRAINT "UploadedTrack_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."LikedSong" ADD CONSTRAINT "LikedSong_uploadedTrackId_fkey" FOREIGN KEY ("uploadedTrackId") REFERENCES "public"."UploadedTrack"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PlaylistTrack" ADD CONSTRAINT "PlaylistTrack_uploadedTrackId_fkey" FOREIGN KEY ("uploadedTrackId") REFERENCES "public"."UploadedTrack"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
