import 'package:flutter/material.dart';
import 'package:ruta_go/theme/app_theme.dart';
import 'package:ruta_go/utils/responsive.dart';
import 'package:ruta_go/screens/search_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<SavedPlace> _savedPlaces = [
    SavedPlace(
      id: '1',
      name: 'Home',
      address: '123 Quezon Avenue, Quezon City',
      icon: Icons.home_rounded,
      type: PlaceType.home,
    ),
    SavedPlace(
      id: '2',
      name: 'Work',
      address: 'Ayala Avenue, Makati CBD',
      icon: Icons.work_rounded,
      type: PlaceType.work,
    ),
    SavedPlace(
      id: '3',
      name: 'SM Mall of Asia',
      address: 'Bay City, Pasay',
      icon: Icons.star_rounded,
      type: PlaceType.favorite,
    ),
    SavedPlace(
      id: '4',
      name: 'BGC High Street',
      address: 'Bonifacio Global City, Taguig',
      icon: Icons.star_rounded,
      type: PlaceType.favorite,
    ),
  ];

  void _deletePlace(String id) {
    setState(() {
      _savedPlaces.removeWhere((place) => place.id == id);
    });
  }

  IconData _getTypeIcon(PlaceType type) {
    switch (type) {
      case PlaceType.home:
        return Icons.home_rounded;
      case PlaceType.work:
        return Icons.work_rounded;
      case PlaceType.favorite:
        return Icons.star_rounded;
    }
  }

  String _getTypeLabel(PlaceType type) {
    switch (type) {
      case PlaceType.home:
        return 'Home';
      case PlaceType.work:
        return 'Work';
      case PlaceType.favorite:
        return 'Favorite';
    }
  }

  Color _getTypeColor(PlaceType type) {
    switch (type) {
      case PlaceType.home:
        return const Color(0xFF2196F3);
      case PlaceType.work:
        return const Color(0xFF4CAF50);
      case PlaceType.favorite:
        return AppColors.orange;
    }
  }

  void _showAddPlaceSheet(BuildContext context) {
    final r = Responsive(context);
    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    PlaceType selectedType = PlaceType.favorite;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: EdgeInsets.all(r.spaceMD),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(r.radiusXL),
                ),
                border: const Border(
                  top: BorderSide(color: AppColors.borderAlt),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Handle
                  Center(
                    child: Container(
                      width: r.screenWidth * 0.1,
                      height: 4,
                      margin: EdgeInsets.only(bottom: r.spaceMD),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    'Add Saved Place',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: r.fontXL,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: r.spaceLG),

                  // Type selector label
                  Text(
                    'TYPE',
                    style: TextStyle(
                      color: AppColors.textDisabled,
                      fontSize: r.fontXS,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),

                  SizedBox(height: r.spaceSM),

                  // Type selector
                  Row(
                    children: PlaceType.values.map((type) {
                      final isSelected = selectedType == type;
                      final isLast =
                          type == PlaceType.values.last;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setSheetState(
                                  () => selectedType = type),
                          child: AnimatedContainer(
                            duration:
                            const Duration(milliseconds: 200),
                            margin: EdgeInsets.only(
                              right: isLast ? 0 : r.spaceXS,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: r.spaceSM,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.surfaceAlt,
                              borderRadius: BorderRadius.circular(
                                  r.radiusMD),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.border,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  _getTypeIcon(type),
                                  color: isSelected
                                      ? Colors.black
                                      : AppColors.textSecondary,
                                  size: r.iconMD,
                                ),
                                SizedBox(height: r.spaceXS * 0.5),
                                Text(
                                  _getTypeLabel(type),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.black
                                        : AppColors.textSecondary,
                                    fontSize: r.fontXS,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: r.spaceLG),

                  // Name label
                  Text(
                    'NAME',
                    style: TextStyle(
                      color: AppColors.textDisabled,
                      fontSize: r.fontXS,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),

                  SizedBox(height: r.spaceSM),

                  // Name field
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.spaceMD,
                      vertical: r.spaceSM,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius:
                      BorderRadius.circular(r.radiusLG),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: nameController,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: r.fontMD,
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g. Home, Office, Gym',
                        hintStyle: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: r.fontMD,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  SizedBox(height: r.spaceMD),

                  // Address label
                  Text(
                    'ADDRESS',
                    style: TextStyle(
                      color: AppColors.textDisabled,
                      fontSize: r.fontXS,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),

                  SizedBox(height: r.spaceSM),

                  // Address field
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.spaceMD,
                      vertical: r.spaceSM,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius:
                      BorderRadius.circular(r.radiusLG),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: addressController,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: r.fontMD,
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g. Ayala Avenue, Makati',
                        hintStyle: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: r.fontMD,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  SizedBox(height: r.spaceLG),

                  // Save button
                  GestureDetector(
                    onTap: () {
                      if (nameController.text.isNotEmpty &&
                          addressController.text.isNotEmpty) {
                        setState(() {
                          _savedPlaces.add(SavedPlace(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            name: nameController.text,
                            address: addressController.text,
                            icon: _getTypeIcon(selectedType),
                            type: selectedType,
                          ));
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding:
                      EdgeInsets.symmetric(vertical: r.spaceMD),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(r.radiusLG),
                      ),
                      child: Text(
                        'Save Place',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: r.fontMD,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: r.spaceSM),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(
                r.spaceMD,
                r.spaceMD,
                r.spaceMD,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saved Places',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: r.font3XL,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: r.spaceXS * 0.5),
                      Text(
                        '${_savedPlaces.length} places saved',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: r.fontSM,
                        ),
                      ),
                    ],
                  ),

                  // Add button
                  GestureDetector(
                    onTap: () => _showAddPlaceSheet(context),
                    child: Container(
                      padding: EdgeInsets.all(r.spaceSM),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(r.radiusMD),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                        size: r.iconMD,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: r.spaceLG),

            // Content
            Expanded(
              child: _savedPlaces.isEmpty
                  ? _buildEmptyState(r)
                  : _buildSavedList(r),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Responsive r) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(r.spaceLG),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              Icons.bookmark_outline,
              color: AppColors.textSecondary,
              size: r.iconXL,
            ),
          ),
          SizedBox(height: r.spaceLG),
          Text(
            'No saved places yet',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: r.fontXL,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: r.spaceXS),
          Text(
            'Save your favorite destinations\nfor quick access',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: r.fontMD,
              height: 1.5,
            ),
          ),
          SizedBox(height: r.spaceLG),
          GestureDetector(
            onTap: () => _showAddPlaceSheet(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: r.spaceLG,
                vertical: r.spaceMD,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.black, size: r.iconSM),
                  SizedBox(width: r.spaceXS),
                  Text(
                    'Add a Place',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: r.fontMD,
                      fontWeight: FontWeight.w700,
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

  Widget _buildSavedList(Responsive r) {
    final homeWork = _savedPlaces
        .where((p) =>
    p.type == PlaceType.home || p.type == PlaceType.work)
        .toList();
    final favorites = _savedPlaces
        .where((p) => p.type == PlaceType.favorite)
        .toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: r.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Home & Work
          if (homeWork.isNotEmpty) ...[
            Text(
              'HOME & WORK',
              style: TextStyle(
                color: AppColors.textDisabled,
                fontSize: r.fontXS,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: r.spaceSM),
            ...homeWork.map((place) => _SavedPlaceTile(
              place: place,
              color: _getTypeColor(place.type),
              r: r,
              onDelete: () => _deletePlace(place.id),
              onTap: () => Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                  const SearchScreen(),
                  transitionsBuilder:
                      (_, animation, __, child) =>
                      FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                ),
              ),
            )),
            SizedBox(height: r.spaceLG),
          ],

          // Favorites
          if (favorites.isNotEmpty) ...[
            Text(
              'FAVORITES',
              style: TextStyle(
                color: AppColors.textDisabled,
                fontSize: r.fontXS,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: r.spaceSM),
            ...favorites.map((place) => _SavedPlaceTile(
              place: place,
              color: _getTypeColor(place.type),
              r: r,
              onDelete: () => _deletePlace(place.id),
              onTap: () => Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                  const SearchScreen(),
                  transitionsBuilder:
                      (_, animation, __, child) =>
                      FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                ),
              ),
            )),
          ],

          SizedBox(height: r.spaceLG),
        ],
      ),
    );
  }
}

// ─── Widgets ──────────────────────────────────────────

class _SavedPlaceTile extends StatelessWidget {
  final SavedPlace place;
  final Color color;
  final Responsive r;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _SavedPlaceTile({
    required this.place,
    required this.color,
    required this.r,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: r.spaceSM),
        padding: EdgeInsets.all(r.spaceMD),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(r.radiusLG),
          border: Border.all(color: AppColors.borderAlt),
        ),
        child: Row(
          children: [

            // Icon
            Container(
              padding: EdgeInsets.all(r.spaceSM),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(r.radiusMD),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Icon(place.icon, color: color, size: r.iconMD),
            ),

            SizedBox(width: r.spaceMD),

            // Name + Address
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: r.fontMD,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: r.spaceXS * 0.5),
                  Text(
                    place.address,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: r.fontSM,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Delete button
            GestureDetector(
              onTap: () => _confirmDelete(context),
              child: Container(
                padding: EdgeInsets.all(r.spaceXS),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(r.radiusSM),
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: AppColors.textMuted,
                  size: r.iconSM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(r.radiusXL),
        ),
        child: Padding(
          padding: EdgeInsets.all(r.spaceLG),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Remove Place?',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: r.fontXL,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: r.spaceXS),
              Text(
                'Remove "${place.name}" from saved places?',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: r.fontMD,
                ),
              ),
              SizedBox(height: r.spaceLG),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: r.spaceMD),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceAlt,
                          borderRadius:
                          BorderRadius.circular(r.radiusLG),
                          border:
                          Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: r.fontMD,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: r.spaceSM),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        onDelete();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: r.spaceMD),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.15),
                          borderRadius:
                          BorderRadius.circular(r.radiusLG),
                          border: Border.all(
                              color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Text(
                          'Remove',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: r.fontMD,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Models ───────────────────────────────────────────

enum PlaceType { home, work, favorite }

class SavedPlace {
  final String id;
  final String name;
  final String address;
  final IconData icon;
  final PlaceType type;

  SavedPlace({
    required this.id,
    required this.name,
    required this.address,
    required this.icon,
    required this.type,
  });
}