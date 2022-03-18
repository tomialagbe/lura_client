import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lura_client/screens/authentication/bloc/onboarding_screen_bloc.dart';
import 'package:lura_client/screens/widgets/app_bars.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:lura_client/ui/widgets/circular_icon_button.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:rxdart/rxdart.dart';

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
                : Container(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child:
                        _OnboardingForm(sizingInformation: sizingInformation),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(widget.sizingInformation.isDesktop ? 100 : 20),
        Text(
          'What\'s your organization name?',
          style: LuraTextStyles.baseTextStyle.copyWith(
              color: LuraColors.blue,
              fontSize: 36,
              fontWeight: FontWeight.w400),
        ),
        const Gap(40),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _orgNameController,
                style: const TextStyle(fontSize: 18, color: LuraColors.blue),
                decoration: const InputDecoration(
                  filled: false,
                  hintText: 'Organization name',
                  hintStyle: TextStyle(
                    color: LuraColors.blue,
                    fontSize: 20,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: LuraColors.blue, width: 1),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: LuraColors.blue, width: 1),
                  ),
                ),
                validator: (name) {
                  if (name == null || name.trim().isEmpty) {
                    return 'Your organization name is required';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              const Gap(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StreamBuilder<bool>(
                    stream: _formCompleteStream,
                    builder: (context, snapshot) {
                      final isFormComplete = (snapshot.data ?? false);
                      final isSubmitting = context
                          .watch<OnboardingScreenBloc>()
                          .state
                          .isSubmitting;
                      return CircularIconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        onTap:
                            isFormComplete && !isSubmitting ? _onSubmit : null,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final businessName = _orgNameController.text.trim();
      context.read<OnboardingScreenBloc>().saveBusiness(businessName);
    }
  }
}
