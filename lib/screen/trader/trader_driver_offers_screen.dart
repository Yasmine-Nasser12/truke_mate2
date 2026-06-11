import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/theme_provider.dart';

// ══════════════════════════════════════════════════════════════════════════════
//  TRADER DRIVER OFFERS SCREEN — trader_driver_offers_screen.dart
//  ✅ Matched 1:1 with DriverOffersScreen.tsx (React Native / Framer Motion)
//
//  STATES (same as RN):
//  • with-offers  → OffersState.withOffers  (default)
//  • empty        → OffersState.empty
//  • loading      → OffersState.loading     (shimmer skeleton)
//  • error        → OffersState.error       (retry button)
//
//  ANIMATIONS (RN → Flutter):
//  • pageVariants:       opacity:0,y:+20→0  0.5s easeOut → _pageFade + _pageSlide
//  • Header:             opacity:0,y:-20→0  0.6s delay:0.1 → _headerCtrl
//  • Shipment banner:    opacity:0,scale:0.95→1 delay:0.2 ease[0.22,1,0.36,1] → _bannerCtrl
//  • containerVariants:  stagger children delay:0.3 + i*0.08 → _cardCtrls
//  • listItemVariants:   opacity:0,y:+20→0 spring → each card
//  • whileTap:           scale:0.96 → _Tap
//  • Reject card:        AnimatedSize fade-out + slide → _dismissCard
//  • Accept card:        dismiss + navigate after 300ms
//  • Shimmer skeleton:   opacity 0.3→0.7 pulse loop
// ══════════════════════════════════════════════════════════════════════════════

// ── State enum ────────────────────────────────────────────────────────────────
enum OffersState { withOffers, empty, loading, error }

// ── Durations ─────────────────────────────────────────────────────────────────
const Duration _kFast = Duration(milliseconds: 250);
const Duration _kMed  = Duration(milliseconds: 450);

// ── Ease [0.22,1,0.36,1] — RN transition ease ────────────────────────────────
const Cubic _kEaseSpring = Cubic(0.22, 1.0, 0.36, 1.0);

// ── Tap scale 0.96 (RN whileTap) ─────────────────────────────────────────────
class _Tap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _Tap({required this.child, this.onTap});

  @override
  State<_Tap> createState() => _TapState();
}

class _TapState extends State<_Tap> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _s;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 120));
    _s = Tween<double>(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown:   (_) => _c.forward(),
        onTapUp:     (_) { _c.reverse(); widget.onTap?.call(); },
        onTapCancel: ()  => _c.reverse(),
        child: ScaleTransition(scale: _s, child: widget.child),
      );
}

// ── Shimmer skeleton box ──────────────────────────────────────────────────────
class _Shimmer extends StatefulWidget {
  final double width, height, radius;
  const _Shimmer({required this.width, required this.height, this.radius = 8});

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double>   _opacity;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.3, end: 0.7)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _opacity,
    builder: (_, __) => Opacity(
      opacity: _opacity.value,
      child: Container(
        width: widget.width, height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFF00D5BE).withOpacity(0.12),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    ),
  );
}

// ── Skeleton card (1 loading item) ───────────────────────────────────────────
class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF0A1628).withOpacity(0.6),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
          color: const Color(0xFF00D5BE).withOpacity(0.2), width: 0.8),
    ),
    child: Column(children: [
      Row(children: [
        const _Shimmer(width: 44, height: 44, radius: 12),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Shimmer(width: 120, height: 14, radius: 6),
            SizedBox(height: 8),
            _Shimmer(width: 180, height: 11, radius: 5),
          ],
        )),
      ]),
      const SizedBox(height: 12),
      const _Shimmer(width: double.infinity, height: 52, radius: 12),
      const SizedBox(height: 12),
      Row(children: const [
        _Shimmer(width: 44, height: 40, radius: 12),
        SizedBox(width: 10),
        Expanded(child: _Shimmer(width: double.infinity, height: 40, radius: 12)),
      ]),
    ]),
  );
}

// ── Data model ────────────────────────────────────────────────────────────────
class _OfferItem {
  final int    id;
  final String name, initials, truckType;
  final double rating;
  final int    trips, price;

  const _OfferItem({
    required this.id, required this.name, required this.initials,
    required this.truckType, required this.rating,
    required this.trips, required this.price,
  });
}

final _kOffers = [
  const _OfferItem(id: 1, name: 'Ahmed Hassan',    initials: 'AH',
      truckType: 'Flatbed Truck', rating: 4.8, trips: 127, price: 285),
  const _OfferItem(id: 2, name: 'Mohamed Ali',     initials: 'MA',
      truckType: 'Box Truck',     rating: 4.9, trips: 203, price: 270),
  const _OfferItem(id: 3, name: 'Omar Khaled',     initials: 'OK',
      truckType: 'Cargo Van',     rating: 4.7, trips: 89,  price: 295),
  const _OfferItem(id: 4, name: 'Youssef Ibrahim', initials: 'YI',
      truckType: 'Flatbed Truck', rating: 4.6, trips: 156, price: 280),
];

// ══════════════════════════════════════════════════════════════════════════════
//  SCREEN
// ══════════════════════════════════════════════════════════════════════════════
class TraderDriverOffersScreen extends StatefulWidget {
  final String    shipmentFrom, shipmentTo, shipmentInfo;
  final OffersState state;

  const TraderDriverOffersScreen({
    super.key,
    this.shipmentFrom = 'Maadi',
    this.shipmentTo   = 'Nasr City',
    this.shipmentInfo = '2.5 tons · Flatbed Truck',
    this.state        = OffersState.withOffers,
  });

  @override
  State<TraderDriverOffersScreen> createState() =>
      _TraderDriverOffersScreenState();
}

class _TraderDriverOffersScreenState
    extends State<TraderDriverOffersScreen> with TickerProviderStateMixin {

  late List<_OfferItem> _offers;

  // page entry (pageVariants: opacity:0, y:+20→0)
  late AnimationController _pageCtrl;
  late Animation<double>   _pageFade;
  late Animation<Offset>   _pageSlide;

  // header (opacity:0, y:-20→0, delay:0.1)
  late AnimationController _headerCtrl;
  late Animation<double>   _headerFade;
  late Animation<Offset>   _headerSlide;

  // banner (opacity:0, scale:0.95→1, delay:0.2)
  late AnimationController _bannerCtrl;
  late Animation<double>   _bannerFade;
  late Animation<double>   _bannerScale;

  // cards stagger (containerVariants: delay:0.3 + i*0.08, listItemVariants: y:+20→0)
  final List<AnimationController> _cardCtrls  = [];
  final List<Animation<double>>   _cardFades  = [];
  final List<Animation<Offset>>   _cardSlides = [];

  // per-card dismiss animation (reject/accept)
  final Map<int, AnimationController> _dismissCtrls = {};
  final Map<int, Animation<double>>   _dismissFades = {};
  final Map<int, Animation<double>>   _dismissSizes = {};

  @override
  void initState() {
    super.initState();
    _offers = List.from(_kOffers);

    // Page entry
    _pageCtrl = AnimationController(vsync: this, duration: _kMed)..forward();
    _pageFade = CurvedAnimation(parent: _pageCtrl, curve: Curves.easeOut);
    _pageSlide = Tween<Offset>(
            begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _pageCtrl, curve: Curves.easeOut));

    // Header
    _headerCtrl = AnimationController(vsync: this, duration: _kMed);
    _headerFade = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(
            begin: const Offset(0, -0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 100),
        () { if (mounted) _headerCtrl.forward(); });

    // Banner
    _bannerCtrl = AnimationController(vsync: this, duration: _kMed);
    _bannerFade = CurvedAnimation(parent: _bannerCtrl, curve: Curves.easeOut);
    _bannerScale = Tween<double>(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(parent: _bannerCtrl, curve: _kEaseSpring));
    Future.delayed(const Duration(milliseconds: 200),
        () { if (mounted) _bannerCtrl.forward(); });

    // Cards stagger: delay 300 + i*80ms, listItemVariants y:+20→0 spring
    for (int i = 0; i < _kOffers.length; i++) {
      final c = AnimationController(vsync: this,
          duration: const Duration(milliseconds: 500));
      _cardCtrls.add(c);
      _cardFades.add(CurvedAnimation(parent: c, curve: Curves.easeOut));
      _cardSlides.add(Tween<Offset>(
              begin: const Offset(0, 0.15), end: Offset.zero)
          .animate(CurvedAnimation(parent: c, curve: _kEaseSpring)));
      Future.delayed(Duration(milliseconds: 300 + i * 80),
          () { if (mounted) c.forward(); });
    }

    // Dismiss controllers for each offer
    for (final offer in _kOffers) {
      final c = AnimationController(vsync: this,
          duration: const Duration(milliseconds: 300));
      _dismissCtrls[offer.id] = c;
      _dismissFades[offer.id] = Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(parent: c, curve: Curves.easeOut));
      _dismissSizes[offer.id] = Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(parent: c, curve: Curves.easeInOut));
    }
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _headerCtrl.dispose();
    _bannerCtrl.dispose();
    for (final c in _cardCtrls) c.dispose();
    for (final c in _dismissCtrls.values) c.dispose();
    super.dispose();
  }

  // ── Reject: animate out then remove ─────────────────────────────────────────
  Future<void> _rejectOffer(int id) async {
    await _dismissCtrls[id]?.forward();
    if (mounted) setState(() => _offers.removeWhere((o) => o.id == id));
  }

  // ── Accept: animate out then navigate after 300ms ────────────────────────────
  Future<void> _acceptOffer(int id) async {
    await _dismissCtrls[id]?.forward();
    if (mounted) {
      setState(() => _offers.removeWhere((o) => o.id == id));
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) Navigator.pushNamed(context, '/map');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    const kBg      = Color(0xFF0A1A24);
    const kTeal    = Color(0xFF00D5BE);
    final kCard    = const Color(0xFF0A1628).withOpacity(0.6);
    final kBorder  = kTeal.withOpacity(0.2);
    const kText    = Color(0xFFF0FDF9);
    final kMuted   = const Color(0xFFCBFBF1).withOpacity(0.5);

    return Scaffold(
      backgroundColor: kBg,
      body: FadeTransition(
        opacity: _pageFade,
        child: SlideTransition(
          position: _pageSlide,
          child: SafeArea(
            child: Column(children: [

              // ── Header ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: FadeTransition(
                  opacity: _headerFade,
                  child: SlideTransition(
                    position: _headerSlide,
                    child: Row(children: [
                      _Tap(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A1628).withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: kBorder, width: 0.8),
                          ),
                          child: const Icon(Icons.chevron_left,
                              color: Color(0xFF00D5BE), size: 22),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Driver Offers',
                              style: TextStyle(color: kText, fontSize: 22,
                                  fontWeight: FontWeight.w700)),
                          Text(
                            '${_offers.length} driver${_offers.length != 1 ? "s" : ""} available',
                            style: TextStyle(color: kMuted, fontSize: 13),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Shipment banner ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FadeTransition(
                  opacity: _bannerFade,
                  child: ScaleTransition(
                    scale: _bannerScale,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kTeal.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: kBorder, width: 0.8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your Shipment',
                              style: TextStyle(color: kMuted, fontSize: 11)),
                          const SizedBox(height: 8),
                          Row(children: [
                            Text(widget.shipmentFrom,
                                style: const TextStyle(
                                    color: kText, fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward,
                                color: Color(0xFF00D5BE), size: 16),
                            const SizedBox(width: 8),
                            Text(widget.shipmentTo,
                                style: const TextStyle(
                                    color: kText, fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                          ]),
                          const SizedBox(height: 4),
                          Text(widget.shipmentInfo,
                              style: TextStyle(color: kMuted, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Body by state ────────────────────────────────────────────
              Expanded(
                child: _buildBody(
                  kCard: kCard, kBorder: kBorder,
                  kText: kText, kMuted: kMuted,
                  kTeal: kTeal, isDark: isDark,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildBody({
    required Color kCard, required Color kBorder,
    required Color kText, required Color kMuted,
    required Color kTeal, required bool isDark,
  }) {
    switch (widget.state) {
      case OffersState.loading:
        return _buildLoading();
      case OffersState.empty:
        return _buildEmpty(kText: kText, kMuted: kMuted, kTeal: kTeal);
      case OffersState.error:
        return _buildError(kText: kText, kMuted: kMuted, kTeal: kTeal);
      case OffersState.withOffers:
        return _buildOffers(
          kCard: kCard, kBorder: kBorder,
          kText: kText, kMuted: kMuted,
          kTeal: kTeal, isDark: isDark,
        );
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  STATE: Loading — shimmer skeletons
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildLoading() => ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    itemCount: 4,
    itemBuilder: (_, __) => const _SkeletonCard(),
  );

  // ══════════════════════════════════════════════════════════════════════════
  //  STATE: Empty
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildEmpty({
    required Color kText,
    required Color kMuted,
    required Color kTeal,
  }) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: kTeal.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: kTeal.withOpacity(0.2)),
          ),
          child: Icon(Icons.check, color: kTeal.withOpacity(0.5), size: 32),
        ),
        const SizedBox(height: 20),
        Text('All offers reviewed',
            style: TextStyle(color: kText, fontSize: 18,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text('Check your active shipments or create a new one',
            textAlign: TextAlign.center,
            style: TextStyle(color: kMuted, fontSize: 14, height: 1.5)),
        const SizedBox(height: 24),
        _Tap(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kTeal, const Color(0xFF009689)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text('Go to Home',
                style: TextStyle(color: Colors.white,
                    fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ),
      ]),
    ),
  );

  // ══════════════════════════════════════════════════════════════════════════
  //  STATE: Error
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildError({
    required Color kText,
    required Color kMuted,
    required Color kTeal,
  }) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444).withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
                color: const Color(0xFFEF4444).withOpacity(0.2)),
          ),
          child: const Icon(Icons.error_outline_rounded,
              color: Color(0xFFEF4444), size: 32),
        ),
        const SizedBox(height: 20),
        Text('Failed to load offers',
            style: TextStyle(color: kText, fontSize: 18,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text('Please try again later',
            textAlign: TextAlign.center,
            style: TextStyle(color: kMuted, fontSize: 14)),
        const SizedBox(height: 24),
        _Tap(
          onTap: () => setState(() {}),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kTeal, const Color(0xFF009689)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text('Retry',
                style: TextStyle(color: Colors.white,
                    fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ),
      ]),
    ),
  );

  // ══════════════════════════════════════════════════════════════════════════
  //  STATE: With Offers — staggered cards + dismiss animation
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildOffers({
    required Color kCard, required Color kBorder,
    required Color kText, required Color kMuted,
    required Color kTeal, required bool isDark,
  }) {
    if (_offers.isEmpty) {
      return _buildEmpty(kText: kText, kMuted: kMuted, kTeal: kTeal);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      itemCount: _offers.length,
      itemBuilder: (_, i) {
        final offer = _offers[i];
        final idx   = _kOffers.indexWhere((o) => o.id == offer.id);
        final fade  = idx < _cardFades.length
            ? _cardFades[idx]
            : const AlwaysStoppedAnimation(1.0);
        final slide = idx < _cardSlides.length
            ? _cardSlides[idx]
            : const AlwaysStoppedAnimation(Offset.zero);
        final dismissFade = _dismissFades[offer.id]!;
        final dismissSize = _dismissSizes[offer.id]!;

        return AnimatedBuilder(
          animation: _dismissCtrls[offer.id]!,
          builder: (_, child) => SizeTransition(
            sizeFactor: dismissSize,
            axisAlignment: -1,
            child: FadeTransition(
              opacity: dismissFade,
              child: child,
            ),
          ),
          child: FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: slide,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _OfferCard(
                  offer:    offer,
                  kCard:    kCard,
                  kBorder:  kBorder,
                  kText:    kText,
                  kMuted:   kMuted,
                  kTeal:    kTeal,
                  onReject: () => _rejectOffer(offer.id),
                  onAccept: () => _acceptOffer(offer.id),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  OFFER CARD WIDGET
//  RN: bg rgba(10,22,40,0.6), border rgba(0,213,190,0.2)
//      hover:border-[rgba(0,213,190,0.4)] → AnimatedContainer on hover
// ══════════════════════════════════════════════════════════════════════════════
class _OfferCard extends StatefulWidget {
  final _OfferItem offer;
  final Color kCard, kBorder, kText, kMuted, kTeal;
  final VoidCallback onReject, onAccept;

  const _OfferCard({
    required this.offer, required this.kCard, required this.kBorder,
    required this.kText, required this.kMuted, required this.kTeal,
    required this.onReject, required this.onAccept,
  });

  @override
  State<_OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<_OfferCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // hover:border-[rgba(0,213,190,0.4)] matching RN hover
      onEnter: (_) => setState(() => _pressed = true),
      onExit:  (_) => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: _kFast,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.kCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _pressed
                ? widget.kTeal.withOpacity(0.4)
                : widget.kTeal.withOpacity(0.2),
            width: 0.8,
          ),
        ),
        child: Column(children: [

          // ── Driver info row ───────────────────────────────────────────
          Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00D5BE), Color(0xFF009689)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(
                  color: const Color(0xFF00D5BE).withOpacity(0.3),
                  blurRadius: 8, offset: const Offset(0, 2))],
              ),
              alignment: Alignment.center,
              child: Text(widget.offer.initials,
                  style: const TextStyle(color: Colors.white,
                      fontSize: 14, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.offer.name,
                    style: TextStyle(color: widget.kText, fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(children: [
                  Text(widget.offer.truckType,
                      style: TextStyle(color: widget.kMuted, fontSize: 11)),
                  const SizedBox(width: 6),
                  Container(width: 3, height: 3,
                      decoration: BoxDecoration(
                          color: widget.kMuted, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  const Icon(Icons.star, color: Color(0xFFFBBF24), size: 13),
                  const SizedBox(width: 2),
                  Text('${widget.offer.rating}',
                      style: TextStyle(color: widget.kMuted, fontSize: 11)),
                  const SizedBox(width: 6),
                  Container(width: 3, height: 3,
                      decoration: BoxDecoration(
                          color: widget.kMuted, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text('${widget.offer.trips} trips',
                      style: TextStyle(color: widget.kMuted, fontSize: 11)),
                ]),
              ],
            )),
          ]),
          const SizedBox(height: 12),

          // ── Price box — bg rgba(0,213,190,0.08) matching RN ───────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF00D5BE).withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: const Color(0xFF00D5BE).withOpacity(0.2),
                  width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Price', style: TextStyle(
                      color: widget.kMuted, fontSize: 10)),
                  const SizedBox(height: 2),
                  Text('\$${widget.offer.price}',
                      style: const TextStyle(
                          color: Color(0xFF00D5BE), fontSize: 22,
                          fontWeight: FontWeight.w700)),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('Delivery', style: TextStyle(
                      color: widget.kMuted, fontSize: 10)),
                  const SizedBox(height: 2),
                  Text('4-5 hrs', style: TextStyle(
                      color: widget.kText, fontSize: 14,
                      fontWeight: FontWeight.w600)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Action buttons ────────────────────────────────────────────
          Row(children: [
            // Reject
            _Tap(
              onTap: widget.onReject,
              child: Container(
                width: 44, height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFFEF4444).withOpacity(0.3),
                      width: 0.8),
                ),
                child: const Icon(Icons.close,
                    color: Color(0xFFEF4444), size: 20),
              ),
            ),
            const SizedBox(width: 10),
            // Accept
            Expanded(child: _Tap(
              onTap: widget.onAccept,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF009689), Color(0xFF00BBA7)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(
                    color: const Color(0xFF00D5BE).withOpacity(0.3),
                    blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text('Accept',
                        style: TextStyle(color: Colors.white,
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            )),
          ]),
        ]),
      ),
    );
  }
}