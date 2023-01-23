import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nerve/core/services/notification_service.dart';
import 'package:nerve/main.dart';
import '../../core/globalvalues/sizedboxes.dart' as sb;
import '../../core/globalvalues/theme_color.dart';

class ScreenNotification extends StatefulWidget {
  const ScreenNotification({super.key});

  @override
  State<ScreenNotification> createState() => _ScreenNotificationState();
}

final TextEditingController _messageTitle = TextEditingController();
final TextEditingController _messageContent = TextEditingController();

class _ScreenNotificationState extends State<ScreenNotification> {
  final database = dbReference.child('Notifications');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style: GoogleFonts.ubuntu(
                        color: ThemeColor.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: ThemeColor.lightGrey,
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.all(12),
                        child: const FaIcon(
                          FontAwesomeIcons.upload,
                        ),
                      ),
                      onTap: () {
                        messageAddPopUp(context);
                      },
                    ),
                  ],
                ),
                sb.height20,
                FirebaseAnimatedList(
                  query: database,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  defaultChild: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  itemBuilder: (context, snapshot, animation, index) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: ThemeColor.black),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.child('title').value.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            sb.height10,
                            Text(
                              snapshot.child('content').value.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            sb.height10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  snapshot.child('date').value.toString(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                sb.height50
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> messageAddPopUp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: ThemeColor.scaffoldBgColor,
            title: Center(
              child: Text(
                'Add Notifications',
                style: GoogleFonts.ubuntu(
                  color: ThemeColor.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: ThemeColor.shadow,
                          blurRadius: 10,
                          spreadRadius: 0.1,
                          offset: Offset(0, 10)),
                    ],
                    color: ThemeColor.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 5),
                      child: TextField(
                        controller: _messageTitle,
                        showCursor: true,
                        minLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          alignLabelWithHint: true,
                          hintText: 'Title is here',
                          hintStyle:
                              GoogleFonts.ubuntu(color: ThemeColor.black),
                        ),
                      )),
                ),
              ),
              sb.height10,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: ThemeColor.shadow,
                          blurRadius: 10,
                          spreadRadius: 0.1,
                          offset: Offset(0, 10)),
                    ],
                    color: ThemeColor.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 5),
                      child: TextField(
                        controller: _messageContent,
                        showCursor: true,
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          alignLabelWithHint: true,
                          hintText: 'Content is here',
                          hintStyle:
                              GoogleFonts.ubuntu(color: ThemeColor.black),
                        ),
                      )),
                ),
              ),
              sb.height10,
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    if (_messageContent.text.isEmpty) {
                      return;
                    }
                    if (_messageTitle.text.isEmpty) {
                      return;
                    }
                    addNotification(
                      _messageTitle.text,
                      _messageContent.text,
                    );
                    Navigator.pop(context);
                    _messageContent.clear();
                    _messageTitle.clear();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        color: ThemeColor.primary,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        "Upload Message",
                        style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.bold,
                            color: ThemeColor.white),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: Text('Cancel',
                      style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.bold, color: ThemeColor.red)),
                ),
              ),
            ],
          );
        });
  }
}
