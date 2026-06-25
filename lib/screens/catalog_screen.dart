import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../models/constants.dart';
import '../widgets/pokemon_card.dart';

class CatalogScreen extends StatelessWidget {
  final List<Pokemon> filteredPokemon;
  final bool isLoading;
  final String error;
  final List<int> favorites;
  final List<Pokemon> team;
  final bool isShinyGlobal;
  final ValueChanged<String> onSearch;
  final ValueChanged<Region> onRegionChanged;
  final Region activeRegion;
  final bool showFavoritesOnly;
  final VoidCallback onToggleFavoritesOnly;
  final VoidCallback onToggleShinyGlobal;
  final Function(Pokemon) onToggleFavorite;
  final Function(Pokemon) onToggleTeam;
  final Function(Pokemon) onSelectPokemon;

  const CatalogScreen({
    super.key,
    required this.filteredPokemon,
    required this.isLoading,
    required this.error,
    required this.favorites,
    required this.team,
    required this.isShinyGlobal,
    required this.onSearch,
    required this.onRegionChanged,
    required this.activeRegion,
    required this.showFavoritesOnly,
    required this.onToggleFavoritesOnly,
    required this.onToggleShinyGlobal,
    required this.onToggleFavorite,
    required this.onToggleTeam,
    required this.onSelectPokemon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Controls
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search
              TextField(
                onChanged: onSearch,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Pokemon axtar (ad və ya ID)...',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                  prefixIcon: Icon(Icons.search, color: Colors.white.withValues(alpha: 0.4)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.amber),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Region Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Region>(
                          value: activeRegion,
                          dropdownColor: const Color(0xFF0F172A),
                          icon: Icon(Icons.filter_list, size: 16, color: Colors.white.withValues(alpha: 0.5)),
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          items: regions.map((r) {
                            return DropdownMenuItem<Region>(
                              value: r,
                              child: Text(r.nameAz),
                            );
                          }).toList(),
                          onChanged: (r) {
                            if (r != null) onRegionChanged(r);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // Favorites filter toggle
                    FilterChip(
                      label: const Text('Favoritlər', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      selected: showFavoritesOnly,
                      onSelected: (_) => onToggleFavoritesOnly(),
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                      selectedColor: Colors.redAccent.withValues(alpha: 0.2),
                      side: BorderSide(
                        color: showFavoritesOnly ? Colors.redAccent.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.1),
                      ),
                      labelStyle: TextStyle(
                        color: showFavoritesOnly ? Colors.redAccent : Colors.white.withValues(alpha: 0.6),
                      ),
                      avatar: Icon(
                        Icons.star,
                        size: 14,
                        color: showFavoritesOnly ? Colors.redAccent : Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Shiny toggle
                    FilterChip(
                      label: const Text('Shiny Mod', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      selected: isShinyGlobal,
                      onSelected: (_) => onToggleShinyGlobal(),
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                      selectedColor: Colors.amber.withValues(alpha: 0.2),
                      side: BorderSide(
                        color: isShinyGlobal ? Colors.amber.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.1),
                      ),
                      labelStyle: TextStyle(
                        color: isShinyGlobal ? Colors.amber : Colors.white.withValues(alpha: 0.6),
                      ),
                      avatar: Icon(
                        Icons.auto_awesome,
                        size: 14,
                        color: isShinyGlobal ? Colors.amber : Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Grid
        Expanded(
          child: isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: Colors.amber),
                      const SizedBox(height: 16),
                      Text(
                        'Pokedex Yüklənir...',
                        style: TextStyle(color: Colors.amber.withValues(alpha: 0.8), letterSpacing: 2, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : error.isNotEmpty
                  ? Center(child: Text('Error: $error', style: const TextStyle(color: Colors.redAccent)))
                  : filteredPokemon.isEmpty
                      ? Center(
                          child: Container(
                            margin: const EdgeInsets.all(32),
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search_off, size: 48, color: Colors.white.withValues(alpha: 0.4)),
                                const SizedBox(height: 16),
                                const Text(
                                  'Nəticə Tapılmadı',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Daxil etdiyiniz kriteriyalara uyğun pokemon tapılmadı.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100), // extra bottom padding
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // can use LayoutBuilder for responsiveness
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: filteredPokemon.length,
                          itemBuilder: (context, index) {
                            final pokemon = filteredPokemon[index];
                            return PokemonCard(
                              pokemon: pokemon,
                              isFavorite: favorites.contains(pokemon.id),
                              isInTeam: team.any((p) => p.id == pokemon.id),
                              isShiny: isShinyGlobal,
                              onToggleFavorite: () => onToggleFavorite(pokemon),
                              onToggleTeam: () => onToggleTeam(pokemon),
                              onSelect: onSelectPokemon,
                            );
                          },
                        ),
        ),
      ],
    );
  }
}
