import 'package:appwrite/appwrite.dart';

Client appwriteClient = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('6772d4a9001f92eafb15');

Account appwriteAccount = Account(appwriteClient);

const appwriteDatabaseId = '677957e2003e1ba5f1dc';

const appwriteHabitsCID = '67795856000c5482c68f';

const appwriteHabitActionsCID = '677ae82b001da713b983';
