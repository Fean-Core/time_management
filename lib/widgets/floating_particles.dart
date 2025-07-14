import 'package:flutter/material.dart';
import 'dart:math';

class FloatingParticles extends StatefulWidget {
  final int particleCount;
  final Color color;
  final double minSize;
  final double maxSize;

  const FloatingParticles({
    super.key,
    this.particleCount = 20,
    this.color = Colors.white,
    this.minSize = 2.0,
    this.maxSize = 6.0,
  });

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    // Inicializar partículas
    _initializeParticles();
  }

  void _initializeParticles() {
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: widget.minSize + _random.nextDouble() * (widget.maxSize - widget.minSize),
        speedX: (_random.nextDouble() - 0.5) * 0.002,
        speedY: _random.nextDouble() * 0.001 + 0.0005,
        opacity: _random.nextDouble() * 0.5 + 0.1,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlesPainter(
            particles: _particles,
            color: widget.color,
            animation: _controller,
          ),
          child: Container(),
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speedX;
  final double speedY;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
  });

  void update() {
    x += speedX;
    y += speedY;

    // Reposicionar se sair da tela
    if (y > 1.1) {
      y = -0.1;
      x = Random().nextDouble();
    }
    if (x > 1.1) {
      x = -0.1;
    } else if (x < -0.1) {
      x = 1.1;
    }
  }
}

class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;
  final Animation<double> animation;

  ParticlesPainter({
    required this.particles,
    required this.color,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      particle.update();
      
      paint.color = color.withValues(alpha: particle.opacity);
      
      canvas.drawCircle(
        Offset(
          particle.x * size.width,
          particle.y * size.height,
        ),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlesPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value;
  }
}
