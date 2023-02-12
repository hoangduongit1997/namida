import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:namida/controller/indexer_controller.dart';
import 'package:namida/controller/settings_controller.dart';
import 'package:namida/core/icon_fonts/broken_icons.dart';
import 'package:namida/core/translations/strings.dart';
import 'package:namida/ui/widgets/artwork.dart';
import 'package:namida/core/extensions.dart';
import 'package:namida/ui/widgets/library/artist_tile.dart';
import 'package:namida/ui/widgets/library/track_tile.dart';

class ArtistsPage extends StatelessWidget {
  ArtistsPage({super.key});
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      controller: _scrollController,
      child: AnimationLimiter(
        child: Obx(
          () => ListView.builder(
            controller: _scrollController,
            itemCount: Indexer.inst.artistSearchList.length,
            itemBuilder: (BuildContext context, int i) {
              final artist = Indexer.inst.groupedArtistsMap.entries.toList()[i];
              return AnimationConfiguration.staggeredList(
                position: i,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  verticalOffset: 25.0,
                  child: FadeInAnimation(
                    duration: const Duration(milliseconds: 400),
                    child: ArtistTile(
                      tracks: artist.value.toList(),
                      name: artist.key,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ArtistTracksPage extends StatelessWidget {
  final List<Track> artist;
  final String name;
  ArtistTracksPage({super.key, required this.artist, required this.name});

  @override
  Widget build(BuildContext context) {
    // final AlbumTracksController albumtracksc = AlbumTracksController(album);
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Broken.arrow_left_2)),
          title: Text(
            artist[0].artistsList.toString(),
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        body: ListView(
          // cacheExtent: 1000,
          children: [
            // Top Container holding image and info and buttons
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(24.0),
              height: Get.width / 2.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0.multipliedRadius),
                    ),
                    width: 140,
                    child: Hero(
                      tag: 'artist$name',
                      child: ArtworkWidget(
                        thumnailSize: SettingsController.inst.albumThumbnailSizeinList.value,
                        track: artist.elementAt(0),
                        compressed: false,
                        // size: (SettingsController.inst.albumThumbnailSizeinList.value * 2).round(),

                        // borderRadiusValue: 8.0,
                        forceSquared: SettingsController.inst.forceSquaredAlbumThumbnail.value,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 18.0,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 18.0,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Text(
                            artist[0].album,
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Text(
                            [artist.displayTrackKeyword, if (artist.isNotEmpty) artist.totalDurationFormatted].join(' - '),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 14),
                          ),
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),
                        Row(
                          // mainAxisAlignment:
                          //     MainAxisAlignment.spaceEvenly,
                          children: [
                            const Spacer(),
                            FittedBox(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Playback.instance.open(
                                  //   [...widget.playlist.tracks]..shuffle(),
                                  // );
                                },
                                child: const Icon(Broken.shuffle),
                              ),
                            ),
                            const Spacer(),
                            FittedBox(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Playback.instance.open(
                                  //   [
                                  //     ...widget.playlist.tracks,
                                  //     if (Configuration.instance.seamlessPlayback) ...[...Collection.instance.tracks]..shuffle()
                                  //   ],
                                  // );
                                },
                                child: Row(
                                  children: [
                                    const Icon(Broken.play),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(Language.inst.PLAY_ALL),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            ...artist
                .asMap()
                .entries
                .map((track) => TrackTile(
                      track: track.value,
                    ))
                .toList()
          ],
        ),
      ),
    );
  }
}
