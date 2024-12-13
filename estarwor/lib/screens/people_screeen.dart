import 'package:estarwor/models/people.dart';
import 'package:estarwor/models/people_response.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});
  


  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  late Future<PeopleResponse> peopleResponse;

  @override
  void initState() {
    super.initState();
    peopleResponse = getPeople();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StarWars'),
      ),
      body: FutureBuilder<PeopleResponse>(
        future: peopleResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: 
                  Container(
                      color: Colors.black,
                      child: _buildCarouselList(snapshot.data!),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<PeopleResponse> getPeople() async {
    final response = await http.get(Uri.parse('https://swapi.dev/api/people'));

    if (response.statusCode == 200) {
      return PeopleResponse.fromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
  


  Widget _buildCarouselList(PeopleResponse peopleResponse) {
    
    return CarouselSlider(
      options: CarouselOptions(height: 400.0),
      items: peopleResponse.results!.map((person) {
        return Builder(
          builder: (BuildContext context) {
            return _buildCarouselItem(context, person);
          },
        );
      }).toList(),
    );
  }

  Widget _buildPeopleList(PeopleResponse peopleResponse) {
    return ListView.builder(
        itemCount: peopleResponse.results!.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  height: 20,
                  color: Colors.red,
                  child: const Text("imagen"),
                ),
                Container(
                  height: 40,
                  color: Colors.blue,
                  child: Text(peopleResponse.results![index].name!,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: Colors.white)),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildCarouselItem(BuildContext context, People person) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          width: 300,
          child: Image.network('https://starwars-visualguide.com/assets/img/characters/${_createImg(person.url!)}.jpg'),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: const BoxDecoration(color: Colors.amber),
            child: Text(
              person.name!,
              style: const TextStyle(fontSize: 16.0),
            )),
      ],
    );
  }
}


String _createImg(String url) {
  // Extraer el identificador de la URL
  // Ejemplo: https://swapi.dev/api/people/1/ -> 1
  final regex = RegExp(r'/(\d+)/');
  final match = regex.firstMatch(url);
  return match != null ? match.group(1)! : 'placeholder';
}

