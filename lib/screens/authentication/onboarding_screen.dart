import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lura_client/screens/authentication/bloc/onboarding_screen_bloc.dart';
import 'package:lura_client/screens/widgets/app_bars.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:rxdart/rxdart.dart';

import '../../ui/widgets/buttons/lura_flat_button.dart';
import '../../ui/widgets/lura_text_field.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      return Scaffold(
        appBar: luraAppBar(context),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: sizingInformation.isMobile
                ? SingleChildScrollView(
                    child:
                        _OnboardingForm(sizingInformation: sizingInformation))
                : Center(
                    child: SizedBox(
                      width: 700,
                      child:
                          _OnboardingForm(sizingInformation: sizingInformation),
                    ),
                  ),
          ),
        ),
      );
    });
  }
}

class _OnboardingForm extends StatefulWidget {
  final SizingInformation sizingInformation;

  const _OnboardingForm({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  State<_OnboardingForm> createState() => _OnboardingFormState();
}

class _OnboardingFormState extends State<_OnboardingForm> {
  final _orgNameController = TextEditingController();
  final _formCompleteStream = BehaviorSubject.seeded(false);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _orgNameController.addListener(() {
      _formCompleteStream
          .add(_orgNameController.text.trim().isEmpty ? false : true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenBloc = context.watch<OnboardingScreenBloc>();
    final isSubmitting = screenBloc.state.isSubmitting;
    final isComplete = screenBloc.state.completed;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.sizingInformation.isMobile)
            Gap(0.1 * MediaQuery.of(context).size.height),
          Text(
            'Onboarding',
            style: widget.sizingInformation.isDesktop
                ? Theme.of(context).textTheme.headline3
                : Theme.of(context).textTheme.headline4,
          ),
          const Gap(20),
          Text(
            'What\'s your business name?',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const Gap(40),
          LuraTextField(
            large: true,
            controller: _orgNameController,
            textInputValidator: (name) {
              if (name == null || name.trim().isEmpty) {
                return 'Your organization name is required';
              }
              return null;
            },
            keyboardType: TextInputType.text,
            hintText: 'Your business name',
          ),
          const Gap(30),
          LuraFlatButton(
            text: 'Save',
            onTap: !isSubmitting && !isComplete ? _onSubmit : null,
          ),
        ],
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final businessName = _orgNameController.text.trim();
      context.read<OnboardingScreenBloc>().saveBusiness(businessName);
    }
  }
}
