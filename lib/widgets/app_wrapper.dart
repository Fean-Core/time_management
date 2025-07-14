import 'package:flutter/material.dart';

class AppWrapper extends StatelessWidget {
  final Widget child;
  final bool enableBackground;

  const AppWrapper({
    Key? key,
    required this.child,
    this.enableBackground = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!enableBackground) {
      return child;
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F1F8), // Azul bem claro mas visível
            Color(0xFFCDE3F0), // Azul um pouco mais escuro
          ],
        ),
      ),
      child: Stack(
        children: [
          // Padrão geométrico mais visível
          Positioned.fill(
            child: Opacity(
              opacity: 0.2, // Bem mais visível
              child: CustomPaint(
                painter: GeometricPatternPainter(),
              ),
            ),
          ),
          // Conteúdo principal
          child,
        ],
      ),
    );
  }
}

class GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2196F3).withOpacity(0.6) // Bem mais visível
      ..strokeWidth = 1.5 // Linha mais grossa
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    
    // Desenhar linhas horizontais e verticais
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Desenhar círculos nos cruzamentos
    final circlePaint = Paint()
      ..color = const Color(0xFF2196F3).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(
          Offset(x, y),
          2.5, // Círculo maior e mais visível
          circlePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
