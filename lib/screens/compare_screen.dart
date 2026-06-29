import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../models/constants.dart';

class CompareScreen extends StatefulWidget {
  final List<Pokemon> availablePokemon;

  const CompareScreen({super.key, required this.availablePokemon});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  Pokemon? pokemon1;
  Pokemon? pokemon2;

  @override
  void initState() {
    super.initState();
    if (widget.availablePokemon.isNotEmpty) {
      pokemon1 = widget.availablePokemon[0];
      if (widget.availablePokemon.length > 1) {
        pokemon2 = widget.availablePokemon[1];
      }
    }
  }

  @override
  void didUpdateWidget(CompareScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.availablePokemon.isNotEmpty && pokemon1 == null) {
      pokemon1 = widget.availablePokemon.first;
    }
  }

  Widget _buildPokemonSelector(Pokemon? current, ValueChanged<Pokemon?> onChanged, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Pokemon>(
          isExpanded: true,
          value: widget.availablePokemon.contains(current) ? current : null,
          dropdownColor: AppColors.surface,
          hint: Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
          items: widget.availablePokemon.map((p) {
            return DropdownMenuItem<Pokemon>(
              value: p,
              child: Text(
                '${p.name.toUpperCase()} (#${p.id})',
                style: const TextStyle(color: Colors.white, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.availablePokemon.isEmpty) {
      return const Center(
        child: Text(AppStrings.compareNoPokemon, style: TextStyle(color: Colors.white)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildSelectors(),
          const SizedBox(height: 24),
          _buildImages(),
          const SizedBox(height: 32),
          if (pokemon1 != null && pokemon2 != null) _buildStatsCompare(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          const Icon(Icons.bar_chart, size: 40, color: Colors.cyan),
          const SizedBox(height: 12),
          const Text(
            AppStrings.compareTitle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.compareSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectors() {
    return Row(
      children: [
        Expanded(
          child: _buildPokemonSelector(pokemon1, (p) => setState(() => pokemon1 = p), AppStrings.pokemon1Label),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(AppStrings.vsText, style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        Expanded(
          child: _buildPokemonSelector(pokemon2, (p) => setState(() => pokemon2 = p), AppStrings.pokemon2Label),
        ),
      ],
    );
  }

  Widget _buildImages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (pokemon1 != null)
          Column(
            children: [
              Image.network(pokemon1!.imageUrl, height: 120, width: 120),
              const SizedBox(height: 8),
              Text(pokemon1!.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          )
        else
          const SizedBox(width: 120, height: 120),

        if (pokemon2 != null)
          Column(
            children: [
              Image.network(pokemon2!.imageUrl, height: 120, width: 120),
              const SizedBox(height: 8),
              Text(pokemon2!.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          )
        else
          const SizedBox(width: 120, height: 120),
      ],
    );
  }

  Widget _buildStatsCompare() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: statDetails.keys.map((statKey) {
          final s1 = pokemon1!.stats.firstWhere((s) => s.statName == statKey, orElse: () => PokemonStat(baseStat: 0, statName: statKey));
          final s2 = pokemon2!.stats.firstWhere((s) => s.statName == statKey, orElse: () => PokemonStat(baseStat: 0, statName: statKey));
          
          final statInfo = statDetails[statKey]!;
          
          final isP1Winner = s1.baseStat > s2.baseStat;
          final isP2Winner = s2.baseStat > s1.baseStat;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Text(
                  statInfo.nameAz,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // P1 Bar
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            s1.baseStat.toString(),
                            style: TextStyle(
                              color: isP1Winner ? Colors.green : Colors.white,
                              fontWeight: isP1Winner ? FontWeight.w900 : FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(3.14159), // flip horizontally so it grows right to left
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: s1.baseStat / 255.0,
                                  minHeight: 8,
                                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                                  valueColor: AlwaysStoppedAnimation<Color>(isP1Winner ? Colors.green : statInfo.color),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // P2 Bar
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: s2.baseStat / 255.0,
                                minHeight: 8,
                                backgroundColor: Colors.white.withValues(alpha: 0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(isP2Winner ? Colors.green : statInfo.color),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            s2.baseStat.toString(),
                            style: TextStyle(
                              color: isP2Winner ? Colors.green : Colors.white,
                              fontWeight: isP2Winner ? FontWeight.w900 : FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
