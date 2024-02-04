import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hieroglyphic_app/Screens/home_screen/home_screen.dart';
import 'package:hieroglyphic_app/Screens/loginscreen/cubit/state.dart';
import 'package:hieroglyphic_app/Screens/test_real.dart';
import 'package:hieroglyphic_app/compenets/components.dart';
import 'package:hieroglyphic_app/Screens/register_screen/register_screen.dart';
import 'package:hieroglyphic_app/compenets/constant/colors.dart';
import 'package:hieroglyphic_app/screens/loginscreen/cubit/cubit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isLoading = false;

  LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => socialloginCubit(),
      child: BlocConsumer<socialloginCubit, LoginState>(
        listener: (context, state) {
          if(state is LoginLoading){
            isLoading=true;
          }else if(state is IsAdmin){
            Navigator.pushNamed(
                context, HomeScreen.routeName, arguments: emailController.text);
            isLoading=false;
          }
          else if(state is LoginSuccess){
            Navigator.pushNamed(
                context, HomeScreen.routeName, arguments: emailController.text);
            isLoading=false;
          }else if(state is LoginFailure){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.errorMessage )));
           isLoading=false;
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColor.primaryColor,
                title:  Text(AppLocalizations.of(context)!.loginAppBar),
                centerTitle: true,
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 100.0,
                              width: 100.0,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Center(
                            child: Text(
                              "Welcome Back",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Center(
                            child: Text(
                              "Login to continue",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            enabled: true,
                            validator: (value) {

                              if (value!.isEmpty) {
                                return 'Please enter Email';
                              }



                            },
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.email,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            //  obscureText: socialloginCubit.get(context).isPassword,
                            enabled: true,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter password';
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.key),
                              // suffixIcon: IconButton(
                              //   onPressed: () {
                              //     socialloginCubit.get(context).ChangePassword();
                              //   },
                              //   icon: Icon(
                              //     socialloginCubit.get(context).suffix,
                              //   ),
                              // ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          textButton(
                            function: () {
                              // navigateTo(context, const RestPasswordScreen());
                            },
                            text: "Forgotten password?",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          defaultMaterialButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                BlocProvider.of<socialloginCubit>(context)
                                    .LoginUser(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  context: context,
                                );
                              } else {}
                            },
                            text: 'Login',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Don\'t have an account?',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              textButton(

                                function: () {
                                  navigateTo(context, RegisterScreen());
                                },

                                text: 'Register Now!',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
