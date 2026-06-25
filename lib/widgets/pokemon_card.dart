import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../models/constants.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final bool isFavorite;
  final bool isInTeam;
  final bool isShiny;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleTeam;
  final ValueChanged<Pokemon> onSelect;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.isFavorite,
    required this.isInTeam,
    required this.isShiny,
    required this.onToggleFavorite,
    required this.onToggleTeam,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    // Primary color from first type
    final primaryType = pokemon.types.isNotEmpty ? pokemon.types.first : 'normal';
    final primaryColor = getTypeColor(primaryType);
    
    return GestureDetector(
      onTap: () => onSelect(pokemon),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.05),
              blurRadius: 20,
              spreadRadius: -5,
            )
          ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Background glow
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withValues(alpha: 0.2),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ID & Icons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '#${pokemon.id.toString().padLeft(3, '0')}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: onToggleTeam,
                              child: Icon(
                                isInTeam ? Icons.shield : Icons.shield_outlined,
                                size: 20,
                                color: isInTeam ? Colors.amber : Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: onToggleFavorite,
                              child: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                size: 20,
                                color: isFavorite ? Colors.redAccent : Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    
                    // Image
                    Expanded(
                      child: Hero(
                        tag: 'pokemon_image_${pokemon.id}',
                        child: Image.network(
                          isShiny ? pokemon.shinyImageUrl : pokemon.imageUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                          },
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.grey),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Name
                    Text(
                      pokemon.name.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Types
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: pokemon.types.map((t) {
                        final typeColor = getTypeColor(t);
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.2),
                            border: Border.all(color: typeColor.withValues(alpha: 0.5), width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            getTypeNameAz(t),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: typeColor.withValues(alpha: 0.9),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
