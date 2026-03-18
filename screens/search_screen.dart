import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final FocusNode _fromFocus = FocusNode();
  final FocusNode _toFocus = FocusNode();
  final Dio _dio = Dio();

  List<dynamic> _suggestions = [];
  bool _isLoadingSuggestions = false;
  bool _isFromActive = false;
  bool _isToActive = true;

  // Recent searches — mock data muna
  final List<Map<String, String>> _recentSearches = [
    {'name': 'SM Mall of Asia', 'address': 'Bay City, Pasay'},
    {'name': 'Makati CBD', 'address': 'Ayala Avenue, Makati'},
    {'name': 'BGC High Street', 'address': 'Bonifacio Global City'},
    {'name': 'Quezon City Hall', 'address': 'Elliptical Road, QC'},
  ];

  @override
  void initState() {
    super.initState();
    _fromFocus.addListener(() {
      setState(() => _isFromActive = _fromFocus.hasFocus);
    });
    _toFocus.addListener(() {
      setState(() => _isToActive = _toFocus.hasFocus);
    });
    // Auto focus sa "To" field
    Future.delayed(const Duration(milliseconds: 300), () {
      _toFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _fromFocus.dispose();
    _toFocus.dispose();
    super.dispose();
  }

  // Search places via Nominatim
  Future<void> _searchPlaces(String query) async {
    if (query.length < 3) {
      setState(() => _suggestions = []);
      return;
    }

    setState(() => _isLoadingSuggestions = true);

    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': '$query, Philippines',
          'format': 'json',
          'limit': 5,
          'addressdetails': 1,
        },
        options: Options(
          headers: {'User-Agent': 'RutaGoApp/1.0'},
        ),
      );

      if (mounted) {
        setState(() {
          _suggestions = response.data;
          _isLoadingSuggestions = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingSuggestions = false);
      }
    }
  }

  void _selectSuggestion(Map<String, dynamic> place) {
    final name = place['display_name'].toString().split(',').first;
    final address = place['display_name'].toString();

    if (_isFromActive) {
      _fromController.text = name;
    } else {
      _toController.text = name;
    }

    setState(() => _suggestions = []);
    FocusScope.of(context).unfocus();
  }

  void _swapLocations() {
    final temp = _fromController.text;
    _fromController.text = _toController.text;
    _toController.text = temp;
  }

  bool get _canSearch =>
      _fromController.text.isNotEmpty && _toController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [

            // Header
            _buildHeader(),

            // Input fields
            _buildInputFields(),

            const SizedBox(height: 8),

            // Divider
            const Divider(color: Color(0xFF1E1E1E), height: 1),

            // Suggestions or Recent searches
            Expanded(
              child: _suggestions.isNotEmpty
                  ? _buildSuggestions()
                  : _buildRecentSearches(),
            ),

            // Find Route Button
            _buildFindRouteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          const Text(
            'Find a Route',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFields() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Column(
          children: [

            // FROM field
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Row(
                children: [
                  // Dot indicator
                  Column(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isFromActive
                              ? Colors.white
                              : const Color(0xFF444444),
                          border: Border.all(
                            color: _isFromActive
                                ? Colors.white
                                : const Color(0xFF444444),
                            width: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _fromController,
                      focusNode: _fromFocus,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Where are you from?',
                        hintStyle: TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {
                        setState(() => _isFromActive = true);
                        _searchPlaces(value);
                      },
                    ),
                  ),
                  if (_fromController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _fromController.clear();
                        setState(() => _suggestions = []);
                      },
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFF555555),
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),

            // Dotted line divider
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Row(
                children: List.generate(
                  30,
                      (index) => Expanded(
                    child: Container(
                      height: 1,
                      color: index.isEven
                          ? const Color(0xFF2A2A2A)
                          : Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),

            // TO field
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              child: Row(
                children: [
                  // Square indicator
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: _isToActive
                          ? const Color(0xFFFF6D00)
                          : const Color(0xFF444444),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _toController,
                      focusNode: _toFocus,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Where are you going?',
                        hintStyle: TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {
                        setState(() => _isToActive = true);
                        _searchPlaces(value);
                      },
                    ),
                  ),
                  if (_toController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _toController.clear();
                        setState(() => _suggestions = []);
                      },
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFF555555),
                        size: 16,
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

  // Swap button
  Widget _buildSwapButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: _swapLocations,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: const Icon(
              Icons.swap_vert,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        if (_isLoadingSuggestions)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          )
        else
          ..._suggestions.map((place) {
            final name =
                place['display_name'].toString().split(',').first;
            final address = place['display_name'].toString();
            return _SuggestionTile(
              name: name,
              address: address,
              onTap: () => _selectSuggestion(place),
            );
          }),
      ],
    );
  }

  Widget _buildRecentSearches() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        const Text(
          'RECENT SEARCHES',
          style: TextStyle(
            color: Color(0xFF444444),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        ..._recentSearches.map((place) => _SuggestionTile(
          name: place['name']!,
          address: place['address']!,
          isRecent: true,
          onTap: () {
            if (_isToActive) {
              _toController.text = place['name']!;
            } else {
              _fromController.text = place['name']!;
            }
            setState(() {});
          },
        )),
      ],
    );
  }

  Widget _buildFindRouteButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: GestureDetector(
        onTap: _canSearch
            ? () {
          // TODO: Navigate to Route Result Screen
        }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: _canSearch
                ? Colors.white
                : const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _canSearch
                  ? Colors.white
                  : const Color(0xFF2A2A2A),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.route_rounded,
                color: _canSearch
                    ? Colors.black
                    : const Color(0xFF444444),
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Find Route',
                style: TextStyle(
                  color: _canSearch
                      ? Colors.black
                      : const Color(0xFF444444),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final String name;
  final String address;
  final bool isRecent;
  final VoidCallback onTap;

  const _SuggestionTile({
    required this.name,
    required this.address,
    required this.onTap,
    this.isRecent = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E1E1E)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isRecent ? Icons.access_time : Icons.location_on_outlined,
                color: isRecent
                    ? const Color(0xFF555555)
                    : const Color(0xFFFF6D00),
                size: 16,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address,
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF333333),
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}