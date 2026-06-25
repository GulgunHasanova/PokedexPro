import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../models/constants.dart';

class PokemonDetailModal extends StatelessWidget {
  final Pokemon pokemon;
  final bool isFavorite;
  final bool isInTeam;
  final bool isShiny;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleTeam;
  final VoidCallback onClose;

  const PokemonDetailModal({
    super.key,
    required this.pokemon,
    required this.isFavorite,
    required this.isInTeam,
    required this.isShiny,
    required this.onToggleFavorite,
    required this.onToggleTeam,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final primaryType = pokemon.types.isNotEmpty ? pokemon.types.first : 'normal';
    final primaryColor = getTypeColor(primaryType);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // slate-950 roughly
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(color: primaryColor.withValues(alpha: 0.3), width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: onClose,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isInTeam ? Icons.shield : Icons.shield_outlined,
                        color: isInTeam ? Colors.amber : Colors.white.withValues(alpha: 0.5),
                      ),
                      onPressed: onToggleTeam,
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color: isFavorite ? Colors.redAccent : Colors.white.withValues(alpha: 0.5),
                      ),
                      onPressed: onToggleFavorite,
                    ),
                  ],
                )
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  // Image
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withValues(alpha: 0.1),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.2),
                          blurRadius: 40,
                          spreadRadius: 10,
                        )
                      ],
                    ),
                    child: Hero(
                      tag: 'pokemon_image_detail_${pokemon.id}',
                      child: Image.network(
                        isShiny ? pokemon.shinyImageUrl : pokemon.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name & ID
                  Text(
                    '#${pokemon.id.toString().padLeft(3, '0')}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pokemon.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Types
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: pokemon.types.map((t) {
                      final c = getTypeColor(t);
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: c.withValues(alpha: 0.2),
                          border: Border.all(color: c.withValues(alpha: 0.5), width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          getTypeNameAz(t),
                          style: TextStyle(
                            color: c.withValues(alpha: 0.9),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Stats
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      children: pokemon.stats.map((stat) {
                        final statInfo = statDetails[stat.statName] ??
                            StatDetail(nameAz: stat.statName, shortAz: stat.statName, color: Colors.grey);
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: Text(
                                  statInfo.shortAz,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                                child: Text(
                                  stat.baseStat.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: stat.baseStat / 255.0, // max stat is usually 255
                                    minHeight: 8,
                                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                                    valueColor: AlwaysStoppedAnimation<Color>(statInfo.color),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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
