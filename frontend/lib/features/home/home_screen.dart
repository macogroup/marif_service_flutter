import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../services/api_service.dart';
import '../../services/models.dart';
import '../chat/chat_screen.dart';
import '../../core/widgets/asset_media.dart';
import '../../core/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _api = const ApiService();
  bool _safetyFilter = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            title: const Text('Мариф'),
            actions: [
              Row(
                children: [
                  const Icon(Icons.monetization_on, color: AppColors.currencyYellow),
                  const SizedBox(width: 4),
                  const Text('1,250', style: TextStyle(color: AppColors.currencyYellow)),
                  const SizedBox(width: 12),
                  const Icon(Icons.timer, color: AppColors.secondaryText),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: AppColors.primaryText),
                    onPressed: () {},
                  )
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppInsets.s16, vertical: AppInsets.s12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Фильтр безопасности', style: TextStyle(color: AppColors.secondaryText)),
                  Switch(
                    value: _safetyFilter,
                    onChanged: (v) => setState(() => _safetyFilter = v),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionHeader(title: 'Самые продаваемые в наши дни (ТОП10)'),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 210,
              child: FutureBuilder<List<Character>>(
                future: _api.getTopCharacters(safetyFilter: _safetyFilter),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final items = snapshot.data!;
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppInsets.s16),
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final c = items[index];
                      return _CharacterCard(
                        character: c,
                        onTap: () {
                          Navigator.of(context).push(
                            fadeRoute(ChatScreen.placeholder(character: c)),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionHeader(title: 'Сарафанное радио распространяется'),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 210,
              child: FutureBuilder<List<Character>>(
                future: _api.getRumorCharacters(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final items = snapshot.data!;
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppInsets.s16),
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final c = items[index];
                      return _CharacterCard(
                        character: c,
                        onTap: () {
                          Navigator.of(context).push(
                            fadeRoute(ChatScreen.placeholder(character: c)),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppInsets.s16, AppInsets.s16, AppInsets.s16, AppInsets.s8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;
  const _CharacterCard({required this.character, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r12),
      child: Ink(
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            assetImage(
              character.imageAsset,
              height: 110,
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
                  Text(character.description, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text('@${character.author}', style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


