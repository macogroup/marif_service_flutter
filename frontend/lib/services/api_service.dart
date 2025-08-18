import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../core/constants.dart';
import 'models.dart';

class ApiService {
  const ApiService();

  Future<List<Character>> getTopCharacters({bool safetyFilter = true}) async {
    final raw = await rootBundle.loadString(AssetPaths.json('characters.json'));
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    final characters = list.map((e) => Character.fromJson(e as Map<String, dynamic>)).toList();
    return characters.take(10).toList();
  }

  Future<List<Character>> getRumorCharacters() async {
    return getTopCharacters();
  }

  Future<List<Character>> getCharactersByFilter(IdealTypeFilter filter) async {
    final all = await getTopCharacters();
    if (filter == IdealTypeFilter.all) return all;
    return all.where((c) => c.tags.contains(_mapFilterToTag(filter))).toList();
  }

  Future<List<ChatSummary>> getPinnedChats() async {
    final raw = await rootBundle.loadString(AssetPaths.json('chats.json'));
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final List<dynamic> list = json['pinned'] as List<dynamic>;
    return list.map((e) => ChatSummary.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<ChatSummary>> getChats() async {
    final raw = await rootBundle.loadString(AssetPaths.json('chats.json'));
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final List<dynamic> list = json['items'] as List<dynamic>;
    return list.map((e) => ChatSummary.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Profile> getProfile() async {
    final raw = await rootBundle.loadString(AssetPaths.json('profile.json'));
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return Profile.fromJson(json);
  }

  Future<List<Character>> getRecommendations(RecommendTab tab) async {
    final all = await getTopCharacters();
    switch (tab) {
      case RecommendTab.all:
        return all;
      case RecommendTab.women:
        return all.where((c) => c.tags.contains('милый')).toList();
      case RecommendTab.men:
        return all.where((c) => c.tags.contains('сексуальный')).toList();
    }
  }

  // TODO: интеграция с backend (FastAPI + LangChain)
  Future<void> sendStartChat(String characterId) async {}

  String _mapFilterToTag(IdealTypeFilter filter) {
    switch (filter) {
      case IdealTypeFilter.cute:
        return 'милый';
      case IdealTypeFilter.sexy:
        return 'сексуальный';
      case IdealTypeFilter.funny:
        return 'весёлый';
      case IdealTypeFilter.all:
        return '';
    }
  }
}


