import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'file:///C:/Users/HAKKICAN/Desktop/Sifirdan%20Flutter%20ile%20Android%20ve%20Ios%20Apps%20Development/flutter%20projeleri/stuvent_hakkican/lib/repository/user_repository.dart';
import 'package:provider/provider.dart';

import 'package:stuventmobil/ui/homepage/home_page.dart';
import 'package:stuventmobil/ui/Login/login.dart';

class LandingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, UserRepository userRepo, child){
      switch(userRepo.durum){
        case UserDurum.Idle:
          return SplashEkran();
        case UserDurum.OturumAciliyor:
        case UserDurum.OturumAcilmamis:
          return Login();
        case UserDurum.OturumAcik:
          return HomePage();
        default :
          return SplashEkran();
      }
    });
  }
}

class SplashEkran extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}