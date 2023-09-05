import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  TextStyle appTitle =
      GoogleFonts.dmSans(color: Colors.black, fontWeight: FontWeight.bold);
  TextStyle appFont =
      GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.bold);
  TextStyle appCategoryFont =
      GoogleFonts.dmSans(fontSize: 32, fontWeight: FontWeight.bold);
  TextStyle appQuoteFont =
      GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w400);
  TextStyle appAuthorFont =
      GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w500);
  String quote = '';
  String author = '';
  String category = '';

  String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  void apiCall() async {
    try {
      var url = Uri.https('api.api-ninjas.com', '/v1/quotes', {'category': ''});

      var response = await http.get(
        url,
        headers: {
          'X-Api-Key': 'E8FT86/9TbhMgAhWe/pPUA==1nVI2cw3CpfscNvf',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse);

        var quoteItem = jsonResponse[0];
        setState(() {
          quote = quoteItem['quote'];
          author = quoteItem['author'];
          category = quoteItem['category'];
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    apiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFDED6),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quotes', style: appTitle),
              IconButton(
                splashRadius: 25,
                onPressed: () {
                  apiCall();
                },
                icon: const Icon(
                  PhosphorIcons.arrow_clockwise,
                  color: Colors.black,
                  weight: 20,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFFFCEC2),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 120,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category', style: appFont),
                          Text('${capitalize(category)}',
                              style: appCategoryFont),
                          const SizedBox(height: 20),
                          Text(
                            '"${quote}"',
                            style: appQuoteFont,
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 10),
                          Text('$author', style: appAuthorFont),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
