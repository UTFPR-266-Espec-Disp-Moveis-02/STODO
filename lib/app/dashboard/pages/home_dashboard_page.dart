import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stodo/app/dashboard/cubit/dashboard_cubit.dart';
import 'package:stodo/app/dashboard/repository/dashboard_repository.dart';
import 'package:stodo/app/dashboard/states/dashboard_states.dart';

import '../../../core/components/assets/app_logo_horizontal.dart';
import '../../../core/components/states/full_empty_state.dart';
import '../../../core/themes/colors.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DashboardCubit(DashboardRepository())..loadDashboard(),
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        appBar: AppBar(
          centerTitle: false,
          title: AppLogoHorizontal(height: 42, width: 145),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {},
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gray400, width: 1),
                      color: AppColors.gray400.withValues(alpha: 0.2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.white60,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Colors.white10, height: 1),
          ),
        ),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DashboardErrorState) {
              return Center(child: Text(state.message));
            }

            if (state is DashboardSuccessState) {
              if (state.recentBooks.isEmpty && state.topicProgress.isEmpty) {
                return Container(
                  color: AppColors.primaryDark,
                  child: FullEmptyState(
                    title: 'Sua jornada de estudos\ncomeça aqui',
                    subtitle:
                        'Cadastre seu primeiro livro ou crie um tópico\npara organizar seus materiais.',
                    primaryButtonText: 'Cadastrar Livro',
                    onPrimaryPressed: () {},
                    outlineButtonText: 'Criar Tópico',
                    onOutlinePressed: () {},
                  ),
                );
              }

              return const Center(
                child: Text('Dashboard Carregado com Sucesso!'),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
