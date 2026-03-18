import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ruta_go/theme/app_theme.dart';
import 'package:ruta_go/utils/responsive.dart';
import 'package:ruta_go/screens/route_result_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _fromController =
  TextEditingController();
  final TextEditingController _toController =
  TextEditingController();
  final FocusNode _fromFocus = FocusNode();
  final FocusNode _toFocus = FocusNode();
  final Dio _dio = Dio();

  List<dynamic> _suggestions = [];
  bool _isLoadingSuggestions = false;
  bool _isFromActive = false;
  bool _isToActive = true;

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
    final name =
        place['display_name'].toString().split(',').first;
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
    setState(() {});
  }

  bool get _canSearch =>
      _fromController.text.isNotEmpty &&
          _toController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [

            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(
                r.spaceXS,
                r.spaceSM,
                r.spaceMD,
                0,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: r.iconMD,
                    ),
                  ),
                  Text(
                    'Find a Route',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: r.fontXL,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: r.spaceSM),

            // Input fields
            Padding(
              padding: EdgeInsets.symmetric(horizontal: r.spaceMD),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(r.radiusXL),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [

                    // FROM field
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.spaceMD,
                        vertical: r.spaceMD,
                      ),
                      child: Row(
                        children: [
                          // Icon container
                          Container(
                            padding: EdgeInsets.all(r.spaceXS),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceAlt,
                              borderRadius: BorderRadius.circular(r.radiusSM),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Icon(
                              Icons.my_location,
                              color: _isFromActive
                                  ? Colors.white
                                  : AppColors.textMuted,
                              size: r.iconSM,
                            ),
                          ),
                          SizedBox(width: r.spaceSM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'FROM',
                                  style: TextStyle(
                                    color: AppColors.textDisabled,
                                    fontSize: r.fontXS * 0.9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(height: r.spaceXS * 0.25),
                                TextField(
                                  controller: _fromController,
                                  focusNode: _fromFocus,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: r.fontMD,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Your current location',
                                    hintStyle: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: r.fontMD,
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
                              ],
                            ),
                          ),
                          if (_fromController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _fromController.clear();
                                setState(() => _suggestions = []);
                              },
                              child: Container(
                                padding: EdgeInsets.all(r.spaceXS * 0.5),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceAlt,
                                  borderRadius:
                                  BorderRadius.circular(999),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: AppColors.textMuted,
                                  size: r.iconSM * 0.8,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Divider with swap button
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: r.spaceMD),
                      child: Row(
                        children: [
                          // Left line
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.border,
                            ),
                          ),

                          // Swap button
                          GestureDetector(
                            onTap: _swapLocations,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: r.spaceXS),
                              padding: EdgeInsets.all(r.spaceXS),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceAlt,
                                borderRadius:
                                BorderRadius.circular(r.radiusSM),
                                border:
                                Border.all(color: AppColors.border),
                              ),
                              child: Icon(
                                Icons.swap_vert,
                                color: AppColors.textSecondary,
                                size: r.iconSM,
                              ),
                            ),
                          ),

                          // Right line
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.border,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // TO field
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.spaceMD,
                        vertical: r.spaceMD,
                      ),
                      child: Row(
                        children: [
                          // Icon container
                          Container(
                            padding: EdgeInsets.all(r.spaceXS),
                            decoration: BoxDecoration(
                              color: _isToActive
                                  ? AppColors.orange.withOpacity(0.15)
                                  : AppColors.surfaceAlt,
                              borderRadius:
                              BorderRadius.circular(r.radiusSM),
                              border: Border.all(
                                color: _isToActive
                                    ? AppColors.orange.withOpacity(0.3)
                                    : AppColors.border,
                              ),
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: _isToActive
                                  ? AppColors.orange
                                  : AppColors.textMuted,
                              size: r.iconSM,
                            ),
                          ),
                          SizedBox(width: r.spaceSM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TO',
                                  style: TextStyle(
                                    color: AppColors.textDisabled,
                                    fontSize: r.fontXS * 0.9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(height: r.spaceXS * 0.25),
                                TextField(
                                  controller: _toController,
                                  focusNode: _toFocus,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: r.fontMD,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Search destination',
                                    hintStyle: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: r.fontMD,
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
                              ],
                            ),
                          ),
                          if (_toController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _toController.clear();
                                setState(() => _suggestions = []);
                              },
                              child: Container(
                                padding: EdgeInsets.all(r.spaceXS * 0.5),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceAlt,
                                  borderRadius:
                                  BorderRadius.circular(999),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: AppColors.textMuted,
                                  size: r.iconSM * 0.8,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Swap button
            Padding(
              padding: EdgeInsets.only(
                right: r.spaceMD,
                top: r.spaceXS,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _swapLocations,
                  child: Container(
                    padding: EdgeInsets.all(r.spaceXS),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                      BorderRadius.circular(r.radiusSM),
                      border:
                      Border.all(color: AppColors.border),
                    ),
                    child: Icon(
                      Icons.swap_vert,
                      color: Colors.white,
                      size: r.iconSM,
                    ),
                  ),
                ),
              ),
            ),

            const Divider(
                color: AppColors.borderAlt, height: 1),

            // Suggestions or Recent
            Expanded(
              child: _suggestions.isNotEmpty
                  ? _buildSuggestions(r)
                  : _buildRecentSearches(r),
            ),

            // Find Route button
            Padding(
              padding: EdgeInsets.fromLTRB(
                r.spaceMD,
                r.spaceSM,
                r.spaceMD,
                r.spaceLG,
              ),
              child: GestureDetector(
                onTap: _canSearch
                    ? () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          RouteResultScreen(
                            origin: _fromController.text,
                            destination: _toController.text,
                          ),
                      transitionsBuilder: (_, animation,
                          __, child) =>
                          SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 1),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            )),
                            child: child,
                          ),
                      transitionDuration: const Duration(
                          milliseconds: 400),
                    ),
                  );
                }
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: r.spaceMD),
                  decoration: BoxDecoration(
                    color: _canSearch
                        ? Colors.white
                        : AppColors.surface,
                    borderRadius:
                    BorderRadius.circular(r.radiusLG),
                    border: Border.all(
                      color: _canSearch
                          ? Colors.white
                          : AppColors.border,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.route_rounded,
                        color: _canSearch
                            ? Colors.black
                            : AppColors.textMuted,
                        size: r.iconMD,
                      ),
                      SizedBox(width: r.spaceXS),
                      Text(
                        'Find Route',
                        style: TextStyle(
                          color: _canSearch
                              ? Colors.black
                              : AppColors.textMuted,
                          fontSize: r.fontMD,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(Responsive r) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: r.spaceMD,
        vertical: r.spaceSM,
      ),
      children: [
        if (_isLoadingSuggestions)
          Center(
            child: Padding(
              padding: EdgeInsets.all(r.spaceLG),
              child: SizedBox(
                width: r.iconLG,
                height: r.iconLG,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
          )
        else
          ..._suggestions.map((place) {
            final name = place['display_name']
                .toString()
                .split(',')
                .first;
            final address =
            place['display_name'].toString();
            return _SuggestionTile(
              name: name,
              address: address,
              isRecent: false,
              r: r,
              onTap: () => _selectSuggestion(place),
            );
          }),
      ],
    );
  }

  Widget _buildRecentSearches(Responsive r) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: r.spaceMD,
        vertical: r.spaceMD,
      ),
      children: [
        Text(
          'RECENT SEARCHES',
          style: TextStyle(
            color: AppColors.textDisabled,
            fontSize: r.fontXS,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: r.spaceSM),
        ..._recentSearches.map((place) => _SuggestionTile(
          name: place['name']!,
          address: place['address']!,
          isRecent: true,
          r: r,
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
}

class _SuggestionTile extends StatelessWidget {
  final String name;
  final String address;
  final bool isRecent;
  final Responsive r;
  final VoidCallback onTap;

  const _SuggestionTile({
    required this.name,
    required this.address,
    required this.isRecent,
    required this.r,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: r.spaceSM),
        padding: EdgeInsets.symmetric(
          horizontal: r.spaceMD,
          vertical: r.spaceMD,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(r.radiusLG),
          border: Border.all(color: AppColors.borderAlt),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(r.spaceXS),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius:
                BorderRadius.circular(r.radiusSM),
              ),
              child: Icon(
                isRecent
                    ? Icons.access_time
                    : Icons.location_on_outlined,
                color: isRecent
                    ? AppColors.textMuted
                    : AppColors.orange,
                size: r.iconSM,
              ),
            ),
            SizedBox(width: r.spaceMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: r.fontMD,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: r.spaceXS * 0.5),
                  Text(
                    address,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: r.fontSM,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.border,
              size: r.iconSM * 0.75,
            ),
          ],
        ),
      ),
    );
  }
}