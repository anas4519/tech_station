import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/devices/presentation/bloc/device_list_bloc.dart';
import 'features/account/presentation/bloc/theme_bloc.dart';
import 'features/account/presentation/bloc/theme_state.dart';
import 'injection_container.dart';

class TechStationApp extends StatelessWidget {
  const TechStationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider<DeviceListBloc>(create: (_) => sl<DeviceListBloc>()),
        BlocProvider<ThemeBloc>(create: (_) => sl<ThemeBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          final authBloc = context.read<AuthBloc>();
          final router = AppRouter.router(authBloc);

          return MaterialApp.router(
            title: 'Tech Station',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
