import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../services/api_service.dart';
import '../../services/models.dart';
import '../chat/chat_screen.dart';
import '../../core/widgets/asset_media.dart';
import '../../core/app_router.dart';

class RecommendScreen extends StatefulWidget {
  const RecommendScreen({super.key});

  @override
  State<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> with SingleTickerProviderStateMixin {
  final ApiService _api = const ApiService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Создаем TabController с 3 вкладками
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // Освобождаем ресурсы TabController
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Верхние вкладки для переключения между категориями
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Все рекомендации'),
              Tab(text: 'Для женщин'),
              Tab(text: 'Для мужчин'),
            ],
          ),
          // ГЛАВНОЕ ИЗМЕНЕНИЕ: Ограничиваем высоту области с карточками
          SizedBox(
            height: 270, // Увеличили общую высоту с 240 до 270 из-за больших изображений
            child: TabBarView(
              controller: _tabController,
              children: [
                _RecommendList(loader: () => _api.getRecommendations(RecommendTab.all)),
                _RecommendList(loader: () => _api.getRecommendations(RecommendTab.women)),
                _RecommendList(loader: () => _api.getRecommendations(RecommendTab.men)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _RecommendList extends StatelessWidget {
  final Future<List<Character>> Function() loader;
  const _RecommendList({required this.loader});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Character>>(
      future: loader(),
      builder: (context, snapshot) {
        // Показываем индикатор загрузки пока данные не загружены
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final items = snapshot.data!;

        // Горизонтальный список карточек
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          scrollDirection: Axis.horizontal, // Горизонтальная прокрутка
          itemCount: items.length,
          itemBuilder: (_, i) => Padding(
            // Отступы: больший слева для первого элемента, справа для последнего
            padding: EdgeInsets.only(left: i == 0 ? 16 : 12, right: i == items.length - 1 ? 16 : 0),
            child: _RecommendCard(character: items[i]),
          ),
        );
      },
    );
  }
}

class _RecommendCard extends StatelessWidget {
  final Character character;
  const _RecommendCard({required this.character});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180, // Уменьшили ширину карточки с 220 до 180
      child: Card(
        // Убираем лишние отступы у Card
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(8), // Уменьшили padding с AppInsets.s12 до 8
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Карточка занимает минимум места по высоте
            children: [
              // Изображение персонажа - увеличиваем размер для лучшего восприятия
              assetImage(
                character.name == 'Алиса' ? 'assets/images/avatars/alice_avatar.jpg' : character.imageAsset,
                height: 100, // Увеличили высоту с 55 до 80 для более заметного изображения
                width: double.infinity,
                fit: BoxFit.cover, // Обрезает изображение, чтобы заполнить область
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              const SizedBox(height: 3), // Минимальный отступ после изображения

              // Имя персонажа - компактный шрифт
              Text(
                  character.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14 // Увеличили шрифт имени с 12 до 14
                  )
              ),
              const SizedBox(height: 2), // Минимальный отступ

              // Теги персонажа - максимально компактные
              Wrap(
                spacing: 2, // Минимальное расстояние между тегами
                children: character.tags.take(2).map((t) => Chip(
                  label: Text(
                      t,
                      style: const TextStyle(fontSize: 10) // Увеличили шрифт тегов с 8 до 10
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 2), // Минимальный padding
                )).toList(),
              ),
              const SizedBox(height: 2), // Минимальный отступ

              // Цитата персонажа
              const Text(
                  '"Короткая цитата"',
                  style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 11 // Увеличили шрифт цитаты с 9 до 11
                  )
              ),
              const SizedBox(height: 4), // Небольшой отступ перед кнопкой

              // Кнопка для начала разговора - компактная
              SizedBox(
                width: double.infinity,
                height: 28, // Уменьшили высоту кнопки
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // Убираем padding кнопки
                    textStyle: const TextStyle(fontSize: 12), // Увеличили шрифт кнопки с 10 до 12
                  ),
                  onPressed: () {
                    // Переходим на экран чата с выбранным персонажем
                    Navigator.of(context).push(
                      fadeRoute(ChatScreen.placeholder(character: character)),
                    );
                  },
                  child: const Text('Разговаривать'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}