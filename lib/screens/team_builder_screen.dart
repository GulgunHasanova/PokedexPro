import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../widgets/pokemon_card.dart';

class TeamBuilderScreen extends StatelessWidget {
  final List<Pokemon> team;
  final Function(Pokemon) onRemoveFromTeam;
  final Function(Pokemon) onSelectPokemon;
  final VoidCallback onOpenCatalog;

  const TeamBuilderScreen({
    super.key,
    required this.team,
    required this.onRemoveFromTeam,
    required this.onSelectPokemon,
    required this.onOpenCatalog,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                const Icon(Icons.shield, size: 40, color: Colors.amber),
                const SizedBox(height: 12),
                const Text(
                  'Komanda Qurucusu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Xəyalınızdakı 6 Pokemon-dan ibarət komandanı qurun.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
                ),
                const SizedBox(height: 16),
                
                // Slots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    final isFilled = index < team.length;
                    return Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isFilled ? Colors.amber.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                        border: Border.all(
                          color: isFilled ? Colors.amber : Colors.white.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: isFilled
                          ? Center(
                              child: Image.network(
                                team[index].imageUrl,
                                width: 24,
                                height: 24,
                              ),
                            )
                          : Icon(Icons.add, size: 16, color: Colors.white.withValues(alpha: 0.2)),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          if (team.isEmpty)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Icon(Icons.catching_pokemon, size: 60, color: Colors.white.withValues(alpha: 0.2)),
                  const SizedBox(height: 16),
                  const Text(
                    'Komandanız boşdur',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kataloqdan pokemon əlavə edin.',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: onOpenCatalog,
                    icon: const Icon(Icons.map),
                    label: const Text('Kataloqa Keç'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 10,
                      shadowColor: Colors.amber.withValues(alpha: 0.5),
                    ),
                  )
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: team.length,
              itemBuilder: (context, index) {
                final pokemon = team[index];
                return Stack(
                  children: [
                    Positioned.fill(
                      child: PokemonCard(
                        pokemon: pokemon,
                        isFavorite: false, // not needed context
                        isInTeam: true,
                        isShiny: false, // keeping normal here, or pass global
                        onToggleFavorite: () {}, // empty
                        onToggleTeam: () => onRemoveFromTeam(pokemon),
                        onSelect: onSelectPokemon,
                      ),
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(blurRadius: 4, color: Colors.red.withValues(alpha: 0.5))],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 16, color: Colors.white),
                          onPressed: () => onRemoveFromTeam(pokemon),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
