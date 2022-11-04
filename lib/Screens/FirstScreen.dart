import 'package:apod/methods/methods.dart';
import 'package:apod/models/models.dart';
import 'package:flutter/material.dart';
import 'package:stretchy_header/stretchy_header.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FirstScreen extends StatefulWidget {
  FirstScreen({Key? key, this.date}) : super(key: key);
  DateTime? date;
  @override
  State<FirstScreen> createState() => _FirstScreenState(date: date!);
}

bool haiKya = false;
Welcome? x;
Widget? topWidget;
class _FirstScreenState extends State<FirstScreen> {
  DateTime date;
  _FirstScreenState({required this.date});

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width*0.8;
    setState(() {
      haiKya = true;
    });
    waitingForYou();
    setState(() {
      haiKya = false;
    });
    var dateController = TextEditingController();
    return FutureBuilder(
      future: waitingForYou(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                horizontalRotatingDots(color: Colors.white, size: 200),
                const Text(
                  'getting data from the server!',
                  style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: StretchyHeader.listViewBuilder(
                headerData: HeaderData(
                  highlightHeader: SizedBox(
                    width: cWidth+cWidth/4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          x!.title!,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  blurContent: true,
                  blurColor: Colors.black,
                  headerHeight: 250,
                  header: topWidget!,
                ),
                itemCount: 1,
                itemBuilder: (context, i) {
                  return Container(
                    margin: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          x!.explanation!,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                        TextField(
                          controller: dateController,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.calendar_today),
                              labelText:
                                  "${date.day}/${date.month}/${date.year}"),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1996),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate!=null) {
                              date = pickedDate;
                              dateController.text =
                                  '${date.day}/${date.month}/${date.year}';
                            }
                            else{
                              date = DateTime.now();
                              dateController.text =
                              '${date.day}/${date.month}/${date.year}';
                            }
                            setState(() {
                              waitingForYou();
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

  Future<String> waitingForYou() async {
      x = await dateApod(date);
      if(x!.mediaType == 'image'){
        topWidget = Image(
          image: NetworkImage(x!.url!),
          fit: BoxFit.cover,
        );
      }
      else if(x!.mediaType == 'video'){
        var url = x!.url!;
        url = url.substring(29, 41);
        YoutubePlayerController _controller = YoutubePlayerController(
          initialVideoId: url,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            loop: true,
            mute: true,
          ),
        );
        topWidget = YoutubePlayer(controller: _controller,
          progressColors: ProgressBarColors(backgroundColor: Colors.black, handleColor: Colors.white, playedColor: Colors.red),
          progressIndicatorColor: Colors.red,
        );
    }
    return 'es';
  }
}
