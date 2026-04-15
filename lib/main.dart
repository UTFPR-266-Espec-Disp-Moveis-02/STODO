import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/dashboard/cubit/dashboard_cubit.dart';
import 'package:stodo/app/dashboard/repository/dashboard_repository.dart';
import 'package:stodo/app/library/pages/book_details_page.dart';
import 'package:stodo/app/library/pages/create_update_book_page.dart';
import 'package:stodo/app/library/repository/books_repository.dart';
import 'package:stodo/app/topics/cubit/topics_cubit.dart';
import 'package:stodo/app/topics/cubit/topics_detail_cubit.dart';
import 'package:stodo/app/topics/pages/topics_detail.dart';
import 'package:stodo/app/topics/repository/topics_repository.dart';
import 'package:stodo/core/db/app_database.dart';
import 'package:stodo/core/models/book_model.dart';
import 'package:stodo/core/models/topic_progress_model.dart';

import 'app/base_page.dart';
import 'core/themes/theme_exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppDatabase.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              DashboardCubit(DashboardRepository(), TopicsRepository())
                ..loadDashboard(),
        ),
        BlocProvider(
          create: (_) => TopicsCubit(TopicsRepository())..loadTopics(),
        ),
      ],
      child: MaterialApp(
        title: 'STodo',
        theme: AppDarkTheme.darkTheme,
        darkTheme: AppDarkTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const BasePage(),
        onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/book-details':
            final book = settings.arguments as BookModel;
            return MaterialPageRoute(
              builder: (_) => BookDetailsPage(book: book),
              settings: settings,
            );
          case '/create-update-book':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => CreateUpdateBookPage(
                id: args?['id'] as int?,
                topicId: args?['topicId'] as int?,
              ),
              settings: settings,
            );
          case '/topic-detail':
            final topic = settings.arguments as TopicProgressModel;
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) =>
                    TopicsDetailCubit(BooksRepository())..loadBooks(topic.id),
                child: TopicsDetailPage(topic: topic),
              ),
              settings: settings,
            );
          default:
            return null;
        }
      },
      ),
    );
  }
}