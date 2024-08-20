import 'package:flutter/material.dart';
import 'package:parkmate/models/spot.dart';
import 'package:parkmate/providers/app_provider.dart';
import 'package:parkmate/providers/spot_host_provider.dart';
import 'package:parkmate/providers/spot_seeker_provider.dart';
import 'package:parkmate/splash_view.dart';
import 'package:parkmate/spot_host/add_spot.dart';
import 'package:parkmate/spot_host/commands/get_registered_spots.dart';
import 'package:parkmate/spot_host/host_profile.dart';
import 'package:parkmate/spot_seaker/booking_history.dart';
import 'package:parkmate/spot_seaker/spot_map.dart';
import 'package:parkmate/widgets/park_mate_button.dart';
import 'package:parkmate/widgets/spot_card.dart';
import 'package:parkmate/widgets/styled_spacers.dart';
import 'package:parkmate/widgets/styles.dart';
import 'package:provider/provider.dart';

class HostDashboard extends StatefulWidget {
  const HostDashboard({super.key});

  @override
  State<HostDashboard> createState() => _HostDashboardState();
}

class _HostDashboardState extends State<HostDashboard> {
  List<Spot> spots = [];
  List<Spot> filteredSpots = [];

  void getFilteredSpots(BuildContext context, String query) async {
    filteredSpots.clear();
    for (var spot in spots) {
      if (spot.name.toLowerCase().contains(query.toLowerCase())) {
        filteredSpots.add(spot);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.read<AppProvider>();
    final String searchQuery = context.read<SpotSeekerProvider>().searchQuery;
    final bool isLoading = context.select(
      (SpotSeekerProvider spotSeekerProvider) =>
          spotSeekerProvider.isFetchingSpots,
    );
    spots = context.select(
      (SpotSeekerProvider spotSeekerProvider) => spotSeekerProvider.spots,
    );
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          title: Text(
            "My Spots",
            style: TextStyles.h2.copyWith(fontSize: 32.0),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                appProvider.signOut();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SafeArea(
                      child: Scaffold(
                        body: SplashView(),
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(Insets.lg),
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  context.read<SpotSeekerProvider>().searchQuery = value;
                  getFilteredSpots(context, value);
                },
                decoration: InputDecoration(
                  hintText: "Search for parking spots",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Insets.med),
                  ),
                ),
              ),
              VSpace.lg,
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await getRegisteredSpotsData(context);
                  },
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : spots.isEmpty
                          ? ListView(
                              children: [
                                Center(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height -
                                        100, // Adjust the height as needed
                                    child: const Center(
                                        child: Text("No spots found")),
                                  ),
                                ),
                              ],
                            )
                          : GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 0.9,
                              crossAxisSpacing: Insets.med,
                              mainAxisSpacing: Insets.med,
                              children: List.generate(
                                searchQuery.isNotEmpty
                                    ? filteredSpots.length
                                    : spots.length,
                                (index) {
                                  Spot spot = searchQuery.isNotEmpty
                                      ? filteredSpots[index]
                                      : spots[index];
                                  return SpotCard(
                                    spot: spot,
                                    theme: theme,
                                    isHost: true,
                                  );
                                },
                              ),
                            ),
                ),
              ),
              VSpace.lg,
              ParkMateButton(
                onTap: () {
                  context.read<SpotHostProvider>().clear();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddSpot(),
                    ),
                  ).then((value) {
                    if (value == true) {
                      getRegisteredSpotsData(context);
                    }
                  });
                },
                text: "Add Spot",
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                ),
                child: const Center(
                    child: Text('ParkMate App Menu',
                        style: TextStyle(color: Colors.white, fontSize: 24.0))),
              ),
              ListTile(
                title: const Text('Spot Maps'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SafeArea(
                        child: Scaffold(
                          body: SpotMap(
                            spots: spots,
                            isHost: true,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Bookings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingHistory(
                        isHost: true,
                      ),
                    ),
                  );
                },
              ),
              // profile
              ListTile(
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HostProfile(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
