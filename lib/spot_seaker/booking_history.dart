import 'package:flutter/material.dart';
import 'package:parkmate/models/bookings.dart';
import 'package:parkmate/spot_seaker/commands/get_booking_history.dart';
import 'package:parkmate/widgets/spot_list_card.dart';
import 'package:parkmate/widgets/styled_spacers.dart';
import 'package:parkmate/widgets/styles.dart';
import 'package:intl/intl.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key, this.isHost = false});
  final bool isHost;
  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  List<Bookings> bookings = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    bookings = await getBookingHistory(context, widget.isHost);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isHost ? "Your bookings" : "Booking history",
            style: TextStyles.h2.copyWith(fontSize: 32.0),
            textAlign: TextAlign.center,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(Insets.lg).copyWith(top: Insets.sm),
          child: ListView(
            children: List.generate(bookings.length, (index) {
              // format the date from DateTime to String containing time
              return SpotListCard(
                image: bookings[index].spot!.image,
                spotName: bookings[index].spot!.name,
                bookingDate: DateFormat('dd-MM-yyyy hh:mm a')
                    .format(bookings[index].bookingDate ?? DateTime.now()),
                rate: "${bookings[index].spot!.ratePerHr} \$/hr",
                amount: "\$ ${bookings[index].totalAmount.toString()}",
              );
            }),
          ),
        ),
      ),
    );
  }
}
