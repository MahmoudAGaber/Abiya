import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:janel_abiya/presentation/home/provider/categoryViewModel.dart';
import 'package:janel_abiya/presentation/home/screen/home.dart';
import 'package:janel_abiya/presentation/home/screen/OrderScreen.dart';
import 'package:janel_abiya/presentation/home/screen/ProductDetailScreen.dart';
import 'package:path_provider/path_provider.dart';

import 'domain/models/OrderModel.dart';
import 'domain/models/ProductModel.dart';
import 'domain/models/SizeModel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(ProductModelAdapter()); // Register the adapter
  Hive.registerAdapter(SizeModelAdapter()); // Register other adapters if needed
  Hive.registerAdapter(SizeQuantityModelAdapter());
  Hive.registerAdapter(OrderModelAdapter());

  runApp(const ProviderScope(child: JanelAbiyeApp()));
}

class JanelAbiyeApp extends ConsumerWidget {
  const JanelAbiyeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/orders', builder: (_, __) => const OrdersScreen()),
        GoRoute(
          path: '/product/:code',
          builder: (context, state) {
            final code = state.pathParameters['code']!;
            final product = ref.read(productProvider).data!.firstWhere((p) => p.code == code);
            return ProductDetailScreen(product: product,);
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Janel Abiye',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
      routerConfig: _router,
    );
  }
}