import 'package:flutter/material.dart';
import 'dart:async';
import 'auth_wrapper.dart';
import '../widgets/floating_particles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

  int _currentMessageIndex = 0;
  Timer? _messageTimer;

  // Lista de mensagens sobre funcionalidades
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Organize suas tarefas com prioridades',
      'icon': Icons.task_alt,
      'color': Colors.blue,
    },
    {
      'text': 'Rastreie seu tempo com precisão',
      'icon': Icons.timer,
      'color': Colors.green,
    },
    {
      'text': 'Analise sua produtividade',
      'icon': Icons.analytics,
      'color': Colors.orange,
    },
    {
      'text': 'Receba alertas e lembretes',
      'icon': Icons.notifications_active,
      'color': Colors.purple,
    },
    {
      'text': 'Visualize relatórios detalhados',
      'icon': Icons.bar_chart,
      'color': Colors.teal,
    },
    {
      'text': 'Maximize sua eficiência',
      'icon': Icons.trending_up,
      'color': Colors.red,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startMessageRotation();
    _navigateToHome();
  }

  void _initializeAnimations() {
    // Animação de fade
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Animação de escala
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Animação de progresso
    _progressController = AnimationController(
      duration: const Duration(seconds: 14),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    // Iniciar animações
    _fadeController.forward();
    _scaleController.forward();
    _progressController.forward();
  }

  void _startMessageRotation() {
    _messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _currentMessageIndex = (_currentMessageIndex + 1) % _messages.length;
        });
      }
    });
  }

  void _navigateToHome() {
    Timer(const Duration(seconds: 14), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AuthWrapper(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _fadeController.dispose();
    _scaleController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentMessage = _messages[_currentMessageIndex];
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 600 || screenWidth < 360;
    
    return Scaffold(
      body: Stack(
        children: [
          // Background com gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.tertiary,
                ],
              ),
            ),
          ),
          // Partículas flutuantes
          Positioned.fill(
            child: FloatingParticles(
              particleCount: 15,
              color: Colors.white.withValues(alpha: 0.6),
              minSize: 1.5,
              maxSize: 4.0,
            ),
          ),
          // Conteúdo principal
          SafeArea(
            child: Column(
            children: [
              Expanded(
                flex: isSmallScreen ? 2 : 3,
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo/Ícone principal
                          Container(
                            width: isSmallScreen ? 80 : 120,
                            height: isSmallScreen ? 80 : 120,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.access_time_rounded,
                              size: isSmallScreen ? 40 : 60,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 24),
                          // Título
                          Text(
                            'Gestão de Tempo',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 24 : 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 4 : 8),
                          // Subtítulo
                          Text(
                            'Maximize sua produtividade',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Seção de mensagens dinâmicas
              Expanded(
                flex: isSmallScreen ? 2 : 2,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.3),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      key: ValueKey(_currentMessageIndex),
                      margin: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 20 : 40,
                      ),
                      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                            decoration: BoxDecoration(
                              color: currentMessage['color'].withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              currentMessage['icon'],
                              size: isSmallScreen ? 24 : 32,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 12 : 16),
                          Text(
                            currentMessage['text'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Barra de progresso e indicadores
              Padding(
                padding: EdgeInsets.all(isSmallScreen ? 20 : 40),
                child: Column(
                  children: [
                    // Barra de progresso
                    Container(
                      width: double.infinity,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _progressAnimation.value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    // Indicadores de funcionalidades
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _messages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isSmallScreen ? 6 : 8,
                          height: isSmallScreen ? 6 : 8,
                          decoration: BoxDecoration(
                            color: index == _currentMessageIndex
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    // Texto de carregamento
                    Text(
                      'Preparando tudo para você...',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}
