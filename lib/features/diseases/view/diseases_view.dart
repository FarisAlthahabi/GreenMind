import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/features/diseases/cubit/diseases_cubit.dart';
import 'package:green_mind/features/diseases/model/disease_model/disease_model.dart';
import 'package:green_mind/features/diseases/view/widgets/update_disease_view.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/extensions/locale_x.dart';
import 'package:green_mind/global/extensions/string_x.dart';
import 'package:green_mind/global/models/user_role_enum.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/utils/utils.dart';
import 'package:green_mind/global/widgets/insure_delete_widget.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_app_bar.dart';
import 'package:green_mind/global/widgets/main_drawer.dart';
import 'package:green_mind/global/widgets/main_error_widget.dart';
import 'package:green_mind/global/widgets/main_fab.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';
import 'package:green_mind/global/widgets/main_tile.dart';

abstract class DiseasesViewCallBacks {}

@RoutePage()
class DiseasesView extends StatelessWidget {
  const DiseasesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<DiseasesCubit>(),
      child: const DiseasesPage(),
    );
  }
}

class DiseasesPage extends StatefulWidget {
  const DiseasesPage({super.key});

  @override
  State<DiseasesPage> createState() => _DiseasesPageState();
}

class _DiseasesPageState extends State<DiseasesPage>
    implements DiseasesViewCallBacks {
  late final DiseasesCubit diseasesCubit = context.read();

  @override
  void initState() {
    super.initState();
    fetchDiseases();
  }

  void onDeleteDisease(DiseaseModel disease) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => InsureDeleteWidget(
        item: disease,
        onSuccess: () => diseasesCubit.deleteLocalDisease(disease),
      ),
    );
  }

  void onUpdateDisease(DiseaseModel? disease) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          UpdateDiseaseView(diseasesCubit: diseasesCubit, disease: disease),
    );
  }

  void fetchDiseases() => diseasesCubit.getDiseases();

  @override
  Widget build(BuildContext context) {
    final role = Utils.userRole;
    final locale = context.locale;
    return Scaffold(
      appBar: const MainAppBar(title: "diseases"),
      drawer: const MainDrawer(),
      body: Padding(
        padding: AppConstants.padding16,
        child: Column(
          spacing: 20,
          crossAxisAlignment: .start,
          children: [
            MainTextField(
              hintText: "search_for_disease",
              prefixIcon: const Icon(Icons.search),
              onChanged: diseasesCubit.setSearchQuery,
            ),
            Expanded(
              child: BlocBuilder<DiseasesCubit, GeneralDiseasesState>(
                buildWhen: (_, current) => current is DiseasesState,
                builder: (context, state) {
                  if (state is DiseasesLoading) {
                    return const Align(child: LoadingIndicator());
                  } else if (state is DiseasesSuccess) {
                    final diseases = state.diseases;
                    return RefreshIndicator(
                      onRefresh: () async => fetchDiseases(),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          spacing: 16,
                          children: AnimationConfiguration.toStaggeredList(
                            duration: AppConstants.duration500ms,
                            childAnimationBuilder: (widget) => SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(child: widget),
                            ),
                            children: [
                              ...diseases.map(
                                (disease) =>
                                    _buildDiseaseTile(disease, role, locale),
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (state is DiseasesEmpty) {
                    return MainErrorWidget(
                      error: state.message,
                      isRefresh: true,
                      onTryAgainTap: fetchDiseases,
                    );
                  } else if (state is DiseasesFail) {
                    return MainErrorWidget(
                      error: state.error,
                      onTryAgainTap: fetchDiseases,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: !role.isFarmer
          ? MainFab(onTap: () => onUpdateDisease(null))
          : null,
    );
  }

  Widget _buildDiseaseTile(
    DiseaseModel disease,
    UserRoleEnum role,
    Locale locale,
  ) {
    final name = locale.isAr ? disease.arName : disease.enName;
    return MainTile(
      child: Column(
        spacing: 16,
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .start,
            spacing: 10,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: context.tt.titleLarge?.copyWith(fontWeight: .bold),
                ),
              ),
              if (!role.isFarmer) ...[
                _buildIconBtn(
                  Icons.edit,
                  context.cs.secondaryContainer,
                  context.cs.secondary,
                  () => onUpdateDisease(disease),
                ),
                _buildIconBtn(
                  Icons.delete,
                  context.cs.errorContainer,
                  context.cs.error,
                  () => onDeleteDisease(disease),
                ),
              ],
            ],
          ),
          Row(
            crossAxisAlignment: .start,
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${"technical_name".tr()}: ${disease.technicalName}",
                ),
              ),
              Text("${"date".tr()}: ${disease.createdAt?.formatYYYYMMDD}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconBtn(
    IconData icon,
    Color bgColor,
    Color color,
    void Function() onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppConstants.borderRadius10,
        ),
        child: Padding(
          padding: AppConstants.padding10,
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
