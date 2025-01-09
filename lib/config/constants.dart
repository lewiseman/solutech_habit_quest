import 'package:appwrite/appwrite.dart';

Client appwriteClient = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('677ff48c000cb7fb611b');

Account appwriteAccount = Account(appwriteClient);

const appwriteDatabaseId = '677ff623003390a574b0';

const appwriteHabitsCID = '677ff764000d64aeb1a3';

const appwriteHabitActionsCID = '677ff8870007f409f2bc';

const appwriteExploreBlogCID = '677ff64b0003d2fa952a';

const maxPageWidth = 600.0;

const generalAvatar =
    'https://api.dicebear.com/9.x/adventurer-neutral/svg?radius=50';
