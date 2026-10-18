import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const HydroLensApp());
}

class HydroLensApp extends StatefulWidget {
  const HydroLensApp({super.key});

  @override
  State<HydroLensApp> createState() => _HydroLensAppState();
}

class _HydroLensAppState extends State<HydroLensApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() => isDarkMode = !isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HydroLens',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      theme: ThemeData(
        fontFamily: 'Roboto',
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDarkMode ? const Color(0xFF10121A) : const Color(0xFFF3F5FA),
        cardColor: isDarkMode ? const Color(0xFF1A1D28) : Colors.white,
        useMaterial3: true,
      ),
      home: HydroLensMainController(
        isDarkMode: isDarkMode,
        onToggleTheme: toggleTheme,
      ),
    );
  }
}

Widget buildBrandLogo({required double size, required double fontSize}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(size * 0.28),
      gradient: const LinearGradient(
        colors: [Color(0xFF8B88E8), Color(0xFF63C5D6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF8B88E8).withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Center(
      child: Text(
        'H',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    ),
  );
}

class SensorRecord {
  final DateTime time;
  final int humidity;
  final int light;
  final bool isSimulated;

  SensorRecord({
    required this.time,
    required this.humidity,
    required this.light,
    required this.isSimulated,
  });
}

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class HydroLensMainController extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const HydroLensMainController({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<HydroLensMainController> createState() => _HydroLensMainControllerState();
}

class _HydroLensMainControllerState extends State<HydroLensMainController> {
  int _selectedIndex = 0;

  int? humidityPercent;
  int? lightLux;

  bool isBluetoothConnected = false;
  bool isSimulationActive = false;
  bool isAutoPilot = true;
  DateTime? lastUpdate;

  bool isAwaitingSprayAck = false;
  bool isSprayCooldown = false;
  String sprayBtnLabel = 'إصدار أمر ترطيب (وضع محاكاة العرض)';

  // المتغيرات المطلوبة لتشغيل الإعدادات التفاعلية الجديدة
  bool eyeRestReminderEnabled = true;
  int reminderIntervalMinutes = 20;

  List<SensorRecord> sensorHistory = [];
  List<Map<String, dynamic>> notifications = [];

  final TextEditingController _chatInputController = TextEditingController();
  List<ChatMessage> chatMessages = [
    ChatMessage(
      text: 'مرحباً بك! أنا مساعد HydroLens الذكي. يمكنك الاستفسار عن القراءات المتاحة والتوصيات المناسبة للعرض.',
      isUser: false,
    ),
  ];

  @override
  void dispose() {
    _chatInputController.dispose();
    super.dispose();
  }

  // تصحيح رسالة نجاح الترطيب لتتوافق مع العرض الأكاديمي
  Future<void> _triggerManualSpray() async {
    if (isSprayCooldown || isAwaitingSprayAck) {
      _showSnackBar('إجراء آمن: يرجى الانتظار لحين انتهاء مهلة الأمان (60 ثانية)! ⏳');
      return;
    }

    setState(() {
      isAwaitingSprayAck = true;
      sprayBtnLabel = 'جاري إرسال الأمر للنظارة بانتظار التأكيد... 🔄';
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      isAwaitingSprayAck = false;
      isSprayCooldown = true;
      sprayBtnLabel = 'اكتملت محاكاة الترطيب 💧';
    });

    _showSnackBar('اكتملت محاكاة أمر الترطيب بنجاح 💧');

    Timer(const Duration(seconds: 60), () {
      if (mounted) {
        setState(() {
          isSprayCooldown = false;
          sprayBtnLabel = 'إصدار أمر ترطيب (وضع محاكاة العرض)';
        });
      }
    });
  }

  void _processDataInput(int hum, int lux, {required bool simulated}) {
    final now = DateTime.now();
    setState(() {
      humidityPercent = hum;
      lightLux = lux;
      lastUpdate = now;
      isSimulationActive = simulated;

      sensorHistory.insert(
        0,
        SensorRecord(
          time: now,
          humidity: hum,
          light: lux,
          isSimulated: simulated,
        ),
      );
    });

    if (hum < 40) {
      _addNotification('تنبيه جفاف الجو المحيط', 'انخفاض الرطوبة إلى $hum%. يوصى بأخذ استراحة وترطيب.');
    }
    if (lux > 800) {
      _addNotification('تنبيه إضاءة عالية جداً', 'ارتفاع الضوء إلى $lux Lux. يفضل تقليل السطوع.');
    }
  }

  void _addNotification(String title, String desc) {
    setState(() {
      notifications.insert(0, {
        'title': title,
        'desc': desc,
        'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        'read': false,
      });
    });
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 3)),
    );
  }

  void _handleSendMessage() {
    final text = _chatInputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      chatMessages.add(ChatMessage(text: text, isUser: true));
      _chatInputController.clear();
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      String reply = '';

      if (humidityPercent == null || lightLux == null) {
        reply = 'لا توجد قراءات مسجلة حالياً. يرجى تفعيل إحدى سيناريوهات المحاكاة للعرض.';
      } else if (text.contains('رطوبة') || text.contains('جفاف')) {
        reply = 'قراءة الرطوبة القريبة حالياً مسجلة عند $humidityPercent%.';
      } else if (text.contains('إضاءة') || text.contains('ضوء')) {
        reply = 'شدة الإضاءة المحيطة الحالية مسجلة عند $lightLux Lux.';
      } else {
        reply = 'القراءات الحالية للعرض: الرطوبة $humidityPercent% والإضاءة $lightLux Lux.';
      }

      setState(() {
        chatMessages.add(ChatMessage(text: reply, isUser: false));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = Theme.of(context).cardColor;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            buildBrandLogo(size: 32, fontSize: 18),
            const SizedBox(width: 10),
            const Text('HydroLens', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBluetoothConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
              color: isBluetoothConnected ? Colors.teal : Colors.grey,
            ),
            onPressed: () => setState(() => _selectedIndex = 8),
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round, color: Colors.amber),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF8B88E8), Color(0xFF63C5D6)]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildBrandLogo(size: 48, fontSize: 26),
                  const SizedBox(height: 8),
                  const Text('منصة HydroLens الذكية', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const Text('وضع العرض والمحاكاة الأكاديمية 🧪', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
            _drawerItem(0, Icons.dashboard_rounded, '1. الرئيسية'),
            _drawerItem(1, Icons.remove_red_eye_rounded, '2. مراقبة العين'),
            _drawerItem(2, Icons.light_mode_rounded, '3. الإضاءة المحيطة'),
            _drawerItem(3, Icons.water_drop_rounded, '4. الترطيب الذكي'),
            _drawerItem(4, Icons.smart_toy_rounded, '5. المساعد الذكي'),
            _drawerItem(5, Icons.history_rounded, '6. سجل القراءات'),
            _drawerItem(6, Icons.bar_chart_rounded, '7. التقارير والإحصائيات'),
            _drawerItem(7, Icons.notifications_active_rounded, '8. مركز التنبيهات'),
            _drawerItem(8, Icons.settings_remote_rounded, '9. حالة النظارة والحساسات'),
            _drawerItem(9, Icons.person_outline_rounded, '10. الإعدادات والخصوصية'),
          ],
        ),
      ),
      body: _buildCurrentPage(cardBg),
    );
  }

  Widget _drawerItem(int index, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: _selectedIndex == index ? const Color(0xFF5B61F4) : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
          color: _selectedIndex == index ? const Color(0xFF5B61F4) : null,
          fontSize: 13,
        ),
      ),
      selected: _selectedIndex == index,
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildCurrentPage(Color cardBg) {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardPage(cardBg);
      case 1:
        return _buildEyeMonitoringPage(cardBg);
      case 2:
        return _buildLightSystemPage(cardBg);
      case 3:
        return _buildHydrationPage(cardBg);
      case 4:
        return _buildAIAssistantPage(cardBg);
      case 5:
        return _buildReadingsHistoryPage(cardBg);
      case 6:
        return _buildReportsPage(cardBg);
      case 7:
        return _buildNotificationsCenterPage(cardBg);
      case 8:
        return _buildGlassesSettingsPage(cardBg);
      case 9:
        return _buildPersonalSettingsPage(cardBg);
      default:
        return _buildDashboardPage(cardBg);
    }
  }

  Widget _buildDashboardPage(Color cardBg) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: Colors.orange),
                    SizedBox(width: 6),
                    Text('وضع المحاكاة للعرض الأكاديمي [بيانات تجريبية]', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text(
                  lastUpdate != null
                      ? 'آخر تحديث: ${lastUpdate!.hour}:${lastUpdate!.minute.toString().padLeft(2, '0')}'
                      : 'بانتظار الاختيار',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  cardBg,
                  'رطوبة محيط العين',
                  humidityPercent != null ? '$humidityPercent%' : 'بانتظار البيانات...',
                  humidityPercent == null
                      ? 'غير متوفرة'
                      : (humidityPercent! < 40 ? 'منخفضة' : (humidityPercent! <= 49 ? 'معتدلة' : 'ضمن النطاق المحدد')),
                  Icons.water_drop,
                  Colors.teal,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildOverviewCard(
                  cardBg,
                  'الإضاءة المحيطة',
                  lightLux != null ? '$lightLux Lux' : 'بانتظار البيانات...',
                  lightLux == null
                      ? 'غير متوفرة'
                      : (lightLux! < 300 ? 'أقل من النطاق' : (lightLux! <= 500 ? 'ضمن النطاق المستهدف' : 'مرتفعة جداً')),
                  Icons.light_mode,
                  Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('نظام الترطيب التلقائي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Switch(
                      value: isAutoPilot,
                      activeThumbColor: const Color(0xFF5B61F4),
                      onChanged: (v) => setState(() => isAutoPilot = v),
                    ),
                  ],
                ),
                const Text('محاكاة إطلاق الرذاذ التلقائي عند انخفاض الرطوبة.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: (isSprayCooldown || isAwaitingSprayAck) ? null : _triggerManualSpray,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (isSprayCooldown || isAwaitingSprayAck) ? Colors.grey : const Color(0xFF5B61F4),
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.water, color: Colors.white, size: 16),
                  label: Text(
                    sprayBtnLabel,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('اختبار المحاكاة [خاص بلجنة المناقشة] 🧪', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _processDataInput(28, 890, simulated: true),
                        child: const Text('محاكاة جفاف وإضاءة عالية', style: TextStyle(fontSize: 10, color: Colors.red)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _processDataInput(58, 310, simulated: true),
                        child: const Text('محاكاة وضع مريح ومثالي', style: TextStyle(fontSize: 10, color: Colors.green)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(Color cardBg, String title, String val, String sub, IconData icon, Color col) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: col, size: 18),
              Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          Text(val, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(sub, style: TextStyle(fontSize: 9, color: col, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildEyeMonitoringPage(Color cardBg) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('نظام مراقبة رطوبة الجو المحيط بالعين 👁️', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('يقيس الحساس رطوبة الجو المباشر أمام العين، ولا يعد ذلك تشخيصاً طبياً مباشراً.', style: TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('مستوى الرطوبة الحالية:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      humidityPercent != null ? '$humidityPercent%' : 'بانتظار البيانات...',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _statusLine('أقل من 40%:', 'منخفضة (تطلب ترطيباً واستراحة).'),
                _statusLine('40% – 49%:', 'معتدلة (حالة آمنة وتستدعي المتابعة).'),
                _statusLine('50% – 70%:', 'ضمن النطاق المحدد (مستوى مريح للعين).'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusLine(String label, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          const SizedBox(width: 6),
          Expanded(child: Text(desc, style: const TextStyle(fontSize: 11, color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildLightSystemPage(Color cardBg) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('مراقبة شدة الإضاءة المحيطة (Lux) 💡', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('القراءة الحالية:'),
                    Text(
                      lightLux != null ? '$lightLux Lux' : 'بانتظار البيانات...',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _statusLine('300 – 500 Lux:', 'ضمن النطاق المستهدف المريح.'),
                _statusLine('أعلى من 800 Lux:', 'مرتفعة جداً (ينصح بتقليل السطوع).'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHydrationPage(Color cardBg) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('نظام التحكم بالترطيب والرذاذ 💧', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  title: const Text('حالة نظام الرش الذكي'),
                  subtitle: Text(isAutoPilot ? 'النظام التلقائي مفعل' : 'النظام التلقائي متوقف'),
                  trailing: Switch(
                    value: isAutoPilot,
                    onChanged: (v) => setState(() => isAutoPilot = v),
                  ),
                ),
                const Divider(),
                ElevatedButton(
                  onPressed: (isSprayCooldown || isAwaitingSprayAck) ? null : _triggerManualSpray,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B61F4), minimumSize: const Size(double.infinity, 45)),
                  child: Text(sprayBtnLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIAssistantPage(Color cardBg) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('مساعد HydroLens الذكي 🧠', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
              child: ListView.builder(
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  final msg = chatMessages[index];
                  return Align(
                    alignment: msg.isUser ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: msg.isUser ? const Color(0xFF5B61F4) : (widget.isDarkMode ? const Color(0xFF2B2E3D) : const Color(0xFFE8ECF5)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(fontSize: 12, color: msg.isUser ? Colors.white : null),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatInputController,
                  decoration: InputDecoration(
                    hintText: 'اسأل عن القراءات والتقارير...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF5B61F4)),
                onPressed: _handleSendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReadingsHistoryPage(Color cardBg) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('سجل القراءات التجريبية المحفوظ 📜', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: sensorHistory.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('لا توجد قراءات مسجلة حالياً.', style: TextStyle(color: Colors.grey)),
                  Text('قم بتفعيل أزرار المحاكاة في الرئيسية لبدء التوثيق.', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            )
                : ListView.builder(
              itemCount: sensorHistory.length,
              itemBuilder: (context, index) {
                final item = sensorHistory[index];
                return Card(
                  color: cardBg,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text('رطوبة: ${item.humidity}% | إضاءة: ${item.light} Lux'),
                    subtitle: Text(
                      'الوقت: ${item.time.hour}:${item.time.minute.toString().padLeft(2, '0')} [بيانات تجريبية للعرض]',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsPage(Color cardBg) {
    if (sensorHistory.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text('لا توجد بيانات كافية لإعداد التقرير التجميعي.', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('يرجى إجراء قراءات تجريبية لعرض المتوسطات الحسابية.', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    double avgHum = sensorHistory.map((e) => e.humidity).reduce((a, b) => a + b) / sensorHistory.length;
    double avgLight = sensorHistory.map((e) => e.light).reduce((a, b) => a + b) / sensorHistory.length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('التقارير والإحصائيات [محسوبة ديناميكياً] 📊', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• إجمالي السجلات بالتطبيق: ${sensorHistory.length} سجل تجريبي.'),
                const SizedBox(height: 6),
                Text('• متوسط رطوبة الجو المحيط: ${avgHum.toStringAsFixed(1)}%.'),
                const SizedBox(height: 6),
                Text('• متوسط شدة الإضاءة المحيطة: ${avgLight.toStringAsFixed(1)} Lux.'),
                const SizedBox(height: 6),
                Text('• إجمالي التنبيهات المسجلة: ${notifications.length} إشعار.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCenterPage(Color cardBg) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('مركز التنبيهات الإشعارية 🔔', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (notifications.isNotEmpty)
                TextButton(
                  onPressed: () => setState(() => notifications.clear()),
                  child: const Text('مسح التنبيهات', style: TextStyle(color: Colors.red, fontSize: 11)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: notifications.isEmpty
                ? const Center(child: Text('لا توجد إشعارات مسجلة حالياً.', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, i) {
                final item = notifications[i];
                return Card(
                  color: cardBg,
                  child: ListTile(
                    title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text(item['desc'], style: const TextStyle(fontSize: 11)),
                    trailing: Text(item['time'], style: const TextStyle(fontSize: 9, color: Colors.grey)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassesSettingsPage(Color cardBg) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('حالة النظارة وعرض النظام 📡', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('نمط المشروع الحالي'),
                  subtitle: Text('تطبيق Flutter متكامل للعرض والمناقشة (مخصص للواجهات والمحاكاة الآمنة).'),
                ),
                Divider(),
                ListTile(
                  title: Text('حالة بروتوكول البلوتوث'),
                  subtitle: Text('جاهز للربط الفعلي عند توفر مكتبات Serial البرمجية لقطعة ESP32.'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. صفحة الإعدادات والخصوصية المعدلة تفاعلياً
  Widget _buildPersonalSettingsPage(Color cardBg) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('الإعدادات العامة والخصوصية 🔒', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('تذكير الراحة (قاعدة 20-20-20)'),
                  subtitle: Text('تنبيه أوتوماتيكي كل $reminderIntervalMinutes دقيقة لإراحة العين.'),
                  value: eyeRestReminderEnabled,
                  activeColor: const Color(0xFF5B61F4),
                  onChanged: (v) => setState(() => eyeRestReminderEnabled = v),
                ),
                const Divider(),
                const ListTile(
                  title: Text('حفظ السجل المحلي (Local Memory Storage)'),
                  subtitle: Text('تخزين السجلات مؤقتاً في ذاكرة التطبيق الحالية للعرض.'),
                ),
                const Divider(),
                const ListTile(
                  title: Text('سياسة الخصوصية'),
                  subtitle: Text('النسخة الحالية تجريبية ولا تقوم بإرسال أي بيانات إلى خوادم خارجية.'),
                ),
                const Divider(),
                const ListTile(
                  title: Text('حول النظام'),
                  subtitle: Text('HydroLens - الإصدار 1.0.0 (مشروع تخرج أكاديمي).'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
