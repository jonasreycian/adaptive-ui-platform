# Stacked & BLoC Architecture Integration

## Adaptive UI Platform

This guide shows how to consume `adaptive_ui_platform` packages inside apps built with two popular Flutter architectures: **Stacked** and **BLoC**.

---

## Stacked Architecture

[Stacked](https://stacked.filledstacks.com/) is a production-ready Flutter MVVM framework by FilledStacks. It uses `ViewModelBuilder` and `BaseViewModel` to separate UI from business logic.

### 1. Add dependencies

```yaml
# your_app/pubspec.yaml
dependencies:
  stacked: ^3.4.0
  stacked_services: ^1.1.0

  # Platform packages
  ckgroup_core_engine:
    path: ../adaptive_ui_platform/packages/ckgroup_core_engine
```

### 2. Register brands in `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';
import 'app.dart';

void main() {
  BrandRegistry.instance.register(
    const BrandConfig(
      brandId: 'my_stacked_app',
      displayName: 'My App',
      lightTokens: ColorTokens.light,
      darkTokens: ColorTokens.dark,
    ),
  );
  runApp(const MyApp());
}
```

### 3. Wrap the widget tree with platform providers

```dart
// lib/app.dart
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';
import 'app_viewmodel.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      viewModelBuilder: AppViewModel.new,
      builder: (context, viewModel, child) {
        final brand = BrandRegistry.instance.find('my_stacked_app')!;
        final colors = brand.resolveColors(isDark: viewModel.isDark);
        return BrandResolver(
          brand: brand,
          child: TokenResolver(
            colors: colors,
            spacing: SpacingTokens.instance,
            typography: TypographyTokens.instance,
            radius: RadiusTokens.instance,
            elevation: ElevationTokens.instance,
            motion: MotionTokens.instance,
            child: MaterialApp.router(
              routerConfig: viewModel.router,
            ),
          ),
        );
      },
    );
  }
}
```

### 4. Create a ViewModel

```dart
// lib/app_viewmodel.dart
import 'package:stacked/stacked.dart';

class AppViewModel extends BaseViewModel {
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggleDark() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
```

### 5. Use `AdaptiveScaffold` in a view

```dart
// lib/features/home/home_view.dart
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return AdaptiveScaffold(
      body: Center(
        child: AdaptiveButton(
          label: 'Get Started',
          onPressed: viewModel.navigateToLoan,
        ),
      ),
    );
  }
}
```

### 6. Unit-test the ViewModel

```dart
// test/home_viewmodel_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/features/home/home_viewmodel.dart';

void main() {
  group('HomeViewModel', () {
    test('initialises correctly', () {
      final vm = HomeViewModel();
      expect(vm.isBusy, isFalse);
    });
  });
}
```

---

## BLoC Architecture

[flutter_bloc](https://bloclibrary.dev/) is a predictable state management library from Felix Angelov. It uses `Cubit` / `Bloc` with `BlocBuilder` to drive the UI.

### 1. Add dependencies

```yaml
# your_app/pubspec.yaml
dependencies:
  flutter_bloc: ^8.1.0
  equatable: ^2.0.5

  ckgroup_core_engine:
    path: ../adaptive_ui_platform/packages/ckgroup_core_engine
```

### 2. Register brands in `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';
import 'blocs/theme/theme_cubit.dart';
import 'app.dart';

void main() {
  BrandRegistry.instance.register(
    const BrandConfig(
      brandId: 'my_bloc_app',
      displayName: 'My App',
      lightTokens: ColorTokens.light,
      darkTokens: ColorTokens.dark,
    ),
  );
  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(),
      child: const MyApp(),
    ),
  );
}
```

### 3. ThemeCubit

```dart
// lib/blocs/theme/theme_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false); // false = light mode

  void toggleDark() => emit(!state);
}
```

### 4. Wrap the widget tree

```dart
// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';
import 'blocs/theme/theme_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDark) {
        final brand = BrandRegistry.instance.find('my_bloc_app')!;
        final colors = brand.resolveColors(isDark: isDark);
        return BrandResolver(
          brand: brand,
          child: TokenResolver(
            colors: colors,
            spacing: SpacingTokens.instance,
            typography: TypographyTokens.instance,
            radius: RadiusTokens.instance,
            elevation: ElevationTokens.instance,
            motion: MotionTokens.instance,
            child: MaterialApp(
              home: const HomeScreen(),
            ),
          ),
        );
      },
    );
  }
}
```

### 5. Feature BLoC example

```dart
// lib/blocs/loan/loan_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class LoanEvent extends Equatable {
  const LoanEvent();
  @override
  List<Object?> get props => [];
}

class LoanStepAdvanced extends LoanEvent {
  const LoanStepAdvanced();
}

class LoanStepRetreated extends LoanEvent {
  const LoanStepRetreated();
}

class LoanSubmitted extends LoanEvent {
  const LoanSubmitted();
}

// State
class LoanState extends Equatable {
  const LoanState({this.currentStep = 0, this.submitted = false});

  final int currentStep;
  final bool submitted;

  LoanState copyWith({int? currentStep, bool? submitted}) => LoanState(
        currentStep: currentStep ?? this.currentStep,
        submitted: submitted ?? this.submitted,
      );

  @override
  List<Object?> get props => [currentStep, submitted];
}

// BLoC
class LoanBloc extends Bloc<LoanEvent, LoanState> {
  static const int _totalSteps = 4;

  LoanBloc() : super(const LoanState()) {
    on<LoanStepAdvanced>(_onAdvanced);
    on<LoanStepRetreated>(_onRetreated);
    on<LoanSubmitted>(_onSubmitted);
  }

  void _onAdvanced(LoanStepAdvanced event, Emitter<LoanState> emit) {
    if (state.currentStep < _totalSteps - 1) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void _onRetreated(LoanStepRetreated event, Emitter<LoanState> emit) {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onSubmitted(LoanSubmitted event, Emitter<LoanState> emit) {
    emit(state.copyWith(submitted: true));
  }
}
```

### 6. Connect the BLoC to an `AdaptiveButton`

```dart
// lib/screens/loan_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';
import '../blocs/loan/loan_bloc.dart';

class LoanFormScreen extends StatelessWidget {
  const LoanFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoanBloc, LoanState>(
      builder: (context, state) {
        return AdaptiveScaffold(
          body: Column(
            children: [
              Text('Step ${state.currentStep + 1} of 4'),
              AdaptiveButton(
                label: state.currentStep < 3 ? 'Next' : 'Submit',
                onPressed: () {
                  if (state.currentStep < 3) {
                    context.read<LoanBloc>().add(const LoanStepAdvanced());
                  } else {
                    context.read<LoanBloc>().add(const LoanSubmitted());
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### 7. Unit-test the BLoC

```dart
// test/loan_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/blocs/loan/loan_bloc.dart';

void main() {
  group('LoanBloc', () {
    blocTest<LoanBloc, LoanState>(
      'emits step 1 when LoanStepAdvanced added',
      build: LoanBloc.new,
      act: (bloc) => bloc.add(const LoanStepAdvanced()),
      expect: () => [const LoanState(currentStep: 1)],
    );

    blocTest<LoanBloc, LoanState>(
      'does not go below step 0',
      build: LoanBloc.new,
      act: (bloc) => bloc.add(const LoanStepRetreated()),
      expect: () => [],
    );

    blocTest<LoanBloc, LoanState>(
      'sets submitted on LoanSubmitted',
      build: LoanBloc.new,
      seed: () => const LoanState(currentStep: 3),
      act: (bloc) => bloc.add(const LoanSubmitted()),
      expect: () => [const LoanState(currentStep: 3, submitted: true)],
    );
  });
}
```

---

## Summary

| Concern | Stacked | BLoC |
|---|---|---|
| State holder | `BaseViewModel` | `Cubit` / `Bloc` |
| UI binding | `ViewModelBuilder` / `StackedView` | `BlocBuilder` |
| Theme toggle | `AppViewModel.toggleDark()` | `ThemeCubit.toggleDark()` |
| Token resolution | `TokenResolver.of(context)` | `TokenResolver.of(context)` |
| Brand resolution | `BrandResolver` widget | `BrandResolver` widget |
| Navigation | `NavigationService` (Stacked) | `go_router` / `Navigator` |
| Testing | `flutter_test` + Mockito | `bloc_test` + `flutter_test` |

Both architectures consume platform packages in exactly the same way: register brands at startup, wrap the tree with `BrandResolver` + `TokenResolver`, and use `TokenResolver.of(context)` inside widgets. Only the state-management layer differs.
