import 'package:flutter/material.dart';
import '../utils/app_settings_store.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _pinController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  late Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeIn = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _slideUp =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final storedPin = await AppSettingsStore.readPin();

    if (!mounted) return;

    if (_pinController.text == storedPin) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      setState(() {
        _isLoading = false;
        _error = 'Incorrect PIN';
      });
      _animController.forward(from: 0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/arcanus_wallpaper.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.28),
                const Color(0xFF050510).withValues(alpha: 0.72),
                Colors.black.withValues(alpha: 0.88),
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideUp,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 460),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: const Color(0xFF080713).withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF854CFF).withValues(alpha: 0.42),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF854CFF).withValues(alpha: 0.25),
                          blurRadius: 42,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.62),
                          blurRadius: 48,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScaleTransition(
                          scale: _logoScale,
                          child: Container(
                            width: 132,
                            height: 132,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.04),
                              border: Border.all(
                                color: const Color(0xFFCFC3FF)
                                    .withValues(alpha: 0.28),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF854CFF)
                                      .withValues(alpha: 0.45),
                                  blurRadius: 34,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Image.asset(
                              'assets/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFFFFFFFF),
                              Color(0xFFCFC3FF),
                              Color(0xFF854CFF),
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            "Arcanus Ledger",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Secure business ledger",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withValues(alpha: 0.72),
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 46),
                        Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.09),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _error != null
                                  ? Colors.redAccent
                                  : const Color(0xFFCFC3FF)
                                      .withValues(alpha: 0.22),
                              width: 1.4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _error != null
                                    ? Colors.redAccent.withValues(alpha: 0.2)
                                    : Colors.black.withValues(alpha: 0.2),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: TextField(
                              controller: _pinController,
                              obscureText: true,
                              maxLength: 6,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 32,
                                letterSpacing: 0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                hintText: "••••••",
                                hintStyle: TextStyle(
                                  fontSize: 32,
                                  letterSpacing: 0,
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                              ),
                              onSubmitted: (_) => _login(),
                            ),
                          ),
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.redAccent,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _error!,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF854CFF),
                              foregroundColor: Colors.white,
                              elevation: 8,
                              shadowColor: const Color(
                                0xFF854CFF,
                              ).withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Unlock Ledger",
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward, size: 20),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF854CFF)
                                  .withValues(alpha: 0.28),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Default PIN: 1234",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
