import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_typography.dart';
import '../models/models.dart';
import '../providers/mock_data_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/theme_provider.dart';
import '../widgets/cupertino/main_app_header.dart';
import '../widgets/drop_card.dart';

enum _DropSort {
  featured,
  priceLow,
  priceHigh,
  newest,
}

enum _PriceBand {
  all,
  under100,
  between100and300,
  over300,
}

class DropsScreen extends ConsumerStatefulWidget {
  const DropsScreen({super.key});

  @override
  ConsumerState<DropsScreen> createState() => _DropsScreenState();
}

class _DropsScreenState extends ConsumerState<DropsScreen> {
  static const _categories = [
    'All Drops',
    'Footwear',
    'Tech',
    'Apparel',
    'Accessories',
    'Watches',
    'Lifestyle',
    'Collectibles',
  ];

  int _categoryIndex = 0;
  _DropSort _sort = _DropSort.featured;
  _PriceBand _priceBand = _PriceBand.all;
  bool _inStockOnly = false;

  bool _matchesCategory(Drop d, String cat) {
    if (cat == 'All Drops') return true;
    final t = '${d.title} ${d.subtitle} ${d.badge}'.toLowerCase();
    switch (cat) {
      case 'Footwear':
        return t.contains('sneaker') || t.contains('aero') || t.contains('shoe');
      case 'Tech':
        return t.contains('headphone') ||
            t.contains('pulse') ||
            t.contains('dock') ||
            t.contains('cable') ||
            t.contains('lamp') ||
            t.contains('diamond');
      case 'Apparel':
        return t.contains('backpack') || t.contains('nomad') || t.contains('travel');
      case 'Accessories':
        return t.contains('mat') ||
            t.contains('bottle') ||
            t.contains('case') ||
            t.contains('cable') ||
            t.contains('desk');
      case 'Watches':
        return t.contains('chrono') ||
            t.contains('h1') ||
            t.contains('studio pro') ||
            t.contains('watch');
      case 'Lifestyle':
        return t.contains('lamp') || t.contains('bottle') || t.contains('mat') || t.contains('desk');
      case 'Collectibles':
        return t.contains('limited') || t.contains('hot drop') || t.contains('neon');
      default:
        return true;
    }
  }

  bool _dropInStock(Drop d) {
    final b = d.badge.toUpperCase();
    return !b.contains('OUT OF STOCK') && !b.contains('SOLD OUT');
  }

  bool _matchesPriceBand(Drop d) {
    switch (_priceBand) {
      case _PriceBand.all:
        return true;
      case _PriceBand.under100:
        return d.price < 100;
      case _PriceBand.between100and300:
        return d.price >= 100 && d.price <= 300;
      case _PriceBand.over300:
        return d.price > 300;
    }
  }

  List<Drop> _filterAndSort(List<Drop> all) {
    final cat = _categories[_categoryIndex];
    var list = cat == 'All Drops'
        ? List<Drop>.from(all)
        : all.where((d) => _matchesCategory(d, cat)).toList();
    if (_inStockOnly) {
      list = list.where(_dropInStock).toList();
    }
    list = list.where(_matchesPriceBand).toList();
    switch (_sort) {
      case _DropSort.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
      case _DropSort.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
      case _DropSort.newest:
        list = list.reversed.toList();
      case _DropSort.featured:
        break;
    }
    return list;
  }

  Future<void> _openFilterSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _DropsFilterSheet(
          sort: _sort,
          priceBand: _priceBand,
          inStockOnly: _inStockOnly,
          onApply: (sort, price, stock) {
            setState(() {
              _sort = sort;
              _priceBand = price;
              _inStockOnly = stock;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allDrops = ref.watch(dropsProvider);
    final drops = _filterAndSort(allDrops);
    final cs = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    const activePillBg = Color(0xFF162032);
    final ctaBg = isLight ? cs.primary : const Color(0xFF1E2430);

    return Scaffold(
      backgroundColor: cs.background,
      body: Column(
        children: [
          MainAppHeader(
            onTitleLongPress: () {
              final current = ref.read(themeModeProvider);
              ref.read(themeModeProvider.notifier).state =
                  current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 56,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                              padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10, right: 0),
                              itemCount: _categories.length,
                              itemBuilder: (context, index) {
                                final isSelected = index == _categoryIndex;
                                return Padding(
                                  padding: EdgeInsets.only(right: index == _categories.length - 1 ? 0 : 12),
                                  child: GestureDetector(
                                    onTap: () => setState(() => _categoryIndex = index),
                                    behavior: HitTestBehavior.opaque,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 220),
                                      curve: Curves.easeOut,
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? (isLight ? cs.primary : activePillBg)
                                            : cs.surfaceVariant,
                                        borderRadius: BorderRadius.circular(22),
                                        border: Border.all(
                                          color: isSelected
                                              ? (isLight ? cs.primary : cs.primary.withOpacity(0.35))
                                              : cs.outlineVariant,
                                          width: isLight ? 1.0 : 0.6,
                                        ),
                                      ),
                                      child: Text(
                                        _categories[index],
                                        style: AppTypography.buttonText.copyWith(
                                          fontSize: 13,
                                          color: isSelected
                                              ? (isLight ? Colors.white : cs.primary)
                                              : cs.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: _openFilterSheet,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: cs.surfaceVariant,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: cs.outlineVariant, width: isLight ? 1 : 0.6),
                                ),
                                child: Icon(AppIcons.filter, color: cs.onSurfaceVariant, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (drops.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                        child: Text(
                          'No drops match these filters. Try adjusting price or availability.',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySecondary.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.48,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          childCount: drops.length,
                          (context, index) {
                            final offsetTop = index.isOdd ? 40.0 : 0.0;
                            return Transform.translate(
                              offset: Offset(0, offsetTop),
                              child: DropCard(drop: drops[index]),
                            );
                          },
                        ),
                      ),
                    ),

                  SliverToBoxAdapter(
                    child: Builder(
                      builder: (context) {
                        final bottomInset = MediaQuery.paddingOf(context).bottom;
                        final clearance = bottomInset + 120;
                        return Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, clearance),
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: isLight ? cs.primary : ctaBg,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'View New Drops',
                                  style: AppTypography.h2.copyWith(
                                    color: isLight ? Colors.white : cs.onBackground,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  AppIcons.chevronRight,
                                  color: isLight ? Colors.white : cs.onBackground,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropsFilterSheet extends StatefulWidget {
  const _DropsFilterSheet({
    required this.sort,
    required this.priceBand,
    required this.inStockOnly,
    required this.onApply,
  });

  final _DropSort sort;
  final _PriceBand priceBand;
  final bool inStockOnly;
  final void Function(_DropSort sort, _PriceBand price, bool inStock) onApply;

  @override
  State<_DropsFilterSheet> createState() => _DropsFilterSheetState();
}

class _DropsFilterSheetState extends State<_DropsFilterSheet> {
  late _DropSort _sort;
  late _PriceBand _price;
  late bool _inStock;

  @override
  void initState() {
    super.initState();
    _sort = widget.sort;
    _price = widget.priceBand;
    _inStock = widget.inStockOnly;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.58,
      minChildSize: 0.42,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Filters',
                        style: AppTypography.h2.copyWith(fontSize: 18),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _price = _PriceBand.all;
                          _inStock = false;
                          _sort = _DropSort.featured;
                        });
                      },
                      child: Text(
                        'Clear',
                        style: AppTypography.buttonText.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  children: [
                    Text(
                      'PRICE',
                      style: AppTypography.microLabel.copyWith(
                        letterSpacing: 1.0,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _priceChip('Any', _PriceBand.all, cs),
                        _priceChip('Under \$100', _PriceBand.under100, cs),
                        _priceChip('\$100 – \$300', _PriceBand.between100and300, cs),
                        _priceChip('Over \$300', _PriceBand.over300, cs),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'AVAILABILITY',
                      style: AppTypography.microLabel.copyWith(
                        letterSpacing: 1.0,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: cs.background,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                'In stock only',
                                style: AppTypography.bodyPrimary.copyWith(fontSize: 15),
                              ),
                            ),
                          ),
                          CupertinoSwitch(
                            value: _inStock,
                            activeTrackColor: AppColors.accent,
                            onChanged: (v) => setState(() => _inStock = v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'SORT',
                      style: AppTypography.microLabel.copyWith(
                        letterSpacing: 1.0,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _sortTile('Featured', _DropSort.featured, cs),
                    _sortTile('Price: low to high', _DropSort.priceLow, cs),
                    _sortTile('Price: high to low', _DropSort.priceHigh, cs),
                    _sortTile('Newest first', _DropSort.newest, cs),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 12 + bottom),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: () {
                        widget.onApply(_sort, _price, _inStock);
                        Navigator.of(context).pop();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.background,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        'Apply filters',
                        style: AppTypography.buttonText.copyWith(color: AppColors.background),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _priceChip(String label, _PriceBand band, ColorScheme cs) {
    final sel = _price == band;
    return FilterChip(
      label: Text(label),
      selected: sel,
      onSelected: (_) => setState(() => _price = band),
      showCheckmark: false,
      selectedColor: cs.primary.withValues(alpha: 0.2),
      checkmarkColor: cs.primary,
      labelStyle: AppTypography.bodyPrimary.copyWith(
        fontSize: 13,
        color: sel ? cs.primary : cs.onSurfaceVariant,
        fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
      ),
      side: BorderSide(color: sel ? cs.primary : cs.outlineVariant),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }

  Widget _sortTile(String label, _DropSort value, ColorScheme cs) {
    final sel = _sort == value;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _sort = value),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              Icon(
                sel ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 22,
                color: sel ? cs.primary : cs.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyPrimary.copyWith(
                    fontSize: 15,
                    fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                    color: sel ? cs.primary : cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
