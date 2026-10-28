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
      title: 'HydroLens - Smart Eyewear Platform',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        fontFamily: 'Roboto',
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        cardColor: Colors.white,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardColor: const Color(0xFF1E293B),
        useMaterial3: true,
      ),
      home: LandingScreen(
        isDarkMode: isDarkMode,
        onToggleTheme: toggleTheme,
      ),
    );
  }
}

// ----------------- الصفحة الرئيسية التعريفية الشاملة (Landing Page) -----------------
class LandingScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const LandingScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = Theme.of(context).cardColor;
    final primaryColor = const Color(0xFF5B61F4);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 1,
        title: Row(
          children: [
            buildBrandLogo(size: 38, fontSize: 20),
            const SizedBox(width: 10),
            const Text(
              'HydroLens',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round, color: Colors.amber),
            onPressed: onToggleTheme,
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(
                      isDarkMode: isDarkMode,
                      onToggleTheme: onToggleTheme,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              ),
              icon: const Icon(Icons.dashboard, color: Colors.white, size: 16),
              label: const Text(
                'لوحة التحكم',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [const Color(0xFF1E1B4B), const Color(0xFF0F172A)]
                      : [const Color(0xFFEEF2FF), const Color(0xFFF8FAFC)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  buildBrandLogo(size: 90, fontSize: 45),
                  const SizedBox(height: 24),
                  const Text(
                    'النظارة الذكية لحماية صحة العين',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 650),
                    child: const Text(
                      'منظومة تقنية متكاملة لتشخيص وحماية صحة البصر، تجمع بين وحدات استشعار متطورة (ESP32) لمنع جفاف العين ومراقبة الإضاءة المحيطة، مدعومة بمنصة ويب تفاعلية ومساعد ذكي لتحليل البيانات بشكل لحظي.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                isDarkMode: isDarkMode,
                                onToggleTheme: onToggleTheme,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: const Icon(Icons.login, color: Colors.white),
                        label: const Text(
                          'الدخول للنظام وربط النظارة',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Features Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Column(
                children: [
                  const Text(
                    'مميزات تقنية HydroLens المتقدمة',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'تم تصميم النظام ليوفر حماية متكاملة بصرية وتقنية',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildFeatureCard(
                        context,
                        title: 'الترطيب الأوتوماتيكي الذكي 💧',
                        desc: 'استشعار الجفاف وإطلاق رذاذ مائي ناعم تلقائياً للمحافظة على رطوبة منطقة العين.',
                        icon: Icons.water_drop_rounded,
                        color: Colors.teal,
                      ),
                      _buildFeatureCard(
                        context,
                        title: 'مراقبة الإضاءة المحيطة 💡',
                        desc: 'قياس شدة الضوء بـ Lux وتنبيه المستخدم لتعديل السطوع لحماية الشبكية.',
                        icon: Icons.light_mode_rounded,
                        color: Colors.amber,
                      ),
                      _buildFeatureCard(
                        context,
                        title: 'المساعد والتحليل الذكي 🧠',
                        desc: 'مساعد ذكي يحلل السجلات السابقة ويعطي توصيات مخصصة للراحة وفق قاعدة 20-20-20.',
                        icon: Icons.smart_toy_rounded,
                        color: Colors.indigo,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // How it Works Section
            Container(
              color: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              width: double.infinity,
              child: Column(
                children: [
                  const Text(
                    'كيف تعمل المنظومة؟',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStepItem('1', 'مستشعرات النظارة', 'قراءة معدل الرمش والإضاءة'),
                        const Icon(Icons.arrow_back, color: Colors.grey),
                        _buildStepItem('2', 'معالجة ESP32', 'إتخاذ القرار والترطيب الذكي'),
                        const Icon(Icons.arrow_back, color: Colors.grey),
                        _buildStepItem('3', 'لوحة التحكم الويب', 'عرض التقارير والإحصائيات'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Contact Us Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      const Text('تواصل معنا / الدعم الأكاديمي 📩', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('يسعدنا استقبال الاستفسارات والاقتراحات حول مشروع HydroLens', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'الاسم الكريم / الجهة',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'الرسالة أو الأستفسار',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم استلام رسالتك بنجاح. شكراً لتواصلك!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('إرسال الرسالة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              color: isDarkMode ? const Color(0xFF090D16) : const Color(0xFFE2E8F0),
              width: double.infinity,
              child: Column(
                children: [
                  const Text(
                    'حقوق الطبع محفوظة © 2026 | مشروع تخرج HydroLens الذكي',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, {required String title, required String desc, required IconData icon, required Color color}) {
    final cardBg = Theme.of(context).cardColor;
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            radius: 28,
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.5), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildStepItem(String stepNum, String title, String sub) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFF5B61F4),
          radius: 18,
          child: Text(stepNum, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

// ----------------- شاشة تسجيل الدخول -----------------
class LoginScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const LoginScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final TextEditingController _glassesIdController = TextEditingController(
    text: 'GL-SYS-9021',
  );
  bool _isSignUpMode = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _glassesIdController.dispose();
    super.dispose();
  }

  void _handleAuthAction() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() => _isLoading = false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HydroLensMainController(
              userEmail: _emailController.text.trim(),
              glassesId: _glassesIdController.text.trim(),
              isDarkMode: widget.isDarkMode,
              onToggleTheme: widget.onToggleTheme,
            ),
          ),
        );
      });
    }
  }

  void _showPasswordResetDialog() {
    final resetController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('استعادة كلمة المرور'),
        content: TextField(
          controller: resetController,
          decoration: const InputDecoration(labelText: 'أدخل بريدك الإلكتروني'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إرسال رابط إعادة تعيين كلمة المرور.')),
              );
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = Theme.of(context).cardColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round, color: Colors.amber),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildBrandLogo(size: 70, fontSize: 36),
                  const SizedBox(height: 16),
                  Text(_isSignUpMode ? 'إنشاء حساب جديد' : 'منصة HydroLens الذكية', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(_isSignUpMode ? 'تسجيل مستخدم جديد وربط الجهاز' : 'تسجيل الدخول وربط معرف النظارة', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) => (value == null || !value.contains('@')) ? 'يرجى إدخال بريد إلكتروني صحيح' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) => (value == null || value.length < 6) ? 'كلمة المرور يجب أن لا تقل عن 6 خانات' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _glassesIdController,
                    decoration: InputDecoration(
                      labelText: 'معرف النظارة (Glasses ID)',
                      prefixIcon: const Icon(Icons.qr_code_scanner),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'معرف النظارة مطلوب' : null,
                  ),
                  const SizedBox(height: 8),
                  if (!_isSignUpMode)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _showPasswordResetDialog,
                        child: const Text('هل نسيت كلمة المرور؟', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleAuthAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B61F4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(_isSignUpMode ? 'إنشاء حساب جديد' : 'دخول لوحة التحكم', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => setState(() => _isSignUpMode = !_isSignUpMode),
                    child: Text(_isSignUpMode ? 'لديك حساب بالفعل؟ سجل دخولك' : 'ليس لديك حساب؟ أنشئ حساباً جديداً'),
                  ),
                ],
              ),
            ),
          ),
        ),
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
          color: const Color(0xFF8B88E8).withOpacity(0.3),
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

// ----------------- لوحة التحكم الرئيسية والمساعد الذكي -----------------
class HydroLensMainController extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final String userEmail;
  final String glassesId;

  const HydroLensMainController({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.userEmail,
    required this.glassesId,
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
  String sprayBtnLabel = 'إصدار أمر ترطيب [وضع تجريبي]';

  bool eyeRestReminderEnabled = true;
  int reminderIntervalMinutes = 20;

  List<SensorRecord> sensorHistory = [];
  List<Map<String, dynamic>> notifications = [];

  final TextEditingController _chatInputController = TextEditingController();
  late List<ChatMessage> chatMessages;

  @override
  void initState() {
    super.initState();
    chatMessages = [
      ChatMessage(
        text: 'أهلاً بك يا ${widget.userEmail}! أنا مساعد HydroLens الذكي المرتبط بمعرف نظارتك (${widget.glassesId}). اسألني عن قراءات الرطوبة، الإضاءة، أو أي استشارة لصحة عينك، وأنا جاهز لإجابتك فوراً!',
        isUser: false,
      ),
    ];
  }

  @override
  void dispose() {
    _chatInputController.dispose();
    super.dispose();
  }

  Future<void> _triggerManualSpray() async {
    if (isSprayCooldown || isAwaitingSprayAck) {
      _showSnackBar('إجراء آمن: يرجى الانتظار لحين انتهاء مهلة الأمان (60 ثانية)! ⏳');
      return;
    }

    setState(() {
      isAwaitingSprayAck = true;
      sprayBtnLabel = 'جاري إرسال الأمر للنظارة (${widget.glassesId})... 🔄';
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      isAwaitingSprayAck = false;
      isSprayCooldown = true;
      sprayBtnLabel = 'تم إرسال أمر الترطيب [وضع تجريبي] 💧';
    });

    _showSnackBar('تم إرسال أمر الترطيب بنجاح للمعرف 💧');

    Timer(const Duration(seconds: 60), () {
      if (mounted) {
        setState(() {
          isSprayCooldown = false;
          sprayBtnLabel = 'إصدار أمر ترطيب [وضع تجريبي]';
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
      _addNotification('تنبيه جفاف الجو المحيط', 'انخفاض الرطوبة إلى $hum% للنظارة ${widget.glassesId}. يوصى بأخذ استراحة وترطيب.');
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

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      String reply = '';
      final query = text.toLowerCase();

      if (query.contains('مرحبا') || query.contains('السلام') || query.contains('أهلاً')) {
        reply = 'أهلاً بك! أنا مساعد HydroLens الذكي. كيف يمكنني مساعدتك في صحة عينك أو قراءات نظارتك اليوم؟';
      } else if (query.contains('رطوبة') || query.contains('جفاف') || query.contains('ماء')) {
        if (humidityPercent == null) {
          reply = 'لم يتم تسجيل قراءة رطوبة بعد. جرب تفعيل أزرار المحاكاة في الصفحة الرئيسية لقراءة حالة الجو الحالي.';
        } else {
          reply = 'مستوى الرطوبة الحالي لنظارتك (${widget.glassesId}) هو $humidityPercent%. ${humidityPercent! < 40 ? 'الرطوبة منخفضة ويُنصح بتفعيل رذاذ الترطيب.' : 'المستوى ضمن النطاق المريح والصحي للعين.'}';
        }
      } else if (query.contains('إضاءة') || query.contains('ضوء') || query.contains('ساطع') || query.contains('lux')) {
        if (lightLux == null) {
          reply = 'لم يتم استقبال بيانات الإضاءة حتى الآن. يمكنك تفعيل المحاكاة من الشاشة الرئيسية.';
        } else {
          reply = 'شدة الإضاءة المحيطة الحالية مسجلة عند $lightLux Lux. ${lightLux! > 800 ? 'الإضاءة عالية جداً وقد تجهد عينك، يفضل تقليل السطوع.' : 'الإضاءة ضمن المعدل الطبيعي والمريح.'}';
        }
      } else if (query.contains('حالة') || query.contains('تقرير') || query.contains('ملخص')) {
        reply = 'ملخص نظارتك (${widget.glassesId}): الرطوبة (${humidityPercent ?? "غير مسجل"}%)، الإضاءة (${lightLux ?? "غير مسجل"} Lux)، وعدد التنبيهات المسجلة (${notifications.length}). النظام يعمل بكفاءة عالية!';
      } else if (query.contains('قاعدة') || query.contains('20') || query.contains('راحة')) {
        reply = 'قاعدة 20-20-20 تنص على أنه كل 20 دقيقة، يجب أن تنظر إلى شيء يبعد 20 قدمًا لمدة 20 ثانية لإراحة عضلات العين. نظامنا يتيح لك تفعيل تذكيرات أوتوماتيكية لذلك!';
      } else if (query.contains('اسمك') || query.contains('من أنت')) {
        reply = 'أنا المساعد الذكي لمنظومة HydroLens الذكية، تم تطويري لمساعدتك في حماية بصرك وتقديم تقارير فورية لحالة نظارتك.';
      } else {
        reply = 'لقد استقبلت استفسارك بشأن "${text}". بناءً على قراءات نظارتك الحالية بمعرف (${widget.glassesId})، أنصحك بمتابعة لوحة التحكم والتحقق من مستويات الرطوبة والإضاءة باستمرار لضمان راحة مثالية لعينيك.';
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
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isBluetoothConnected ? Colors.teal.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isBluetoothConnected ? '${widget.glassesId} 🟢' : 'غير متصل 🔴',
                style: TextStyle(fontSize: 10, color: isBluetoothConnected ? Colors.teal : Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
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
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'تسجيل الخروج',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LandingScreen(
                    isDarkMode: widget.isDarkMode,
                    onToggleTheme: widget.onToggleTheme,
                  ),
                ),
              );
            },
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
                  buildBrandLogo(size: 40, fontSize: 22),
                  const SizedBox(height: 6),
                  const Text('منصة HydroLens الذكية', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('المستخدم: ${widget.userEmail}', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                  Text('المعرف: ${widget.glassesId}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
                Row(
                  children: [
                    const Icon(Icons.circle, size: 10, color: Colors.orange),
                    const SizedBox(width: 6),
                    Text('معرف النظارة: ${widget.glassesId} [بيانات خاصة]', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
                const Text('اختبار المحاكاة [خاص بمعرف النظارة] 🧪', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
          Text('المعرف المرتبط: ${widget.glassesId} | يقيس الحساس رطوبة الجو المباشر أمام العين.', style: const TextStyle(fontSize: 11, color: Colors.grey)),
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

  // تم تصحيح تصميم مربعات الشات لتكون بخلفية واضحة ونصوص بارزة ومقروءة تماماً
  Widget _buildAIAssistantPage(Color cardBg) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('مساعد HydroLens الذكي 🧠 [${widget.glassesId}]', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? const Color(0xFF0B0F19) : const Color(0xFFEDF2F7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: ListView.builder(
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  final msg = chatMessages[index];
                  return Align(
                    alignment: msg.isUser ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      constraints: const BoxConstraints(maxWidth: 500),
                      decoration: BoxDecoration(
                        color: msg.isUser
                            ? const Color(0xFF5B61F4)
                            : (widget.isDarkMode ? const Color(0xFF1E293B) : Colors.white),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: msg.isUser
                              ? Colors.white
                              : (widget.isDarkMode ? Colors.white : Colors.black87),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatInputController,
                  decoration: InputDecoration(
                    hintText: 'اسأل المساعد عن الرطوبة أو الإضاءة...',
                    filled: true,
                    fillColor: cardBg,
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
          Text('سجل القراءات لنظارتك [معرف: ${widget.glassesId}] 📜', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                      'الوقت: ${item.time.hour}:${item.time.minute.toString().padLeft(2, '0')} [معرف النظارة: ${widget.glassesId}]',
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
          Text('التقارير والإحصائيات [المعرف: ${widget.glassesId}] 📊', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• إجمالي السجلات للمعرف: ${sensorHistory.length} سجل.'),
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
              Text('مركز التنبيهات [${widget.glassesId}] 🔔', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          const Text('حالة النظارة وبلوتوث الهاردوير 📡', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  title: Text('نمط المشروع الحالي'),
                  subtitle: Text('وضع تجريبي جاهز للربط الفعلي مع قطع ESP32 BLE.'),
                ),
                const Divider(),
                ListTile(
                  title: const Text('معرف النظارة المرتبطة بهذا الحساب'),
                  subtitle: Text(widget.glassesId, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                const ListTile(
                  title: Text('المستخدم الحالي'),
                  subtitle: Text('مستخدم النظام'),
                ),
                const Divider(),
                ListTile(
                  title: const Text('معرف النظارة (Glasses ID)'),
                  subtitle: Text(widget.glassesId, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('تذكير الراحة (قاعدة 20-20-20)'),
                  subtitle: Text('تنبيه أوتوماتيكي كل $reminderIntervalMinutes دقيقة لإراحة العين.'),
                  value: eyeRestReminderEnabled,
                  activeColor: const Color(0xFF5B61F4),
                  onChanged: (v) => setState(() => eyeRestReminderEnabled = v),
                ),
                const Divider(),
                const ListTile(
                  title: Text('سياسة الخصوصية وحل الأمان'),
                  subtitle: Text('البيانات معزولة لكل مستخدم بناءً على معرف النظارة الخاص به.'),
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
