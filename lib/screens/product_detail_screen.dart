import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'dart:ui';

class ProductDetailModel with ChangeNotifier {
  int _quantity = 1;
  bool _isFavorite = false;
  bool _isLoading = false;
  double _spiceLevel = 0.0;
  Map<String, bool> _customizations = {
    'Extra Cheese': false,
    'Bacon': false,
    'Avocado': false,
    'No Onions': false,
  };
  double _basePrice = 26.99;

  int get quantity => _quantity;
  bool get isFavorite => _isFavorite;
  bool get isLoading => _isLoading;
  double get spiceLevel => _spiceLevel;
  Map<String, bool> get customizations => _customizations;
  double get totalPrice {
    double total = _basePrice * _quantity;
    if (_customizations['Extra Cheese']!) total += 2.50 * _quantity;
    if (_customizations['Bacon']!) total += 3.00 * _quantity;
    if (_customizations['Avocado']!) total += 2.00 * _quantity;
    return total;
  }

  void setQuantity(int value) {
    _quantity = value.clamp(1, 10);
    notifyListeners();
  }

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    _isLoading = true;
    Future.delayed(Duration(milliseconds: 800), () {
      _isLoading = false;
      notifyListeners();
    });
  }

  void setSpiceLevel(double value) {
    _spiceLevel = value;
    notifyListeners();
  }

  void toggleCustomization(String key) {
    _customizations[key] = !_customizations[key]!;
    notifyListeners();
  }

  void addToCart() {
    _isLoading = true;
    Future.delayed(Duration(milliseconds: 800), () {
      _isLoading = false;
      notifyListeners();
    });
  }
}

class AdvancedProductDetailScreen extends StatefulWidget {
  const AdvancedProductDetailScreen({super.key});

  @override
  _AdvancedProductDetailScreenState createState() =>
      _AdvancedProductDetailScreenState();
}

class _AdvancedProductDetailScreenState
    extends State<AdvancedProductDetailScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late ConfettiController _confettiController;
  int _currentPage = 0;
  final List<String> productImages = [
    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
    _pageController = PageController(viewportFraction: 0.8, initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ChangeNotifierProvider(
      create: (_) => ProductDetailModel(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            _buildBackground(size, isDarkMode),
            _buildFloatingDecorations(size, isDarkMode),
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(context, isDarkMode),
                SliverToBoxAdapter(
                  child: AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 500),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          verticalOffset: 30.0,
                          child: FadeInAnimation(child: widget),
                        ),
                        children: [
                          _buildImageCarousel(size, isDarkMode),
                          _buildProductInfo(size, isDarkMode),
                          _buildCustomizationCard(size, isDarkMode),
                          _buildBurgerVisualizer(size, isDarkMode),
                          _buildDetailsCard(size, isDarkMode),
                          _buildNutritionCard(size, isDarkMode),
                          _buildRecommendations(size, isDarkMode),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _buildBottomActionBar(size, isDarkMode),
            Consumer<ProductDetailModel>(
              builder: (context, model, child) => model.isLoading
                  ? Center(
                      child: SpinKitWaveSpinner(
                        color: const Color(0xFFFE5E33),
                        size: 60.0,
                        trackColor:
                            isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                        waveColor: const Color(0xFFF52C0A),
                        duration: const Duration(milliseconds: 800),
                      )
                          .animate()
                          .scale(duration: 500.ms, curve: Curves.easeOut),
                    )
                  : const SizedBox.shrink(),
            ),
            Positioned(
              top: size.height * 0.15,
              left: size.width * 0.5,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: -pi / 2,
                emissionFrequency: 0.03,
                numberOfParticles: 10,
                maxBlastForce: 60,
                minBlastForce: 10,
                gravity: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(Size size, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF1F2937).withOpacity(0.95),
                  const Color(0xFF374151).withOpacity(0.9),
                  const Color(0xFF4B5563).withOpacity(0.85),
                  const Color(0xFFFE5E33).withOpacity(0.2),
                ]
              : [
                  const Color(0xFFF9FAFB).withOpacity(0.95),
                  const Color(0xFFE5E7EB).withOpacity(0.9),
                  const Color(0xFFD1D5DB).withOpacity(0.85),
                  const Color(0xFFFE5E33).withOpacity(0.1),
                ],
          stops: const [0.0, 0.4, 0.8, 1.0],
        ),
      ),
    ).animate().fadeIn(duration: 1200.ms, curve: Curves.easeInOutCubic);
  }

  Widget _buildFloatingDecorations(Size size, bool isDarkMode) {
    return Stack(
      children: [
        Positioned(
          top: size.height * 0.03,
          right: -30,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFE5E33).withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ).animate().rotate(duration: 5.seconds).scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.05, 1.05),
                duration: 2.5.seconds,
                curve: Curves.easeInOut,
              ),
        ),
        Positioned(
          bottom: size.height * 0.25,
          left: -50,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF3B82F6).withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ).animate().rotate(duration: 7.seconds).scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.05, 1.05),
                duration: 3.5.seconds,
                curve: Curves.easeInOut,
              ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool isDarkMode) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      leading: _buildNeumorphicButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onPressed: () {
          HapticFeedback.selectionClick();
          Navigator.pop(context);
        },
        isDarkMode: isDarkMode,
      ),
      actions: [
        Consumer<ProductDetailModel>(
          builder: (context, model, child) => _buildNeumorphicButton(
            icon: model.isFavorite ? Icons.favorite : Icons.favorite_border,
            onPressed: () {
              model.toggleFavorite();
              _confettiController.play();
              _showFavoriteAnimation(context, model.isFavorite);
            },
            isDarkMode: isDarkMode,
          ),
        ),
      ],
    );
  }

  Widget _buildNeumorphicButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDarkMode,
  }) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
          BoxShadow(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.6),
            blurRadius: 8,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon,
            color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
            size: 22),
        onPressed: onPressed,
      ),
    ).animate().scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1.0, 1.0),
          duration: 600.ms,
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildImageCarousel(Size size, bool isDarkMode) {
    return Consumer<ProductDetailModel>(
      builder: (context, model, child) => Container(
        height: size.height * 0.4,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            HapticFeedback.selectionClick();
            setState(() {
              _currentPage = index;
            });
          },
          itemCount: productImages.length,
          itemBuilder: (context, index) {
            final isActive = index == _currentPage;
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(isActive ? 0 : 0.1 * (index - _currentPage)),
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: EdgeInsets.symmetric(
                    horizontal: 6, vertical: isActive ? 6 : 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.4)
                          : Colors.black.withOpacity(isActive ? 0.25 : 0.1),
                      blurRadius: isActive ? 20 : 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: productImages[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: isDarkMode
                              ? Colors.grey[700]!
                              : Colors.grey[300]!,
                          highlightColor: isDarkMode
                              ? Colors.grey[600]!
                              : Colors.grey[100]!,
                          child: Container(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error,
                          color: Colors.redAccent,
                          size: 40,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.05),
                              Colors.black.withOpacity(0.4),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            productImages.length,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: i == _currentPage ? 16 : 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white
                                    .withOpacity(i == _currentPage ? 0.9 : 0.4),
                                boxShadow: i == _currentPage
                                    ? [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.5),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : [],
                              ),
                            ),
                          ),
                        ).animate().fadeIn(duration: 500.ms),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().scale(
                  begin: Offset(isActive ? 1.0 : 0.95, isActive ? 1.0 : 0.95),
                  end: const Offset(1.0, 1.0),
                  duration: 500.ms,
                  curve: Curves.easeOutBack,
                );
          },
        ),
      ),
    )
        .animate()
        .shimmer(duration: 2.5.seconds, color: Colors.white.withOpacity(0.3));
  }

  Widget _buildProductInfo(Size size, bool isDarkMode) {
    return Consumer<ProductDetailModel>(
      builder: (context, model, child) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.grey[800]!.withOpacity(0.7)
              : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        "Signature Gourmet Burger",
                        textStyle: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF1F2937),
                          letterSpacing: 0.2,
                        ),
                        speed: const Duration(milliseconds: 40),
                      ),
                    ],
                    totalRepeatCount: 1,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          Icons.star_rounded,
                          size: 22,
                          color: index < 4
                              ? Colors.amber.shade700
                              : (isDarkMode
                                  ? Colors.grey[600]
                                  : Colors.grey[300]),
                        )
                            .animate()
                            .fadeIn(delay: (300 * index).ms, duration: 400.ms);
                      }),
                      const SizedBox(width: 8),
                      Text(
                        "4.9",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "(156 reviews)",
                        style: GoogleFonts.inter(
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFE5E33), Color(0xFFF52C0A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF52C0A).withOpacity(0.5),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  "\$${model.totalPrice.toStringAsFixed(2)}",
                                  textStyle: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                  speed: const Duration(milliseconds: 60),
                                ),
                              ],
                              totalRepeatCount: 1,
                            ),
                            Text(
                              "total",
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .scale(duration: 800.ms, curve: Curves.elasticOut),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizationCard(Size size, bool isDarkMode) {
    return Consumer<ProductDetailModel>(
      builder: (context, model, child) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.grey[800]!.withOpacity(0.7)
              : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Craft Your Burger",
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF1F2937),
                        ),
                      ),
                      const Spacer(),
                      Lottie.asset(
                        'assets/burger.json',
                        width: 40,
                        height: 40,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCustomizationSlider(
                    label: "Spice Level",
                    icon: Icons.local_fire_department,
                    value: model.spiceLevel,
                    onChanged: model.setSpiceLevel,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: model.customizations.keys.map((key) {
                      return _buildCustomizationToggle(
                        key,
                        model.customizations[key]!,
                        model.toggleCustomization,
                        isDarkMode,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBurgerVisualizer(Size size, bool isDarkMode) {
    return Consumer<ProductDetailModel>(
      builder: (context, model, child) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.grey[800]!.withOpacity(0.7)
              : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Burger Preview",
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [Colors.grey[700]!, Colors.grey[600]!]
                          : [Colors.grey[200]!, Colors.grey[100]!],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode
                            ? Colors.black.withOpacity(0.2)
                            : Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Lottie.asset(
                        'assets/burger_preview.json',
                        width: size.width * 0.6,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                      ...model.customizations.entries
                          .where((entry) => entry.value)
                          .map((entry) => Positioned(
                                top: 12,
                                child: Text(
                                  "+ ${entry.key}",
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFFE5E33),
                                  ),
                                ).animate().fadeIn(duration: 500.ms).slideY(),
                              ))
                          .toList(),
                    ],
                  ),
                ).animate().scale(duration: 800.ms, curve: Curves.easeOut),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizationSlider({
    required String label,
    required IconData icon,
    required double value,
    required Function(double) onChanged,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFFFE5E33), size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 8,
            thumbColor: const Color(0xFFFE5E33),
            activeTrackColor: const Color(0xFFFE5E33),
            inactiveTrackColor:
                isDarkMode ? Colors.grey[600] : Colors.grey[300],
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            overlayColor: const Color(0xFFFE5E33).withOpacity(0.3),
          ),
          child: Slider(
            value: value,
            min: 0.0,
            max: 1.0,
            divisions: 5,
            onChanged: onChanged,
          ),
        ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Mild",
                style: GoogleFonts.inter(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
            Text("Blazing",
                style: GoogleFonts.inter(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomizationToggle(String label, bool isSelected,
      Function(String) onToggle, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        onToggle(label);
        HapticFeedback.selectionClick();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFE5E33).withOpacity(0.2)
              : (isDarkMode
                  ? Colors.grey[700]!.withOpacity(0.7)
                  : Colors.grey[100]!.withOpacity(0.7)),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.2)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(1, 1),
            ),
            BoxShadow(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(-1, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              {
                'Extra Cheese': Icons.add_a_photo,
                'Bacon': Icons.fastfood,
                'Avocado': Icons.local_florist,
                'No Onions': Icons.no_food,
              }[label],
              color: isSelected
                  ? const Color(0xFFFE5E33)
                  : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFFFE5E33)
                    : (isDarkMode ? Colors.white : const Color(0xFF1F2937)),
              ),
            ),
          ],
        ),
      ).animate().scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1.0, 1.0),
            duration: 500.ms,
            curve: Curves.easeOutBack,
          ),
    );
  }

  Widget _buildDetailsCard(Size size, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.grey[800]!.withOpacity(0.7)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.white.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: [
              _buildDetailRow(
                Icons.info_outline_rounded,
                "Description",
                "A luxurious gourmet burger crafted with premium grass-fed beef, exotic spices, and artisanal ingredients, served on a toasted brioche bun.",
                isDarkMode,
              ),
              _buildDivider(isDarkMode),
              _buildDetailRow(
                Icons.local_dining_rounded,
                "Ingredients",
                "Grass-fed beef, heirloom tomatoes, organic lettuce, aged sharp cheddar, truffle aioli, toasted brioche bun.",
                isDarkMode,
              ),
              _buildDivider(isDarkMode),
              _buildDetailRow(
                Icons.access_time_rounded,
                "Delivery",
                "10-15 minutes • Free delivery on orders over \$30",
                isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      IconData icon, String title, String description, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFE5E33).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.2)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFFFE5E33), size: 22),
          ).animate().scale(duration: 600.ms, curve: Curves.bounceOut),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      description,
                      textStyle: GoogleFonts.inter(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                        fontSize: 14,
                        height: 1.3,
                        fontWeight: FontWeight.w400,
                      ),
                      speed: const Duration(milliseconds: 30),
                    ),
                  ],
                  totalRepeatCount: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
      thickness: 1,
      height: 20,
    );
  }

  Widget _buildNutritionCard(Size size, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.grey[800]!.withOpacity(0.7)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.white.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFE5E33).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.black.withOpacity(0.2)
                              : Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.spa_rounded,
                        color: Color(0xFFFE5E33), size: 22),
                  ).animate().scale(duration: 600.ms, curve: Curves.bounceOut),
                  const SizedBox(width: 12),
                  Text(
                    "Nutrition Facts",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNutritionItem("Calories", "540", "kcal", isDarkMode),
                  _buildNutritionItem("Protein", "32", "g", isDarkMode),
                  _buildNutritionItem("Carbs", "40", "g", isDarkMode),
                  _buildNutritionItem("Fat", "25", "g", isDarkMode),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionItem(
      String label, String value, String unit, bool isDarkMode) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.grey[700]!.withOpacity(0.7)
              : Colors.grey[50]!.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.2)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(1, 1),
            ),
            BoxShadow(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(-1, -1),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  "$value $unit",
                  textStyle: GoogleFonts.inter(
                    color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  speed: const Duration(milliseconds: 60),
                ),
              ],
              totalRepeatCount: 1,
            ),
          ],
        ),
      ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
    );
  }

  Widget _buildRecommendations(Size size, bool isDarkMode) {
    final List<Map<String, dynamic>> recommendations = [
      {
        'name': 'Truffle Mushroom Pizza',
        'icon': Icons.local_pizza,
        'price': 21.99,
        'image': 'https://images.unsplash.com/photo-1594007654729-407eedc4be65',
      },
      {
        'name': 'Artisan Spaghetti',
        'icon': Icons.restaurant,
        'price': 26.50,
        'image': 'https://images.unsplash.com/photo-1608897013039-887f21d8c804',
      },
      {
        'name': 'Red Velvet Cake',
        'icon': Icons.cake,
        'price': 16.99,
        'image': 'https://images.unsplash.com/photo-1614707269212-0c6a7d32bcd9',
      },
      {
        'name': 'Nitro Cold Brew',
        'icon': Icons.coffee,
        'price': 6.50,
        'image': 'https://images.unsplash.com/photo-1512568400610-62da28d7b9a2',
      },
    ];

    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Explore More Delights",
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                  },
                  child: Text(
                    "See all",
                    style: GoogleFonts.inter(
                      color: const Color(0xFFFE5E33),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(recommendations.length, (index) {
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    _confettiController.play();
                  },
                  child: Container(
                    width: size.width * 0.42,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey[800]!.withOpacity(0.7)
                          : Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.black.withOpacity(0.3)
                              : Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.1)
                            : Colors.white.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 140,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: recommendations[index]['image'],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: isDarkMode
                                        ? Colors.grey[700]!
                                        : Colors.grey[300]!,
                                    highlightColor: isDarkMode
                                        ? Colors.grey[600]!
                                        : Colors.grey[100]!,
                                    child: Container(color: Colors.white),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    recommendations[index]['icon'],
                                    size: 50,
                                    color: isDarkMode
                                        ? Colors.white.withOpacity(0.7)
                                        : Colors.white.withOpacity(0.95),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedTextKit(
                                    animatedTexts: [
                                      TypewriterAnimatedText(
                                        recommendations[index]['name'],
                                        textStyle: GoogleFonts.inter(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: isDarkMode
                                              ? Colors.white
                                              : const Color(0xFF1F2937),
                                        ),
                                        speed: const Duration(milliseconds: 60),
                                      ),
                                    ],
                                    totalRepeatCount: 1,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "\$${recommendations[index]['price'].toStringAsFixed(2)}",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      color: const Color(0xFFFE5E33),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: (300 * index).ms, duration: 700.ms)
                      .slideX(begin: 0.3, end: 0.0, curve: Curves.easeOutBack),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(Size size, bool isDarkMode) {
    return Consumer<ProductDetailModel>(
      builder: (context, model, child) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.grey[800]!.withOpacity(0.7)
                : Colors.white.withOpacity(0.7),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, -6),
              ),
            ],
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.4),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: SafeArea(
                child: Row(
                  children: [
                    _buildQuantitySelector(size, model, isDarkMode),
                    const SizedBox(width: 12),
                    Expanded(
                        child:
                            _buildAddToCartButton(model, context, isDarkMode)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ).animate().slideY(
            begin: 0.5,
            end: 0.0,
            duration: 1000.ms,
            curve: Curves.easeOutBack,
          ),
    );
  }

  Widget _buildQuantitySelector(
      Size size, ProductDetailModel model, bool isDarkMode) {
    return Container(
      width: size.width * 0.32,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
          BoxShadow(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.6),
            blurRadius: 8,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildQuantityButton(Icons.remove, () {
            model.setQuantity(model.quantity - 1);
          }, isDarkMode),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              model.quantity.toString(),
              key: ValueKey(model.quantity),
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
          ),
          _buildQuantityButton(Icons.add, () {
            model.setQuantity(model.quantity + 1);
          }, isDarkMode),
        ],
      ),
    ).animate().scale(duration: 800.ms, curve: Curves.elasticOut);
  }

  Widget _buildQuantityButton(
      IconData icon, VoidCallback onPressed, bool isDarkMode) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onPressed();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isDarkMode ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.2)
                    : Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(1, 1),
              ),
              BoxShadow(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.6),
                blurRadius: 6,
                offset: const Offset(-1, -1),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
            size: 22,
          ),
        ),
      ),
    ).animate().scale(duration: 600.ms, curve: Curves.bounceOut);
  }

  Widget _buildAddToCartButton(
      ProductDetailModel model, BuildContext context, bool isDarkMode) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          model.addToCart();
          _confettiController.play();
          _showAddToCartAnimation(context);
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFE5E33), Color(0xFFF52C0A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF52C0A).withOpacity(0.5),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/Plus.json',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Text(
                "Add to Cart",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().scale(duration: 800.ms, curve: Curves.elasticOut);
  }

  void _showFavoriteAnimation(BuildContext context, bool isFavorite) {
    HapticFeedback.vibrate();
    final overlay = Overlay.of(context);
    OverlayEntry entry = OverlayEntry(
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Lottie.asset(
            'assets/favorite_animation.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    overlay.insert(entry);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/favorite_animation.json',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  isFavorite ? "Added to Favorites" : "Removed from Favorites",
                  textStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  speed: const Duration(milliseconds: 60),
                ),
              ],
              totalRepeatCount: 1,
            ),
          ],
        ),
        backgroundColor: isFavorite ? Colors.redAccent : Colors.grey[800],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 12,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }

  void _showAddToCartAnimation(BuildContext context) {
    HapticFeedback.vibrate();
    final overlay = Overlay.of(context);
    OverlayEntry entry = OverlayEntry(
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Lottie.asset(
            'assets/add_to_cart.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
            repeat: false,
          ),
        ),
      ),
    );

    overlay.insert(entry);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/cart_animation.json',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  "Added to Cart",
                  textStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  speed: const Duration(milliseconds: 60),
                ),
              ],
              totalRepeatCount: 1,
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 12,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }
}
