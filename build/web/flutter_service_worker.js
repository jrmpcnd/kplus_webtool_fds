'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "6ec2081ff7aa615801dff5a08049384a",
"index.html": "009ebedef2cf753d0eb4edde16cdfdbb",
"/": "009ebedef2cf753d0eb4edde16cdfdbb",
"main.dart.js": "35b97e5809d665f58d0e601b0fe61cc6",
"flutter.js": "7d69e653079438abfbb24b82a655b0a4",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"mwap_side_logo.png": "a51a8387dbf40f4266c426fb735d6d89",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "93a0134e490a929191f57d4228deac65",
"assets/images/whitelist_logo.png": "c68e0d04e0cf5582cdf2f4c68fc642b3",
"assets/images/mila_sme.png": "3d1b79c27cb5de24b57183865dc4400f",
"assets/images/uploads.png": "4813e2cb72bbc2bb7861d572785efd16",
"assets/images/warning.png": "8a361e3c14a31a44f877a04086a9ad51",
"assets/images/access.png": "553409729b8889d14775c54e94ae810a",
"assets/images/clientbg.png": "663efd952d082ad2862380e793431b86",
"assets/images/amla_logo.png": "3f0570e7850ad27496e581ba67a38214",
"assets/images/user_management.png": "926f84948c730bbb84fe540893bf42a0",
"assets/images/page4.jpeg": "fd15307439fdfc593f2ff8df1f12faa2",
"assets/images/yt.png": "1e956b0f5deaec74b2d69e445bb4db07",
"assets/images/mwap_login_bg.png": "8534c9ebe63f75337b40de76a10b5437",
"assets/images/mwap_header_portrait.png": "10843fa7919122fd89ec66e0581758fb",
"assets/images/404.png": "5133464df56712d4d6f01f78a7a2de48",
"assets/images/fdsap_logo.png": "cd34fcd5f4089e24b5417ba94613bae2",
"assets/images/deleteb.png": "bcda11562bd20eeeed7d92f63f9f1b4c",
"assets/images/kplus_webtool_logo.png": "2497931dcac51a56103a02806e3c75b8",
"assets/images/resetPass_dialog.png": "bff56972df77bff3af4682ee34f20011",
"assets/images/cmila.jpg": "c8a911effbef6165f2c0b30843a102c5",
"assets/images/mfi_whitelist_logo.png": "a6afa556ca698b5dcb149db85f9a47c9",
"assets/images/young_woman.png": "72c6ea25742ac1636cb101dbb9482e90",
"assets/images/no_list.png": "fae894f969b824c651a3d5695f3a728c",
"assets/images/whitelist%20logo%20(5).png": "a51a8387dbf40f4266c426fb735d6d89",
"assets/images/resetPass.png": "605f1680669cb1453919d2809b81f62a",
"assets/images/WHITELIST_NAME.png": "ff3a8f177ba41e2d9f3ec0dcb5f23caa",
"assets/images/fdsaplogo.png": "d986f461e81bfc21dc30842550b86850",
"assets/images/idle.png": "b16b1d92aaebb4f7d01f647ea6a607e6",
"assets/images/CARD_INC.png": "1b308c2f0d052dedd6935bbbf9d9243c",
"assets/images/Whitelist.png": "d0b271c3d270c6d01b82041d7b77b0fe",
"assets/images/session.png": "b507a98bcd4f486790d33ee15376aba1",
"assets/images/resetBorder.png": "56a3ecf6dd411eef8d85c94f6a545fda",
"assets/images/amla_cover.png": "f658dc13eaf8b64af7252ceb3eba1030",
"assets/images/fb.png": "3f1bbf2a4b484095438c2db211c65067",
"assets/images/k2cbi.png": "0be04a381dcd1ea2130abd8e572e0001",
"assets/images/kplus_icon.png": "9174306ee918868d6ff6699859f8c948",
"assets/images/CBI-logo.png": "92bed1f86d13590925a2286319d5a13c",
"assets/images/avatar.webp": "849c29fe823fcbc573db99daf2f5b798",
"assets/images/mwap_logo.png": "536f7ae39f774470f84751bb356fe7f2",
"assets/images/cgby.png": "cc3c7fc14084d82489ef4b81b66d6979",
"assets/images/carlamain.jpeg": "05438cafc9859fa974f3625500efcf0b",
"assets/images/reset_password.png": "7619afca99698977a2a978803a9dca98",
"assets/images/girl.png": "a7b3f326702cbe386f03efea65bdde20",
"assets/images/rbiquotes.png": "8bb7e76b54e8bb14ae9575db87329e64",
"assets/images/img.png": "b4b0ccc1f2f6354db2c5da6db81a87c0",
"assets/images/role.png": "6b91030c8edb51b7db0191c20c42175d",
"assets/images/mwap_header.png": "6590969193a0738434c2377025a777ec",
"assets/images/rbi.png": "ef491f0756b45756ebb33ff821b325e7",
"assets/images/ngobg.png": "415c0db5585d22474f060fd68cd5f311",
"assets/images/kplus_webtool_login.png": "ffad8d7a063d5b897fe6a2417e5a5a46",
"assets/images/sessionout.png": "e6d6abb78476a534824e2f39e8fc896f",
"assets/images/cagabaytitle.png": "c7c5c73095bdfe176fadbc30c2ca1d34",
"assets/images/menuheader.png": "3681f7ea16b342a55ed70f7f4fd7acd1",
"assets/images/CELA.jpeg": "147f201a87ba92322189ec1505a178d6",
"assets/images/amla_side_menu_logo.png": "17c39689998e9da6c8763cb0bb318dbe",
"assets/images/page3.jpeg": "0e7983ea0af82de44baf86edba83bfc5",
"assets/images/k2rbi.png": "6033d6d14e958ef3b692268c138a7ab8",
"assets/images/mfi_whitelist_admin_portal.png": "781c9c8d7842c7921ee15d6b2dfbfa39",
"assets/images/print.png": "2223febf9d959b0b6f68059dcfa86374",
"assets/images/print2.png": "7685bcafa0bcdd4d5ec30eddb945d14a",
"assets/images/page5.webp": "0bcce3e73e8963dfe2a28842e53b0553",
"assets/images/avatar.jpg": "ecee3f19112d2dbc6a3dd2424e67dab5",
"assets/images/CRBI.png": "056edf4d62546325209d15c3219b9117",
"assets/images/session_timeout.png": "81dc02071468c3fbd7a1c837d1aaef7d",
"assets/images/print1.png": "2431bc56ce90f7459f3fb96ca6891199",
"assets/images/rbicp.png": "8ba36b2c1d70363a084f664a7348faaa",
"assets/images/no_user_search.png": "18464e550a14fa9c3eee2f711297a739",
"assets/images/amla_colored_logo.png": "81e12e544a579db02692640bd01f0082",
"assets/images/upload.png": "e70edcf9ae29e6af5a4cf8b9e8d4cb0b",
"assets/images/rbihomepage.png": "f56e09436025effaec0bbb1c50198ad3",
"assets/images/mwap_side_logo.png": "a51a8387dbf40f4266c426fb735d6d89",
"assets/images/kplus.png": "18c791aea50444abb72e6783809e9c3c",
"assets/images/CBI.png": "66309469de1f1303e9c9d95f1cb942b8",
"assets/images/fdsap-logo.png": "ddd5712d0cafc73eb537b860aaa4181f",
"assets/images/kplus_webtool.png": "dad54a059d764e4421c78727b0d00c7c",
"assets/images/web.png": "a1309462f983f8aea56f1bcdcf992efd",
"assets/images/change_password.png": "d6bf09b59cbed9af1f2ff404be1358d0",
"assets/images/smequote.png": "27283130c450db58469782aaa352c473",
"assets/images/gabay.png": "9255f871890b254c1a91ee19c9642bfc",
"assets/images/rbilogo.png": "10e1bf42f6e00a829edf25f29b9f4089",
"assets/images/PERALTA.JPG": "f8776584456c17347fb2d02f16d2ee46",
"assets/images/delete.png": "0fe5ca2a0b84ca3c60732c8ed5035959",
"assets/images/CIH.png": "abc15f55b3d60e478f371dbeb3bf61eb",
"assets/images/reset_pass.png": "e0443d15ee6a856e44f902b92fe0eb66",
"assets/images/finalbg.png": "c929ac92d9064bd7b6f731ad335104b6",
"assets/images/mwap_batch_upload.png": "bfd5b04374a3311f7dde6b3a0a57c8ce",
"assets/images/CI.webp": "d68c0a71db034d5e4d528e0ef7fe6121",
"assets/images/k2sme.png": "90a20c35c8875c11508ba1f1cd76c47c",
"assets/images/edit_square.png": "8953d1ec186ff2ddecd952ecfcf041d7",
"assets/images/5.png": "7913d94aabafee67f60771926bf7fc12",
"assets/images/li.png": "4923034e804c261d13406d8fb5036567",
"assets/images/cii.png": "ea07ff256b8196d802863b2f41a8e74b",
"assets/images/smelogo.png": "2be3e86fbfb35cbbf3e6c8a25ac7915d",
"assets/images/libg.png": "f8ca7f440e641811894850e49aa3a05d",
"assets/images/user.jpeg": "5fea864a94e42027d15a59f7f27ab194",
"assets/images/loginheader.png": "2bf583ff713196dfc1095dbb485ad817",
"assets/images/smecplogo.png": "0f94c006318721bde02eee2348010788",
"assets/images/2.png": "c802d531467ff5933250cea8b8e3fdf1",
"assets/images/page1.jpg": "6bdfcedd9f457ccbc143c68c0a3a0564",
"assets/images/White.png": "e8f3e85449a30e256a04eaf3b2fcb516",
"assets/images/cngo.jpeg": "05438cafc9859fa974f3625500efcf0b",
"assets/images/page1.png": "64e8c6fa5086213ac11d93ad4706eadf",
"assets/images/addbg.png": "355a1d132dd483994acc9ae1c33fc6dd",
"assets/images/client.png": "c8cd44d2e39a8ff9055a767b22074416",
"assets/images/1.png": "a9cb460c2f00a78df45b82da28a2b685",
"assets/images/smehomepage.png": "9c1add42a7e7b6af15879d0c16aac060",
"assets/images/refresh.png": "32615532314578376b05759ab558f22d",
"assets/images/carmela.png": "9ff064cf26b9cdbc4ea9d902296a0653",
"assets/images/page2.jpg": "664b9e86e4b75ecf7d4f7cb932b77ab2",
"assets/images/mri.png": "f7c9090ac91848e78216c24ffa215af2",
"assets/AssetManifest.json": "f6cc52cacca98cf909265e4a0ed9f127",
"assets/NOTICES": "13fcf215f497d7ea1ccba7f61a2e307e",
"assets/json/positions.json": "6a5433ef7967888655f77834ae0cc6ab",
"assets/FontManifest.json": "8ea58499defd6ed3eba33585bed37249",
"assets/AssetManifest.bin.json": "34a46a703084b129a4635545465f93bc",
"assets/packages/material_design_icons_flutter/lib/fonts/materialdesignicons-webfont.ttf": "d10ac4ee5ebe8c8fff90505150ba2a76",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/packages/iconsax_flutter/fonts/FlutterIconsax.ttf": "83c878235f9c448928034fe5bcba1c8a",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"assets/AssetManifest.bin": "168d109d12a97eed8698e496645715a8",
"assets/fonts/Crimson/CrimsonText-SemiBold.ttf": "34b92308cc1867957b375e5aa05d005e",
"assets/fonts/Crimson/CrimsonText-Bold.ttf": "92e8dfc1d9c8baed40c860318b3c5186",
"assets/fonts/Crimson/CrimsonText-Regular.ttf": "c8eaeb3ab46e610c4fa4a623ee8d282f",
"assets/fonts/Crimson/CrimsonText-SemiBoldItalic.ttf": "6fa4572b778d9dea7b50acc4b2f0b558",
"assets/fonts/Crimson/OFL.txt": "3149d3c42f5c71b68f04ee1c4d5fea9f",
"assets/fonts/Crimson/CrimsonText-BoldItalic.ttf": "f6d733af55ff450907945144282bb6ea",
"assets/fonts/Crimson/CrimsonText-Italic.ttf": "684cf58ea500f35fb2f7f8227479439b",
"assets/fonts/Roboto/Roboto-Medium.ttf": "68ea4734cf86bd544650aee05137d7bb",
"assets/fonts/Roboto/Roboto-Light.ttf": "881e150ab929e26d1f812c4342c15a7c",
"assets/fonts/Roboto/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/fonts/Roboto/Roboto-MediumItalic.ttf": "c16d19c2c0fd1278390a82fc245f4923",
"assets/fonts/Roboto/Roboto-ThinItalic.ttf": "7bcadd0675fe47d69c2d8aaef683416f",
"assets/fonts/Roboto/Roboto-BoldItalic.ttf": "fd6e9700781c4aaae877999d09db9e09",
"assets/fonts/Roboto/Roboto-LightItalic.ttf": "5788d5ce921d7a9b4fa0eaa9bf7fec8d",
"assets/fonts/Roboto/Roboto-Italic.ttf": "cebd892d1acfcc455f5e52d4104f2719",
"assets/fonts/Roboto/LICENSE.txt": "d273d63619c9aeaf15cdaf76422c4f87",
"assets/fonts/Roboto/Roboto-BlackItalic.ttf": "c3332e3b8feff748ecb0c6cb75d65eae",
"assets/fonts/Roboto/Roboto-Bold.ttf": "b8e42971dec8d49207a8c8e2b919a6ac",
"assets/fonts/Roboto/Roboto-Thin.ttf": "66209ae01f484e46679622dd607fcbc5",
"assets/fonts/Roboto/Roboto-Black.ttf": "d6a6f8878adb0d8e69f9fa2e0b622924",
"assets/fonts/MaterialIcons-Regular.otf": "6f39f77d6c3054f91867d827a3a84244",
"assets/assets/images/whitelist_logo.png": "c68e0d04e0cf5582cdf2f4c68fc642b3",
"assets/assets/images/mila_sme.png": "3d1b79c27cb5de24b57183865dc4400f",
"assets/assets/images/uploads.png": "4813e2cb72bbc2bb7861d572785efd16",
"assets/assets/images/warning.png": "8a361e3c14a31a44f877a04086a9ad51",
"assets/assets/images/access.png": "553409729b8889d14775c54e94ae810a",
"assets/assets/images/clientbg.png": "663efd952d082ad2862380e793431b86",
"assets/assets/images/amla_logo.png": "3f0570e7850ad27496e581ba67a38214",
"assets/assets/images/user_management.png": "926f84948c730bbb84fe540893bf42a0",
"assets/assets/images/page4.jpeg": "fd15307439fdfc593f2ff8df1f12faa2",
"assets/assets/images/yt.png": "1e956b0f5deaec74b2d69e445bb4db07",
"assets/assets/images/mwap_login_bg.png": "8534c9ebe63f75337b40de76a10b5437",
"assets/assets/images/mwap_header_portrait.png": "10843fa7919122fd89ec66e0581758fb",
"assets/assets/images/404.png": "5133464df56712d4d6f01f78a7a2de48",
"assets/assets/images/fdsap_logo.png": "cd34fcd5f4089e24b5417ba94613bae2",
"assets/assets/images/deleteb.png": "bcda11562bd20eeeed7d92f63f9f1b4c",
"assets/assets/images/kplus_webtool_logo.png": "2497931dcac51a56103a02806e3c75b8",
"assets/assets/images/resetPass_dialog.png": "bff56972df77bff3af4682ee34f20011",
"assets/assets/images/cmila.jpg": "c8a911effbef6165f2c0b30843a102c5",
"assets/assets/images/mfi_whitelist_logo.png": "a6afa556ca698b5dcb149db85f9a47c9",
"assets/assets/images/young_woman.png": "72c6ea25742ac1636cb101dbb9482e90",
"assets/assets/images/no_list.png": "fae894f969b824c651a3d5695f3a728c",
"assets/assets/images/resetPass.png": "605f1680669cb1453919d2809b81f62a",
"assets/assets/images/WHITELIST_NAME.png": "ff3a8f177ba41e2d9f3ec0dcb5f23caa",
"assets/assets/images/fdsaplogo.png": "d986f461e81bfc21dc30842550b86850",
"assets/assets/images/idle.png": "b16b1d92aaebb4f7d01f647ea6a607e6",
"assets/assets/images/CARD_INC.png": "1b308c2f0d052dedd6935bbbf9d9243c",
"assets/assets/images/Whitelist.png": "d0b271c3d270c6d01b82041d7b77b0fe",
"assets/assets/images/session.png": "b507a98bcd4f486790d33ee15376aba1",
"assets/assets/images/resetBorder.png": "56a3ecf6dd411eef8d85c94f6a545fda",
"assets/assets/images/amla_cover.png": "f658dc13eaf8b64af7252ceb3eba1030",
"assets/assets/images/fb.png": "3f1bbf2a4b484095438c2db211c65067",
"assets/assets/images/k2cbi.png": "0be04a381dcd1ea2130abd8e572e0001",
"assets/assets/images/kplus_icon.png": "9174306ee918868d6ff6699859f8c948",
"assets/assets/images/CBI-logo.png": "92bed1f86d13590925a2286319d5a13c",
"assets/assets/images/avatar.webp": "849c29fe823fcbc573db99daf2f5b798",
"assets/assets/images/mwap_logo.png": "536f7ae39f774470f84751bb356fe7f2",
"assets/assets/images/cgby.png": "cc3c7fc14084d82489ef4b81b66d6979",
"assets/assets/images/carlamain.jpeg": "05438cafc9859fa974f3625500efcf0b",
"assets/assets/images/reset_password.png": "7619afca99698977a2a978803a9dca98",
"assets/assets/images/girl.png": "a7b3f326702cbe386f03efea65bdde20",
"assets/assets/images/rbiquotes.png": "8bb7e76b54e8bb14ae9575db87329e64",
"assets/assets/images/img.png": "b4b0ccc1f2f6354db2c5da6db81a87c0",
"assets/assets/images/role.png": "6b91030c8edb51b7db0191c20c42175d",
"assets/assets/images/404_page.png": "ce38fe39ff606b439a777838b45c7b57",
"assets/assets/images/mwap_header.png": "6590969193a0738434c2377025a777ec",
"assets/assets/images/rbi.png": "ef491f0756b45756ebb33ff821b325e7",
"assets/assets/images/ngobg.png": "415c0db5585d22474f060fd68cd5f311",
"assets/assets/images/kplus_webtool_login.png": "ffad8d7a063d5b897fe6a2417e5a5a46",
"assets/assets/images/sessionout.png": "e6d6abb78476a534824e2f39e8fc896f",
"assets/assets/images/cagabaytitle.png": "c7c5c73095bdfe176fadbc30c2ca1d34",
"assets/assets/images/menuheader.png": "3681f7ea16b342a55ed70f7f4fd7acd1",
"assets/assets/images/CELA.jpeg": "147f201a87ba92322189ec1505a178d6",
"assets/assets/images/amla_side_menu_logo.png": "17c39689998e9da6c8763cb0bb318dbe",
"assets/assets/images/page3.jpeg": "0e7983ea0af82de44baf86edba83bfc5",
"assets/assets/images/k2rbi.png": "6033d6d14e958ef3b692268c138a7ab8",
"assets/assets/images/mfi_whitelist_admin_portal.png": "781c9c8d7842c7921ee15d6b2dfbfa39",
"assets/assets/images/print.png": "2223febf9d959b0b6f68059dcfa86374",
"assets/assets/images/print2.png": "7685bcafa0bcdd4d5ec30eddb945d14a",
"assets/assets/images/page5.webp": "0bcce3e73e8963dfe2a28842e53b0553",
"assets/assets/images/avatar.jpg": "ecee3f19112d2dbc6a3dd2424e67dab5",
"assets/assets/images/CRBI.png": "056edf4d62546325209d15c3219b9117",
"assets/assets/images/session_timeout.png": "81dc02071468c3fbd7a1c837d1aaef7d",
"assets/assets/images/print1.png": "2431bc56ce90f7459f3fb96ca6891199",
"assets/assets/images/rbicp.png": "8ba36b2c1d70363a084f664a7348faaa",
"assets/assets/images/no_user_search.png": "18464e550a14fa9c3eee2f711297a739",
"assets/assets/images/amla_colored_logo.png": "81e12e544a579db02692640bd01f0082",
"assets/assets/images/upload.png": "e70edcf9ae29e6af5a4cf8b9e8d4cb0b",
"assets/assets/images/rbihomepage.png": "f56e09436025effaec0bbb1c50198ad3",
"assets/assets/images/mwap_side_logo.png": "a51a8387dbf40f4266c426fb735d6d89",
"assets/assets/images/kplus.png": "18c791aea50444abb72e6783809e9c3c",
"assets/assets/images/CBI.png": "66309469de1f1303e9c9d95f1cb942b8",
"assets/assets/images/fdsap-logo.png": "ddd5712d0cafc73eb537b860aaa4181f",
"assets/assets/images/kplus_webtool.png": "dad54a059d764e4421c78727b0d00c7c",
"assets/assets/images/web.png": "a1309462f983f8aea56f1bcdcf992efd",
"assets/assets/images/change_password.png": "d6bf09b59cbed9af1f2ff404be1358d0",
"assets/assets/images/smequote.png": "27283130c450db58469782aaa352c473",
"assets/assets/images/gabay.png": "9255f871890b254c1a91ee19c9642bfc",
"assets/assets/images/rbilogo.png": "10e1bf42f6e00a829edf25f29b9f4089",
"assets/assets/images/PERALTA.JPG": "f8776584456c17347fb2d02f16d2ee46",
"assets/assets/images/delete.png": "0fe5ca2a0b84ca3c60732c8ed5035959",
"assets/assets/images/CIH.png": "abc15f55b3d60e478f371dbeb3bf61eb",
"assets/assets/images/reset_pass.png": "e0443d15ee6a856e44f902b92fe0eb66",
"assets/assets/images/finalbg.png": "c929ac92d9064bd7b6f731ad335104b6",
"assets/assets/images/mwap_batch_upload.png": "bfd5b04374a3311f7dde6b3a0a57c8ce",
"assets/assets/images/CI.webp": "d68c0a71db034d5e4d528e0ef7fe6121",
"assets/assets/images/k2sme.png": "90a20c35c8875c11508ba1f1cd76c47c",
"assets/assets/images/edit_square.png": "8953d1ec186ff2ddecd952ecfcf041d7",
"assets/assets/images/5.png": "7913d94aabafee67f60771926bf7fc12",
"assets/assets/images/li.png": "4923034e804c261d13406d8fb5036567",
"assets/assets/images/cii.png": "ea07ff256b8196d802863b2f41a8e74b",
"assets/assets/images/smelogo.png": "2be3e86fbfb35cbbf3e6c8a25ac7915d",
"assets/assets/images/libg.png": "f8ca7f440e641811894850e49aa3a05d",
"assets/assets/images/user.jpeg": "5fea864a94e42027d15a59f7f27ab194",
"assets/assets/images/loginheader.png": "2bf583ff713196dfc1095dbb485ad817",
"assets/assets/images/smecplogo.png": "0f94c006318721bde02eee2348010788",
"assets/assets/images/2.png": "c802d531467ff5933250cea8b8e3fdf1",
"assets/assets/images/coming_soon.png": "56f90c8d868c097527ff076bb85703a9",
"assets/assets/images/page1.jpg": "6bdfcedd9f457ccbc143c68c0a3a0564",
"assets/assets/images/White.png": "e8f3e85449a30e256a04eaf3b2fcb516",
"assets/assets/images/cngo.jpeg": "05438cafc9859fa974f3625500efcf0b",
"assets/assets/images/page1.png": "64e8c6fa5086213ac11d93ad4706eadf",
"assets/assets/images/addbg.png": "355a1d132dd483994acc9ae1c33fc6dd",
"assets/assets/images/client.png": "c8cd44d2e39a8ff9055a767b22074416",
"assets/assets/images/1.png": "a9cb460c2f00a78df45b82da28a2b685",
"assets/assets/images/smehomepage.png": "9c1add42a7e7b6af15879d0c16aac060",
"assets/assets/images/refresh.png": "32615532314578376b05759ab558f22d",
"assets/assets/images/carmela.png": "9ff064cf26b9cdbc4ea9d902296a0653",
"assets/assets/images/whitelist%2520logo%2520(5).png": "a51a8387dbf40f4266c426fb735d6d89",
"assets/assets/images/page2.jpg": "664b9e86e4b75ecf7d4f7cb932b77ab2",
"assets/assets/images/mri.png": "f7c9090ac91848e78216c24ffa215af2",
"assets/assets/json/zipcodes.json": "e160a2ba013b05552eb4a27ac4551004",
"assets/assets/json/PSGC.json": "780eb7777b7280b4ca3d0436a9599a9d",
"assets/assets/fonts/Roboto/Roboto-Medium.ttf": "68ea4734cf86bd544650aee05137d7bb",
"2.png": "c802d531467ff5933250cea8b8e3fdf1",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "2fc47c0a0c3c7af8542b601634fe9674",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "143af6ff368f9cd21c863bfa4274c406",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/canvaskit.wasm": "73584c1a3367e3eaf757647a8f5c5989",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
