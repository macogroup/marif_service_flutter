import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../services/api_service.dart';
import '../../services/models.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final api = const ApiService();
    return SafeArea(
      child: FutureBuilder<Profile>(
        future: api.getProfile(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final p = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(AppInsets.s16),
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 32, backgroundImage: AssetImage(p.avatarAsset)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.monetization_on, color: AppColors.currencyYellow, size: 18),
                            const SizedBox(width: 4),
                            Text('Кредиты: ${p.credits}   Монеты: ${p.coins}',
                                style: const TextStyle(color: AppColors.secondaryText)),
                          ],
                        )
                      ],
                    ),
                  ),
                  OutlinedButton(onPressed: () {}, child: const Text('Редактировать'))
                ],
              ),
              const SizedBox(height: 16),
              _SectionCard(title: 'Кредиты и подписки', children: [
                _RowButton(text: 'Смотрите видеорекламу', onPressed: () {}),
                _RowButton(text: 'Зарядка', onPressed: () {}),
              ]),
              const SizedBox(height: 16),
              _SectionCard(title: 'Моя деятельность', children: [
                _RowButton(text: 'Мой персонаж', onPressed: () {}),
                _RowButton(text: 'Мои записи', onPressed: () {}),
                _RowButton(text: 'Моя подарочная коробка', onPressed: () {}),
              ]),
              const SizedBox(height: 16),
              _SectionCard(title: 'Управление', children: [
                _RowButton(text: 'Управление блокировкой', onPressed: () {}),
              ]),
            ],
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppInsets.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _RowButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _RowButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(text),
      trailing: const Icon(Icons.chevron_right),
      onTap: onPressed,
    );
  }
}


