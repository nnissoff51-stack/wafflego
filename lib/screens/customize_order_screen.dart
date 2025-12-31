import 'package:flutter/material.dart';

class _UnitConfig {
  final Set<String> toppings = {};
  String? mix;
}

class CustomizeOrderScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const CustomizeOrderScreen({super.key, required this.item});

  @override
  State<CustomizeOrderScreen> createState() => _CustomizeOrderScreenState();
}

class _CustomizeOrderScreenState extends State<CustomizeOrderScreen> {
  int qty = 1;

  // options
  final List<String> toppings = const ["Oreo Crumbs", "Honey Drizzle"];
  final List<String> mixWith = const ["Butter", "Kaya", "Peanut", "Strawberry", "Chocolate"];

  // per-item config
  final List<_UnitConfig> units = [_UnitConfig()];

  double get basePrice => (widget.item["price"] as num).toDouble();
  double unitTotal(_UnitConfig u) => basePrice + (u.toppings.length * 0.50);
  double get total => units.fold(0.0, (sum, u) => sum + unitTotal(u));

  void _setQty(int newQty) {
    if (newQty < 1) return;
    setState(() {
      qty = newQty;
      while (units.length < qty) units.add(_UnitConfig());
      while (units.length > qty) units.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.item["name"] as String;
    final desc = widget.item["desc"] as String;
    final image = widget.item["image"] as String;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF5E8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Customize Order"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ✅ scroll area
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      image,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // PRODUCT CARD
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Text(
                              "RM${basePrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        Text(
                          desc,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // QTY
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _QtyButton(
                                icon: Icons.remove_rounded,
                                onTap: qty > 1 ? () => _setQty(qty - 1) : null,
                              ),
                              Container(
                                width: 44,
                                alignment: Alignment.center,
                                child: Text(
                                  "$qty",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              _QtyButton(
                                icon: Icons.add_rounded,
                                onTap: () => _setQty(qty + 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ✅ PER-ITEM customization (dalam scroll)
                  for (int i = 0; i < units.length; i++) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Item ${i + 1}",
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                          ),
                          const SizedBox(height: 10),

                          _SectionCard(
                            title: "Topping (+RM0.50 each)",
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                for (final t in toppings)
                                  _TagChip(
                                    text: t,
                                    selected: units[i].toppings.contains(t),
                                    onTap: () {
                                      setState(() {
                                        if (!units[i].toppings.add(t)) {
                                          units[i].toppings.remove(t);
                                        }
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          _SectionCard(
                            title: "Mix with (choose 1)",
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                for (final m in mixWith)
                                  _TagChip(
                                    text: m,
                                    selected: units[i].mix == m,
                                    onTap: () {
                                      setState(() {
                                        units[i].mix = (units[i].mix == m) ? null : m;
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Subtotal: RM${unitTotal(units[i]).toStringAsFixed(2)}",
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),

            // ✅ fixed bottom bar (tak lari)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Total", style: TextStyle(color: Colors.black54)),
                      const SizedBox(height: 4),
                      Text(
                        "RM${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final summary = [
                          for (int i = 0; i < units.length; i++)
                            "Item ${i + 1}: topping = ${units[i].toppings.isEmpty ? "-" : units[i].toppings.join(", ")} mix = ${units[i].mix ?? "-"}"
                        ].join(" | ");

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Added $qty item(s) • $summary")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                      ),
                      child: const Text(
                        "Add Order",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================
// Small widgets
// =====================

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QtyButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: onTap == null ? Colors.black12 : const Color(0xFFFFE2B8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1D8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _TagChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.orange),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: selected ? Colors.white : Colors.orange,
          ),
        ),
      ),
    );
  }
}