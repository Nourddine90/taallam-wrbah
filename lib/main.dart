import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'screens/skill_screen.dart';
import 'screens/market_screen.dart';
import 'screens/wallet_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaallamApp());
}

class TaallamApp extends StatelessWidget {
  const TaallamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تعلم وربح',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterTts _tts = FlutterTts();
  int daysLeftInTrial = 30;
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    _initTTS();
  }

  Future<void> _initTTS() async {
    await _tts.setLanguage('ar');
    await _tts.setSpeechRate(0.5);
    await _tts.speak('مرحبا بيك في تطبيق تعلم وربح');
  }

  void _showPaywall() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('خلص 29 درهم باش تكمل'),
        content: const Text('الفترة التجريبية سالات. خاصك تخلص الاشتراك.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('من بعد')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => isSubscribed = true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('خلص دابا - 29 درهم'),
          ),
        ],
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    const url = 'https://wa.me/212711366556';
    if (await canLaunchUrl(Uri.parse(url))) await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(children: [
          Text('تعلم وربح', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('by Nourddine Abatal', style: TextStyle(fontSize: 14)),
        ]),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.green.shade300, Colors.green.shade600]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.timer, color: Colors.white, size: 30),
              const SizedBox(width: 10),
              Text('الأيام المجانية: $daysLeftInTrial يوم',
                  style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
            ]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                _buildButton('🎓', Colors.orange, () {
                  _tts.speak('تعلم حرفة');
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SkillScreen()));
                }),
                const SizedBox(height: 20),
                _buildButton('🛒', Colors.blue, () {
                  _tts.speak('سوق الحومة');
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketScreen()));
                }),
                const SizedBox(height: 20),
                _buildButton('💰', Colors.green, () {
                  _tts.speak('فلوسي');
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()));
                }),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: _openWhatsApp,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(color: const Color(0xFF25D366), borderRadius: BorderRadius.circular(16)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                  Icon(Icons.support_agent, color: Colors.white, size: 30),
                  SizedBox(width: 10),
                  Text('الدعم عبر واتساب', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Center(child: Text(icon, style: const TextStyle(fontSize: 40))),
      ),
    );
  }
}
