import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../services/api_service.dart';
import '../../services/models.dart';
import '../../core/widgets/asset_media.dart';

class IdealTypeScreen extends StatefulWidget {
  const IdealTypeScreen({super.key});

  @override
  State<IdealTypeScreen> createState() => _IdealTypeScreenState();
}

class _IdealTypeScreenState extends State<IdealTypeScreen> {
  final ApiService _api = const ApiService();
  IdealTypeFilter _filter = IdealTypeFilter.all;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 8),
          _buildFilters(),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<Character>>(
              future: _api.getCharactersByFilter(_filter),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(AppInsets.s16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, i) => _CharacterGridCard(character: items[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    Widget chip(IdealTypeFilter f, String label) {
      final selected = f == _filter;
      return ChoiceChip(
        selected: selected,
        label: Text(label),
        onSelected: (_) => setState(() => _filter = f),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: [
        chip(IdealTypeFilter.all, 'весь'),
        chip(IdealTypeFilter.cute, 'милый'),
        chip(IdealTypeFilter.sexy, 'сексуальный'),
        chip(IdealTypeFilter.funny, 'весёлый'),
      ],
    );
  }
}

class _CharacterGridCard extends StatelessWidget {
  final Character character;
  const _CharacterGridCard({required this.character});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          assetImage(
            character.imageAsset,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppRadius.r12),
              topRight: Radius.circular(AppRadius.r12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppInsets.s12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(character.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(character.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.favorite, size: 16, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Text('${character.likes}')
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


