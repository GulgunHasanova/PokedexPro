import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/constants.dart';
import 'package:pokedex/services/poke_api.dart';
import 'package:pokedex/screens/catalog_screen.dart';
import 'package:pokedex/screens/team_builder_screen.dart';
import 'package:pokedex/screens/compare_screen.dart';
import 'package:pokedex/widgets/pokemon_detail.dart';

void main() {
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokedexPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter', // Assuming standard font, but can fallback
        colorScheme: const ColorScheme.dark(
          primary: Colors.amber,
          surface: Color(0xFF0F172A),
        ),
        scaffoldBackgroundColor: const Color(0xFF0B1121),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final PokeApiService _apiService = PokeApiService();
  
  List<Pokemon> _allPokemon = [];
  List<Pokemon> _filteredPokemon = [];
  final List<int> _favorites = [];
  final List<Pokemon> _team = [];
  
  bool _isLoading = false;
  String _error = "";
  
  Region _activeRegion = regions[1]; // Default to Kanto
  String _searchQuery = "";
  bool _showFavoritesOnly = false;
  bool _isShinyGlobal = false;

  @override
  void initState() {
    super.initState();
    _loadRegion();
  }

  Future<void> _loadRegion() async {
    setState(() {
      _isLoading = true;
      _error = "";
      _allPokemon = [];
      _filteredPokemon = [];
    });

    try {
      final list = await _apiService.fetchPokemonList(
        limit: _activeRegion.limit,
        offset: _activeRegion.offset,
      );
      setState(() {
        _allPokemon = list;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredPokemon = _allPokemon.where((p) {
        if (_showFavoritesOnly && !_favorites.contains(p.id)) {
          return false;
        }
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          if (!p.name.toLowerCase().contains(query) && p.id.toString() != query) {
            return false;
          }
        }
        return true;
      }).toList();
    });
  }

  void _onSearch(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _onRegionChanged(Region r) {
    if (_activeRegion == r) return;
    _activeRegion = r;
    _loadRegion();
  }

  void _toggleFavorite(Pokemon p) {
    setState(() {
      if (_favorites.contains(p.id)) {
        _favorites.remove(p.id);
      } else {
        _favorites.add(p.id);
      }
    });
    _applyFilters();
  }

  void _toggleTeam(Pokemon p) {
    setState(() {
      if (_team.any((t) => t.id == p.id)) {
        _team.removeWhere((t) => t.id == p.id);
      } else {
        if (_team.length < 6) {
          _team.add(p);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Komandada artıq 6 Pokemon var!'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });
  }

  void _showDetails(Pokemon p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return FractionallySizedBox(
              heightFactor: 0.85,
              child: PokemonDetailModal(
                pokemon: p,
                isFavorite: _favorites.contains(p.id),
                isInTeam: _team.any((t) => t.id == p.id),
                isShiny: _isShinyGlobal,
                onToggleFavorite: () {
                  _toggleFavorite(p);
                  setModalState(() {});
                },
                onToggleTeam: () {
                  _toggleTeam(p);
                  setModalState(() {});
                },
                onClose: () => Navigator.pop(context),
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_currentIndex == 0) {
      body = CatalogScreen(
        filteredPokemon: _filteredPokemon,
        isLoading: _isLoading,
        error: _error,
        favorites: _favorites,
        team: _team,
        isShinyGlobal: _isShinyGlobal,
        onSearch: _onSearch,
        onRegionChanged: _onRegionChanged,
        activeRegion: _activeRegion,
        showFavoritesOnly: _showFavoritesOnly,
        onToggleFavoritesOnly: () {
          _showFavoritesOnly = !_showFavoritesOnly;
          _applyFilters();
        },
        onToggleShinyGlobal: () {
          setState(() {
            _isShinyGlobal = !_isShinyGlobal;
          });
        },
        onToggleFavorite: _toggleFavorite,
        onToggleTeam: _toggleTeam,
        onSelectPokemon: _showDetails,
      );
    } else if (_currentIndex == 1) {
      body = TeamBuilderScreen(
        team: _team,
        onRemoveFromTeam: _toggleTeam,
        onSelectPokemon: _showDetails,
        onOpenCatalog: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      );
    } else {
      body = CompareScreen(
        availablePokemon: _allPokemon,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.amber, Colors.redAccent]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'Pokedex',
              style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 22),
            ),
            const Text(
              'Pro',
              style: TextStyle(fontWeight: FontWeight.w900, color: Colors.amber, fontSize: 22),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A).withValues(alpha: 0.9),
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(child: body),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: const Color(0xFF0F172A),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Kataloq',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Komandam',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Müqayisə',
          ),
        ],
      ),
    );
  }
}
