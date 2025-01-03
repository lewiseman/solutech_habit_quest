import 'package:appwrite/appwrite.dart';

Client appwriteClient = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('6772d4a9001f92eafb15');

Account appwriteAccount =  Account(appwriteClient);
