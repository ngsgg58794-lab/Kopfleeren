import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Muss zur Farbe des nativen Splash passen (pubspec.yaml → flutter_native_splash).
const splashBlue = Color(0xFF1668A6);

/// Kantenlänge des Motivs in dp – identisch zum nativen Splash (800 px @4x),
/// damit der Übergang vom nativen zum Flutter-Splash nahtlos ist.
const _motifSize = 200.0;

/// Animierter Splash: Die Welle im Kopf fließt, die Gedanken-Blasen steigen
/// auf und verschwinden, danach wird zur App übergeblendet.
class SplashScreen extends StatefulWidget {
  final Widget next;
  const SplashScreen({super.key, required this.next});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed) _goNext();
    });

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller.isAnimating || _controller.isCompleted) return;
    // „Bewegung reduzieren“ respektieren: Animation überspringen.
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
      WidgetsBinding.instance.addPostFrameCallback((_) => _goNext());
    } else {
      _controller.forward();
    }
  }

  void _goNext() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (_, __, ___) => widget.next,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ColoredBox(
        color: splashBlue,
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final t = _controller.value;
              // Am Ende sanft vergrößern und ausblenden.
              final out =
                  Curves.easeIn.transform(((t - 0.75) / 0.25).clamp(0.0, 1.0));
              return Opacity(
                opacity: 1 - out,
                child: Transform.scale(
                  scale: 1 + 0.08 * out,
                  child: CustomPaint(
                    size: const Size.square(_motifSize),
                    painter: _MotifPainter(t),
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

/// Zeichnet das App-Motiv im 1024er-Koordinatensystem von assets/icon/icon.svg.
class _MotifPainter extends CustomPainter {
  final double t;
  _MotifPainter(this.t);

  static final Path _head = Path()
    ..moveTo(430, 760)
    ..lineTo(430, 690)
    ..cubicTo(360, 660, 318, 596, 318, 516)
    ..cubicTo(318, 406, 406, 322, 520, 322)
    ..cubicTo(626, 322, 706, 398, 706, 498)
    ..lineTo(706, 510)
    ..lineTo(746, 580)
    ..cubicTo(752, 592, 746, 602, 732, 602)
    ..lineTo(706, 602)
    ..lineTo(706, 650)
    ..cubicTo(706, 676, 686, 694, 660, 694)
    ..lineTo(610, 694)
    ..lineTo(610, 760)
    ..close();

  // (x, y, Radius, Deckkraft) – wie im Icon.
  static const _dots = [
    (612.0, 262.0, 22.0, 1.0),
    (680.0, 206.0, 16.0, 0.8),
    (734.0, 162.0, 11.0, 0.6),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 1024);

    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(_head, stroke..strokeWidth = 34);

    // Welle fließt eine volle Periode (Phase 0 = Stand im nativen Splash).
    final phase =
        Curves.easeInOut.transform((t / 0.8).clamp(0.0, 1.0)) * 2 * math.pi;
    final wave = Path();
    for (var i = 0; i <= 120; i++) {
      final dx = i * 2.0;
      final y = 540 - 30 * math.sin(2 * math.pi * dx / 192 - phase);
      i == 0 ? wave.moveTo(398 + dx, y) : wave.lineTo(398 + dx, y);
    }
    canvas.drawPath(
      wave,
      stroke
        ..strokeWidth = 30
        ..color = Colors.white.withValues(alpha: 0.95),
    );

    // Gedanken steigen nacheinander auf und lösen sich auf.
    final fill = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < _dots.length; i++) {
      final (x, y, r, alpha) = _dots[i];
      final start = 0.1 + 0.12 * (_dots.length - 1 - i);
      final p = Curves.easeIn.transform(((t - start) / 0.45).clamp(0.0, 1.0));
      canvas.drawCircle(
        Offset(x + 30 * p, y - 90 * p),
        r * (1 - 0.3 * p),
        fill..color = Colors.white.withValues(alpha: alpha * (1 - p)),
      );
    }
  }

  @override
  bool shouldRepaint(_MotifPainter old) => old.t != t;
}
