import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ads plugin performance',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const ListScreen(),
    );
  }
}

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  BannerAd? _banner;
  AnchoredAdaptiveBannerAdSize? _bannerAdSize;

  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Show/hide a banner using the app bar button.'),
        duration: Duration(seconds: 6),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ads plugin performance'),
        actions: [
          IconButton(
              onPressed: () =>
                  _isAdLoaded ? _removeBanner() : _createBannerAd(),
              icon: Icon(_isAdLoaded ? Icons.remove : Icons.add))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: 50,
                itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 4.0, right: 10.0, bottom: 4.0),
                      child: Card(
                        elevation: 2.0,
                        child: ListTile(
                          title: Text('Element $index'),
                        ),
                      ),
                    )),
          ),
          if (_isAdLoaded)
            SizedBox(
                height: _bannerAdSize?.height.toDouble(),
                child: AdWidget(ad: _banner!))
          else
            Container()
        ],
      ),
    );
  }

  Future<void> _createBannerAd() async {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      _bannerAdSize = await AdSize.getAnchoredAdaptiveBannerAdSize(
        Orientation.portrait,
        MediaQuery.of(context).size.width.truncate(),
      );

      _banner = BannerAd(
        // adUnitId: 'your add unit id', // TODO ADD YOUR ADD UNIT ID HERE
        size: _bannerAdSize!,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) => setState(() {
            _isAdLoaded = true;
          }),
          onAdFailedToLoad: (Ad ad, _) {
            ad.dispose();
            _banner = null;
          },
        ),
      )..load();
    });
  }

  void _removeBanner() {
    _banner?.dispose();
    _banner = null;

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _isAdLoaded = false;
      });
    });
  }
}
